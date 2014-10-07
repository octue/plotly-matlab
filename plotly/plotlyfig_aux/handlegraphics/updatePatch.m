function obj = updatePatch(obj, patchIndex)

%----PATCH FIELDS----%

% x - [DONE]
% y - [DONE]
% r - [HANDLED BY SCATTER]
% t - [HANDLED BY SCATTER]
% mode - [DONE]
% name - [DONE]
% text - [NOT SUPPORTED IN MATLAB]
% error_y - [HANDLED BY ERRORBAR]
% error_x - [HANDLED BY ERRORBAR]
% marler.color - [DONE]
% marker.size - [DONE]
% marker.line.color - [DONE]
% marker.line.width - [DONE]
% marker.line.dash - [NOT SUPPORTED IN MATLAB]
% marker.line.opacity --- [TODO]
% marker.line.smoothing - [NOT SUPPORTED IN MATLAB]
% marker.line.shape - [NOT SUPPORTED IN MATLAB]
% marker.opacity - [NOT SUPPORTED IN MATLAB]
% marker.colorscale - [NOT SUPPORTED IN MATLAB]
% marker.sizemode - [NOT SUPPORTED IN MATLAB]
% marker.sizeref - [NOT SUPPORTED IN MATLAB]
% marker.maxdisplayed - [NOT SUPPORTED IN MATLAB]
% line.color - [DONE]
% line.width - [DONE]
% line.dash - [DONE]
% line.opacity --- [TODO]
% line.smoothing - [NOT SUPPORTED IN MATLAB]
% line.shape - [NOT SUPPORTED IN MATLAB]
% connectgaps - [NOT SUPPORTED IN MATLAB]
% fill - [HANDLED BY PATCH]
% fillcolor - [HANDLED BY PATCH]
% opacity --- [TODO]
% textfont - [NOT SUPPORTED IN MATLAB]
% textposition - [NOT SUPPORTED IN MATLAB]
% xaxis [DONE]
% yaxis [DONE]
% showlegend [DONE]
% stream - [HANDLED BY PLOTLYSTREAM]
% visible [DONE]
% type [DONE]

%-AXIS INDEX-%
axIndex = obj.getAxisIndex(obj.State.Plot(patchIndex).AssociatedAxis);

%-PATCH DATA STRUCTURE- %
patch_data = get(obj.State.Plot(patchIndex).Handle);

%-CHECK FOR MULTIPLE AXES-%
[xsource, ysource] = findSourceAxis(obj,axIndex);

%-AXIS DATA-%
eval(['xaxis = obj.layout.xaxis' num2str(xsource) ';']);
eval(['yaxis = obj.layout.yaxis' num2str(ysource) ';']);

%-------------------------------------------------------------------------%

%-patch xaxis-%
obj.data{patchIndex}.xaxis = ['x' num2str(xsource)];

%-------------------------------------------------------------------------%

%-patch yaxis-%
obj.data{patchIndex}.yaxis = ['y' num2str(ysource)];

%-------------------------------------------------------------------------%

%-patch type-%
obj.data{patchIndex}.type = 'scatter';

%-------------------------------------------------------------------------%

%-patch x-%
xdata = patch_data.XData;
if isvector(xdata)
    obj.data{patchIndex}.x = [xdata' xdata(1)];
else
    xtemp = reshape(xdata,[],1);
    xnew = [];
    for n = 1:size(xdata,2)
        xnew = [xnew ; xdata(:,n) ; xdata(1,n); NaN];
    end
    obj.data{patchIndex}.x = xnew;
end

%-------------------------------------------------------------------------%

%-patch y-%
ydata = patch_data.YData;
if isvector(ydata)
    obj.data{patchIndex}.y = [ydata' ydata(1)];
else
    ytemp = reshape(ydata,[],1);
    ynew = [];
    for n = 1:size(ydata,2)
        ynew = [ynew ; ydata(:,n) ; ydata(1,n); NaN];
    end
    obj.data{patchIndex}.y = ynew;
end

%-------------------------------------------------------------------------%

%-patch name-%
if ~isempty(patch_data.DisplayName);
    obj.data{patchIndex}.name = patch_data.DisplayName;
else
    obj.data{patchIndex}.name = patch_data.DisplayName;
end

%-------------------------------------------------------------------------%

%-patch visible-%
obj.data{patchIndex}.visible = strcmp(patch_data.Visible,'on');

%-------------------------------------------------------------------------%

%-patch fill-%
obj.data{patchIndex}.fill = 'tonexty';

%-PATCH MODE-%
if ~strcmpi('none', patch_data.Marker) && ~strcmpi('none', patch_data.LineStyle)
    mode = 'lines+markers';
elseif ~strcmpi('none', patch_data.Marker)
    mode = 'markers';
elseif ~strcmpi('none', patch_data.LineStyle)
    mode = 'lines';
else
    mode = 'none';
end

obj.data{patchIndex}.mode = mode;

%-------------------------------------------------------------------------%

%-patch marker-%
obj.data{patchIndex}.marker = extractPatchMarker(patch_data);

%-------------------------------------------------------------------------%

%-patch line-%
obj.data{patchIndex}.line = extractPatchLine(patch_data);

%-------------------------------------------------------------------------%

%-patch fillcolor-%
fill = extractPatchFace(patch_data);
obj.data{patchIndex}.fillcolor = fill.color;

%-------------------------------------------------------------------------%

%-patch showlegend-%
leg = get(patch_data.Annotation);
legInfo = get(leg.LegendInformation);

switch legInfo.IconDisplayStyle
    case 'on'
        showleg = true;
    case 'off'
        showleg = false;
end

obj.data{patchIndex}.showlegend = showleg;

%-------------------------------------------------------------------------%

end