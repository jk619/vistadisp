tbUse vistadisp
% runme for fLOC
% 228 TRs
Screen('Preference', 'TextRenderer', 0); % For draw formatted text
%% 

params                      = retCreateDefaultGUIParams;
params.fixation             = 'dot';
params.tr                   = 1;
params.skipSyncTests        = 0;
params.calibration          = 'CBI_Propixx';
params.prescanDuration      = 0;
params.experiment           = 'experiment from file';
params.doEyelink            = true;
params.period               = 238;
params.responseDevice       = '932';
params.keyboard             = 'Magic Keyboard';
params.responseKeys         = {'1';'2';'3';'4';'6';'7';'8';'9'};
params.displayGUI           = false;
params.savefilepath         = '/Users/winawerlab/matlab/toolboxes/vistadisp/data_NEI/floc';

%% run it

params.initials = 'XX';

for ii = 1:4
    params.sesNum = ii;
    params.loadMatrix = sprintf('run%i_fLOC_238TRs_2hz.mat',ii);
    ret(params);
end

