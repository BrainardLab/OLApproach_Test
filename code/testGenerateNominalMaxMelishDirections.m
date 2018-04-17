function [MaxLMSDirection, MaxMelDirection, LightFluxDirection] = testGenerateNominalMaxMelishDirections(calibrationType, observerAge)
% Function to compute nominal backgrounds and directions based on
% calibration type and subject age.  This version is used for developing
% and testing modulations for MaxMel type experiments.

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
%   - directionStructs (MaxLMS, MaxMel, and LightFlux): our Squint
%       experiment uses three stimulus types, and the code produces the
%       nominal directionStruct for each type. The relevant contrast
%       information is stored within as
%       directionStruct.describe.validation.predictedContrast and
%       directionStruct.describe.validation.predictedContrastPostreceptoral.
%       Note that these have the same values as the
%       actualContrast/actualContrastPostReceptoral because we're not doing
%       any direction correction or performing actual validation
%       measurements

% History:
%   04/01/18  dhb  Starting working on it starting with jv version from
%                  OLApproach_Squint.

% Examples:
%{
testGenerateNominalMaxMelishDirections('BoxBRandomizedLongCableAEyePiece1_ND04', 32);
%}
%{
testGenerateNominalMaxMelishDirections('BoxBShortLiquidLightGuideDEyePiece1_ND04', 57);
%}

%% Parameters
%
% Always test MAXLMS because we use that to get a common set of receptors.
TEST_MAXMEL = false;
TEST_LIGHTFLUX = true;

% Which cmfs to use
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

%% Load XYZ cmfs
whichXYZ = 'xyzCIEPhys10';
eval(['tempXYZ = load(''T_' whichXYZ ''');']);
eval(['T_xyz = SplineCmf(tempXYZ.S_' whichXYZ ',683*tempXYZ.T_' whichXYZ ',cal.describe.S);']);

%% Set up some information about our theoretical observer
protocolParams.observerID = '';
protocolParams.observerAgeInYrs = observerAge;

%% Set up simulations
% To make these nominal OLDirections we'll need to simulate the
% OneLight and the radiometer. Set that up here
radiometer = [];
protocolParams.simulate.oneLight = true;
protocolParams.simulate.makePlots = false;

% Make the oneLight object
ol = OneLight('simulate',protocolParams.simulate.oneLight,'plotWhenSimulating',protocolParams.simulate.makePlots); drawnow;

%% MaxLMS test
nDirections = nDirections+1;
directions{nDirections} = 'MaxLMSDirection';

MaxLMSParams = OLDirectionParamsFromName('MaxLMS_unipolar_275_60_667', ...
    'alternateDictionaryFunc', directionAlternateDictionary);
[MaxLMSDirection, MaxLMSBackground] = OLDirectionNominalFromParams(MaxLMSParams, cal, ...
    'observerAge',protocolParams.observerAgeInYrs, ...
    'alternateBackgroundDictionaryFunc', backgroundAlternateDictionary);


%% MaxMel
if (TEST_MAXMEL)
    nDirections = nDirections+1;
    directions{nDirections} = 'MaxMelDirection';
    
    MaxMelParams = OLDirectionParamsFromName('MaxMel_unipolar_275_60_667', ...
        'alternateDictionaryFunc', directionAlternateDictionary);
    [MaxMelDirection, MaxMelBackground] = OLDirectionNominalFromParams(MaxMelParams, cal, ...
        'observerAge',protocolParams.observerAgeInYrs, ...
        'alternateBackgroundDictionaryFunc', backgroundAlternateDictionary);
end

%% Light flux at one chrom
if (TEST_LIGHTFLUX)
    nDirections = nDirections+1;
    directions{nDirections} = 'LightFluxDirection';
    
    LightFluxParams = OLDirectionParamsFromName('LightFlux_UnipolarBase', ...
        'alternateDictionaryFunc', directionAlternateDictionary);
    LightFluxParams.backgroundParams = OLBackgroundParamsFromName(LightFluxParams.backgroundName,...
                            'alternateDictionaryFunc',backgroundAlternateDictionary);
                        
    % Parameter adjustment
    LightFluxParams.desiredxy = [0.595,0.388];
    LightFluxParams.whichXYZ = whichXYZ;
    LightFluxParams.desiredMaxContrast = 4;
    LightFluxParams.backgroundParams.desiredxy = LightFluxParams.desiredxy;
    LightFluxParams.backgroundParams.whichXYZ = whichXYZ;
    LightFluxParams.backgroundParams.desiredMaxContrast = 4;
    
    LightFluxParams.backgroundParams.search.primaryHeadroom = 0.000;
    LightFluxParams.backgroundParams.search.primaryTolerance = 1e-6;
    LightFluxParams.backgroundParams.search.checkPrimaryOutOfRange = true;
    LightFluxParams.backgroundParams.search.initialLuminanceFactor = 0.2;
    LightFluxParams.backgroundParams.search.lambda = 0;
    LightFluxParams.backgroundParams.search.whichSpdToPrimaryMin = 'fractionalError';
    LightFluxParams.backgroundParams.search.spdToleranceFraction = 0.003;
    LightFluxParams.backgroundParams.search.chromaticityTolerance = 0.001;
    LightFluxParams.backgroundParams.search.optimizationTarget = 'maxContrast';
    LightFluxParams.backgroundParams.search.targetContrast = 4;
    LightFluxParams.backgroundParams.search.primaryHeadroomForInitialMax = 0.000;
    LightFluxParams.backgroundParams.search.maxScaleDownForStart = 2;
    LightFluxParams.backgroundParams.search.maxSearchIter = 3000;
    LightFluxParams.backgroundParams.search.verbose = true;

    tic
    [LightFluxDirection, LightFluxBackground] = OLDirectionNominalFromParams(LightFluxParams, cal, ...
        'alternateBackgroundDictionaryFunc', backgroundAlternateDictionary);
    toc
end

%% Simulate validation to easily determine the contrast in our nominal OLDirections
%
% Assuming that all directions use same receptors as MaxLMS.  OK for
% testing here.
receptors = MaxLMSDirection.describe.directionParams.T_receptors;
receptorStrings = MaxLMSDirection.describe.directionParams.photoreceptorClasses;
MaxLMSDirection.describe.validation = OLValidateDirection(MaxLMSDirection,MaxLMSBackground,ol,radiometer,...
    'receptors',receptors);
if (TEST_MAXMEL)
    MaxMelDirection.describe.validation = OLValidateDirection(MaxMelDirection,MaxMelBackground,ol,radiometer,...
        'receptors',receptors);
end
if (TEST_LIGHTFLUX)
    LightFluxDirection.describe.validation = OLValidateDirection(LightFluxDirection,LightFluxBackground,ol,radiometer,...
        'receptors',receptors);
end

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
    postreceptoralContrasts = direction.describe.validation.postreceptoralContrastDesired;
    
    % Report of receptoral contrast
    for j = 1:size(receptors,1)
        fprintf('  * <strong>%s</strong>: contrast = %0.1f%%\n',receptorStrings{j},100*receptorContrasts(j));
    end
    
    % Report on postreceptoral contrast
    NCombinations = size(postreceptoralContrasts, 1);
    fprintf('\n');
    for ii = 1:NCombinations
        fprintf('   * <strong>%s</strong>: contrast = %0.1f%%\n',postreceptoralStrings{ii},100*postreceptoralContrasts(ii));
    end
    
    % Chromaticity and luminance
    backgroundxyY = XYZToxyY(T_xyz*OLPrimaryToSpd(cal,background.differentialPrimaryValues));
    directionxyY = XYZToxyY(T_xyz*OLPrimaryToSpd(cal,background.differentialPrimaryValues+direction.differentialPrimaryValues));
    fprintf('\n');
    fprintf('   * <strong>Luminance weber contrast </strong>: %0.1f%%\n',100*(directionxyY(3)-backgroundxyY(3))/backgroundxyY(3));
    fprintf('   * <strong>Background x, y, Y</strong>: %0.3f, %0.3f, %0.1f cd/m2\n',backgroundxyY(1),backgroundxyY(2),backgroundxyY(3));
    fprintf('   * <strong>Direction at max x, y, Y</strong>: %0.3f, %0.3f, %0.1f cd/m2\n',directionxyY(1),directionxyY(2),directionxyY(3));

    fprintf('\n\n');
end