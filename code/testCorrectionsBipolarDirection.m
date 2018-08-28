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
MaxMelParams = OLDirectionParamsFromName('MaxMel_bipolar_275_80_667');
[ MaxMelBipolar, MaxMelBackground ] = OLDirectionNominalFromParams(MaxMelParams, calibration, 'observerAge',observerAge);
receptors = MaxMelBipolar.describe.directionParams.T_receptors;
MaxMelBipolar.describe.photoreceptorClasses = MaxMelBipolar.describe.directionParams.photoreceptorClasses;
MaxMelBipolar.describe.T_receptors = receptors;

%% Validate pre-correction
OLValidateDirection(MaxMelBackground, OLDirection_unipolar.Null(calibration), onelight, radiometer, 'receptors', receptors, 'label', 'pre-correction');
OLValidateDirection(MaxMelBipolar, MaxMelBackground, onelight, radiometer, 'receptors', receptors, 'label', 'pre-correction');
preValidation = MaxMelBipolar.describe.validation(1); 
OLPlotValidationDirectionBipolar(preValidation);

%% Correct
lightlevelScalar = OLMeasureLightlevelScalar(onelight, calibration, radiometer);
OLCorrectDirection(MaxMelBipolar, MaxMelBackground, onelight, radiometer, 'receptors', receptors,...
    'smoothness',.001,...
    'lightlevelScalar',lightlevelScalar,...    
    'measureStateTrackingSPDs',~simulate,'temperatureProbe',[]);

%% Validate post-correction
OLValidateDirection(MaxMelBackground, OLDirection_unipolar.Null(calibration), onelight, radiometer, 'receptors', receptors, 'label', 'post-correction');
OLValidateDirection(MaxMelBipolar, MaxMelBackground, onelight, radiometer, 'receptors', receptors, 'label', 'post-correction');
postValidation = MaxMelBipolar.describe.validation(2);
OLPlotValidationDirectionBipolar(postValidation);