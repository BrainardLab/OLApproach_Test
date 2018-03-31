% TestAltnerateDictionaries
%
% Description:
%    Test the features that allow us to call alternate dictionaries.
%

% History:
%   03/31/18  dhb  Wrote it.

% Clear
clear; close all;

% Define altnernate dictionary function.
backgroundAlternateDictionary = 'OLBackgroundParamsDictionary_Test';

% List entries
%   Tests OLGetBackgroundNames and OLGetDictionaryNames.
names = OLGetBackgroundNames('alternateDictionaryFunc',backgroundAlternateDictionary)

% Get params
backgroundParams = OLBackgroundParamsFromName('Test',...
    'alternateDictionaryFunc',backgroundAlternateDictionary);
