function dictionary = OLBackgroundParamsDictionary_Color()
% Defines a dictionary with parameters for named nominal backgrounds
%
% Syntax:
%   dictionary = OLBackgroundParamsDictionary_Color()
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

end