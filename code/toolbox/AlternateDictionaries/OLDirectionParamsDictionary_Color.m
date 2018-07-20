function dictionary = OLDirectionParamsDictionary_Color()
% Defines a dictionary with parameters for named nominal directions
%
% Syntax:
%   dictionary = OLDirectionParamsDictionary_COlor()
%
% Description:
%    Define a dictionary of named directions of modulation, with
%    corresponding nominal parameters. Types of directions, and their
%    corresponding fields, are defined in OLDirectionParamsDefaults,
%    and validated by OLDirectionParamsValidate.
%
% Inputs:
%    None.
%
% Outputs:
%    dictionary - Dictionary with all parameters for all desired directions
%
% Notes:
%    None.
%
% See also: OLBackgroundParamsDictionary

% History:
%    03/31/18  dhb  Created from OneLightToolbox version. Remove
%                   alternateDictionaryFunc key/value pair, since this
%                   would be called as the result of that.

%% Initialize dictionary
dictionary = containers.Map();

%% Some contrasts
LMinusMContrast = 0.06;

%% ConeDirected1
%
% Create a modulation around an already computed background
% that has desired cone contrasts for two field sizes.
targetContrastLMS = [LMinusMContrast -LMinusMContrast 0];

params = OLDirectionParams_Unipolar;
params.pupilDiameterMm = 6.0;
params.photoreceptorClasses = {'LConeTabulatedAbsorbance','MConeTabulatedAbsorbance','SConeTabulatedAbsorbance','LConeTabulatedAbsorbance','MConeTabulatedAbsorbance','SConeTabulatedAbsorbance'};
params.fieldSizeDegrees = [15 15 15 2 2 2];
params.backgroundName = '';
params.targetContrast = [targetContrastLMS targetContrastLMS];

% These are the options that go to OLPrimaryInvSolveChrom
params.search.primaryHeadroom = 0.005;
params.search.primaryTolerance = 1e-6;
params.search.checkPrimaryOutOfRange = true;
params.search.lambda = 0;
params.search.whichSpdToPrimaryMin = 'leastSquares';
params.search.chromaticityTolerance = 10-5;
params.search.lumToleranceFraction = 10-3;
params.search.optimizationTarget = 'receptorContrast';
params.search.primaryHeadroomForInitialMax = 0.005;
params.search.maxSearchIter = 3000;
params.search.verbose = false;

params.name = 'ConeDirected1';
if OLDirectionParamsValidate(params)
    dictionary(params.name) = params;
end

%% ConeDirected2
%
% Create a modulation around an already computed background
% that has desired cone contrasts for two field sizes.
targetContrastLMS = [0.1 -0.1 0];

params = OLDirectionParams_Bipolar;
params.pupilDiameterMm = 6.0;
params.photoreceptorClasses = {'LConeTabulatedAbsorbance','MConeTabulatedAbsorbance','SConeTabulatedAbsorbance','LConeTabulatedAbsorbance','MConeTabulatedAbsorbance','SConeTabulatedAbsorbance'};
params.fieldSizeDegrees = [15 15 15 2 2 2];
params.modulationContrast = [LMinusMContrast -LMinusMContrast LMinusMContrast -LMinusMContrast];
params.whichReceptorsToIsolate = [1 2 4 5];
params.whichReceptorsToIgnore = [];
params.whichReceptorsToMinimize = [];
params.backgroundName = '';
params.name = OLDirectionNameFromParams(params);
if OLDirectionParamsValidate(params)
    dictionary(params.name) = params;
end

params.name = 'ConeDirected2';
if OLDirectionParamsValidate(params)
    dictionary(params.name) = params;
end

%% ConeDirectedBackground
%
% Set up to create a background of specified contrast and luminance
params = OLDirectionParams_LightFluxChrom;
params.baseName = 'ConeDirectedBackground';
params.polarType = 'unipolar';
params.desiredxy = [0.3 0.3];
params.whichXYZ = 'xyzCIEPhys10';
params.desiredMaxContrast = 1e-4;
params.desiredLum = 100;

% These are the options that go to OLPrimaryInvSolveChrom
params.search.primaryHeadroom = 0.000;
params.search.primaryTolerance = 1e-6;
params.search.checkPrimaryOutOfRange = true;
params.search.lambda = 0;
params.search.whichSpdToPrimaryMin = 'leastSquares';
params.search.spdToleranceFraction = 10-5;
params.search.chromaticityTolerance = 10-5;
params.search.optimizationTarget = 'maxContrast';
params.search.primaryHeadroomForInitialMax = 0.000;
params.search.maxSearchIter = 3000;
params.search.verbose = false;

params.name = 'ConeDirectedBackground';
if OLDirectionParamsValidate(params)
    dictionary(params.name) = params;
end

end