tbUse vistadisp
% runme for Ajay's SF
% 396 TRs
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
params.period               = 396;
params.responseDevice       = '932';
params.keyboard             = 'Magic Keyboard';
params.responseKeys         = {'1';'2';'3';'4';'6';'7';'8';'9'};
params.displayGUI           = false;
params.savefilepath         = '/Users/winawerlab/matlab/toolboxes/vistadisp/data_ajay/'; %if not specified it will save files in vistarootpath dir

if ~exist(params.savefilepath,'dir')
    mkdir(params.savefilepath)
end
%% run it
wlsubjnum = input('What is the subject wlsubj number? \n\n','s');
params.initials = sprintf('%s_',wlsubjnum);

for ii = 1:11
    params.sesNum = ii;
    params.loadMatrix = sprintf('run_%i_SFnoise_396TRs_1hz_1080.mat',ii);
    ret(params);
end

