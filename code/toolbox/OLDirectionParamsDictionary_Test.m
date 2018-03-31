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

%% TestDir
% Direction for maximum unipolar contrast melanopsin step
%   Field size: 27.5 deg
%   Pupil diameter: 8 mm
%   bipolar contrast: 66.7%
%
% Bipolar contrast is specified to generate, but the result is a 400% 
% unipolar contrast step up relative to the background.
params = OLDirectionParams_Unipolar;
params.baseName = 'TestDir';
params.primaryHeadRoom = 0.01;
params.baseModulationContrast = 2/3;
params.fieldSizeDegrees = 27.5;
params.pupilDiameterMm = 8.0;
params.photoreceptorClasses = {'LConeTabulatedAbsorbance','MConeTabulatedAbsorbance','SConeTabulatedAbsorbance','Melanopsin'};
params.modulationContrast = [params.baseModulationContrast];
params.whichReceptorsToIsolate = [4];
params.whichReceptorsToIgnore = [];
params.whichReceptorsToMinimize = [];
params.backgroundName = 'Test'; %'MelanopsinDirected_275_80_667';
params.name = 'TestDir' %OLDirectionNameFromParams(params);
if OLDirectionParamsValidate(params)
    % All validations OK. Add entry to the dictionary.
    dictionary(params.name) = params;
end



end