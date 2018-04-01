function dictionary = OLWaveformParamsDictionary_Test()
% Defines a dictionary with parameters for named modulations
%
% Syntax:
%   dictionary = OLWaveformParamsDictionary_Test()
%
% Description:
%    Define a dictionary of named timeseries of modulation, with
%    corresponding nominal parameters. Types of modulations, and their
%    corresponding fields, are defined in OLWaveformParamsDefaults
%    and validated by OLWaveformParamsValidate.
%
% Inputs:
%    None.
%
% Outputs:
%    dictionary - dictionary with all parameters for all desired
%                 backgrounds
%
% Notes:
%    None.
%
% See also: 
%    OLWaveformParamsDefaults, OLWaveformParamsValidate,
%    OLMakeModulationPrimaries, OLDirectionParamsDictionary,
%    OLMakeDirectionNominalPrimaries.
%

% History:
%    03/31/18  dhb  Created from OneLightToolbox version. Remove
%                   alternateDictionaryFunc key/value pair, since this
%                   would be called as the result of that.

%% Initialize dictionary
dictionary = containers.Map();

%% MaxContrast3sPulse
modulationName = 'TestWav';
type = 'pulse';

params = OLWaveformParamsDefaults(type);
params.name = modulationName;
params.stimulusDuration = 0;

if OLWaveformParamsValidate(params)
    % All validations OK. Add entry to the dictionary.
    dictionary(params.name) = params;
end

end