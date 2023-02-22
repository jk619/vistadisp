
% runme for the colorful stimulus
% 192 TRs

%% 

params                      = retCreateDefaultGUIParams;
params.fixation             = 'dot with grid';
params.tr                   = 1;
params.skipSyncTests        = 0;
params.calibration          = 'CBI_Propixx';
params.prescanDuration      = 0;
params.experiment           = 'experiment from file';
params.doEyelink            = true;
params.period               = 192;
params.responseDevice       = '932';
params.keyboard             = 'Magic Keyboard';
params.responseKeys         = {'1';'2';'3';'4';'6';'7';'8';'9'};
params.displayGUI           = false;
%% stim file

%% run it

for ii = 1:6
    params.sesNum = ii;
    params.loadMatrix = sprintf('ret_%d.mat', ii);
    ret(params);
end