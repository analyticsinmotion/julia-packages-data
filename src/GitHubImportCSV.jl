module GitHubImportCSV

using CSV
using DataFrames

export import_csv


# *********************************************************************************************************
# ----------------------------------------- Function - import_csv -----------------------------------------
# *********************************************************************************************************

"""
    import_csv()

Reads a CSV file from a specified GitHub repository and returns the data as a DataFrame.

This function constructs the path to a CSV file using a relative path, reads the CSV file using the CSV.jl package, and returns the content as a DataFrame.

# Returns
A DataFrame containing the data from the specified CSV file.

# Examples
```julia
df = import_csv()
```

"""
function import_csv()
  
    # Construct the path to the CSV file using the relative path
    csv_path = joinpath(dirname(@__FILE__), "..", "data", "julia_package_names.csv")
    
    # CHECK - Print the path 
    println("File path in Github: ", csv_path)
    
    # Read the CSV file
    df_read_csv = CSV.read(csv_path, DataFrame)
    
    # Return the DataFrame
    return df_read_csv

end

# Read the current master file that shows all the package names and uuids
df_read_current_package_master_file = import_csv()

# CHECK Header
println("="^40)
println("START of GitHubImportCSV.jl test")
println("="^40)

# CHECK - Print the number of rows in the DataFrame
println("Count of rows in the DataFrame: ", nrow(df_read_current_package_master_file))

# CHECK - Print the first 5 rows
println("TEST: Return top 5 rows in Dataframe")
println(first(df_read_current_package_master_file, 5))



end