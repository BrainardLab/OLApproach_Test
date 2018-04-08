function [MaxLMSDirection, MaxMelDirection, LightFluxDirection_540_380] = testGenerateNominalMaxMelishDirections(calibrationType, observerAge)
% Function to compute nominal backgrounds and directions based on
% calibration type and subject age

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
testGenerateNominalMaxMelishDirections('BoxBRandomizedLongCableAEyePiece1_ND04', 32)
%}
%{
testGenerateNominalMaxMelishDirections('BoxBShortLiquidLightGuideDEyePiece1_ND04', 57)
%}

%% Parameters
%
% Always test MAXLMS because we use that to get a common set of receptors.
TEST_MAXMEL = true;
TEST_LIGHTFLUX_540_380 = true;

%% Define altnernate dictionary functions.
backgroundAlternateDictionary = 'OLBackgroundParamsDictionary_Test';
directionAlternateDictionary = 'OLDirectionParamsDictionary_Test';
waveformAlternateDictionary = 'OLWaveformParamsDictionary_Test';

%% Set some stuff up
% set up the calibrationStructure
protocolParams.calibrationType = calibrationType;
calibration = OLGetCalibrationStructure('CalibrationType',protocolParams.calibrationType,'CalibrationDate','latest');
nDirections = 0;

% Set up some information about our theoretical observer
protocolParams.observerID = '';
protocolParams.observerAgeInYrs = observerAge;

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
[MaxLMSDirection, MaxLMSBackground] = OLDirectionNominalFromParams(MaxLMSParams, calibration, ...
    'observerAge',protocolParams.observerAgeInYrs, ...
    'alternateBackgroundDictionaryFunc', backgroundAlternateDictionary);


%% MaxMel
if (TEST_MAXMEL)
    nDirections = nDirections+1;
    directions{nDirections} = 'MaxMelDirection';
    
    MaxMelParams = OLDirectionParamsFromName('MaxMel_unipolar_275_60_667', ...
        'alternateDictionaryFunc', directionAlternateDictionary);
    [MaxMelDirection, MaxMelBackground] = OLDirectionNominalFromParams(MaxMelParams, calibration, ...
        'observerAge',protocolParams.observerAgeInYrs, ...
        'alternateBackgroundDictionaryFunc', backgroundAlternateDictionary);
end

%% Light flux at one chrom
if (TEST_LIGHTFLUX_540_380)
    nDirections = nDirections+1;
    directions{nDirections} = 'LightFluxDirection_540_380';
    
    LightFluxParams = OLDirectionParamsFromName('LightFlux_540_380_50', ...
        'alternateDictionaryFunc', directionAlternateDictionary);
    [LightFluxDirection_540_380, LightFluxBackground_540_380] = OLDirectionNominalFromParams(LightFluxParams, calibration, ...
        'alternateBackgroundDictionaryFunc', backgroundAlternateDictionary);
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
if (TEST_LIGHTFLUX_540_380)
    LightFluxDirection_540_380.describe.validation = OLValidateDirection(LightFluxDirection_540_380,LightFluxBackground_540_380,ol,radiometer,...
        'receptors',receptors);
end

%% Report on nominal contrasts
postreceptoralStrings = {'L+M+S', 'L-M', 'S-(L+M)'};
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
    fprintf('\n\n');
end