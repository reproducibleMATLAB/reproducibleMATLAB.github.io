clear;clc
close all

data = read_temperature_file(fullfile("data", "milton_MA.csv"));
data.tmid = (data.tmax(:)+data.tmin(:))/2;
data = table2timetable(data);

yearly_avg_temp = retime(data, 'yearly', 'mean');

max_temp = max(yearly_avg_temp.tmid);
min_temp = min(yearly_avg_temp.tmid);

min_year = min(data.date.Year);
max_year = max(data.date.Year);

monthNames = month(datetime(1, 1:12, 1), 's');

% colour scale is calibrated against the average temperature 1971-2000
% see https://showyourstripes.info/faq
averaging_timerange = timerange("1971-01-01","2000-12-31");
tmid_mean_1971_2000 = mean(data(averaging_timerange, :).tmid);
threshold = tmid_mean_1971_2000;

% plotting parameters
grayscale = 1;%0.6;
alpha_reduction_factor = 0.90;
plotted_lines = [];

% Gif writing parameters
write_gif = true;
start_new_image_file = true;
filename = "temperature_linear_plot.gif";
gif_delay_time = 0.1;

%%
figure;
for year=min_year:max_year
    year_data = data(data.date.Year == year, :);
    year_avg_temp = yearly_avg_temp(yearly_avg_temp.date.Year==year, :).tmid;

    if year_avg_temp == threshold
        color = grayscale*[1 1 1];
    elseif year_avg_temp > threshold
        color = [1 0 0] + grayscale*[0 1 1]*(1-(year_avg_temp - threshold)/(max_temp - threshold));
    else
        color = [0 0 1] + grayscale*[1 1 0]*(1-(threshold - year_avg_temp)/(threshold - min_temp));
    end

    % make all years the same so they fall in the same axis range, the year
    % here is arbitrary
    year_data.date.Year(:) = max_year;
    p = plot(year_data.date,year_data.tmid, 'Color', color, 'LineWidth',1); hold on
    xtickformat("MM")
    set(gca, 'XTickLabel', monthNames);
    set(gca, 'ylim', [-30 40]);
    set(gca,'color',[0 0 0]);
    ylabel("Temperature (^{\circ}C)")
    if ~exist("year_label", "var")
        year_label = text(10, 35, string(year),'FontSize',14, 'Color', 'w');
    else
        year_label.String = string(year);
    end

    p.Color = [p.Color 1];
    % store the alpha (transparency) value in a new property of the line
    % class, this is unused by the plotting, just used for keeping track of
    % line alpha values
    addprop(p, "alpha");
    p.alpha = 1;
    
    for j = 1:size(plotted_lines, 1)
        line_old_alpha = plotted_lines(j).alpha; % get a line's previous alpha
        line_new_alpha = line_old_alpha * alpha_reduction_factor; % calculate its new value of alpha
        plotted_lines(j).Color = [plotted_lines(j).Color line_new_alpha]; % set its alpha value
        plotted_lines(j).alpha = line_new_alpha; % store its alpha value
    end
    plotted_lines = [plotted_lines; p];

    drawnow

    if write_gif
        frame = getframe(1);
        im = frame2im(frame);
        [imind,cm] = rgb2ind(im,256);
    
        if start_new_image_file
            recycle("on")
            delete(filename)
            imwrite(imind,cm,filename,'gif', 'Loopcount',1, "DelayTime", gif_delay_time);
            start_new_image_file = false;
        else
            imwrite(imind,cm,filename,'gif','WriteMode','append', "DelayTime", gif_delay_time);
        end
    end

end