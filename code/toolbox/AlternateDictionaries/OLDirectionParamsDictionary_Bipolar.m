function dictionary = OLDirectionParamsDictionary_Test()
% Defines a dictionary with parameters for named nominal directions
%
% Syntax:
%   dictionary = OLDirectionParamsDictionary_Test()
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

%% LightFlux_BipolarBase
%
% Base params for light flux bipolar directions
params = OLDirectionParams_LightFluxChrom;
params.baseName = 'LightFlux';
params.polarType = 'bipolar';
params.desiredxy = [0.33 0.33];
params.whichXYZ = 'xyzCIEPhys10';
params.desiredMaxContrast = 0.8;
params.desiredLum = 500;

% These are the options that go to OLPrimaryInvSolveChrom
params.search.primaryHeadroom = 0.005;
params.search.primaryTolerance = 1e-6;
params.search.checkPrimaryOutOfRange = true;
params.search.lambda = 0;
params.search.whichSpdToPrimaryMin = 'leastSquares';
params.search.spdToleranceFraction = 0.005;
params.search.chromaticityTolerance = 0.0001;
params.search.optimizationTarget = 'maxLum';
params.search.primaryHeadroomForInitialMax = 0.005;
params.search.maxSearchIter = 300;
params.search.verbose = true;

params.name = 'LightFlux_BipolarBase';
if OLDirectionParamsValidate(params)
    % All validations OK. Add entry to the dictionary.
    dictionary(params.name) = params;
end

end