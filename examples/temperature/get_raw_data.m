%GET_RAW_DATA Downloads a data file over HTTP. By default a file from the dataset:
% "Compiled historical daily temperature and precipitation data for
% selected 210 U.S. cities" at https://kilthub.cmu.edu/articles/dataset/Compiled_daily_temperature_and_precipitation_data_for_the_U_S_cities/7890488
% 
%
function get_raw_data(NameValueArgs)

arguments
    NameValueArgs.file string {mustBeTextScalar} = "32874107"
    NameValueArgs.url_path string = "https://api.figshare.com/v2/file/download/"
    NameValueArgs.local_filename string = "milton_MA.csv"
    NameValueArgs.data_dir {mustBeFolder} = fullfile(pwd, "data")
    NameValueArgs.timeout {mustBeInteger, mustBePositive} = 30
end

url_path = NameValueArgs.url_path;

if isempty(NameValueArgs.local_filename)
    local_filename = NameValueArgs.file;
else
    local_filename = NameValueArgs.local_filename;
end

file_url = strcat(url_path, NameValueArgs.file);

fprintf("Downloading %s to %s\n", file_url, fullfile(NameValueArgs.data_dir,local_filename))
options = weboptions("Timeout", NameValueArgs.timeout);
websave(fullfile(NameValueArgs.data_dir,NameValueArgs.local_filename), file_url, options);

end

