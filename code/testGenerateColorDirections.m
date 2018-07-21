function [directions] = testGenerateColorDirections(calibrationType, observerAge)
% Compute nominal cone directed modulations around a background.
%
% Syntax:
%    [directions] = testGenerateColorDirections(calibrationType, observerAge)
%
% Description:
%    Find a fixed background near center of calibration's gamut. Then generate 
%    modulations around this background. The modulations are yoked together
%    for both foveal and peripheral cones in terms of their contrasts.
%
%    The key parameters used are stored in dictionaries that go with this
%    script. These are in the AlternateDictionaries folder of the project,
%    and for this script are called OLBackgroundParamsDictionary_Color and
%    OLDirectionParamsDictionary_Color.
%
% Input:
%    calibrationType  String describing the calibration from which we want
%                     to generate directions. Example
%                    'BoxALiquidLightGuideCEyePiece2ND09'.
%    observerAge      Age of subject for whom we're generating the
%                     directions.
%
% Output:
%    directions       Cell array of direction objects.
%

% History:
%   07/21/18  dhb  Color direction version.
%
% Examples:
%{
testGenerateColorDirections('BoxALiquidLightGuideCEyePiece2_ND09', 32);
%}

%% Parameters
%
% We'll use the new CIE XYZ functions.  These should match what is in the
% dictionary for the modulations.
whichXYZ = 'xyzCIEPhys10';

%% Define altnernate dictionary functions.
backgroundAlternateDictionary = 'OLBackgroundParamsDictionary_Color';
directionAlternateDictionary = 'OLDirectionParamsDictionary_Color';

%% Set calibration structure for OneLight.
% set up the calibrationStructure
protocolParams.calibrationType = calibrationType;
cal = OLGetCalibrationStructure('CalibrationType',protocolParams.calibrationType,'CalibrationDate','latest');

%% Direction counter
nDirections = 0;

%% Load cmfs
eval(['tempXYZ = load(''T_' whichXYZ ''');']);
eval(['T_xyz = SplineCmf(tempXYZ.S_' whichXYZ ',683*tempXYZ.T_' whichXYZ ',cal.describe.S);']);

%% Hellow
fprintf('<strong>%s</strong>, observer age %d\n',calibrationType, observerAge);

%% Get native chromaticity for this cal
nativeXYZ = T_xyz*OLPrimaryToSpd(cal,0.5*ones(size(cal.computed.pr650M,2),1));
nativexyY = XYZToxyY(nativeXYZ);
fprintf('\tDevice native half on xyY: %0.3f %0.3f %0.1f\n',nativexyY(1),nativexyY(2),nativexyY(3));

%% Set target xyY for background.
%
% Here we use the native half one, but you can type in what you want.
targetxyY = nativexyY;
fprintf('\tUsing target background xyY: %0.3f %0.3f %0.01\n',targetxyY(1),targetxyY(2),targetxyY(3));

%% Set up some information about our theoretical observer
protocolParams.observerID = '';
protocolParams.observerAgeInYrs = observerAge;

%% Set up simulations
%
% Having simulated radiometer and OneLight lets us call some underlying
% routines for reporting on the modulations we construct.
radiometer = [];
protocolParams.simulate.oneLight = true;
protocolParams.simulate.makePlots = false;

% Make the oneLight object
ol = OneLight('simulate',protocolParams.simulate.oneLight,'plotWhenSimulating',protocolParams.simulate.makePlots); drawnow;

%% Make a background of specified luminance and chromaticity
%
% Get basic parameters.  These ask for essentially no contrast and have
% very tight constraints on the desired chromaticity and luminance.
ConeDirectedBackgroundParams = OLDirectionParamsFromName('ConeDirectedBackground', ...
        'alternateDictionaryFunc', directionAlternateDictionary);
    
% Make sure we are consistent about which XYZ functions we are using.
ConeDirectedBackgroundParams.whichXYZ = whichXYZ;

% Set desired background xyY
ConeDirectedBackgroundParams.desiredxy = targetxyY(1:2);
ConeDirectedBackgroundParams.desiredLum = targetxyY(3);

% Get the background.  This also makes a light flux modulation, but we ignore that.
[~, ConeDirectedBackground] = OLDirectionNominalFromParams(ConeDirectedBackgroundParams, cal, ...
    'alternateBackgroundDictionaryFunc', backgroundAlternateDictionary);

%% Get base direction parameters.
%
% These get tweaked for different directions.
ConeDirectedParams = OLDirectionParamsFromName('ConeDirected', ...
    'alternateDictionaryFunc', directionAlternateDictionary);

% Assuming that no one messed up the dictionary, the base parameters
% specify 6 cone classes at two field sizes for each set of LMS.
%
% If you want to check, verify that the two fields below are as indicated:
%  ConeDirectedParams.photoreceptorClasses = {'LConeTabulatedAbsorbance','MConeTabulatedAbsorbance','SConeTabulatedAbsorbance','LConeTabulatedAbsorbance','MConeTabulatedAbsorbance','SConeTabulatedAbsorbance'};
%  ConeDirectedParams.fieldSizeDegrees = [2 2 2 15 15 15];

%% Make a test direction
%
% Bookkeeping.
nDirections = nDirections+1;
directions{nDirections} = 'ConeDirectedDirection1';

% Make a copy of the base parameters and set contrasts for an
% L-M modulation.
%
% The contrast was chosen by hand to be the highest
% we can get in this direction. If you make it much larger, you will not
% get equal and opposite contrasts as desired.  One could automate the
% search for the max feasible contrast, but doing it by hand goes pretty
% quickly.
ConeDirectedParams1 = ConeDirectedParams;
LMinusMContrast = 0.06;
ConeDirectedParams1.modulationContrast = [LMinusMContrast -LMinusMContrast LMinusMContrast -LMinusMContrast];
ConeDirectedParams1.whichReceptorsToIsolate = [1 2 4 5];

% Make direction. For contrast reporting to come out, we need some name matching
% between direction and background, which is why the background gets copied
% here.
ConeDirectedBackground1 = ConeDirectedBackground;
[ConeDirectedDirection1] = OLDirectionNominalFromParams(ConeDirectedParams1, cal, ...
    'observerAge',protocolParams.observerAgeInYrs, ...
    'background',ConeDirectedBackground1, ...
    'alternateBackgroundDictionaryFunc', backgroundAlternateDictionary);

%% Make another direction, just to show it wasn't a fluke.
%
% Only need to rewrite key parameters
nDirections = nDirections+1;
directions{nDirections} = 'ConeDirectedDirection2';

% We say which cones we want at a target contrast in the whichReceptorsToIsolate field.
% The otherclasses get their contrasts pegged at zero. The indices refer to
% the order of cones specified above.
%
% Again, the contrast was chosen by hand.
ConeDirectedParams2 = ConeDirectedParams;
LPlusMContrast = 0.50;
ConeDirectedParams2.modulationContrast = [LPlusMContrast LPlusMContrast LPlusMContrast LPlusMContrast];
ConeDirectedParams2.whichReceptorsToIsolate = [1 2 4 5];
ConeDirectedBackground2 = ConeDirectedBackground;
[ConeDirectedDirection2] = OLDirectionNominalFromParams(ConeDirectedParams2, cal, ...
    'observerAge',protocolParams.observerAgeInYrs, ...
    'background',ConeDirectedBackground2, ...
    'alternateBackgroundDictionaryFunc', backgroundAlternateDictionary);

%% Get receptor sensitivities used, so that we can get cone contrasts out below.
receptorStrings = ConeDirectedDirection1.describe.directionParams.photoreceptorClasses;
fieldSizes = ConeDirectedDirection1.describe.directionParams.fieldSizeDegrees;
receptors = GetHumanPhotoreceptorSS(ConeDirectedDirection1.calibration.describe.S,receptorStrings,fieldSizes,observerAge,6,[],[]);

%% Report on nominal backgrounds and cone contrasts
for dd = 1:length(directions)
    % Hello for this direction
    fprintf('<strong>%s</strong>\n', directions{dd});

    % Get contrasts. Code assumes matched naming of direction and background objects,
    % so that the string substitution works to get the background object
    % from the direction object.
    direction = eval(directions{dd});
    background = eval(strrep(directions{dd},'Direction','Background'));
    [~, excitations, excitationDiffs] = direction.ToDesiredReceptorContrast(background,receptors);  
      
    % Grab the relevant contrast information from the OLDirection object an
    % and report. Keep pos and neg contrast explicitly separate. These
    % should match in magnitude but be flipped in sign.
    for j = 1:size(receptors,1)
        fprintf('  * <strong>%s, %0.1f degrees</strong>: contrast pos = %0.1f, neg = %0.1f%%\n',receptorStrings{j},fieldSizes(j),100*excitationDiffs(j,1)/excitations(j,1),100*excitationDiffs(j,2)/excitations(j,1));
    end
    
    % Chromaticity and luminance
    backgroundxyY = XYZToxyY(T_xyz*OLPrimaryToSpd(cal,background.differentialPrimaryValues));
    fprintf('\n');
    fprintf('   * <strong>Background x, y, Y</strong>: %0.3f, %0.3f, %0.1f cd/m2\n',backgroundxyY(1),backgroundxyY(2),backgroundxyY(3));
    
    fprintf('\n\n');
end