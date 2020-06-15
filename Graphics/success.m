%% success
% This function is used to declare the end of a process
%
% success(msg)
%
% Input:
%   msg is the message which has to be showed ('Operation Completed' by
%       default)


function success(msg)
    if nargin == 0
        msg = 'Operation Completed';
    end
    bgc = [1 1 1];
    fgc = [0.067 0.118 0.424];
    btn = [0.427 0.804 0.722];
    f = figure;
    funDir = mfilename('fullpath');
    funDir = split(funDir, 'Graphics');
    cd(char(funDir{1}));
    im = imread('logo.png');
    set(f, 'Position', [200 350 300 150], 'Color', bgc, ...
        'MenuBar', 'none', 'Name', 'Success', 'Visible', 'off', ...
        'NumberTitle', 'off');
    axes('pos', [0 0.4 0.25 0.46])
    imshow('logo.png')
    ht = uicontrol('Style', 'text', 'Units', 'normalized', ...
        'Position', [.25 0.4 0.6 0.3], 'String', msg, ...
        'FontUnits', 'normalized', 'FontSize', 0.38, ...
        'BackgroundColor', bgc, 'ForegroundColor', 'k', ...
        'horizontalAlignment', 'left');
    hok = uicontrol('Style', 'pushbutton', 'String', 'OK', ...
        'FontWeight', 'bold', 'Units', 'normalized', ...
        'Position', [0.35 0.05 0.3 0.25], 'Callback', 'close', ...
        'ForegroundColor', fgc, 'BackgroundColor', btn); 
    hbar = uicontrol('Style', 'text', 'Units', 'normalized', ...
        'Position', [0 0.98 0.3 0.02], 'String', '', ...
        'FontUnits', 'normalized', ...
        'BackgroundColor', fgc, 'ForegroundColor', 'k');
    movegui(f, 'center')
    set(f, 'Visible', 'on')
    waitfor(hok);
end