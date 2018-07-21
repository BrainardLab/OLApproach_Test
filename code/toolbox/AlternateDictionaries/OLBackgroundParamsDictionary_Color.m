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
%    07/20/18  dhb  Created. It's actually empty, but we want the file to exist.

% Initialize dictionary
dictionary = containers.Map();

end