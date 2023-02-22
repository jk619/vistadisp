tbUse vistadisp
% runme for bar wedge ring (NEI core grant)
% 300TRs
Screen('Preference', 'TextRenderer', 0); % For draw formatted text
%% 
 
params                      = retCreateDefaultGUIParams;
params.fixation             = 'dot with grid';
params.tr                   = 1;
params.skipSyncTests        = 0;
params.calibration          = 'CBI_Propixx';
params.prescanDuration      = 0;
params.experiment           = 'experiment from file';
params.doEyelink            = true;
params.period               = 300;
params.responseDevice       = '932';
params.keyboard             = 'Magic Keyboard';
params.responseKeys         = {'1';'2';'3';'4';'6';'7';'8';'9'};
params.displayGUI           = false;
params.savefilepath         = '/Users/winawerlab/matlab/toolboxes/vistadisp/data_NEI/ret';

% If you don't know the names of the response box and keyboard use this
% command % [keyboardIndices, productNames, ~] = GetKeyboardIndices;

%% run it
explist = {'run1_bar_300TRs_3hz.mat';'run1_wedgering_300TRs_3hz.mat';'run2_bar_300TRs_3hz.mat';...
    'run2_wedgering_300TRs_3hz.mat';'run3_bar_300TRs_3hz.mat';'run3_wedgering_300TRs_3hz.mat'};
  

params.initials = 'JK';

for ii = 1:2
    
    params.sesNum = ii;
    params.loadMatrix = sprintf('%s', explist{ii});
    ret(params);
    
end

