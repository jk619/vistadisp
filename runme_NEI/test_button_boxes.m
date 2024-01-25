% tbUse vistadisp
params.devices = getDevices;
params.responseDevice      = '932';
params.keyboard            = 'Magic Keyboard';
params                     = setRetinotopyDevices(params);
params.responseKeys        = {'1';'2';'3';'4';'6';'7';'8';'9'};

commandwindow
while 1
        % Find the subject response device
        [ssKeyIsDown,ssSecs,ssKeyCode] = KbCheck(params.devices.keyInputExternal);
        if(ssKeyIsDown)
            
            keypressed = KbName(ssKeyCode);
            Index = find(contains(params.responseKeys,keypressed(1)));
            if ~isempty(Index)
                            
            disp('This is subject response controller')
            end
            break
            
        end

end

while 1
        % Find the keyboard to control this computer
        [ssKeyIsDown,ssSecs,ssKeyCode] = KbCheck(params.devices.keyInputInternal);
        if(ssKeyIsDown)
            disp('This is the keyboard')
            break
            
        end
end
