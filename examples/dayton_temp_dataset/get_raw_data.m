function get_raw_data(NameValueArgs)
%GET_RAW_DATA Downloads the 

arguments
    NameValueArgs.file string = "32874107"
    NameValueArgs.url_path string = "https://api.figshare.com/v2/file/download/"
    NameValueArgs.local_filename string = "milton_MA.csv"
    NameValueArgs.data_dir {mustBeFolder} = fullfile(pwd, "data")
    NameValueArgs.timeout {mustBeInteger, mustBePositive} = 30
end

file_url = strcat(NameValueArgs.url_path, NameValueArgs.file);

fprintf("Downloading %s to %s\n", file_url, fullfile(NameValueArgs.data_dir,NameValueArgs.local_filename))
options = weboptions("Timeout", NameValueArgs.timeout);
websave(fullfile(NameValueArgs.data_dir,NameValueArgs.local_filename), file_url, options);

end

