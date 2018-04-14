function dictionary = OLBackgroundParamsDictionary_Test()
% Defines a dictionary with parameters for named nominal backgrounds
%
% Syntax:
%   dictionary = OLBackgroundParamsDictionary_Test()
%
% Description:
%    Define a dictionary of named backgrounds of modulation, with
%    corresponding nominal parameters.
%
% Inputs:
%    None.
%
% Outputs:
%    dictionary         -  Dictionary with all parameters for all desired
%                          backgrounds
%
% Optional key/value pairs:
%    None.
%
% Notes:
%    None.
%
% See also: 
%    OLBackgroundParams, OLBackgroundNomimalPrimaryFromParams,
%    OLBackgroundNominalPrimaryFromName, OLDirectionParamsDictionary,
%    OLMakeDirectionNominalPrimaries.

% History:
%    03/31/18  dhb  Created from OneLightToolbox version. Remove
%                   alternateDictionaryFunc key/value pair, since this
%                   would be called as the result of that.

% Initialize dictionary
dictionary = containers.Map();

%% MelanopsinDirected_275_60_667
% Background to allow maximum unipolar contrast melanopsin modulations
%   Field size: 27.5 deg
%   Pupil diameter: 6 mm
%   bipolar contrast: 66.7%
%
% Bipolar contrast is specified to generate, this background is also used
% for a 400% unipolar pulse
params = OLBackgroundParams_Optimized;
params.baseName = 'MelanopsinDirected';
params.baseModulationContrast = 4/6;
params.primaryHeadRoom = 0.00;
params.pupilDiameterMm = 6;
params.photoreceptorClasses = {'LConeTabulatedAbsorbance','MConeTabulatedAbsorbance','SConeTabulatedAbsorbance','Melanopsin'};
params.modulationContrast = [4/6];
params.whichReceptorsToIsolate = {[4]};
params.whichReceptorsToIgnore = {[]};
params.whichReceptorsToMinimize = {[]};
params.directionsYoked = [0];
params.directionsYokedAbs = [0];
params.name = OLBackgroundNameFromParams(params);
if OLBackgroundParamsValidate(params)
    % All validations OK. Add entry to the dictionary.
    dictionary(params.name) = params;
end

%% LMSDirected_LMS_275_60_667
% Background to allow maximum unipolar contrast LMS modulations
%   Field size: 27.5 deg
%   Pupil diameter: 6 mm
%   bipolar contrast: 66.7%
%
% Bipolar contrast is specified to generate, this background is also used
% for a 400% unipolar pulse
params = OLBackgroundParams_Optimized;
params.baseName = 'LMSDirected';
params.baseModulationContrast = 4/6;
params.primaryHeadRoom = 0.00;
params.pupilDiameterMm = 6;
params.photoreceptorClasses = {'LConeTabulatedAbsorbance','MConeTabulatedAbsorbance','SConeTabulatedAbsorbance','Melanopsin'};
params.modulationContrast = {[4/6 4/6 4/6]};
params.whichReceptorsToIsolate = {[1 2 3]};
params.whichReceptorsToIgnore = {[]};
params.whichReceptorsToMinimize = {[]};
params.directionsYoked = [1];
params.directionsYokedAbs = [0];
params.name = OLBackgroundNameFromParams(params);
if OLBackgroundParamsValidate(params)
    % All validations OK. Add entry to the dictionary.
    dictionary(params.name) = params;
end

%% LightFlux_UnipolarBase
%
% Base params for unipolar light flux modulation backgrounds
params = OLBackgroundParams_LightFluxChrom;
params.baseName = 'LightFlux';
params.polarType = 'unipolar';
params.desiredxy = [0.59,0.39];
params.whichXYZ = 'xyzCIEPhys10';
params.desiredMaxContrast = 4;

% These are the options that go to OLPrimaryInvSolveChrom
params.search.primaryHeadRoom = 0.005;
params.search.primaryTolerance = 1e-6;
params.search.checkPrimaryOutOfRange = true;
params.search.initialLuminanceFactor = 0.2;
params.search.lambda = 0;
params.search.spdToleranceFraction = 0.005;
params.search.chromaticityTolerance = 0.0001;
params.search.optimizationTarget = 'maxLum';
params.search.primaryHeadroomForInitialMax = 0.005;
params.search.maxScaleDownForStart = 2;
params.search.maxSearchIter = 300;
params.search.verbose = false;

params.name = 'LightFlux_UnipolarBase';
if OLBackgroundParamsValidate(params)
    % All validations OK. Add entry to the dictionary.
    dictionary(params.name) = params;
end

%% LightFlux_330_330_20
%
% Base params for bipolar light flux modulation backgrounds
params = OLBackgroundParams_LightFluxChrom;
params.baseName = 'LightFlux';
params.polarType = 'bipolar';
params.desiredxy = [0.33,0.33];
params.whichXYZ = 'xyzCIEPhys10';
params.desiredMaxContrast = 0.8;

% These are the options that go to OLPrimaryInvSolveChrom
params.search.primaryHeadRoom = 0.005;
params.search.primaryTolerance = 1e-6;
params.search.checkPrimaryOutOfRange = true;
params.search.initialLuminanceFactor = 0.2;
params.search.lambda = 0;
params.search.spdToleranceFraction = 0.005;
params.search.chromaticityTolerance = 0.0001;
params.search.optimizationTarget = 'maxLum';
params.search.primaryHeadroomForInitialMax = 0.005;
params.search.maxScaleDownForStart = 2;
params.search.maxSearchIter = 300;
params.search.verbose = true;

params.name = 'LightFlux_BipolarBase';
if OLBackgroundParamsValidate(params)
    % All validations OK. Add entry to the dictionary.
    dictionary(params.name) = params;
end


end