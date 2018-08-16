%% Test how well corrections of OLDirection_Unipolar works
clear all; close all;
simulate = true;
legacyMode = false;

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

%% Correct
OLCorrectDirection(MaxMelBipolar, MaxMelBackground, onelight, radiometer, 'receptors', receptors,...
    'smoothness',.01);

%% Validate post-correction
OLValidateDirection(MaxMelBackground, OLDirection_unipolar.Null(calibration), onelight, radiometer, 'receptors', receptors, 'label', 'post-correction');
OLValidateDirection(MaxMelBipolar, MaxMelBackground, onelight, radiometer, 'receptors', receptors, 'label', 'post-correction');

%% Pull out SPD, contrast
desiredSPD = MaxMelBipolar.describe.validation(1).SPDcombined.desiredSPD;
desiredSPDBackground = MaxMelBipolar.describe.validation(1).SPDbackground.desiredSPD;
desiredContrast = MaxMelBipolar.describe.validation(1).contrastDesired(:,[1,3]);

preValidation = MaxMelBipolar.describe.validation(1); 
preValidationSPDBackground = preValidation.SPDbackground.measuredSPD;
preValidationSPD = preValidation.SPDcombined.measuredSPD;
preValidationContrast = preValidation.contrastActual(:,[1,3]);

postValidation = MaxMelBipolar.describe.validation(2);
postValidationSPD = postValidation.SPDcombined.measuredSPD;
postValidationSPDBackground = postValidation.SPDbackground.measuredSPD;
postValidationContrast = postValidation.contrastActual(:,[1,3]);

%% Plot
figure();
subplot(2,1,1); hold on;
plot(desiredSPDBackground,'k:');
plot(preValidationSPDBackground,'r:');
plot(postValidationSPDBackground,'g:');

plot(desiredSPD,'k-');
plot(preValidationSPD,'r-');
plot(postValidationSPD,'g-');

legend({'background desired','background pre','background corrected','combined desired','combined pre','combined corrected'});

subplot(2,1,2); hold on;
boxplot(desiredContrast','color','k');
boxplot(preValidationContrast','color','r');
boxplot(postValidationContrast','color','g');
line(xlim,[0 0],'color','k','linestyle',':');
xticks([1 2 3 4]);
xticklabels({'L','M','S','Mel'});