function varargout = Athena_netmeas(varargin)
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Athena_netmeas_OpeningFcn, ...
                   'gui_OutputFcn',  @Athena_netmeas_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
    if nargin && ischar(varargin{1})
        gui_State.gui_Callback = str2func(varargin{1});
    end

    if nargout
        [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
    else
        gui_mainfcn(gui_State, varargin{:});
    end


function Athena_netmeas_OpeningFcn(hObject, eventdata, handles, varargin)
    handles.output = hObject;
    guidata(hObject, handles);
    handles.output = hObject;
    guidata(hObject, handles);
    [x, ~] = imread('logo.png');
    Im = imresize(x, [250 250]);
    set(handles.help_button, 'CData', Im)
    set(handles.scatter, 'Units', 'normalized');
    if nargin >= 4
        path = varargin{1};
        set(handles.aux_dataPath, 'String', path)
        if not(strcmp(path, 'Static Text'))
            set(handles.dataPath_text, 'String', path)
        end
    end
    if nargin >= 5
        set(handles.aux_measure, 'String', varargin{2})
    end
    if nargin >= 6
        set(handles.aux_sub, 'String', varargin{3})
    end
    if nargin >= 7
        set(handles.aux_loc, 'String', varargin{4})
    end
    if nargin >= 8
        set(handles.sub_types, 'Data', varargin{5})
    end
    dataPath_text_Callback(hObject, eventdata, handles)
    network_metrics = {'betweenness_centrality', ...
        'closeness_centrality', 'clustering_coefficient', ...
        'eigenvector_centrality', 'generank_centrality', ...
        'katz_centrality', 'strength', 'subgraph_centrality'};
    network_names = {'Betweenness Centrality', ...
        'Closeness Centrality', 'Clustering Coefficient', ...
        'Eigenvector Centrality', 'Generank Centrality', ...
        'Katz Centrality', 'Strength', 'Subgraph Centrality'};
    set(handles.network, 'String', network_names)
    set(handles.network_args, 'String', network_metrics);
    

    
function varargout = Athena_netmeas_OutputFcn(hObject, eventdata, handles) 
    varargout{1} = handles.output;


function dataPath_text_Callback(hObject, eventdata, handles)
    auxPath = pwd;
    funDir = mfilename('fullpath');
    funDir = split(funDir, 'Graphics');
    cd(char(funDir{1}));
    addpath 'Auxiliary'
    addpath 'Graphics'
    addpath 'Network Metrics'
    
    dataPath = get(handles.dataPath_text, 'String');
    subjectsFile = strcat(path_check(dataPath), 'Subjects.mat');
    if exist(subjectsFile, 'file')
        set(handles.aux_sub, 'String', subjectsFile)
        try
            sub_info = load(subjectsFile);
            aux_sub_info = fields(sub_info);
            eval(strcat("sub_info = sub_info.", aux_sub_info{1}, ";"));
            sub_types = categories(categorical(sub_info(:, end)));
            if length(sub_types) == 2
                set(handles.sub_types, 'Data', sub_types)
            end
        catch
        end
    end
    if exist(dataPath, 'dir')
        cases = dir(dataPath);
        measures = [];
        for i = 1:length(cases)
        	if cases(i).isdir == 1
                if sum(strcmp(cases(i).name, ...
                        Athena_measures_list(1, 0, 1, 0)))
                    measures = [measures, string(cases(i).name)];
                end
            end
        end
        set(handles.meas, 'String', measures)
        set(handles.meas, 'Value', 1)
    end
    set(handles.network, 'Visible', 'off')
    set(handles.normGroup, 'Visible', 'off')
    set(handles.normText, 'Visible', 'off')
    set(handles.network_text, 'Visible', 'off')
    
function dataPath_text_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject, 'BackgroundColor'), ...
            get(0, 'defaultUicontrolBackgroundColor'))
        set(hObject, 'BackgroundColor', 'white');
    end


function Run_Callback(hObject, eventdata, handles)
    [dataPath, measure, netmeas, locations_file, normFLAG, ...
        network_measure_name] = network_measure_initialization(handles);
    if not(exist(strcat(path_check(dataPath), measure), 'dir'))
        problem('Measure not extracted')
        return
    elseif not(exist(locations_file, 'file'))
        problem('Locations file not found')
        return
    end
    network_measure(dataPath, measure, netmeas, locations_file, normFLAG);
    
    Athena_history_update(strcat("network_measure(", ...
        strcat("'", dataPath, "'"), ',', strcat("'", measure, "'"), ...
        ',', strcat("'", netmeas, "'"), ',', ...
        strcat("'", locations_file, "'"), ',', string(normFLAG), ')'));
    
    success(strcat('You will find the resulting files in a', ...
        " subdirectory of the ", measure, " measure (", dataPath, '\', ...
        measure, '\Network\', network_measure_name, ')'))
        
    
function [dataPath, measure, network_measure, locations_file, normFLAG, ...
    network_measure_name] = network_measure_initialization(handles)
    
    dataPath = get(handles.dataPath_text, 'String');
    measure = define_measure(handles);
 
    network_measures_list = get(handles.network, 'String');
    network_measures_args = get(handles.network_args, 'String');
    netmeas = get(handles.network, 'Value');
    network_measure = network_measures_args{netmeas};
    network_measure_name = network_measures_list{netmeas};
    
    normFLAG = get(handles.YesNorm, 'Value');
    
    locations_file = get(handles.aux_loc, 'String');

    
function data_search_Callback(hObject, eventdata, handles)
	d = uigetdir;
    if d ~= 0
        set(handles.dataPath_text, 'String', d)
        dataPath_text_Callback(hObject, eventdata, handles)
    end


function back_Callback(hObject, eventdata, handles)
    funDir = mfilename('fullpath');
    funDir = split(funDir, 'Graphics');
    cd(char(funDir{1}));
    addpath 'Auxiliary'
    addpath 'Graphics'
    [dataPath, measure, sub, loc, sub_types] = GUI_transition(handles);
    if strcmp(dataPath, 'es. C:\User\Data')
        dataPath = "Static Text";
    end
    close(Athena_netmeas)
    Athena_an(dataPath, measure, sub, loc, sub_types)


function meas_Callback(hObject, eventdata, handles)
    dataPath = get(handles.dataPath_text, 'String');
    measure = define_measure(handles);
    dataPath = strcat(path_check(dataPath), path_check(measure));
    if exist(dataPath, 'dir')
        cases = define_cases(dataPath);
        load(strcat(dataPath, cases(1).name));
        set(handles.network, 'Value', 1)
        set(handles.network_text, 'Visible', 'on')
        set(handles.network, 'Visible', 'on')
        set(handles.network, 'Enable', 'on')
        set(handles.normGroup, 'Visible', 'on')
        set(handles.normText, 'Visible', 'on')
        
    else
        set(handles.network, 'Enable', 'off')
        set(handles.network_text, 'Enable', 'off')
        set(handles.normGroup, 'Visible', 'off')
        set(handles.normText, 'Visible', 'off')
    end


function meas_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), ...
            get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
function measure = define_measure(handles)
    measures_list = get(handles.meas, 'String');
    if iscell(measures_list)
        measure = measures_list{get(handles.meas, 'Value')};
    else
    	measure = measures_list;
    end


function network_Callback(hObject, eventdata, handles)


function network_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), ...
            get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


function network_args_Callback(hObject, eventdata, handles)


function network_args_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject, 'BackgroundColor'), ...
            get(0, 'defaultUicontrolBackgroundColor'))
        set(hObject, 'BackgroundColor', 'white');
    end
