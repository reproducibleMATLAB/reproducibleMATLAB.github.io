function [temperature_table] = read_txt_data_file(path)
%READ_DATA Reads in the Dayton EPA text files as a table.

arguments
    path {mustBeFile} = fullfile("data","auckland_temperature_data.txt")
end

% read in the raw data file as a matrix
raw_data = readmatrix(path);

% First clean the data
% Temperatures of '-99' are empty rows so we'll remove them.
% see https://academic.udayton.edu/kissock/http/Weather/source.htm
cleaned_data = [];
for i = 1:length(raw_data)
    if raw_data(i, 4) ~= -99
        cleaned_data = [cleaned_data; raw_data(i, :)];
    end
end
assert(min(cleaned_data(:,4)) > -99, "Cleaned data should have a min temperature > -99F, something isn't working.")

% raw data has dates in US M, D, Y order
% see https://academic.udayton.edu/kissock/http/Weather/source.htm
years = cleaned_data(:, 3);
months = cleaned_data(:, 1);
days = cleaned_data(:, 2);

% validate the data ranges
assert(min(years)==1995 && max(years>2015), "These don't look like years, are you sure the data is right?");
assert(min(months)==1 && max(months==12), "These don't look like months, are you sure the data is right?");
assert(min(days)==1 && max(days<=31), "These don't look like days, are you sure the data is right?");

date = datetime(years, months, days);

% raw data has temperature in Fahrenheit
% see https://academic.udayton.edu/kissock/http/Weather/source.htm
temperature_fahrenheit = cleaned_data(:,4);
assert(min(temperature_fahrenheit)>-99 && max(temperature_fahrenheit)<100, "These don't look like air temperatures, are you sure the data is right?");
temperature = fahrenheit_to_celsius(temperature_fahrenheit);

temperature_table = table(date, temperature);

end

