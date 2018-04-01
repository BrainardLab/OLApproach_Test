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

%% LightFlux_540_380_50
% Background at xy = [0.54,0.38] that allows light flux pulses to increase
% a factor of 5 within gamut
params = OLBackgroundParams_LightFluxChrom;
params.baseName = 'LightFlux';
params.lightFluxDesiredXY = [0.54,0.38];
params.lightFluxDownFactor = 5;
params.primaryHeadRoom = 0.00;
params.name = OLBackgroundNameFromParams(params);
if OLBackgroundParamsValidate(params)
    % All validations OK. Add entry to the dictionary.
    dictionary(params.name) = params;
end

end