function get_raw_data(NameValueArgs)
%GET_RAW_DATA Downloads the Dayton EPA City Daily Temperature Dataset as a
%text file

arguments
    NameValueArgs.file string = "NZACKLND.txt"
    NameValueArgs.url_path string = "https://academic.udayton.edu/kissock/http/Weather/gsod95-current/"
    NameValueArgs.saveas string = "auckland_temperature_data.txt"
    NameValueArgs.data_dir {mustBeFolder} = fullfile(pwd, "data")
    NameValueArgs.timeout {mustBeInteger, mustBePositive} = 30
end

file_url = strcat(NameValueArgs.url_path, NameValueArgs.file);

fprintf("Downloading %s to %s\n", file_url, fullfile(NameValueArgs.data_dir,NameValueArgs.saveas))
options = weboptions("Timeout", NameValueArgs.timeout);
websave(fullfile(NameValueArgs.data_dir,NameValueArgs.saveas), file_url, options);

end

