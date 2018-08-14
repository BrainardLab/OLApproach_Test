%% Test how well corrections of OLDirection_Unipolar works
clear all; close all;
simulate = true;
legacyMode = false;

%% Get calibration
calibrationApproach = 'Psychophysics'; % test on psychophysics rig
calibration = OLGetCalibrationStructure('CalibrationDate','latest',...
    'CalibrationFolder',getpref('OLApproach_Psychophysics','OneLightCalDataPath'));

%% Open hardware
onelight = OneLight('simulate',simulate,'plotWhenSimulating',false); drawnow;
if ~simulate
    radiometerPauseDuration = 0;
    onelight.setAll(true);
    commandwindow;
    fprintf('- Focus the radiometer and press enter to pause %d seconds and start measuring.\n', radiometerPauseDuration);
    input('');
    onelight.setAll(false);
    pause(radiometerPauseDuration);
    radiometer = OLOpenSpectroRadiometerObj('PR-670');
else
    radiometer = [];
end

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
OLCorrectDirection(MaxMelUnipolar, MaxMelBackground, onelight, radiometer, 'receptors', receptors, 'legacyMode', legacyMode);

%% Validate post-correction
OLValidateDirection(MaxMelBackground, OLDirection_unipolar.Null(calibration), onelight, radiometer, 'receptors', receptors, 'label', 'post-correction');
OLValidateDirection(MaxMelUnipolar, MaxMelBackground, onelight, radiometer, 'receptors', receptors, 'label', 'post-correction');

%% Pull out SPD, contrast
desiredSPD = MaxMelUnipolar.describe.validation(1).SPDcombined.desiredSPD;
desiredSPDBackground = MaxMelUnipolar.describe.validation(1).SPDbackground.desiredSPD;
desiredContrast = MaxMelUnipolar.describe.validation(1).contrastDesired(:,1);

preValidation = MaxMelUnipolar.describe.validation(1); 
preValidationSPDBackground = preValidation.SPDbackground.measuredSPD;
preValidationSPD = preValidation.SPDcombined.measuredSPD;
preValidationContrast = preValidation.contrastActual(:,1);

postValidation = MaxMelUnipolar.describe.validation(2);
postValidationSPD = postValidation.SPDcombined.measuredSPD;
postValidationSPDBackground = postValidation.SPDbackground.measuredSPD;
postValidationContrast = postValidation.contrastActual(:,1);

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
bar([desiredContrast preValidationContrast postValidationContrast]);
legend({'Desired','Pre','Post'});
xticks([1 2 3 4]);
xticklabels({'L','M','S','Mel'});