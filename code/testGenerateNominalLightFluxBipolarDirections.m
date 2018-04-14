function [LightFluxDirection_330_330] = testGenerateNominalLightFluxBipolarDirections(calibrationType, observerAge)
% Function to compute nominal backgrounds and directions based on
% calibration type and subject age.  This version is used for developing
% and testing bipolar light flux modulations.

% Input:
%   - calibrationType: string describing the calibration from which we want
%       to generate nominal directionStructs. The relevant calibrations for
%       Box B are:
%            'BoxBRandomizedLongCableAEyePiece1_ND04'
%            'BoxBShortLiquidLightGuideDEyePiece1_ND04'
%   - observerAge: age of fake subject for whom we're generating these
%       nominal directionStructs
%
% Output:
%   - directionStructs (LightFlux)
%

% History:
%   04/09/18  dhb  Light flux bipolar version

% Examples:
%{
testGenerateNominalLightFluxBipolarDirections('BoxBRandomizedLongCableAEyePiece1_ND04', 32);
%}
%{
testGenerateNominalLightFluxBipolarDirections('BoxDRandomizedLongCableBEyePiece2_ND01', 32);
%}

%% Parameters
whichXYZ = 'xyzCIEPhys10';

%% Define altnernate dictionary functions.
backgroundAlternateDictionary = 'OLBackgroundParamsDictionary_Test';
directionAlternateDictionary = 'OLDirectionParamsDictionary_Test';
waveformAlternateDictionary = 'OLWaveformParamsDictionary_Test';

%% Set some stuff up
% set up the calibrationStructure
protocolParams.calibrationType = calibrationType;
cal = OLGetCalibrationStructure('CalibrationType',protocolParams.calibrationType,'CalibrationDate','latest');
nDirections = 0;

%% Load cmfs
eval(['tempXYZ = load(''T_' whichXYZ ''');']);
eval(['T_xyz = SplineCmf(tempXYZ.S_' whichXYZ ',683*tempXYZ.T_' whichXYZ ',cal.describe.S);']);

%% Get native chromaticity for this cal
nativeXYZ = T_xyz*OLPrimaryToSpd(cal,0.5*ones(size(cal.computed.pr650M,2),1));
nativexyY = XYZToxyY(nativeXYZ);
nativexy = nativexyY(1:2);

%% Set up some information about our theoretical observer
protocolParams.observerID = '';
protocolParams.observerAgeInYrs = observerAge;

%% Set up simulations
%
% To make these nominal OLDirections we'll need to simulate the
% OneLight and the radiometer. Set that up here
radiometer = [];
protocolParams.simulate.oneLight = true;
protocolParams.simulate.makePlots = false;

% Make the oneLight object
ol = OneLight('simulate',protocolParams.simulate.oneLight,'plotWhenSimulating',protocolParams.simulate.makePlots); drawnow;

% Need receptors to validate. Light flux objects don't
% currently have them, so making a receptor direction object
% to get them.
MaxLMSParams = OLDirectionParamsFromName('MaxLMS_unipolar_275_60_667', ...
    'alternateDictionaryFunc', directionAlternateDictionary);
[MaxLMSDirection, MaxLMSBackground] = OLDirectionNominalFromParams(MaxLMSParams, cal, ...
    'observerAge',protocolParams.observerAgeInYrs, ...
    'alternateBackgroundDictionaryFunc', backgroundAlternateDictionary);
receptors = MaxLMSDirection.describe.directionParams.T_receptors;

%% Light flux at one chrom
nDirections = nDirections+1;
directions{nDirections} = 'LightFluxDirection';

%% Get base light flux direction and background params
LightFluxParams = OLDirectionParamsFromName('LightFlux_BipolarBase', ...
    'alternateDictionaryFunc', directionAlternateDictionary);
LightFluxParams.backgroundParams = OLBackgroundParamsFromName(LightFluxParams.backgroundName,...
                            'alternateDictionaryFunc',backgroundAlternateDictionary);
                        
%% Parameter adjustment
LightFluxParams.desiredxy = nativexy;
LightFluxParams.whichXYZ = whichXYZ;
LightFluxParams.desiredMaxContrast = 0.8;
LightFluxParams.backgroundParams.desiredxy = LightFluxParams.desiredxy;
LightFluxParams.backgroundParams.whichXYZ = whichXYZ;

%% Generate
[LightFluxDirection, LightFluxBackground] = OLDirectionNominalFromParams(LightFluxParams, cal, ...
    'alternateBackgroundDictionaryFunc', backgroundAlternateDictionary);

%% Simulate validation to easily determine the contrast in our nominal OLDirections
%
% Assuming that all directions use same receptors as MaxLMS.  OK for
% testing here.
receptorStrings = MaxLMSDirection.describe.directionParams.photoreceptorClasses;
LightFluxDirection.describe.validation = OLValidateDirection(LightFluxDirection,LightFluxBackground,ol,radiometer,...
    'receptors',receptors);

%% Load XYZ functions according to chosen type

%% Report on nominal contrasts
postreceptoralStrings = {'L+M+S', 'L-M', 'S-(L+M)'};
fprintf('<strong>%s</strong>, observer age %d\n',calibrationType, observerAge);
for dd = 1:length(directions)
    direction = eval(directions{dd});
    background = eval(strrep(directions{dd},'Direction','Background'));
    
    fprintf('<strong>%s</strong>\n', directions{dd});
    
    % Grab the relevant contrast information from the OLDirection
    receptorContrasts = direction.ToDesiredReceptorContrast(background,receptors);
    %receptorContrasts = direction.describe.validation.contrastDesired;
    %postreceptoralContrasts = direction.describe.validation.postreceptoralContrastDesired;
    
    % Report of receptoral contrast
    for j = 1:size(receptors,1)
        fprintf('  * <strong>%s</strong>: contrast = %0.1f%%\n',receptorStrings{j},100*receptorContrasts(j));
    end
    
    % Report on postreceptoral contrast
    % NCombinations = size(postreceptoralContrasts, 1);
    % fprintf('\n');
    % for ii = 1:NCombinations
    %     fprintf('   * <strong>%s</strong>: contrast = %0.1f%%\n',postreceptoralStrings{ii},100*postreceptoralContrasts(ii));
    % end
    
    % Chromaticity and luminance
    backgroundxyY = XYZToxyY(T_xyz*OLPrimaryToSpd(cal,background.differentialPrimaryValues));
    directionxyY = XYZToxyY(T_xyz*OLPrimaryToSpd(cal,background.differentialPrimaryValues+direction.differentialPositive));
    fprintf('\n');
    fprintf('   * <strong>Luminance weber contrast </strong>: %0.1f%%\n',100*(directionxyY(3)-backgroundxyY(3))/backgroundxyY(3));
    fprintf('   * <strong>Background x, y, Y</strong>: %0.3f, %0.3f, %0.1f cd/m2\n',backgroundxyY(1),backgroundxyY(2),backgroundxyY(3));
    fprintf('   * <strong>Direction at max x, y, Y</strong>: %0.3f, %0.3f, %0.1f cd/m2\n',directionxyY(1),directionxyY(2),directionxyY(3));
    
    fprintf('\n\n');
end