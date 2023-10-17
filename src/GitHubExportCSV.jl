module GitHubExportCSV

using CSV
using DataFrames

export export_csv


# *********************************************************************************************************
# ----------------------------------------- Function - export_csv -----------------------------------------
# *********************************************************************************************************

"""
    export_csv(output_file_name::String, input_data_source::DataFrame, output_file_path::String="")

Create a CSV file from the provided DataFrame and save it to the specified location.

# Arguments
- `output_file_name::String`: The desired name for the output CSV file.
- `input_data_source::DataFrame`: The DataFrame containing the data to be saved to the CSV file.
- `output_file_path::String` (optional): The path where the output CSV file will be saved. Defaults to the current directory.

# Example
```julia
using DataFrames
df = DataFrame(package_name = ["AAindex"], package_uuid = ["1cd36ffe-cb05-4761-9ff9-f7bc1999e190"])
export_csv("output", df, "data/")  # Saves the DataFrame to "data/output.csv"
```

"""
function export_csv(output_file_name::String, input_data_source::DataFrame, output_file_extension::String = ".csv")
    
    # Build the file path
    #full_path = string(output_file_path, output_file_name, output_file_extension)

    # Construct the path to the CSV file using the relative path
    #full_file_name = string(output_file_name, output_file_extension)
    #csv_path = joinpath(dirname(@__FILE__), "..", "data", full_file_name)
    #println("File path in Github: ", csv_path)
    
    # Construct the path to the CSV file
    full_file_name = string(output_file_name, output_file_extension)
    repo_dir = ENV["GITHUB_WORKSPACE"]
    println("Repo Directory: ", repo_dir)
    csv_path = joinpath(repo_dir, "data", full_file_name)
    println("File path in Github: ", csv_path)


    # Using the input data create a CSV file based on the input name
    CSV.write(csv_path, input_data_source)

    return csv_path
    
end


df_test_1 = DataFrame(package_name = ["AAindex"], package_uuid = ["1cd36ffe-cb05-4761-9ff9-f7bc1999e190"])
csv_path = export_csv("output_test", df_test_1)  # Saves the DataFrame to "data/output.csv"

# Commit and push the CSV file to the repository
#run(`git add $csv_update`)
#run(`git commit -m "Add CSV file"`)
#run(`git push`)


# Upload the CSV file to the GitHub repository using GitHub API
repo_owner = "analyticsinmotion"
repo_name = "julia-packages-data"
branch_name = "main"
TOKEN = ENV["TOKEN"]

url = "https://api.github.com/repos/$repo_owner/$repo_name/contents/$csv_path"
headers = Dict("Authorization" => "token $TOKEN")

# Read the CSV content
csv_content = read(csv_path, String)

# Create the request payload
payload = Dict(
    "message" => "Add CSV file",
    "content" => base64encode(csv_content),
    "branch" => branch_name
)

response = HTTP.request("PUT", url, headers=headers, json=payload)

println("CSV file uploaded to the repository.")









# CHECK Header
println("="^40)
println("START of GitHubExportCSV.jl test")
println("="^40)

# CHECK - Print the number of rows in the DataFrame
println("Count of rows in the DataFrame: ", nrow(df_test_1))

# CHECK - Print the first 5 rows
println("TEST: Return top 1 rows in Dataframe")
println(first(df_test_1, 1))



end