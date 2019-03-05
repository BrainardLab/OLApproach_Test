clear all;

%% Define parameters
% What CVD?
CVD = 'protanopia';

% Which photoreceptor classes?
photoreceptorClasses = CVDToPhotoreceptorClasses(CVD);
% Field size
fieldSize = 27.5; % degree visual angle

% Pupil diameter
pupilDiameter = 6; % mm

% Observer age
observerAge = 32;

%% Define direction: mel isolating
% Define as strings
isolate = "Melanopsin";
ignore = "";

% Convert to logical
isolateLogical = photoreceptorClasses == isolate;
ignoreLogical = photoreceptorClasses == ignore;

% Convert to indices that SST expects
whichReceptorsToIsolate = num2cell(find(isolateLogical));
whichReceptorsToIgnore = num2cell(find(ignoreLogical));
whichReceptorsToMinimize = {[]};
if isempty(whichReceptorsToIgnore)
    whichReceptorsToIgnore = {[]};
end

%% Get calibration
calibrationApproach = 'Psychophysics'; % test on psychophysics rig
calibration = OLGetCalibrationStructure('CalibrationDate','latest',...
    'CalibrationFolder',getpref('OLApproach_Psychophysics','OneLightCalDataPath'));

% Extract wavelength sampling
S = calibration.describe.S;

%% Create T_receptors
T_receptors = GetHumanPhotoreceptorSS(S,...
                    photoreceptorClasses,...
                    fieldSize,...
                    observerAge,...
                    pupilDiameter);
                
%% Set optimized background params
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

% Define target contrast
backgroundParams.modulationContrast = [4/6];

%% Create optimized background
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

%% Set background
directionParams.background = background;

%% Make direction, unipolar background
[direction, unipolarBackground] = OLDirectionNominalFromParams(directionParams, calibration);

%% Print contrast
direction.ToDesiredReceptorContrast(unipolarBackground, T_receptors)