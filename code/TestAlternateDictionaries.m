% testAltnerateDictionaries
%
% Description:
%    Test the features that allow us to call alternate dictionaries.
%

% History:
%   03/31/18  dhb  Wrote it.

%% Clear
clear; close all;

% Define altnernate dictionary function.
backgroundAlternateDictionary = 'OLBackgroundParamsDictionary_Test';
directionAlternateDictionary = 'OLDirectionParamsDictionary_Test';
waveformAlternateDictionary = 'OLWaveformParamsDictionary_Test';

%% List entries
%
% Tests OLGetBackgroundNames and OLGetDictionaryNames.
names = OLGetBackgroundNames('alternateDictionaryFunc',backgroundAlternateDictionary)

% Tests OLGetDictionaryNames
names = OLGetDirectionNames('alternateDictionaryFunc',directionAlternateDictionary)

% Tests OLGetWaveformyNames
names = OLGetWaveformNames('alternateDictionaryFunc',waveformAlternateDictionary)

%% Can we still see an original dictionary
names = OLGetWaveformNames

%% Get params
%
% Background
backgroundParams = OLBackgroundParamsFromName('Test',...
    'alternateDictionaryFunc',backgroundAlternateDictionary)

% Directions
directionParams = OLDirectionParamsFromName('TestDir',...
    'alternateDictionaryFunc',directionAlternateDictionary)

% Directions
waveformParams = OLDirectionParamsFromName('TestWav',...
    'alternateDictionaryFunc',waveformAlternateDictionary)
