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
testGenerateNominalMaxMelishDirections('BoxALiquidLightGuideCEyePiece2ND09', 32);
%}

%% Close figures hanging around
close all;

%% Parameters
%
% Always test MAXLMS because we use that to get a common set of receptors.
TEST_MAXLMS_CHROM = true;
TEST_MAXMEL = true;
TEST_MAXMEL_CHROM = true;
TEST_LIGHTFLUX = true;
TEST_LIGHTFLUX_CHROM = true;

% Which cmfs to use
whichXYZ = 'xyzCIEPhys10';

%% Define altnernate dictionary functions.
backgroundAlternateDictionary = 'OLBackgroundParamsDictionary_Test';
directionAlternateDictionary = 'OLDirectionParamsDictionary_Test';
waveformAlternateDictionary = 'OLWaveformParamsDictionary_Test';

%% Set up the calibrationStructure
protocolParams.calibrationType = calibrationType;
cal = OLGetCalibrationStructure('CalibrationType',protocolParams.calibrationType,'CalibrationDate','latest');
nDirections = 0;

%% Load XYZ cmfs
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
if (~TEST_MAXLMS_CHROM)
    % This version works on the bipolar modulations
    MaxLMSParams = OLDirectionParamsFromName('MaxLMS_unipolar_275_60_667', ...
        'alternateDictionaryFunc', directionAlternateDictionary);
    
    [MaxLMSDirection, MaxLMSBackground] = OLDirectionNominalFromParams(MaxLMSParams, cal, ...
        'observerAge',protocolParams.observerAgeInYrs, ...
        'alternateBackgroundDictionaryFunc', backgroundAlternateDictionary);
    
else
    % MaxLMS specify chromaticity version
    MaxLMSParams = OLDirectionParamsFromName('MaxLMS_chrom_unipolar_275_60_4000', ...
        'alternateDictionaryFunc', directionAlternateDictionary);
    
    [MaxLMSDirection, MaxLMSBackground] = OLDirectionNominalFromParams(MaxLMSParams, cal, ...
        'observerAge',protocolParams.observerAgeInYrs, ...
        'alternateBackgroundDictionaryFunc', backgroundAlternateDictionary);
end

%% MaxMel
if (TEST_MAXMEL)
    nDirections = nDirections+1;
    directions{nDirections} = 'MaxMelDirection';
    if (~TEST_MAXLMS_CHROM)
        % MaxMel version based on bipolar modulations
        MaxMelParams = OLDirectionParamsFromName('MaxMel_unipolar_275_60_667', ...
            'alternateDictionaryFunc', directionAlternateDictionary);
        [MaxMelDirection, MaxMelBackground] = OLDirectionNominalFromParams(MaxMelParams, cal, ...
            'observerAge',protocolParams.observerAgeInYrs, ...
            'alternateBackgroundDictionaryFunc', backgroundAlternateDictionary);
    else
        % MaxMel specify chromaticity version
        MaxMelParams = OLDirectionParamsFromName('MaxMel_chrom_unipolar_275_60_4000', ...
            'alternateDictionaryFunc', directionAlternateDictionary);
        
        [MaxMelDirection, MaxMelBackground] = OLDirectionNominalFromParams(MaxMelParams, cal, ...
            'observerAge',protocolParams.observerAgeInYrs, ...
            'alternateBackgroundDictionaryFunc', backgroundAlternateDictionary);
    end
end

%% Light flux at one chrom
if (TEST_LIGHTFLUX)
    nDirections = nDirections+1;
    directions{nDirections} = 'LightFluxDirection';
    
    if (~TEST_LIGHTFLUX_CHROM)
        LightFluxParams = OLDirectionParamsFromName('LightFlux_Unipolar_4000', ...
            'alternateDictionaryFunc', directionAlternateDictionary);
        
        [LightFluxDirection, LightFluxBackground] = OLDirectionNominalFromParams(LightFluxParams, cal, ...
            'alternateBackgroundDictionaryFunc', backgroundAlternateDictionary);
    else
        % "LightFlux specify chromaticity version
        LightFluxParams = OLDirectionParamsFromName('LightFlux_chrom_unipolar_275_60_4000', ...
            'alternateDictionaryFunc', directionAlternateDictionary);
        
        [LightFluxDirection, LightFluxBackground] = OLDirectionNominalFromParams(LightFluxParams, cal, ...
            'observerAge',protocolParams.observerAgeInYrs, ...
            'alternateBackgroundDictionaryFunc', backgroundAlternateDictionary);
    end
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