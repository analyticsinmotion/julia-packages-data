module GitHubUpdateAllPackageNames

# Include the following modules
include("GitHubJuliaPackagePaths.jl")
include("GitHubJuliaPackageNames.jl")
include("GitHubExportCSV.jl")
include("GitHubImportCSV.jl")

# Use the functions from the following modules
using .GitHubJuliaPackagePaths
using .GitHubJuliaPackageNames
using .GitHubExportCSV
using .GitHubImportCSV

using DataFrames

#export add_new_package_names_from_github


# *********************************************************************************************************
# -------------------------- Function - add_new_package_names_from_github ---------------------------------
# *********************************************************************************************************

"""
    add_new_package_names_from_github()

This function checks the Julia package registry on GitHub for any new packages that have been added, 
extracts their names and UUIDs, and appends this info to the Julia Package Names master file.

# Description
The function does the following:
1. Gets all package paths by recursively listing all directories and files in the Julia package registry on GitHub.
2. Extracts just the package names from the paths and creates a dataframe with the paths and names.
3. Imports the current local Julia package name & UUID master CSV file. 
4. Joins the extracted names dataframe with the imported master dataframe to identify any new packages not currently in the master file.
5. Filters for missing UUIDs to get just the new package names.
6. Gets the package name & UUID for these new packages from their paths.
7. Appends the new package info dataframe to the imported master dataframe.
8. Sorts the concatenated dataframe by package name.
9. Exports the updated dataframe to the local Julia package name master CSV file.

This allows easy automated checking for any new packages added to the Julia package registry on GitHub, 
and appending their info to the local master file.

# Returns
This function does not return any value directly. It creates a CSV file with the updated Julia packages list.

# Example
```julia
add_new_package_names_from_github()
```

"""
function add_new_package_names_from_github()
    
    # The location that recursively lists all directories and files in the Julia Registries on Github
    url = "https://api.github.com/repos/JuliaRegistries/General/git/trees/master?recursive=1"
    
    # Using the Julia registry data get all the package paths
    paths = get_all_package_paths_from_github(url)
    
    # Using the package paths extract the name and create a dataframe to show each path and corresponding package name
    df_package_paths_and_names = get_name_from_path(paths)
    println("CHECK 1 - Number of Julia Packages currently on GitHub: ", nrow(df_package_paths_and_names))
    
    # Import the current master file that shows all the package names and uuids
    df_imported_package_master_file = import_csv()
    println("CHECK 2 - Number of Julia Packages in current CSV file: ", nrow(df_imported_package_master_file))
    
    # Join the "df_package_paths_and_names" and "df_imported_package_master_file"
    merged_df = leftjoin(df_package_paths_and_names, df_imported_package_master_file, on=:package_name)
    # Identify the new packages that are not currently in the package master file
    df_missing_package_names = filter(row -> ismissing(row.package_uuid), merged_df)
    
    # From the "df_missing_package_names" dataframe extract the paths and put them in an array
    new_packages_pathways = df_missing_package_names[!, "path"]
    
    # Get the Package Name and Package UUID for the new Julia Packages
    df_new_julia_package_names = get_package_name_and_uuid(new_packages_pathways)
    
    # Append the "df_new_julia_package_names" to the "df_imported_package_master_file"
    df_latest_package_master_file = vcat(df_imported_package_master_file, df_new_julia_package_names)
    
    # Sort the DataFrame based on the "package_name" column in-place
    sort!(df_latest_package_master_file, :package_name)
    
    # Export the "df_latest_package_master_file"
    repo_owner = "analyticsinmotion"
    repo_name = "julia-packages-data"
    branch_name = "main"
    #file_path = "data/output_test.csv"
    file_path = "data/julia_package_names.csv"
    TOKEN = ENV["TOKEN"]  
    export_csv(df_latest_package_master_file, repo_owner, repo_name, branch_name, file_path, TOKEN)

    return df_latest_package_master_file, df_new_julia_package_names
    
end


# Execute the Function
df_latest_package_master_file, df_new_julia_package_names = add_new_package_names_from_github()

println("CHECK 3 - Number of Julia Packages in NEW CSV file: ", nrow(df_latest_package_master_file))

println("CHECK 4 - List of the new Julia Packages added to CSV file:")
println(df_new_julia_package_names)

# CHECK Header
#println("="^40)
#println("START of GitHubUpdateAllPackageNames.jl test")
#println("="^40)

# CHECK - Print the number of rows in the DataFrame
#println("Number of Julia Packages in NEW CSV file: ", nrow(df_latest_package_master_file))

# CHECK - Print the first 5 rows
#println("TEST: Return top 5 rows in Dataframe")
#println(first(df_latest_package_master_file, 5))


end