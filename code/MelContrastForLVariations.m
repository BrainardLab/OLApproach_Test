clear all;

%% Get calibration
whichApproach = ['OLApproach_' GetWithDefault('Use calibration for which approach','Squint')];
calibration = OLGetCalibrationStructure('CalibrationFolder',getpref('OLApproach_Squint','OneLightCalDataPath'));

% Extract wavelength sampling
S = calibration.describe.S;

%% Create receptor fundamentals
% Receptor fundamentals are produced by SST/GetHumanPhotoreceptorSS. First
% pass in which base receptor fundamentals to use, as strings specifying
% the photoreceptor classes. In this case, we want to specify two L cones,
% no M cone, an S cone, and melanopsin.
photoreceptorClasses = {'LConeTabulatedAbsorbance',...
                        'LConeTabulatedAbsorbance',...
                        'SConeTabulatedAbsorbance',...
                        'Melanopsin'};

% It also takes a parameter lambdaMaxShift: a vector with, in nm, how to
% shift each receptor lambda max from the base fundamental:
lambdaMaxShift = [+2 +2 0 0];

% And some additional params:
fieldSize = 27.5; % degree visual angle
pupilDiameter = 6; % mm
observerAge = 32;
headroom = 0;

% GetHumanPhotoreceptorSS is being a pain, and won't create the whole set
% correctly. We'll create them one  at a time to circumvent this:
for i = 1:length(photoreceptorClasses)
T_receptors(i,:) = GetHumanPhotoreceptorSS(S,...
                                      photoreceptorClasses(i),...
                                      fieldSize,...
                                      observerAge,...
                                      pupilDiameter,...
                                      lambdaMaxShift(i));
end
plot(MakeItWls(S),T_receptors');

%% Define direction: mel isolating
% Convert to logical
isolateLogical = [0 0 0 1]; % isolate Mel, which is 4
ignoreLogical = [0 0 0 0];

% Convert to indices that SST expects
whichReceptorsToIsolate = num2cell(find(isolateLogical));
whichReceptorsToIgnore = num2cell(find(ignoreLogical));
whichReceptorsToMinimize = {[]};
if isempty(whichReceptorsToIgnore)
    whichReceptorsToIgnore = {[]};
end

%% Create optimized background
% Get empty background params object
backgroundParams = OLBackgroundParams_Optimized;

% Fill in params
backgroundParams.backgroundObserverAge = observerAge;
backgroundParams.pupilDiameterMm = pupilDiameter;
backgroundParams.fieldSizeDegrees = fieldSize;
backgroundParams.photoreceptorClasses = photoreceptorClasses;
backgroundParams.T_receptors = T_receptors;

% Define isolation params
backgroundParams.whichReceptorsToIgnore = whichReceptorsToIgnore;
backgroundParams.whichReceptorsToIsolate = whichReceptorsToIsolate;
backgroundParams.whichReceptorsToMinimize = whichReceptorsToMinimize;
backgroundParams.modulationContrast = OLUnipolarToBipolarContrast(18);
backgroundParams.primaryHeadRoom = headroom;

% Make background
background = OLBackgroundNominalFromParams(backgroundParams, calibration);

%% Set unipolar direction params
% Get empty direction params object
directionParams = OLDirectionParams_Unipolar;

% Fill in params
directionParams.pupilDiameterMm = pupilDiameter;
directionParams.fieldSizeDegrees = fieldSize;
directionParams.photoreceptorClasses = photoreceptorClasses;
directionParams.T_receptors = T_receptors;

% Define isolation params
directionParams.whichReceptorsToIgnore = [whichReceptorsToIgnore{:}];
directionParams.whichReceptorsToIsolate = [whichReceptorsToIsolate{:}];
directionParams.whichReceptorsToMinimize = [whichReceptorsToMinimize{:}];
directionParams.modulationContrast = OLUnipolarToBipolarContrast(18);
directionParams.primaryHeadRoom = headroom;

% Set background
directionParams.background = background;

% Make direction, unipolar background
[direction, unipolarBackground] = OLDirectionNominalFromParams(directionParams, calibration);

%% Print contrast
direction.ToDesiredReceptorContrast(unipolarBackground, T_receptors)

%% Calculate contrasts