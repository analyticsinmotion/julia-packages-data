module GitHubImportCSV

using CSV
using DataFrames

export read_csv_file


# *********************************************************************************************************
# -------------------------------------- Function - read_csv_file -----------------------------------------
# *********************************************************************************************************

"""
    read_csv_file(github_username::String, repository_name::String, branch::String, file_path::String, file_name::String, file_extension::String = ".csv")

Reads a CSV file from a specified GitHub repository and returns the data as a DataFrame.

## Arguments
- `github_username::String`: The GitHub username of the repository owner.
- `repository_name::String`: The name of the GitHub repository.
- `branch::String`: The branch name of the repository containing the CSV file.
- `file_path::String`: The path to the directory containing the CSV file.
- `file_name::String`: The name of the CSV file (without extension).
- `file_extension::String`: (Optional) The extension of the CSV file (default is ".csv").

## Returns
A DataFrame containing the data from the specified CSV file.

## Examples
```julia
df = read_csv_file("analyticsinmotion", "julia-packages-data", "main", "data", "julia_package_names")
```

"""
function read_csv_file(github_username::String, repository_name::String, branch::String, file_path::String, file_name::String, file_extension::String = ".csv")

    # Build the absolute URL to the CSV file
    # https://raw.githubusercontent.com/analyticsinmotion/julia-packages-data/main/data/julia_package_names.csv
    url_initial_part = "https://raw.githubusercontent.com"
    seperator = "/"
    csv_path = string(url_initial_part, seperator, github_username, seperator, repository_name, seperator, branch, seperator, file_path, seperator, file_name, file_extension)
    
    # Construct the path to the CSV file using the relative path
    #csv_path = joinpath(dirname(@__FILE__), "..", "data", "julia_package_names.csv")
    
    # Construct the path to the CSV file using the absolute path
    #csv_path = "https://raw.githubusercontent.com/analyticsinmotion/julia-packages-data/main/data/julia_package_names.csv"
    
    # Read the CSV file
    df_read_csv = CSV.File(csv_path) |> DataFrame
    
    # Return the DataFrame
    return df_read_csv

end

# Read the current master file that shows all the package names and uuids
df_read_current_package_master_file = read_csv_file("analyticsinmotion", "julia-packages-data", "main", "data", "julia_package_names")

# Print the first 5 rows
println(first(df_read_current_package_master_file, 5))



end