module GitHubJuliaPackagePaths

using HTTP
using JSON
using DataFrames


export get_all_package_paths_from_github,
       get_name_from_path


# *********************************************************************************************************
# ------------------------------------- Function - is_proper_jll_path -------------------------------------
# *********************************************************************************************************

"""
    is_proper_jll_path(path::String)
   
Check if the provided path is a proper JLL (Just Like Light) path.
A JLL package typically contains precompiled binary artifacts (libraries or executables) that can be used with Julia.
   
This function checks if the input `path` meets the criteria of a proper JLL path:
- The path is of the form "jll/X/Y" where X is a single letter and Y is the Julia package name.
   
# Arguments
- `path::String`: The path to be checked.
   
# Returns
- `Bool`: Returns true if the path is a proper JLL path, false otherwise.
   
# Examples
```julia
is_proper_jll_path("jll/Z/ZeroMQ_jll")  # Returns true
is_proper_jll_path("jll")  # Returns false
is_proper_jll_path("jll/A")  # Returns false
is_proper_jll_path("jll/Z")  # Returns false
```

"""
function is_proper_jll_path(path::String)
    parts = split(path, '/')
    return length(parts) == 3 && parts[1] == "jll" && isletter(first(parts[2])) && lastindex(parts[2]) == 1
end


# *********************************************************************************************************
# ------------------------------ Function - get_all_package_paths_from_github -----------------------------
# *********************************************************************************************************

"""
    get_all_package_paths_from_github(github_git_tree_url::String)

Fetches package paths from a GitHub Git tree URL.

This function makes an HTTP GET request to the specified GitHub Git tree URL,
parses the response to extract package paths based on certain criteria, and
returns a collection of valid package paths.

# Arguments
- `github_git_tree_url::String`: The GitHub Git tree URL from which to extract package paths.

# Returns
An array of valid package paths obtained from the GitHub Git tree URL.
["A/AAindex","A/ABBAj","A/ABCDMatrixOptics","jll/Z/ZeroMQ_jll","jll/Z/ZipFlow_jll","jll/Z/ZlibNG_jll"]

The function filters records based on their type and path, considering paths that
satisfy the conditions: path length is greater than 1, type is "tree", and the path
does not start with a dot (".") for non-"jll" paths. For paths starting with "jll",
an additional validation function `is_proper_jll_path` is applied.

"""
function get_all_package_paths_from_github(github_git_tree_url::String)
    
    # Makes a HTTP GET request to the specified URL and returns a HTTP.Response object.
    response = HTTP.get(github_git_tree_url)
    
    # Check if the request was successful
    response.status == 200 || error("Error: HTTP request failed with status $(response.status)")
    
    # Get the response body content
    tree_data = JSON.parse(String(response.body))["tree"]
    
    # Filter records where type is "tree", path does not start with ".", path length is not 1, and path is not "jll"
    filtered_records = filter(record -> 
        begin
            path = get(record, "path", "")
            if startswith(path, "jll")
                return is_proper_jll_path(path)
            else
                return length(path) > 1 && get(record, "type", "") == "tree" && !startswith(path, ".")
            end
        end, tree_data)
    
    # Filter out everything except the path values
    paths = map(r -> r["path"], filtered_records)
    
    return paths
end


# *********************************************************************************************************
# ------------------------------------- Function - get_name_from_path -------------------------------------
# *********************************************************************************************************

"""
    get_name_from_path(paths::Vector{String})

Extracts package names from a list of file paths and creates a DataFrame containing the paths and their corresponding package names.

# Arguments
- `paths::Vector{String}`: A vector of file paths.

# Returns
A DataFrame with the extracted package names and their corresponding paths.

# Examples
```julia
paths = ["A/AAindex","A/ABBAj","A/ABCDMatrixOptics","jll/Z/ZeroMQ_jll","jll/Z/ZipFlow_jll","jll/Z/ZlibNG_jll"]
result_df = get_name_from_path(paths)
```

"""
function get_name_from_path(paths::Vector{String})
    
    # Extract the package names from the paths
    names = [split(names, "/")[end] for names in paths]
    
    # Create a DataFrame with the extracted names
    df_package_paths_and_names = DataFrame(path = paths, package_name = names)
    
    # Return the dataframe with the path and the package names
    return df_package_paths_and_names
    
end

# The location that recursively lists all directories and files in the Julia Registries on Github
#url = "https://api.github.com/repos/JuliaRegistries/General/git/trees/master?recursive=1"
    
# Using the Julia registry data get all the package paths
#paths = get_all_package_paths_from_github(url)

# Using the package paths extract the name and create a dataframe to show each path and corresponding package name
#df_package_paths_and_names = get_name_from_path(paths)


# CHECK Header
#println("="^40)
#println("START of GitHubJuliaPackagePaths.jl test")
#println("="^40)

# CHECK - Print the number of rows in the DataFrame
#println("Count of rows in the DataFrame: ", nrow(df_package_paths_and_names))

# CHECK - Print the first 5 rows
#println("TEST: Return top 5 rows in Dataframe")
#println(first(df_package_paths_and_names, 5))

end