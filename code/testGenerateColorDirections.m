function [ConeDirectedDirection1] = testGenerateColorDirections(calibrationType, observerAge)
% Function to compute nominal cone directed modulations around a
% background.
%
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
%   - directionStructs
%

% History:
%   04/09/18  dhb  Light flux bipolar version

% Examples:
%{
testGenerateColorDirections('BoxALiquidLightGuideCEyePiece2ND09', 32);
%}

%% Parameters
whichXYZ = 'xyzCIEPhys10';
TEST_MAXLMS_CHROM = false;

%% Define altnernate dictionary functions.
backgroundAlternateDictionary = 'OLBackgroundParamsDictionary_Color';
directionAlternateDictionary = 'OLDirectionParamsDictionary_Color';

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
nativeLum = nativexyY(3);

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

%% Make a background of specified luminance and chromaticity
%
% Get basic parameters.  These ask for essentially no contrast and have
% very tight constraints on the desired chromaticity.
ConeDirectedBackgroundParams = OLDirectionParamsFromName('ConeDirectedBackground', ...
        'alternateDictionaryFunc', directionAlternateDictionary);

% Here we use the half on of hte device, but in a real application these
% would be specified explicitly.  Perhaps with the half on of the device
% values at the start of the experiment.
ConeDirectedBackgroundParams.desiredxy = nativexy;
ConeDirectedBackgroundParams.desiredLum = nativeLum;

% Get the background.  This also makes a light flux modulation, but we
% ignore that.
[~, ConeDirectedBackground] = OLDirectionNominalFromParams(ConeDirectedBackgroundParams, cal, ...
    'alternateBackgroundDictionaryFunc', backgroundAlternateDictionary);
 
%% Test direction 2
nDirections = nDirections+1;
directions{nDirections} = 'ConeDirectedDirection2';

ConeDirectedParams2 = OLDirectionParamsFromName('ConeDirected2', ...
    'alternateDictionaryFunc', directionAlternateDictionary);
ConeDirectedBackground2 = ConeDirectedBackground;

[ConeDirectedDirection2] = OLDirectionNominalFromParams(ConeDirectedParams2, cal, ...
    'observerAge',protocolParams.observerAgeInYrs, ...
    'background',ConeDirectedBackground2, ...
    'alternateBackgroundDictionaryFunc', backgroundAlternateDictionary);

%% Simulate validation to easily determine the contrast in our nominal OLDirections
%
% Assuming that all directions use same receptors.
receptorStrings = ConeDirectedDirection2.describe.directionParams.photoreceptorClasses;
fieldSizes = ConeDirectedDirection2.describe.directionParams.fieldSizeDegrees;
receptors = GetHumanPhotoreceptorSS(ConeDirectedDirection2.calibration.describe.S,receptorStrings,fieldSizes,observerAge,6,[],[]);
ConeDirectedDirection2.describe.validation = OLValidateDirection(ConeDirectedDirection2,ConeDirectedBackground,ol,radiometer, ...
    'receptors',receptors);

%% Report on nominal contrasts
fprintf('<strong>%s</strong>, observer age %d\n',calibrationType, observerAge);
fprintf('   * <strong>Target background x, y, Y</strong>: %0.3f, %0.3f, %0.1f cd/m2\n',nativexyY(1),nativexyY(2),nativexyY(3));
fprintf('\n');

for dd = 1:length(directions)
    direction = eval(directions{dd});
    background = eval(strrep(directions{dd},'Direction','Background'));
    
    fprintf('<strong>%s</strong>\n', directions{dd});
    
    % Grab the relevant contrast information from the OLDirection object an
    % and report. Keep pos and neg contrast explicitly separate.
    [~, excitations, excitationDiffs] = direction.ToDesiredReceptorContrast(background,receptors);  
    for j = 1:size(receptors,1)
        fprintf('  * <strong>%s, %0.1f degrees</strong>: contrast pos = %0.1f%%\n',receptorStrings{j},fieldSizes(j),100*excitationDiffs(j,1)/excitations(j,1));
        fprintf('  * <strong>%s, %0.1f degrees</strong>: contrast neg = %0.1f%%\n',receptorStrings{j},fieldSizes(j),100*excitationDiffs(j,2)/excitations(j,1));
    end
    
    % Chromaticity and luminance
    backgroundxyY = XYZToxyY(T_xyz*OLPrimaryToSpd(cal,background.differentialPrimaryValues));
    fprintf('\n');
    fprintf('   * <strong>Background x, y, Y</strong>: %0.3f, %0.3f, %0.1f cd/m2\n',backgroundxyY(1),backgroundxyY(2),backgroundxyY(3));
    
    fprintf('\n\n');
end