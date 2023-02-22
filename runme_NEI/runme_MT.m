clc
clear
tbUse vistadisp
addpath(genpath('./code_and_documentation'))
Screen('Preference', 'TextRenderer', 0); % For draw formatted text


params.responseDevice       = '932';
params.keyboard             = 'Magic Keyboard';
params.doEyelink            = 1;
params.savefilepath         = '/Users/winawerlab/matlab/toolboxes/vistadisp/data_NEI/mot';

% runme for MT localizer (NEI core grant)
% 300TRs

%% 

initials = '';

for ii = 1:3
    MTloc(params,initials,ii)
end

