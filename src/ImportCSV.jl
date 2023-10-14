module ImportCSV

using CSV
using DataFrames

export import_csv


# *********************************************************************************************************
# ----------------------------------------- Function - import_csv -----------------------------------------
# *********************************************************************************************************

"""
    import_csv(file_name::String, file_path::String="")

Import a CSV file and convert it to a DataFrame.

# Arguments
- `file_name::String`: The name of the CSV file to import (without .csv extension).
- `file_path::String`: (Optional) The path to the directory containing the CSV file. Default is an empty string, indicating the current working directory.

# Returns
A DataFrame representing the contents of the imported CSV file.

This function constructs the full file path by combining `file_path`, `file_name`, and the `.csv` extension. 
It then imports the CSV file using `CSV.File` and converts it to a DataFrame using `DataFrame`.

# Example
```julia
using DataFrames
imported_df = import_csv("julia_package_names", "data/")
```

"""
function import_csv(file_name::String, file_path::String="")
    
    # Build the file path
    file_extension = ".csv"
    full_path = string(file_path, file_name, file_extension)
    
    # Import the CSV file and convert to a DataFrame
    df_imported_csv = CSV.File(full_path) |> DataFrame    
    
    # Return the DataFrame
    return df_imported_csv
    
end



end