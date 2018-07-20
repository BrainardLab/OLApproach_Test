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
%   Bipolar contrast: 66.7%
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

%% LMSDirected_275_60_667
% Background to allow maximum unipolar contrast LMS modulations
%   Field size: 27.5 deg
%   Pupil diameter: 6 mm
%   Bipolar contrast: 66.7%
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

%% LMSDirected_chrom_275_60_400
% Background to allow maximum unipolar contrast LMS modulations
%   Field size: 27.5 deg
%   Pupil diameter: 6 mm
%   Unipolar contrast: 400%
params = OLBackgroundParams_Optimized;
params.baseName = 'LMSDirected_chrom';
params.baseModulationContrast = 4;
params.fieldSizeDegrees = 27.5;
params.pupilDiameterMm = 6;
params.photoreceptorClasses = {'LConeTabulatedAbsorbance','MConeTabulatedAbsorbance','SConeTabulatedAbsorbance','Melanopsin'};

% These are the options that go to OLPrimaryInvSolveChrom
params.desiredxy = [0.60,0.37];
params.desiredLum = 120;
params.whichXYZ = 'xyzCIEPhys10';
params.targetContrast = [params.baseModulationContrast params.baseModulationContrast params.baseModulationContrast 0];
params.search.primaryHeadroom = 0.005;
params.search.primaryTolerance = 1e-6;
params.search.checkPrimaryOutOfRange = true;
params.search.lambda = 0;
params.search.whichSpdToPrimaryMin = 'leastSquares';
params.search.chromaticityTolerance = 0.03;
params.search.lumToleranceFraction = 0.1;
params.search.optimizationTarget = 'receptorContrast';
params.search.primaryHeadroomForInitialMax = 0.005;
params.search.maxSearchIter = 3000;
params.search.verbose = false;

params.name = OLBackgroundNameFromParams(params);
if OLBackgroundParamsValidate(params)
    % All validations OK. Add entry to the dictionary.
    dictionary(params.name) = params;
end

%% MelDirected_chrom_275_60_400
% Background to allow maximum unipolar contrast Mel modulations
%   Field size: 27.5 deg
%   Pupil diameter: 6 mm
%   Unipolar contrast: 400%
params = OLBackgroundParams_Optimized;
params.baseName = 'MelDirected_chrom';
params.baseModulationContrast = 4;
params.fieldSizeDegrees = 27.5;
params.pupilDiameterMm = 6;
params.photoreceptorClasses = {'LConeTabulatedAbsorbance','MConeTabulatedAbsorbance','SConeTabulatedAbsorbance','Melanopsin'};

% These are the options that go to OLPrimaryInvSolveChrom
params.desiredxy = [0.59,0.39];
params.desiredLum = 315;
params.whichXYZ = 'xyzCIEPhys10';
params.targetContrast = [0 0 0 params.baseModulationContrast];
params.search.primaryHeadroom = 0.005;
params.search.primaryTolerance = 1e-6;
params.search.checkPrimaryOutOfRange = true;
params.search.lambda = 0;
params.search.whichSpdToPrimaryMin = 'leastSquares';
params.search.chromaticityTolerance = 0.03;
params.search.lumToleranceFraction = 0.1;
params.search.optimizationTarget = 'receptorContrast';
params.search.primaryHeadroomForInitialMax = 0.005;
params.search.maxSearchIter = 3000;
params.search.verbose = false;

params.name = OLBackgroundNameFromParams(params);
if OLBackgroundParamsValidate(params)
    % All validations OK. Add entry to the dictionary.
    dictionary(params.name) = params;
end


%% LightFluxDirected_chrom_275_60_400
% Background to allow maximum unipolar contrast LightFlux modulations
%   Field size: 27.5 deg
%   Pupil diameter: 6 mm
%   Unipolar contrast: 400%
params = OLBackgroundParams_Optimized;
params.baseName = 'LightFlux_chrom';
params.baseModulationContrast = 4;
params.fieldSizeDegrees = 27.5;
params.pupilDiameterMm = 6;
params.photoreceptorClasses = {'LConeTabulatedAbsorbance','MConeTabulatedAbsorbance','SConeTabulatedAbsorbance','Melanopsin'};

% These are the options that go to OLPrimaryInvSolveChrom
params.desiredxy = [0.58,0.39];
params.desiredLum = 210;
params.whichXYZ = 'xyzCIEPhys10';
params.targetContrast = [params.baseModulationContrast params.baseModulationContrast params.baseModulationContrast params.baseModulationContrast];
params.search.primaryHeadroom = 0.005;
params.search.primaryTolerance = 1e-6;
params.search.checkPrimaryOutOfRange = true;
params.search.lambda = 0;
params.search.whichSpdToPrimaryMin = 'leastSquares';
params.search.chromaticityTolerance = 0.03;
params.search.lumToleranceFraction = 0.6;
params.search.optimizationTarget = 'receptorContrast';
params.search.primaryHeadroomForInitialMax = 0.005;
params.search.maxSearchIter = 3000;
params.search.verbose = true;

params.name = OLBackgroundNameFromParams(params);
if OLBackgroundParamsValidate(params)
    % All validations OK. Add entry to the dictionary.
    dictionary(params.name) = params;
end

end