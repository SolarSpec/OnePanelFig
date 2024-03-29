%%% BEGINNING OF SCRIPT
% General setup
ax = gca;
fig = gcf;

% Configure window
fig.Color = 'white';
fig.WindowStyle = 'normal';
fig.Units = 'centimeters';

% Configure axes
ax.Color = 'white';
ax.LineWidth = 1.5;
ax.XGrid = 'off';
ax.YGrid = 'off';
ax.Box = 'on';
ax.FontName = 'Arial';
ax.Units = 'centimeter';
ax.XMinorTick = 'on';
ax.YMinorTick = 'on';
ax.TickLength = [0.03 0.01];

% Make axes bold if checked
if checkbox{1} == true
    ax.FontWeight = 'bold';
end

% Set axes labels
xlabel(ax,x_label{1});
ylabel(ax,y_label{1});

% Set axes limits
ax.XLim = [lowerX{1} upperX{1}];
ax.YLim = [lowerY{1} upperY{1}];

% Set axes scale
ax.XScale = x_scale{1};
ax.YScale = y_scale{1};

% Set axes orientation
value = invertY{1};
tf = strcmp(value,'On');
if tf == 1
    set(ax, 'YDir', 'reverse');
else
    set(ax, 'YDir', 'normal');
end

value = invertX{1};
tf = strcmp(value,'On');
if tf == 1
    set(ax, 'XDir', 'reverse');
else
    set(ax, 'XDir', 'normal');
end

% Set data format
if xnot{1} == true
    mag = floor(log(abs(ax.XLim(2)))./log(10));
    ax.XRuler.Exponent = mag;
else
    ax.XRuler.Exponent = 0;
end

if ynot{1} == true
    mag = floor(log(abs(ax.YLim(2)))./log(10));
    ax.YRuler.Exponent = mag;
else
    ax.YRuler.Exponent = 0;
end

% Set tick spacing
ax.XTick = lowerX{1}:tickspace{1}:upperX{1};


%%Set data properties
% Find all objects in axes and size
Objects = flipud(allchild(ax));

for i = 1:size(Objects,1)
    if strcmp(Objects(i,1).Type,"constantline")
        Objects(i) = []; % Erase any ylines from list
    end
end

% Find type
try
    type = Objects.Type;
    typeString = convertCharsToStrings(type(1,:));
catch
    % If line is mixed with scatter (e.g. in a fit plot)
    for i = 1:size(Objects,1)
        %                     typeArray(i,1) = convertCharsToStrings(Objects(i,1).Type);
        if strcmp(Objects(i,1).Type,"line")
            Objects(i) = []; % Erase any fit lines from list and only edit scatter
        end
    end
    typeString = 'scatter';
end

% Find number of gobjects and split legend names
Num = size(Objects,1);
names = split(legends{1}, {',',';'});
names = strtrim(names);

if colourType{1} == "Multiple Data Sets"
    ColorPallet = distinguishable_colors(Num);
else
    ColorPallet = turbo(Num);
end

% Determine the type of plot (LINE?)
if strcmp(typeString, 'line') == 1

    if style == "Solid"
        ax.LineStyleOrder = '-';
    elseif style == "Dashed"
        ax.LineStyleOrder = '--';
    elseif style == "Dotted"
        ax.LineStyleOrder = ':';
    elseif style == "Dash-Dot"
        ax.LineStyleOrder = '-.';
    end

    for count = 1:1:Num
        Objects(count).Marker = marker;
        Objects(count).MarkerSize = markerSize{1};
        Objects(count).LineWidth = width{1};

        if ~indices(count) % Determing type of coloring
            Objects(count).Color = ColorPallet(count,:);
        else
            Objects(count).Color = individuals(count,:);
        end

        Objects(count).DisplayName = names{count,1};
    end

elseif strcmp(typeString, 'scatter') == 1 % Determine the type of plot (SCATTER?)

    for count = 1:1:Num
        Objects(count).Marker = marker;
        Objects(count).SizeData = markerSize{1};

        if ~indices(count) % Determing type of coloring
            Objects(count).MarkerEdgeColor = ColorPallet(count,:);
        else
            Objects(count).MarkerEdgeColor = individuals(count,:);
        end

        Objects(count).MarkerFaceColor = Objects(count).MarkerEdgeColor;
        Objects(count).DisplayName = names{count,1};
    end
end

l = legend(Objects,'Location','best','fontsize',12,'Box','off');
if isempty(names) || names(count,:) == ""
    l.Visible = false;
else
    l.Visible = true;
end

% Add last to ensure the font changes for all prompts
ax.FontSize = 14;

% Get rid of extra white space around figure
% fig.WindowStyle = 'normal';
value = preset{1};
% Keep fig stationary, only change aspect ratio
CurrentFigPos = fig.Position;

if value == "Default"
    % Calculate difference w predetermined height to keep top left anchored
    currentTopLeft = fig.InnerPosition(2) + fig.InnerPosition(4);
    newTopLeft = currentTopLeft - 8;

    ax.OuterPosition = [0 0 14.8167 8];
    fig.InnerPosition = [CurrentFigPos(1) newTopLeft 14.8167 8];

elseif value == "Horizontal, 1 column wide"
    % Calculate difference w predetermined height to keep top left anchored
    currentTopLeft = fig.InnerPosition(2) + fig.InnerPosition(4);
    newTopLeft = currentTopLeft - 6.15;

    ax.OuterPosition = [0 0 9.70 6.15];
    fig.InnerPosition = [CurrentFigPos(1) newTopLeft 9.70 6.15];

elseif value == "Horizontal, 2 columns wide"
    % Calculate difference w predetermined height to keep top left anchored
    currentTopLeft = fig.InnerPosition(2) + fig.InnerPosition(4);
    newTopLeft = currentTopLeft - 8.88;

    ax.OuterPosition = [0 0 17.65 8.88];
    fig.InnerPosition = [CurrentFigPos(1) newTopLeft 17.65 8.88];

elseif value == "Vertical"
    % Calculate difference w predetermined height to keep top left anchored
    currentTopLeft = fig.InnerPosition(2) + fig.InnerPosition(4);
    newTopLeft = currentTopLeft - 8.88;

    ax.OuterPosition = [0 0 5.6 8.88];
    fig.InnerPosition = [CurrentFigPos(1) newTopLeft 5.6 8.88];

elseif value == "Square"
    % Calculate difference w predetermined height to keep top left anchored
    currentTopLeft = fig.InnerPosition(2) + fig.InnerPosition(4);
    newTopLeft = currentTopLeft - 8.88;

    ax.OuterPosition = [0 0 9.9 8.88];
    fig.InnerPosition = [CurrentFigPos(1) newTopLeft 9.9 8.88];
end

function colors = distinguishable_colors(n_colors,bg,func)
% DISTINGUISHABLE_COLORS: pick colors that are maximally perceptually distinct
%
% When plotting a set of lines, you may want to distinguish them by color.
% By default, Matlab chooses a small set of colors and cycles among them,
% and so if you have more than a few lines there will be confusion about
% which line is which. To fix this problem, one would want to be able to
% pick a much larger set of distinct colors, where the number of colors
% equals or exceeds the number of lines you want to plot. Because our
% ability to distinguish among colors has limits, one should choose these
% colors to be "maximally perceptually distinguishable."
%
% This function generates a set of colors which are distinguishable
% by reference to the "Lab" color space, which more closely matches
% human color perception than RGB. Given an initial large list of possible
% colors, it iteratively chooses the entry in the list that is farthest (in
% Lab space) from all previously-chosen entries. While this "greedy"
% algorithm does not yield a global maximum, it is simple and efficient.
% Moreover, the sequence of colors is consistent no matter how many you
% request, which facilitates the users' ability to learn the color order
% and avoids major changes in the appearance of plots when adding or
% removing lines.
%
% Syntax:
%   colors = distinguishable_colors(n_colors)
% Specify the number of colors you want as a scalar, n_colors. This will
% generate an n_colors-by-3 matrix, each row representing an RGB
% color triple. If you don't precisely know how many you will need in
% advance, there is no harm (other than execution time) in specifying
% slightly more than you think you will need.
%
%   colors = distinguishable_colors(n_colors,bg)
% This syntax allows you to specify the background color, to make sure that
% your colors are also distinguishable from the background. Default value
% is white. bg may be specified as an RGB triple or as one of the standard
% "ColorSpec" strings. You can even specify multiple colors:
%     bg = {'w','k'}
% or
%     bg = [1 1 1; 0 0 0]
% will only produce colors that are distinguishable from both white and
% black.
%
%   colors = distinguishable_colors(n_colors,bg,rgb2labfunc)
% By default, distinguishable_colors uses the image processing toolbox's
% color conversion functions makecform and applycform. Alternatively, you
% can supply your own color conversion function.
%
% Example:
%   c = distinguishable_colors(25);
%   figure
%   image(reshape(c,[1 size(c)]))
%
% Example using the file exchange's 'colorspace':
%   func = @(x) colorspace('RGB->Lab',x);
%   c = distinguishable_colors(25,'w',func);

% Copyright 2010-2011 by Timothy E. Holy

% Parse the inputs
if (nargin < 3)
    bg = [1 1 1];  % default white background
else
    if iscell(bg)
        % User specified a list of colors as a cell aray
        bgc = bg;
        for ind = 1:length(bgc)
            bgc{ind} = parsecolor(bgc{ind});
        end
        bg = cat(1,bgc{:});
    else
        % User specified a numeric array of colors (n-by-3)
        bg = parsecolor(bg);
    end
end

% Generate a sizable number of RGB triples. This represents our space of
% possible choices. By starting in RGB space, we ensure that all of the
% colors can be generated by the monitor.
n_grid = 30;  % number of grid divisions along each axis in RGB space
x = linspace(0,1,n_grid);
[R,G,B] = ndgrid(x,x,x);
rgb = [R(:) G(:) B(:)];
if (n_colors > size(rgb,1)/3)
    error('You can''t readily distinguish that many colors');
end

% Convert to Lab color space, which more closely represents human
% perception
if (nargin > 3)
    lab = func(rgb);
    bglab = func(bg);
else
    C = makecform('srgb2lab');
    lab = applycform(rgb,C);
    bglab = applycform(bg,C);
end

% If the user specified multiple background colors, compute distances
% from the candidate colors to the background colors
mindist2 = inf(size(rgb,1),1);
for ind = 1:size(bglab,1)-1
    dX = bsxfun(@minus,lab,bglab(ind,:)); % displacement all colors from bg
    dist2 = sum(dX.^2,2);  % square distance
    mindist2 = min(dist2,mindist2);  % dist2 to closest previously-chosen color
end

% Iteratively pick the color that maximizes the distance to the nearest
% already-picked color
colors = zeros(n_colors,3);
lastlab = bglab(end,:);   % initialize by making the "previous" color equal to background
for ind = 1:n_colors
    dX = bsxfun(@minus,lab,lastlab); % displacement of last from all colors on list
    dist2 = sum(dX.^2,2);  % square distance
    mindist2 = min(dist2,mindist2);  % dist2 to closest previously-chosen color
    [~,index] = max(mindist2);  % find the entry farthest from all previously-chosen colors
    colors(ind,:) = rgb(index,:);  % save for output
    lastlab = lab(index,:);  % prepare for next iteration
end
end

function c = parsecolor(s)
if ischar(s)
    c = colorstr2rgb(s);
elseif isnumeric(s) && size(s,2) == 3
    c = s;
else
    error('MATLAB:InvalidColorSpec','Color specification cannot be parsed.');
end
end

function c = colorstr2rgb(c)
% Convert a color string to an RGB value.
% This is cribbed from Matlab's whitebg function.
% Why don't they make this a stand-alone function?
rgbspec = [1 0 0;0 1 0;0 0 1;1 1 1;0 1 1;1 0 1;1 1 0;0 0 0];
cspec = 'rgbwcmyk';
k = find(cspec==c(1));
if isempty(k)
    error('MATLAB:InvalidColorString','Unknown color string.');
end
if k~=3 || length(c)==1
    c = rgbspec(k,:);
elseif length(c)>2
    if strcmpi(c(1:3),'bla')
        c = [0 0 0];
    elseif strcmpi(c(1:3),'blu')
        c = [0 0 1];
    else
        error('MATLAB:UnknownColorString', 'Unknown color string.');
    end
end
end