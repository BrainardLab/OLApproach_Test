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

%% MaxMel_unipolar_275_60_667
% Direction for maximum unipolar contrast melanopsin step
%   Field size: 27.5 deg
%   Pupil diameter: 6 mm -- for use with 6 mm artificial pupil as part of
%   pupillometry
%   bipolar contrast: 66.7%
%
% Bipolar contrast is specified to generate, but the result is a 400% unipolar
% contrast step up relative to the background.
params = OLDirectionParams_Unipolar;
params.baseName = 'MaxMel';
params.primaryHeadRoom = 0.0;
params.baseModulationContrast = 2/3;
params.fieldSizeDegrees = 27.5;
params.pupilDiameterMm = 6.0;
params.photoreceptorClasses = {'LConeTabulatedAbsorbance','MConeTabulatedAbsorbance','SConeTabulatedAbsorbance','Melanopsin'};
params.modulationContrast = [params.baseModulationContrast];
params.whichReceptorsToIsolate = [4];
params.whichReceptorsToIgnore = [];
params.whichReceptorsToMinimize = [];
params.backgroundName = 'MelanopsinDirected_275_60_667';
params.name = OLDirectionNameFromParams(params);
if OLDirectionParamsValidate(params)
    % All validations OK. Add entry to the dictionary.
    dictionary(params.name) = params;
end

%% MaxLMS_unipolar_275_60_667
% Direction for maximum unipolar contrast LMS step
%   Field size: 27.5 deg
%   Pupil diameter: 6 mm -- for use with 6 mm artificial pupil with
%   pupillometry
%   bipolar contrast: 66.7%
%
% Bipolar contrast is specified to generate, but the result is a 400% unipolar
% contrast step up relative to the background.
params = OLDirectionParams_Unipolar;
params.baseName = 'MaxLMS';
params.primaryHeadRoom = 0.0;
params.baseModulationContrast = 2/3;
params.fieldSizeDegrees = 27.5;
params.pupilDiameterMm = 6.0;
params.photoreceptorClasses = {'LConeTabulatedAbsorbance','MConeTabulatedAbsorbance','SConeTabulatedAbsorbance','Melanopsin'};
params.modulationContrast = [params.baseModulationContrast params.baseModulationContrast params.baseModulationContrast];
params.whichReceptorsToIsolate = [1 2 3];
params.whichReceptorsToIgnore = [];
params.whichReceptorsToMinimize = [];
params.backgroundName = 'LMSDirected_275_60_667';
params.name = OLDirectionNameFromParams(params);
if OLDirectionParamsValidate(params)
    % All validations OK. Add entry to the dictionary.
    dictionary(params.name) = params;
end

%% MaxLMS_chrom_unipolar_275_60_400
% Direction for maximum unipolar contrast LMS step
%   Field size: 27.5 deg
%   Pupil diameter: 6 mm
%   Unipolar contrast: 400%

params = OLDirectionParams_Unipolar;
params.baseName = 'MaxLMS_chrom';
params.baseModulationContrast = 4;
params.fieldSizeDegrees = 27.5;
params.pupilDiameterMm = 6.0;
params.photoreceptorClasses = {'LConeTabulatedAbsorbance','MConeTabulatedAbsorbance','SConeTabulatedAbsorbance','Melanopsin'};
params.backgroundName = 'LMSDirected_chrom_275_60_4000';

% These are the options that go to OLPrimaryInvSolveChrom
params.desiredxy = [0.59,0.39];
params.desiredLum = [];
params.targetContrast = [params.baseModulationContrast params.baseModulationContrast params.baseModulationContrast 0];
params.search.primaryHeadroom = 0.005;
params.search.primaryTolerance = 1e-6;
params.search.checkPrimaryOutOfRange = true;
params.search.lambda = 0;
params.search.whichSpdToPrimaryMin = 'leastSquares';
params.search.chromaticityTolerance = 0.03;
params.search.lumToleranceFraction = 0.2;
params.search.optimizationTarget = 'receptorContrast';
params.search.primaryHeadroomForInitialMax = 0.005;
params.search.maxSearchIter = 3000;
params.search.verbose = false;

params.name = OLDirectionNameFromParams(params);
if OLDirectionParamsValidate(params)
    % All validations OK. Add entry to the dictionary.
    dictionary(params.name) = params;
end

%% MaxMel_chrom_unipolar_275_60_400
% Direction for maximum unipolar contrast Mel step
%   Field size: 27.5 deg
%   Pupil diameter: 6 mm
%   Unipolar contrast: 400%

params = OLDirectionParams_Unipolar;
params.baseName = 'MaxMel_chrom';
params.baseModulationContrast = 4;
params.fieldSizeDegrees = 27.5;
params.pupilDiameterMm = 6.0;
params.photoreceptorClasses = {'LConeTabulatedAbsorbance','MConeTabulatedAbsorbance','SConeTabulatedAbsorbance','Melanopsin'};
params.backgroundName = 'MelDirected_chrom_275_60_4000';

% These are the options that go to OLPrimaryInvSolveChrom
params.desiredxy = [0.59,0.39];
params.desiredLum = [];
params.targetContrast = [0 0 0 params.baseModulationContrast];
params.search.primaryHeadroom = 0.005;
params.search.primaryTolerance = 1e-6;
params.search.checkPrimaryOutOfRange = true;
params.search.lambda = 0;
params.search.whichSpdToPrimaryMin = 'leastSquares';
params.search.chromaticityTolerance = 0.03;
params.search.lumToleranceFraction = 0.2;
params.search.optimizationTarget = 'receptorContrast';
params.search.primaryHeadroomForInitialMax = 0.005;
params.search.maxSearchIter = 3000;
params.search.verbose = false;

params.name = OLDirectionNameFromParams(params);
if OLDirectionParamsValidate(params)
    % All validations OK. Add entry to the dictionary.
    dictionary(params.name) = params;
end

%% LightFlux_UnipolarBase
%
% Base params for unipolar light flux directions
params = OLDirectionParams_LightFluxChrom;
params.baseName = 'LightFlux';
params.polarType = 'unipolar';
params.desiredxy = [0.59,0.39];
params.whichXYZ = 'xyzCIEPhys10';
params.desiredMaxContrast = 4;
params.desiredBackgroundLuminance = 500;

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
params.search.verbose = false;

params.name = 'LightFlux_UnipolarBase';
if OLDirectionParamsValidate(params)
    % All validations OK. Add entry to the dictionary.
    dictionary(params.name) = params;
end

%% LightFlux_BipolarBase
%
% Base params for light flux bipolar directions
params = OLDirectionParams_LightFluxChrom;
params.baseName = 'LightFlux';
params.polarType = 'bipolar';
params.desiredxy = [0.33,0.33];
params.whichXYZ = 'xyzCIEPhys10';
params.desiredMaxContrast = 0.8;
params.desiredBackgroundLuminance = 500;

% These are the options that go to OLPrimaryInvSolveChrom
params.search.primaryHeadRoom = 0.005;
params.search.primaryTolerance = 1e-6;
params.search.checkPrimaryOutOfRange = true;
params.search.lambda = 0;
params.search.whichSpdToPrimaryMin = 'leastSquares';
params.search.spdToleranceFraction = 0.005;
params.search.chromaticityTolerance = 0.0001;
params.search.optimizationTarget = 'maxLum';
params.search.primaryHeadroomForInitialMax = 0.005;
params.search.maxSearchIter = 300;
params.search.verbose = false;

params.name = 'LightFlux_BipolarBase';
if OLDirectionParamsValidate(params)
    % All validations OK. Add entry to the dictionary.
    dictionary(params.name) = params;
end

end