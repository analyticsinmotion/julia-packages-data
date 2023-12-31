module CreateCSV

using CSV
using DataFrames

export create_csv


# *********************************************************************************************************
# ----------------------------------------- Function - create_csv -----------------------------------------
# *********************************************************************************************************

"""
    create_csv(output_file_name::String, input_data_source::DataFrame, output_file_path::String="")

Create a CSV file from the provided DataFrame and save it to the specified location.

# Arguments
- `output_file_name::String`: The desired name for the output CSV file.
- `input_data_source::DataFrame`: The DataFrame containing the data to be saved to the CSV file.
- `output_file_path::String` (optional): The path where the output CSV file will be saved. Defaults to the current directory.

# Example
```julia
using DataFrames
df = DataFrame(package_name = ["AAindex"], package_uuid = ["1cd36ffe-cb05-4761-9ff9-f7bc1999e190"])
create_csv("output", df, "data/")  # Saves the DataFrame to "data/output.csv"
```

"""
function create_csv(output_file_name::String, input_data_source::DataFrame, output_file_path::String="")
    
    # Build the file path
    output_file_extension = ".csv"
    full_path = string(output_file_path, output_file_name, output_file_extension)
    
    # Using the input data create a CSV file based on the input name
    CSV.write(full_path, input_data_source)
    
end



end