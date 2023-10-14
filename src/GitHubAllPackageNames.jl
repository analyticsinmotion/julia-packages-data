module GitHubAllPackageNames

# Include the following modules
include("JuliaPackagePaths.jl")
include("JuliaPackageNames.jl")
include("CreateCSV.jl")

# Use the functions from the following modules
using .JuliaPackagePaths
using .JuliaPackageNames
using .CreateCSV

#export get_all_package_names_from_github


# *********************************************************************************************************
# -------------------------- Function - get_all_package_names_from_github ---------------------------------
# *********************************************************************************************************

"""
    get_all_package_names_from_github()

Fetches the names and UUIDs of Julia packages from the Julia Registries on GitHub.
WARNING: This code will do 10,000+ HTTP requests to Github to get the data. 
WARNING: As a result the code may take an hour to run, depending on Github's throttling
ADVICE: You only need to run this file once to get the current Package names.
ADVICE: After that can use the AppendNames module which will append new packages to the master file daily.

# Description
This function retrieves package information by performing the following steps:
1. Retrieves the package paths from the Julia Registries on GitHub.
2. Extracts package names and UUIDs from each package's Package.toml file.
3. Creates a CSV file containing the package names and UUIDs.

# Returns
This function does not return any value directly. It creates a CSV file with the package names and UUIDs.

# Dependencies
- get_all_package_paths_from_github(url::String): Fetches package paths from a given GitHub URL.
- get_package_name_and_uuid(paths::Vector{String}): Extracts package names and UUIDs from package paths.
- create_csv(filename::String, data::DataFrame, directory::String): Creates a CSV file from the provided DataFrame.

# Example
```julia
get_all_package_names_from_github()
```

"""
function get_all_package_names_from_github()
    
    # The location that recursively lists all directories and files in the Julia Registries on Github
    url = "https://api.github.com/repos/JuliaRegistries/General/git/trees/master?recursive=1"
    
    # Using the Julia registry data get all the package paths
    paths = get_all_package_paths_from_github(url)
    
    # Using the package paths extract the name and uuid from each package's Package.toml file
    df_julia_package_names = get_package_name_and_uuid(paths)
    
    # Create a CSV file of the output
    create_csv("julia_package_names", df_julia_package_names, "data/")
    
end


# Execute the Function
get_all_package_names_from_github()


end