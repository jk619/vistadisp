% This code is based on 
%https://github.com/rmartins-net/Localizer-MT-MST-MT-proper-Psychophysics-Toolbox

function MTloc(params,initials,ii)


sesNum = ii;


%--------------%
% MT localizer %
%--------------%
%%

% Close (eventually) open connections and PTB screens
IOPort('CloseAll');
Screen('CloseAll');

% Trick suggested by the PTB authors to avoid synchronization/calibration
% problems
figure(1)
plot(sin(0:0.1:3.14));
% Close figure with sin plot (PTB authors trick for synchronization)
close Figure 1



[keyboardIndices, productNames, ~] = GetKeyboardIndices;
for i=1:length(productNames)                                               % for each possible devicesca
    sca
    
    if strcmp(productNames{i},params.keyboard)                                % compare the name to the name you want
        keyboard=keyboardIndices(i);                                   % grab the correct id, and exit loop
        break;
    end
end

[keyboardIndices, productNames, ~] = GetKeyboardIndices;
for i=1:length(productNames)                                               % for each possible device
    if strcmp(productNames{i},params.responseDevice)                                % compare the name to the name you want
        responsebox=keyboardIndices(i);                                   % grab the correct id, and exit loop
        break;
    end
end

%%
% Synchronization tests procedure - PTBscsasca

% Do you want to skipsync tests (1) or not (0) ?
skipsynctests = 1;

% KbName will switch its internal naming
% scheme from the operating system specific scheme (which was used in
% the old Psychtoolboxes on MacOS-9 and on Windows) to the MacOS-X
% naming scheme, thereby allowing to use one common naming scheme for
% all operating systems
KbName('UnifyKeyNames');
% Code to identify "escape" key
escapekeycode = KbName('ESCAPE');
responsecodes = KbName({'1!';'2@';'3#';'4$';'6^';'7&';'8*';'9('; ...
    '1';'2';'3';'4';'6';'7';'8';'9'});


%----------------------------------------------------%

AssertOpenGL;

try
    
    % ------------------------
    % set dot field parameters
    % ------------------------
    
    nframes     = 18000; % number of animation frames in loop
    mon_width   = 60;   % horizontal dimension of viewable screen (cm)
    v_dist      = 83.5;   % viewing distance (cm)
    dot_speed   = 5; %7;    % dot speed (deg/sec)
    f_kill      = 0.00; % fraction of dots to kill each frame (limited lifetime)
    ndots       = 100; %2000; % number of dots
    max_d       = 4;%15;   % maximum radius of  annulus (degrees)
    min_d       = 0.1; %1;    % minumum (degrees)
    dot_w       = 0.1;  % width of dot (deg) px
    fix_r       = 0.09; %0.15; % radius of fixation point (deg)
    waitframes  = 1; % Show new dot-images at each waitframes'th monitor refresh.  'waitframes' Number of video refresh intervals to show each image before updating the dot field. Defaults to 1 if omitted.
    
    % ---------------
    % My Parameters
    % ---------------
    
    offset_left=10;  % (degrees)
    offset_right=10; % (degrees)
    offset_center=0;  % (degrees)
    
    efr=60; % estimated-target frame rate (Hz)
    TR=1 ;   % MRI TR (seconds)sca
    
    
    my_protocol=zeros(1,nframes);
    flip=zeros(1,nframes);
    % rest
    repeat = 4;
    conditions = repmat([1 -1 2 -2 3 -3],[1 repeat]);
    
    framesperblock = nframes/(numel(conditions)+1); %720;
    for c = 1 : length(conditions)
        
        my_protocol((1:framesperblock)+(c-1)*framesperblock) = conditions(c);
        
    end
    
    
    % ---------------
    % open the screen
    % ---------------
    
    screens=Screen('Screens');
    screenNumber=max(screens);
    [w, rect] = Screen('OpenWindow', screenNumber, 0);
    commandwindow
    % Enable alpha blending with proper blend-function. We need it
    % for drawing of smoothed points:
    Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    [center(1), center(2)] = RectCenter(rect);
    fps=Screen('FrameRate',w);      % frames per second
    ifi=Screen('GetFlipInterval', w);
    if fps==0
        fps=1/ifi;
    end
    
    white = WhiteIndex(w);
    HideCursor;	% Hide the mouse cursor
    Priority(MaxPriority(w));
    
    % Do initial flip...
    vbl=Screen('Flip', w);
    
    % ---------------------------------------
    % initialize dot positions and velocities
    % ---------------------------------------
    
    ppd = pi * (rect(3)-rect(1)) / atan(mon_width/v_dist/2) / 360;    % pixels per degree
    pfs = dot_speed * ppd / fps;                            % dot speed (pixels/frame)
    dotsize = dot_w * ppd; % dot size (pixels)
    smin=dotsize;
    smax=dotsize+dotsize;
    fix_cord = [center-fix_r*ppd center+fix_r*ppd];
    
    rmax = max_d * ppd;	% maximum radius of annulus (pixels from center)
    rmin = min_d * ppd; % minimum
    
    ms=(smax-smin)/(rmax-rmin);
    
    % IN #####################
    r_IN = rmax * sqrt(rand(ndots,1));	% r
    r_IN(r_IN<rmin) = rmin;
    t_IN = 2*pi*rand(ndots,1);                     % theta polar coordinate
    cs_IN = [cos(t_IN), sin(t_IN)];
    xy_IN = [r_IN r_IN] .* cs_IN;   % dot positions in Cartesian coordinates (pixels from center)
    
    %mdir = 2 * floor(rand(ndots,1)+0.5) - 1;    % motion direction (in or out) for each dot
    mdirIN=ones(ndots,1)-2;
    drIN = pfs * mdirIN;                            % change in radius per frame (pixels)
    dxdyIN = [drIN drIN] .* cs_IN;                       % change in x and y per frame (pixels)
    
    
    
    % OUT #####################
    r_EXT = rmax * sqrt(rand(ndots,1));	% r
    r_EXT(r_EXT<rmin) = rmin;
    t_EXT = 2*pi*rand(ndots,1);                     % theta polar coordinate
    cs_EXT = [cos(t_EXT), sin(t_EXT)];
    xy_EXT = [r_EXT r_EXT] .* cs_EXT;   % dot positions in Cartesian coordinates (pixels from center)
    
    %mdir = 2 * floor(rand(ndots,1)+0.5) - 1;    % motion direction (in or out) for each dot
    mdirEXT=ones(ndots,1);
    drEXT = pfs * mdirEXT;                            % change in radius per frame (pixels)
    dxdyEXT = [drEXT drEXT] .* cs_EXT;                       % change in x and y per frame (pixels)
    
    
    % Create a vector with different colors for each single dot, if
    % requested:
    colvect=white;
    
    %%
     %% Initialize EyeLink if requested
    if params.doEyelink
        fprintf('\n[%s]: Setting up Eyelink..\n',mfilename)
        
        Eyelink('SetAddress','192.168.1.5');
        el = EyelinkInitDefaults(w);
        EyelinkUpdateDefaults(el);
        %
        % %     Initialize the eyetracker
        Eyelink('Initialize', 'PsychEyelinkDispatchCallback');
        % %     Set up 5 point calibration
        s = Eyelink('command', 'calibration_type=HV5');
        %
        % %     Calibrate the eye tracker
        EyelinkDoTrackerSetup(el);
        %
        % %     Throw an error if calibration failed
        if s~=0
            error('link_sample_data error, status: ', s)
        end
   
        el = prepEyelink(w);
        
        sesFileName = sprintf('%s%d%s', initials, sesNum);

            
        ELfileName = sprintf('%s.edf', sesFileName);
        
        edfFileStatus = Eyelink('OpenFile', ELfileName);
        
        if edfFileStatus ~= 0, fprintf('Cannot open .edf file. Exiting ...');
            try
                Eyelink('CloseFile');
                Eyelink('Shutdown');
            end
            return; 
        else
            fprintf('\n[%s]: Succesfully openend Eyelink file..\n',mfilename)
        end
        
        cal = EyelinkDoTrackerSetup(el);
        
    end
    
    
    Screen('FillRect', w,[0 0 0])
    Screen('DrawDots', w, center,dotsize,[255 0 0],[],1)

    vbl=Screen('Flip', w);
    
    WaitSecs(1)
    wait4T(keyboard);
    
    if params.doEyelink
        Eyelink('StartRecording');
    end
    %%
    
    % --------------
    % animation loop
    % --------------
    duration_of_fixation = 180;
    fixation_presses = zeros(1,nframes);
    fixation_changes = cell(1,2);
    fixation_changes{1} = zeros(duration_of_fixation,1);
    fixation_changes{2} = ones(duration_of_fixation,1);
    fixation_changes = repelem(fixation_changes,(nframes/duration_of_fixation)/2);
    fixation_changes = fixation_changes(randperm(length(fixation_changes)));
    fixation_changes = cell2mat(fixation_changes(:));
    
    for i = 1:nframes
        
        if (i>1)
            
            [keyIsDown, secs, keyCode] = KbCheck(keyboard);
            
            if keyIsDown==1 && keyCode(escapekeycode)
                
                % Close PTB screen and connections
                Screen('CloseAll');
                IOPort('CloseAll');
                ShowCursor;
                Priority(0);
                
                % Launch window with warning of early end of program
                warndlg('The run was terminated with ''Esc'' before the end!','Warning','modal')
                
                return % abort program
            end
            
            [keyIsDown, secs, keyCode] = KbCheck(responsebox);

            if keyIsDown==1 && any(keyCode(responsecodes))
                fixation_presses(i) = 1;
            end
            
            if fixation_changes(i)
                
                Screen('DrawDots', w, center,dotsize,[255 0 0],[],1);
                
            else
                Screen('DrawDots', w, center,dotsize,[0 255 0],[],1);
            end
            
            if my_protocol(i)==0
                % do nothing
                
            elseif my_protocol(i)==1
                my_xymatrix(1,:)=xymatrix(1,:)+offset_center*ppd;
                my_xymatrix(2,:)=xymatrix(2,:);
                xy_IN = xy_IN + dxdyIN;						% move dots
                r_IN = r_IN + drIN;							% update polar coordinates too
                xy_EXT = xy_EXT + dxdyEXT;				% move dots
                r_EXT = r_EXT + drEXT;					% update polar coordinates too
                
                
                Screen('DrawDots', w, my_xymatrix, my_s, colvect, center,1);  % change 1 to 0 to draw square dots
                Screen('DrawingFinished', w); % Tell PTB that no further drawing commands will follow before Screen('Flip')
            elseif my_protocol(i)==-1
                my_xymatrix(1,:)=xymatrix(1,:)+offset_center*ppd;
                my_xymatrix(2,:)=xymatrix(2,:);
%                 xy_IN = xy_IN;  						% move dots
%                 r_IN = r_IN;							% update polar coordinates too
%                 xy_EXT = xy_EXT;      				% move dots
%                 r_EXT = r_EXT;   		    			% update polar coordinates too
                Screen('DrawDots', w, my_xymatrix, my_s, colvect, center,1);  % change 1 to 0 to draw square dots
                Screen('DrawingFinished', w); % Tell PTB that no further drawing commands will follow before Screen('Flip')
            elseif my_protocol(i)==2
                my_xymatrix(1,:)=xymatrix(1,:)-offset_left*ppd;
                my_xymatrix(2,:)=xymatrix(2,:);
                xy_IN = xy_IN + dxdyIN;						% move dots
                r_IN = r_IN + drIN;							% update polar coordinates too
                xy_EXT = xy_EXT + dxdyEXT;				% move dots
                r_EXT = r_EXT + drEXT;					% update polar coordinates too
                Screen('DrawDots', w, my_xymatrix, my_s, colvect, center,1);  % change 1 to 0 to draw square dots
                Screen('DrawingFinished', w); % Tell PTB that no further drawing commands will follow before Screen('Flip')
            elseif my_protocol(i)==-2
                my_xymatrix(1,:)=xymatrix(1,:)-offset_left*ppd;
                my_xymatrix(2,:)=xymatrix(2,:);
%                 xy_IN = xy_IN;						% move dots
%                 r_IN = r_IN;						% update polar coordinates too
%                 xy_EXT = xy_EXT;	     			% move dots
%                 r_EXT = r_EXT;					% update polar coordinates too
                Screen('DrawDots', w, my_xymatrix, my_s, colvect, center,1);  % change 1 to 0 to draw square dots
                Screen('DrawingFinished', w); % Tell PTB that no further drawing commands will follow before Screen('Flip')
            elseif my_protocol(i)==3
                my_xymatrix(1,:)=xymatrix(1,:)+offset_right*ppd;
                my_xymatrix(2,:)=xymatrix(2,:);
                xy_IN = xy_IN + dxdyIN;						% move dots
                r_IN = r_IN + drIN;							% update polar coordinates too
                xy_EXT = xy_EXT + dxdyEXT;				% move dots
                r_EXT = r_EXT + drEXT;					% update polar coordinates too
                Screen('DrawDots', w, my_xymatrix, my_s, colvect, center,1);  % change 1 to 0 to draw square dots
                Screen('DrawingFinished', w); % Tell PTB that no further drawing commands will follow before Screen('Flip')
            elseif my_protocol(i)==-3
                my_xymatrix(1,:)=xymatrix(1,:)+offset_right*ppd;
                my_xymatrix(2,:)=xymatrix(2,:);
%                 xy_IN = xy_IN;						% move dots
%                 r_IN = r_IN;							% update polar coordinates too
%                 xy_EXT = xy_EXT;				% move dots
%                 r_EXT = r_EXT;					% update polar coordinates too
                Screen('DrawDots', w, my_xymatrix, my_s, colvect, center,1);  % change 1 to 0 to draw square dots
                Screen('DrawingFinished', w); % Tell PTB that no further drawing commands will follow before Screen('Flip')
            end
            
        end
        
        % check to see which dots have gone beyond the borders of the annuli
        r_out = find(r_EXT > rmax | r_EXT < rmin | rand(ndots,1) < f_kill);	% dots to reposition
        nout = length(r_out);
        if nout
            
            % choose new coordinates
            r_EXT(r_out) = rmin; %* sqrt(rand(nout,1));
            r_EXT(r_EXT<rmin) = rmin;
            t_EXT(r_out) = 2*pi*(rand(nout,1));
            
            % now convert the polar coordinates to Cartesian
            cs_EXT(r_out,:) = [cos(t_EXT(r_out)), sin(t_EXT(r_out))];
            xy_EXT(r_out,:) = [r_EXT(r_out) r_EXT(r_out)] .* cs_EXT(r_out,:);
            
            % compute the new cartesian velocities
            dxdyEXT(r_out,:) = [drEXT(r_out) drEXT(r_out)] .* cs_EXT(r_out,:);
            
        end
        xymatrix_EXT = transpose(xy_EXT);
        
        
        
        
        
        % check to see which dots have gone beyond the borders of the annuli
        r_out = find(r_IN > rmax | r_IN < rmin | rand(ndots,1) < f_kill);	% dots to reposition
        nout = length(r_out);
        if nout
            
            % choose new coordinates
            r_IN(r_out) = rmax; %* sqrt(rand(nout,1));
            r_IN(r_IN<rmin) = rmax;
            t_IN(r_out) = 2*pi*(rand(nout,1));
            
            % now convert the polar coordinates to Cartesian
            cs_IN(r_out,:) = [cos(t_IN(r_out)), sin(t_IN(r_out))];
            xy_IN(r_out,:) = [r_IN(r_out) r_IN(r_out)] .* cs_IN(r_out,:);
            
            % compute the new cartesian velocities
            dxdyIN(r_out,:) = [drIN(r_out) drIN(r_out)] .* cs_IN(r_out,:);
        end
        xymatrix_IN = transpose(xy_IN);
        
        
        
        my_s(1:ndots)=ms*r_IN'+smin;
        my_s(ndots+1:2*ndots)=ms*r_EXT'+smin;
        
        % RICARDO - record video
        %imageArrayN=Screen('GetImage', w, [], [], [], []);
        %imwrite(imageArrayN,[num2str(1000+i),'.png'],'png');
        % RICARDO - record video
        
        % merge IN and OUT dots
        xymatrix=[xymatrix_IN xymatrix_EXT];
        vbl=Screen('Flip', w, vbl + (waitframes-0.5)*ifi);

        flip(i) = vbl;
        
    end
    
    d = datetime;
    d.Format = 'uuuuMMdd';
    t = datetime;
    t.Format = 'HHmmss';
    datestring = sprintf('%sT%s',d,t);
    savename = sprintf('%s/%s%i_%s',params.savefilepath,initials,sesNum,datestring);
    
    

    if params.doEyelink
        Eyelink('StopRecording');
        Eyelink('ReceiveFile', ELfileName, fileparts(vistadispRootPath) ,1);
        Eyelink('CloseFile');
        Eyelink('Shutdown');
        movefile(sprintf('%s/%s',fileparts(vistadispRootPath),ELfileName),sprintf('%s.edf',savename))

    end
    
    Priority(0);
    ShowCursor;
    Screen('CloseAll');
    
catch
    
    Priority(0);
    ShowCursor;
    Screen('CloseAll');
    
end

stimulus.nframes     = nframes; % number of animation frames in loop
stimulus.mon_width   = mon_width;   % horizontal dimension of viewable screen (cm)
stimulus.v_dist      = v_dist;   % viewing distance (cm)
stimulus.dot_speed   = dot_speed; %7;    % dot speed (deg/sec)
stimulus.f_kill      = f_kill; % fraction of dots to kill each frame (limited lifetime)
stimulus.ndots       = ndots; %2000; % number of dots
stimulus.max_d       = max_d;%15;   % maximum radius of  annulus (degrees)
stimulus.min_d       = min_d; %1;    % minumum (degrees)
stimulus.dot_w       = dot_w;  % width of dot (deg) px
stimulus.fix_r       = fix_r; %0.15; % radius of fixation point (deg)
stimulus.waitframes  = waitframes; % Show new dot-images at each waitframe
stimulus.fixation_changes = fixation_changes;
stimulus.fixation_presses = fixation_presses;
stimulus.initials = initials;
stimulus.sesNum = sesNum;
stimulus.exp = 'MT_loc';
stimulus.flip = flip;


save(sprintf('%s.mat',savename),'stimulus')

end

function wait4T(keyboard)

ch = '';
while ~strcmp(ch,'5')
    [ ~, ~, keyCode ] = KbCheck(keyboard);
    keyPressed= KbName(keyCode);
    if ~isempty(keyPressed)
        ch = keyPressed(1);
    end
end

end
