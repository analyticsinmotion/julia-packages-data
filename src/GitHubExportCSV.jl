module GitHubExportCSV

using HTTP
using JSON
using CSV
using DataFrames
using Base64

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
function export_csv(data::String, repo_owner::String, repo_name::String, branch_name::String, file_path::String, access_token::String)

    url = "https://api.github.com/repos/$repo_owner/$repo_name/contents/$file_path"

    headers = Dict(
        "Authorization" => "Bearer $access_token",
        "Accept" => "application/vnd.github.v3+json"
    )

    encoded_data = String(Base64.encode(UInt8(data)))

    payload = Dict(
        "message" => "Update CSV file",
        "content" => encoded_data,
        "branch" => branch_name
    )

    response = HTTP.request(
        "PUT",
        url,
        headers,
        JSON.json(payload)
    )

    return response
    
end


df_test_1 = DataFrame(package_name = ["AAindex"], package_uuid = ["1cd36ffe-cb05-4761-9ff9-f7bc1999e190"])
repo_owner = "analyticsinmotion"
repo_name = "julia-packages-data"
branch_name = "main"
file_path = "data/output_test.csv"
TOKEN = ENV["TOKEN"]

export_csv(df_test_1, repo_owner, repo_name, branch_name, file_path, TOKEN)





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