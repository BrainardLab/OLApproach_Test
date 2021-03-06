%% Test whether OLCorrectionDirection performs well (enough)
simulate = false;

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
MaxMelParams = OLDirectionParamsFromName('MaxMel_unipolar_275_60_667');
[ MaxMelDirection, MaxMelBackground ] = OLDirectionNominalFromParams(MaxMelParams, calibration, 'observerAge',observerAge);
receptors = MaxMelDirection.describe.directionParams.T_receptors;

%% Validate pre-correction
OLValidateDirection(MaxMelBackground, OLDirection_unipolar.Null(calibration), onelight, radiometer, 'receptors', receptors, 'label', 'pre-correction');
OLValidateDirection(MaxMelDirection, MaxMelBackground, onelight, radiometer, 'receptors', receptors, 'label', 'pre-correction');

%% Correct
% dataWrapper = makeFakeCache(MaxMelDirection);
% correctedData = OLCorrectCacheFileOOC_modified(...
%         dataWrapper, calibration, onelight, ...
%         'igdalova@mail.med.upenn.edu', ...
%         'PR-670', radiometer, false, ...
%         'FullOnMeas', false, ...
%         'CalStateMeas', false, ...
%         'DarkMeas', false, ...
%         'OBSERVER_AGE', observerAge, ...
%         'ReducedPowerLevels', false, ...
%         'selectedCalType', calibrationType, ...
%         'CALCULATE_SPLATTER', false, ...
%         'lambda', 0.8, ...
%         'NIter', 20, ...
%         'powerLevels', [0 1.0000], ...
%         'doCorrection', true, ...
%         'postreceptoralCombinations', [1 1 1 0 ; 1 -1 0 0 ; 0 0 1 0 ; 0 0 0 1], ...
%         'outDir', fullfile('~/Desktop'), ...
%         'takeTemperatureMeasurements', false);

% OLCorrectDirection will correct both direction and background
OLCorrectDirection(MaxMelDirection,MaxMelBackground,onelight,radiometer);
    
%% Validate post-correction
OLValidateDirection(MaxMelBackground, OLDirection_unipolar.Null(calibration), onelight, radiometer, 'receptors', receptors, 'label', 'post-correction');
OLValidateDirection(MaxMelDirection, MaxMelBackground, onelight, radiometer, 'receptors', receptors, 'label', 'post-correction');