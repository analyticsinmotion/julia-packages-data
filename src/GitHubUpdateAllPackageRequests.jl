module GitHubUpdateAllPackageRequests

# Include the following modules
include("GitHubExportCSV.jl")

# Use the functions from the following Local Modules
using .GitHubExportCSV

# Use the functions from the following Julia Modules
using HTTP, CSV, DataFrames


# *********************************************************************************************************
# ------------------------------------- Function - get_data_from_web --------------------------------------
# *********************************************************************************************************

"""
    get_data_from_web(data_url::String)

This function retrieves data from a web URL, parses it as a CSV, and returns the data as a DataFrame.

# Arguments
- `data_url::String`: A string containing the URL of the data to fetch.

# Returns
A DataFrame containing the parsed data from the specified URL.

# Errors
- An error is raised if the HTTP GET request does not return a 200 status code, indicating a failed request.

The function works in the following steps:
1. It makes an HTTP GET request to the specified URL and gets the response as a `HTTP.Response` object.
2. It checks if the request was successful (status code 200). If not, it raises an error.
3. The function parses the CSV data from the HTTP response by streaming it through the following steps:
4. The final DataFrame is returned.

Example:
```julia
url = "https://example.com/data.csv"
data_frame = get_data_from_web(url)
```

This function is useful for fetching data from a web source and converting it into a format suitable for analysis and manipulation.

"""
function get_data_from_web(data_url::String)
    
    # Makes a HTTP GET request to the specified URL and returns a HTTP.Response object.
    response = HTTP.get(data_url)
    
    # Check if the request was successful
    response.status == 200 || error("Error: HTTP request failed with status $(response.status)")
    
    # Parse the CSV data from the HTTP response into a DataFrame, by piping the response body through several steps
    # Step 1 - response.body - Gets the body stream/IOBuffer from the HTTP response. This contains the raw CSV data.
    # Step 2 - IOBuffer(response.body) - Wraps the stream in an IOBuffer which allows reading/parsing the data.
    # Step 3 - |> CSV.File - Pipes the buffer into the CSV.File function which parses the CSV data.
    # Step 4 - |> DataFrame - Finally pipes the parsed CSV into a DataFrame.
    df_source_data = IOBuffer(response.body) |> CSV.File |> DataFrame
    
    # Return the final dataframe
    return df_source_data
    
end



# *********************************************************************************************************
# ----------------------- Function - get_and_update_all_julia_package_requests_data -----------------------
# *********************************************************************************************************

"""
get_and_update_all_julia_package_requests_data()

Fetches and updates data related to Julia package requests from various sources.

This function performs the following tasks:
1. Retrieves the latest list of Julia package names from GitHub.
2. Downloads data files for package requests from different sources.
3. Left joins the downloaded data with the Julia package names data.
4. Saves the merged data to CSV files in the 'data' directory.

The function fetches data from predefined URLs and file names, and then combines it with the package names to create a comprehensive dataset for further analysis.

No arguments are required for this function. Make sure to call this function to update the package requests data.

Example usage:
```julia
get_and_update_all_julia_package_requests_data()
```

"""
function get_and_update_all_julia_package_requests_data()
    
    # Get the latest Julia Packages Name file from GitHub
    url_julia_package_names = "https://raw.githubusercontent.com/analyticsinmotion/julia-packages-data/main/data/julia_package_names.csv"
    df_julia_package_names = get_data_from_web(url_julia_package_names)
    
    # Package Request File Names
    package_request_file_names = ["package_requests", "package_requests_by_region", "package_requests_by_date", "package_requests_by_region_by_date"]
    url_prefix = "https://julialang-logs.s3.amazonaws.com/public_outputs/current/"
    file_extension = ".csv.gz"
    
    # Loop through the File Names, build the source URL and call the function get_data_from_web()
    for file_name in package_request_file_names
        url = string(url_prefix, file_name, file_extension)
        
        # Call the function
        df_result = get_data_from_web(url)
        
        # Left Join with the latest Julia Packages Name file
        df_output = leftjoin(df_result, df_julia_package_names, on=:package_uuid)
        println("Number of rows in file julia_",  file_name, ".csv: ", nrow(df_output))

        # Export the "df_output" dataframe to GitHub
        repo_owner = "analyticsinmotion"
        repo_name = "julia-packages-data"
        branch_name = "main"
        new_file_name = string("julia_", file_name)
        file_path = string("data/", new_file_name, ".csv")
        TOKEN = ENV["TOKEN"]  
        export_csv(df_output, repo_owner, repo_name, branch_name, file_path, TOKEN)
    end

end



# Execute 
get_and_update_all_julia_package_requests_data()


end