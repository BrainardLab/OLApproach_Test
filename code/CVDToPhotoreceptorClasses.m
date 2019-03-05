function photoreceptorClasses = CVDToPhotoreceptorClasses(CVD)
% Return default photoreceptor classes for specified CVD
%
% Syntax:
%   photoreceptorClasses = CVDToPhotoreceptorClasses(CVD)
%
% Description:
%    Takes in a string specification of a color vision deficiency, and
%    returns array of photoreceptor classes associated present for that
%    deficiency. The returned string specifications of photoreceptor
%    classes are understood by the SilentSubstitutionToolbox.
%
% Input:
%    CVD                  - scalar string specifying color vision
%                           deficiency, currently knows:
%                            - protonopia
%                            - deuterantopia
%                            - tritanopia
%
% Outputs:
%    photoreceptorClasses - cellstr specifying default photoreceptor
%                           classes present for given CVD. Appriopriate L,
%                           M, S cone tabulated absorbances, and melanopsin
%
% Optional keyword arguments:
%    None.
%
% See also:
%    GetHumanPhotoreceptorSS

% History:
%    03/05/19  jv   wrote CVDToPhotoreceptorClasses

switch CVD
    case {'protanope','protanopia'}
        photoreceptorClasses = {...
            'MConeTabulatedAbsorbance'...
            'SConeTabulatedAbsorbance'...
            'Melanopsin'};
    case {'deuteranope','deuteranopia'}
        photoreceptorClasses = {...
            'LConeTabulatedAbsorbance'...
            'SConeTabulatedAbsorbance'...
            'Melanopsin'};
    case {'tritanope','tritanopia'}
        photoreceptorClasses = {...
            'LConeTabulatedAbsorbance'...
            'MConeTabulatedAbsorbance'...
            'Melanopsin'};
end
end