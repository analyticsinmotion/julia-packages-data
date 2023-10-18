module GitHubExportCSV

using HTTP
using JSON
using CSV
using DataFrames
using Base64

export export_csv


# *********************************************************************************************************
# ----------------------------------------- Function - get_sha --------------------------------------------
# *********************************************************************************************************

"""
    get_sha(repo_owner::String, repo_name::String, branch_name::String, file_path::String, token::String)

Retrieve the SHA (Secure Hash Algorithm) of a file from a GitHub repository at a specified branch and path.

# Arguments
- `repo_owner::String`: The owner of the GitHub repository.
- `repo_name::String`: The name of the GitHub repository.
- `branch_name::String`: The branch name where the file is located.
- `file_path::String`: The path to the file in the repository.
- `token::String`: The GitHub personal access token for authentication.

## Returns
- `String`: The SHA (Secure Hash Algorithm) of the specified file.

# Throws
- `ErrorException`: If the request to retrieve the SHA fails or the HTTP response status is not 200.

"""
function get_sha(repo_owner::String, repo_name::String, branch_name::String, file_path::String, token::String)
    url = "https://api.github.com/repos/$repo_owner/$repo_name/contents/$file_path?ref=$branch_name"
    headers = Dict("Authorization" => "token $token", "Accept" => "application/vnd.github.v3+json")

    response = HTTP.request("GET", url, headers)

    if response.status == 200
        response_json = JSON.parse(String(response.body))
        return response_json["sha"]
    else
        error("Failed to retrieve SHA for the file. Status code: $(response.status)")
    end
end



# *********************************************************************************************************
# ----------------------------------------- Function - export_csv -----------------------------------------
# *********************************************************************************************************

"""
    export_csv(dataframe::DataFrame, repo_owner::String, repo_name::String, branch_name::String, file_path::String, token::String)

Export a DataFrame to a CSV file and push it to a GitHub repository.

# Arguments
- `dataframe::DataFrame`: The DataFrame to be exported to CSV.
- `repo_owner::String`: The owner of the GitHub repository.
- `repo_name::String`: The name of the GitHub repository.
- `branch_name::String`: The name of the branch where the CSV file will be pushed.
- `file_path::String`: The path to the CSV file within the repository.
- `token::String`: The GitHub personal access token for authentication.

# Description
This function converts the provided DataFrame to CSV format, encodes the CSV data using base64, and creates a commit payload to update the CSV file in the specified GitHub repository. The commit payload includes the encoded CSV data, commit message, branch name, and the SHA of the existing file. The function then sends a request to GitHub's API to create a commit and update the file in the repository.

# Example
```julia
using DataFrames

# Create a sample DataFrame
df = DataFrame(package_name = ["AAindex"], package_uuid = ["1cd36ffe-cb05-4761-9ff9-f7bc1999e190"])

# Call the export_csv function
export_csv(df, "analyticsinmotion", "julia-packages-data", "main", "data/output_test.csv", TOKEN)
```

"""
function export_csv(dataframe::DataFrame, repo_owner::String, repo_name::String, branch_name::String, file_path::String, token::String)
    
    # Convert the DataFrame to CSV format
    io_buffer = IOBuffer()
    csv_data = CSV.write(io_buffer, dataframe)

    # Convert the IOBuffer to a string
    csv_data = String(take!(io_buffer))

    #println("CSV Data:")
    #println(csv_data)

    # Encode the CSV data using base64
    encoded_csv_data = base64encode(csv_data)

    # Create a commit payload
    commit_message = "Update CSV data"
    branch_ref = "refs/heads/$branch_name"

    commit_payload = Dict(
        "message" => commit_message,
        "content" => encoded_csv_data,
        "branch" => branch_name,
        "sha" => get_sha(repo_owner, repo_name, branch_name, file_path, token)
    )

    # Send a request to create a commit
    url = "https://api.github.com/repos/$repo_owner/$repo_name/contents/$file_path"
    headers = Dict("Authorization" => "token $token", "Accept" => "application/vnd.github.v3+json")

    response = HTTP.request("PUT", url, headers, JSON.json(commit_payload))

    if response.status in [200, 201]
        println("CSV data successfully exported to GitHub repository.")
    else
        println("Failed to export CSV data to GitHub repository. Status code: $(response.status)")
        println(String(response.body))
    end
end


# For Testing
#df_test_1 = DataFrame(package_name = ["AAindex"], package_uuid = ["1cd36ffe-cb05-4761-9ff9-f7bc1999e190"])
#repo_owner = "analyticsinmotion"
#repo_name = "julia-packages-data"
#branch_name = "main"
#file_path = "data/output_test.csv"
#TOKEN = ENV["TOKEN"]  

# Export DataFrame called df_test_1 
#export_csv(df_test_1, repo_owner, repo_name, branch_name, file_path, TOKEN)



# CHECK Header
#println("="^40)
#println("START of GitHubExportCSV.jl test")
#println("="^40)

# CHECK - Print the number of rows in the DataFrame
#println("Count of rows in the DataFrame: ", nrow(df_test_1))

# CHECK - Print the first 5 rows
#println("TEST: Return top 1 rows in Dataframe")
#println(first(df_test_1, 1))



end