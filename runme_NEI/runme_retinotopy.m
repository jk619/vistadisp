% runme for bar wedge ring (NEI core grant)
% 300TRs
Screen('Preference', 'TextRenderer', 0); % For draw formatted text
%% 
 
params                      = retCreateDefaultGUIParams;
params.fixation             = 'dot with grid';
params.tr                   = 1;
params.skipSyncTests        = 0;
params.calibration          = '';
params.prescanDuration      = 0;
params.experiment           = 'experiment from file';
params.doEyelink            = false;
params.period               = 300;
params.responseDevice       = 'Magic Keyboard';
params.keyboard             = 'Magic Keyboard'; %'Magic Keyboard';

%% the above responseDevice and keyboard should be set to what psychtoolbox sees as a device
% [keyboardIndices, productNames, ~] = GetKeyboardIndices;
% substitute both with whaterver comes out of productNames

params.responseKeys         = {'1';'2';'3';'4';'6';'7';'8';'9'};
params.displayGUI           = false;
params.savefilepath         = './data/'; %if not specified it will save files in vistarootpath dir


%% run it
explist = {'run1_bar_300TRs_3hz_1080px.mat';'run1_wedgering_300TRs_3hz_1080px.mat';'run2_bar_300TRs_3hz_1080px.mat';...
    'run2_wedgering_300TRs_3hz_1080px.mat';'run3_bar_300TRs_3hz_1080px.mat';'run3_wedgering_300TRs_3hz_1080px.mat'};


params.initials = 'XX';
commandwindow
for ii = 1:6

    params.sesNum = ii;
    params.loadMatrix = sprintf('%s', explist{ii});
    ret(params);

end
