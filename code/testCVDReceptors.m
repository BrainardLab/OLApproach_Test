%% Define parameters
% Field size
fieldSize = 27.5; % degree visual angle

% Pupil diameter
pupilDiameter = 6; % mm

% Observer age
observerAge = 32;

% Wavelength sampling
S = [380 2 201];

%% Get trichromat receptors
photoreceptorClasses = {
    'LConeTabulatedAbsorbance'...
    'MConeTabulatedAbsorbance'...
    'SConeTabulatedAbsorbance'...
    'Melanopsin'};
Tri_receptors = GetHumanPhotoreceptorSS(S,...
                    photoreceptorClasses,...
                    fieldSize,...
                    observerAge,...
                    pupilDiameter);

%% Create T_receptors for CVD
% What CVD?
CVD = 'protanopia';

% Which photoreceptor classes?
photoreceptorClassesCVD = CVDToPhotoreceptorClasses(CVD);

% Get receptors
CVD_receptors = GetHumanPhotoreceptorSS(S,...
                    photoreceptorClassesCVD,...
                    fieldSize,...
                    observerAge,...
                    pupilDiameter);

%% Plot
plot(SToWls(S),Tri_receptors','r-'); hold on;
plot(SToWls(S),CVD_receptors','k-');