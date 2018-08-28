%% Test how well corrections of OLDirection_Unipolar works
clear all; close all;
simulate = true;

%% Open hardware
onelight = OneLight('simulate',simulate,'plotWhenSimulating',false); drawnow;
if ~simulate
    onelight.setAll(true);
    radiometer = OLOpenSpectroRadiometerObj('PR-670');
else
    radiometer = [];
end

%% Get calibration
calibrationApproach = 'Psychophysics'; % test on psychophysics rig
calibration = OLGetCalibrationStructure('CalibrationDate','latest',...
    'CalibrationFolder',getpref('OLApproach_Psychophysics','OneLightCalDataPath'));

%% Generate direction
observerAge = 32;
MaxMelParams = OLDirectionParamsFromName('MaxMel_unipolar_275_80_667');
[ MaxMelUnipolar, MaxMelBackground ] = OLDirectionNominalFromParams(MaxMelParams, calibration, 'observerAge',observerAge);
receptors = MaxMelUnipolar.describe.directionParams.T_receptors;
MaxMelUnipolar.describe.photoreceptorClasses = MaxMelUnipolar.describe.directionParams.photoreceptorClasses;
MaxMelUnipolar.describe.T_receptors = receptors;

%% Validate pre-correction
OLValidateDirection(MaxMelBackground, OLDirection_unipolar.Null(calibration), onelight, radiometer, 'receptors', receptors, 'label', 'pre-correction');
OLValidateDirection(MaxMelUnipolar, MaxMelBackground, onelight, radiometer, 'receptors', receptors, 'label', 'pre-correction');

%% Correct
OLCorrectDirection(MaxMelUnipolar, MaxMelBackground, onelight, radiometer, 'receptors', receptors,...
    'smoothness',.001,...
    'measureStateTrackingSPDs',~simulate,'temperatureProbe',[]);

%% Validate post-correction
OLValidateDirection(MaxMelBackground, OLDirection_unipolar.Null(calibration), onelight, radiometer, 'receptors', receptors, 'label', 'post-correction');
OLValidateDirection(MaxMelUnipolar, MaxMelBackground, onelight, radiometer, 'receptors', receptors, 'label', 'post-correction');

%% Pull out validations
preValidation = MaxMelUnipolar.describe.validation(1); 
postValidation = MaxMelUnipolar.describe.validation(2);

%% Plot
OLPlotValidationDirectionUnipolar(preValidation);
OLPlotValidationDirectionUnipolar(postValidation);