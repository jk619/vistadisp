clc
clear
tbUse vistadisp
addpath(genpath('./code_and_documentation'))
Screen('Preference', 'TextRenderer', 0); % For draw formatted text


params.responseDevice       = '932';
params.keyboard             = 'Magic Keyboard';
params.doEyelink            = 1;

% runme for MT localizer (NEI core grant)
% 300TRs

%% 

initials = input('Please enter subjct initials: ', 's');

for ii = 1
    MTloc(params,initials,ii)
end

