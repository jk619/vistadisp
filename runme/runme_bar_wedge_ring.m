tbUse vistadisp
% runme for bar wedge ring (NSD pRF design)
% 300TRs

%% 
 
params                      = retCreateDefaultGUIParams;
params.fixation             = 'dot with grid';
params.tr                   = 1;
params.skipSyncTests        = 0;
params.calibration          = 'CBI_Propixx';
params.prescanDuration      = 0;
params.experiment           = 'experiment from file';
params.doEyelink            = false;
params.period               = 300;
params.responseDevice       = '932';
params.keyboard             = 'Magic Keyboard';
params.responseKeys         = {'1';'2';'3';'4';'6';'7';'8';'9'};

% If you don't know the names of the response box and keyboard use this
% command % [keyboardIndices, productNames, ~] = GetKeyboardIndices;

%% stim file

%% run it
explist = {'bar_300TRs_5hz_1';'wedgering_300TRs_5hz_1';'bar_300TRs_10hz_1';'wedgering_300TRs_10hz_1';'bar_300TRs_15hz_1';'wedgering_300TRs_15hz_1'};

for ii = 2:length(explist)
    params.loadMatrix = sprintf('%s.mat', explist{ii});
    ret(params);
end


% Edit in dispStringInCenter
% Screen(?Preference?,?TextRenderer?, 0);