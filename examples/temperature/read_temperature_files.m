function [cleaned_data] = read_temperature_files(path)
%READ_TEMPERATURE_FILES Reads in temperature & precipitation text files as a table.
% Multiple files can be passed in as arguments and are concatendated
% together in the order that they are provided.

arguments (Repeating)
    path {mustBeFile}
end

raw_data = table();
for p = path    % read in the raw data file as a matrix
    file_data = readtable(p{:}, 'FileType', 'delimitedtext');
    raw_data = vertcat(raw_data, file_data);
end

% First clean the data
% Temperatures of 'NA' in the raw file are read in by readtable as 'NaN' and are empty rows so we'll remove them.
date = [];
tmax = [];
tmin = [];
for i = 1:size(raw_data, 1)
    if ~isnan(raw_data.tmax(i)) && ~isnan(raw_data.tmin(i))
        date = [date; raw_data.Date(i)];
        % also convert temperatures in F to temperatures in C
        tmax = [tmax; fahrenheit_to_celsius(raw_data.tmax(i))];
        tmin = [tmin; fahrenheit_to_celsius(raw_data.tmin(i))];
    end
end
cleaned_data = table(date,tmax,tmin);

% validate correct conversion of temperature
assert(min(cleaned_data.tmin)>-99 && max(cleaned_data.tmin)<100, "These don't look like air temperatures, are you sure the data is right?");
assert(min(cleaned_data.tmax)>-99 && max(cleaned_data.tmax)<100, "These don't look like air temperatures, are you sure the data is right?");

end

