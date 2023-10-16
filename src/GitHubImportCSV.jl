module GitHubImportCSV

using CSV
using DataFrames

export read_csv_file


# *********************************************************************************************************
# -------------------------------------- Function - read_csv_file -----------------------------------------
# *********************************************************************************************************

"""
    read_csv_file()

Reads a CSV file from a specified GitHub repository and returns the data as a DataFrame.

This function constructs the path to a CSV file using a relative path, reads the CSV file using the CSV.jl package, and returns the content as a DataFrame.

# Returns
A DataFrame containing the data from the specified CSV file.

# Examples
```julia
df = read_csv_file()
```

"""
function read_csv_file()
  
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
df_read_current_package_master_file = read_csv_file()

# CHECK - Print the first 5 rows
println("TEST: Return top 5 rows in Dataframe")
println(first(df_read_current_package_master_file, 5))



end