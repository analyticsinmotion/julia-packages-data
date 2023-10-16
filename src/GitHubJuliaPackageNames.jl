module JuliaPackageNames

using TOML
using DataFrames
using HTTP

export get_package_name_and_uuid


# *********************************************************************************************************
# -------------------------- Function - get_package_name_and_uuid - String Input --------------------------
# *********************************************************************************************************

"""
    get_package_name_and_uuid(package_pathway::String)

Extracts package names and their UUIDs from a Julia package registry based on the provided package pathway.

# Arguments
- `package_pathway::String`: A string representing the pathway to a Julia package in a package registry.

# Description
This function constructs a URL to access a package's Package.toml file from the Julia registry based on the given package pathway. 
It then makes an HTTP GET request to the constructed URL and extracts the package name and UUID from the response. 
If the package name is not already present in the reference dictionary, it is added along with its UUID.

# Multiple Dispatch
The behavior of this function will vary based on the argument data types. 
This function is when `package_pathway` is of type `String`.

# Returns
A DataFrame with two columns: "package_name" and "package_uuid", containing the extracted package names and their respective UUIDs, sorted by package name.

# Example
```julia
df = get_package_name_and_uuid("A/AAindex")
println(df)

| package_name | package_uuid                             |
|--------------|------------------------------------------|
| AAindex      | 1cd36ffe-cb05-4761-9ff9-f7bc1999e190     |
```

"""
function get_package_name_and_uuid(package_pathway::String)
    
    # Initialize blank dictionary
    reference_dictionary = Dict{String, String}()
    
    # Using the package pathway, create the URL to access each package's Package.toml file
    url_part_1 = "https://raw.githubusercontent.com/JuliaRegistries/General/master/"
    url_part_2 = "/Package.toml"
    url = string(url_part_1, package_pathway, url_part_2)    
    
    # Makes a HTTP GET request to the specified URL and returns a HTTP.Response object.
    response = HTTP.get(url)
    
    # Check if the request was successful
    response.status == 200 || error("Error: HTTP request failed with status $(response.status)")
    
    # Get the response body content
    content = String(response.body)
    
    # Parse the content to extract name and UUID
    package_toml = TOML.parse(content)
    name = package_toml["name"]
    uuid = package_toml["uuid"]
    
    # Check if the key is already in the dictionary
    # If not add it in otherwise do nothing
    if !haskey(reference_dictionary, name)
        reference_dictionary[name] = uuid
    end
    
    # Initialize an empty DataFrame
    df_reference = DataFrame(package_name = String[], package_uuid = String[])
    
    # Iterate over the dictionary and add rows to the DataFrame
    for (key, value) in reference_dictionary
        push!(df_reference, (key, value))
    end

    # Sort the DataFrame based on the "package_name" column in-place
    sort!(df_reference, :package_name)
    
    return df_reference
    
end


# *********************************************************************************************************
# -------------------------- Function - get_package_name_and_uuid - Vector Input --------------------------
# *********************************************************************************************************

"""
    get_package_name_and_uuid(package_pathway::Vector{String})

Retrieve package names and UUIDs from the Julia General registry based on the provided package pathway.

# Arguments
- `package_pathway::Vector{String}`: A vector of strings representing the pathways to package information.

# Description
This function constructs a URL to access a package's Package.toml file from the Julia registry based on the given package pathway. 
It then makes an HTTP GET request to the constructed URL and extracts the package name and UUID from the response. 
If the package name is not already present in the reference dictionary, it is added along with its UUID.

# Multiple Dispatch
The behavior of this function will vary based on the argument data types. 
This function is when `package_pathway` is of type `String`.

# Returns
A DataFrame with two columns: "package_name" and "package_uuid", containing the extracted package names and their respective UUIDs, sorted by package name.


# Example
```julia
package_pathway = ["A/AAindex", "A/ABBAj", "A/ABCDMatrixOptics"]
result_df = get_package_name_and_uuid(package_pathway)
println(result_df)

| package_name 	     | package_uuid                             |
|--------------------|------------------------------------------|
| AAindex 	         | 1cd36ffe-cb05-4761-9ff9-f7bc1999e190     |
| ABBAj   	         | 6b41afa3-2ed9-49a7-abc1-b2d458227d0d     |
| ABCDMatrixOptics   | ccdfd77c-c9b6-493d-8c46-f34d2494ed29     |
```

"""
function get_package_name_and_uuid(package_pathway::Vector{String})
    
    # Initialize blank dictionary
    reference_dictionary = Dict{String, String}()
    
    # Loop through the vector to get each path
    for path in package_pathway
        
        # Using the package pathway, create the URL to access each package's Package.toml file
        url_part_1 = "https://raw.githubusercontent.com/JuliaRegistries/General/master/"
        url_part_2 = "/Package.toml"
        url = string(url_part_1, path, url_part_2)    
    
        # Makes a HTTP GET request to the specified URL and returns a HTTP.Response object.
        response = HTTP.get(url)
    
        # Check if the request was successful
        response.status == 200 || error("Error: HTTP request failed with status $(response.status)")
    
        # Get the response body content
        content = String(response.body)
    
        # Parse the content to extract name and UUID
        package_toml = TOML.parse(content)
        name = package_toml["name"]
        uuid = package_toml["uuid"]
    
        # Check if the key is already in the dictionary
        # If not add it in otherwise do nothing
        if !haskey(reference_dictionary, name)
            reference_dictionary[name] = uuid
        end
        
    end
    
    # Initialize an empty DataFrame
    df_reference = DataFrame(package_name = String[], package_uuid = String[])
    
    # Iterate over the dictionary and add rows to the DataFrame
    for (key, value) in reference_dictionary
        push!(df_reference, (key, value))
    end

    # Sort the DataFrame based on the "package_name" column in-place
    sort!(df_reference, :package_name)
    
    return df_reference
    
end

# TEST - A sample array of paths
package_pathway = ["A/AAindex", "A/ABBAj", "A/ABCDMatrixOptics", "A/ABCdeZ", "A/ACEbase", "A/ACME", "A/ACSets", "A/ACTRModels", "A/ACTRSimulators", "A/AD4SM"]
df_julia_package_names = get_package_name_and_uuid(package_pathway)

println("TEST: Return all 10 test rows in Dataframe")
println(df_julia_package_names)



end