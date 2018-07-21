function dictionary = OLDirectionParamsDictionary_Color()
% Defines a dictionary with parameters for named nominal directions
%
% Syntax:
%   dictionary = OLDirectionParamsDictionary_Color()
%
% Description:
%    Define a dictionary of named directions of modulation, with
%    corresponding nominal parameters.
%
% Inputs:
%    None.
%
% Outputs:
%    dictionary   Dictionary with all parameters for all desired directions
%
% Notes:
%    None.
%
% See also: OLDirectionParamsDictionary, OLBackgroundParamsDictionary,
%     OLBackgroundParamsDictionary_Color
%

% History:
%    07/20/18  dhb  Created this version.

%% Initialize dictionary
dictionary = containers.Map();

%% ConeDirected
%
% Create a modulation around an already computed background
% that has desired cone contrasts for two field sizes.
LMinusMContrast = 0.06;
params = OLDirectionParams_Bipolar;
params.pupilDiameterMm = 6.0;
params.photoreceptorClasses = {'LConeTabulatedAbsorbance','MConeTabulatedAbsorbance','SConeTabulatedAbsorbance','LConeTabulatedAbsorbance','MConeTabulatedAbsorbance','SConeTabulatedAbsorbance'};
params.fieldSizeDegrees = [2 2 2 15 15 15];
params.modulationContrast = [LMinusMContrast -LMinusMContrast LMinusMContrast -LMinusMContrast];
params.whichReceptorsToIsolate = [1 2 4 5];
params.whichReceptorsToIgnore = [];
params.whichReceptorsToMinimize = [];
params.backgroundName = '';
params.name = OLDirectionNameFromParams(params);
if OLDirectionParamsValidate(params)
    dictionary(params.name) = params;
end

params.name = 'ConeDirected';
if OLDirectionParamsValidate(params)
    dictionary(params.name) = params;
end

%% ConeDirectedBackground
%
% Set up to create a background of specified contrast and luminance.
% This is specified in the directions dictionary because the background
% appears as part of the construction of a light flux modulation.
%
% Conceptually, we'd prefer to separate generation of backgrounds from
% modulations, but life is a little short to do that right now.
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