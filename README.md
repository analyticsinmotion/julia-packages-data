<div align="center">
  <br />
    <img src=".github/workflows/assets/images/julia-packages-data.png" width=20% height=20%>
</div>
<h1 align="center">Julia Packages Data 
  <a href="https://twitter.com/intent/tweet?text=Get%20the%20latest%20mappings%20of%20all%20Julia%20Package%20Names%20to%20their%20respective%20UUIDs.
&url=https://github.com/analyticsinmotion/julia-packages-data&via=analyticsmotion&hashtags=JuliaLang,JuliaPackage,JuliaProgramming,JuliaTools">
    <img src="https://img.shields.io/twitter/url/http/shields.io.svg?style=social" alt="Tweet">
  </a>
</h1>

<!-- badges: start -->
<div align="center">


[![Julia](https://img.shields.io/badge/Julia-9558B2?logo=julia&logoColor=white)](https://julialang.org/)&nbsp;&nbsp;
[![MIT license](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/analyticsinmotion/julia-packages-data/blob/main/LICENSE)&nbsp;&nbsp;
![Status: Stable](https://img.shields.io/badge/Status-Stable-brightgreen)&nbsp;&nbsp;
[![Julia Packages Data](https://github.com/analyticsinmotion/julia-packages-data/actions/workflows/update-package-names.yml/badge.svg)](https://github.com/analyticsinmotion/julia-packages-data/actions/workflows/update-package-names.yml)&nbsp;&nbsp;
[![Analytics in Motion](https://raw.githubusercontent.com/analyticsinmotion/.github/main/assets/images/analytics-in-motion-github-badge-rounded.svg)](https://www.analyticsinmotion.com)&nbsp;&nbsp;
<!-- [![Coverage](https://codecov.io/gh/analyticsinmotion/DMARCParser.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/analyticsinmotion/DMARCParser.jl)&nbsp;&nbsp; -->

</div>
<!-- badges: end -->

<br />

:wave: Welcome to the Julia Packages Data Repository on GitHub!  

## About this Project
This repository is dedicated to collecting and updating a master file that maps Julia package names to their respective Universally Unique Identifiers (UUIDs). Our aim is to maintain an accurate and current record of these essential identifiers, ensuring that developers and users in the Julia ecosystem have access to reliable information for their packages. By daily updates and curation, we strive to provide a valuable resource for the Julia community. Explore, contribute, and stay informed with the latest in Julia Packages Data.

<br />

## Files available in Julia Packages Data
The following table provides an overview of the data that can be accessed in this repository.

| File Name  | Updated | Description |
| ------------- | ------------- | ------------- | 
| <a href="https://github.com/analyticsinmotion/julia-packages-data/blob/main/data/julia_package_names.csv" target="_blank">julia_package_names.csv</a> | Daily | Matches all current Julia Package Names to their UUID. |
| <a href="https://github.com/analyticsinmotion/julia-packages-data/blob/main/data/julia_package_requests.csv" target="_blank">julia_package_requests.csv</a> | Daily | Total request count for all Julia Packages. |
| <a href="https://github.com/analyticsinmotion/julia-packages-data/blob/main/data/julia_package_requests_by_date.csv" target="_blank">julia_package_requests_by_date.csv</a> | Daily | The request counts by date for all Julia Packages. |
| <a href="https://github.com/analyticsinmotion/julia-packages-data/blob/main/data/julia_package_requests_by_region.csv" target="_blank">julia_package_requests_by_region.csv</a> | Daily | Total requests for each Julia Package, categorized by geographical region. |
| <a href="https://github.com/analyticsinmotion/julia-packages-data/blob/main/data/julia_package_requests_by_region_by_date.csv" target="_blank">julia_package_requests_by_region_by_date.csv</a> | Daily | Request counts for each Julia Package, split by Geographical Region, and request date. |


<br />


## How to access and download data files

There are two methods that can be used to access and download the data files:

### Download directly from GitHub

1. Click on the link from the table able to access the raw version of the data file. Some of the files are quite large so the data may not show in the screen. This is perfectly fine and will not affect the download at all.

2. Click the "Download" button located at the top right of the screen to download the raw data file to your local machine. If prompted, choose a location to save the file.

<br />

### Using Julia to access data

1. Install the required packages:

```julia
using Pkg; Pkg.add(["HTTP", "CSV", "DataFrames"])
```

2. Import the required modules:
```julia
using HTTP, CSV, DataFrames
```

3. Create a helper function:
```julia
function get_julia_master_file(file_name::String, return_dataframe::Bool=true, download_csv::Bool=false)
    url = string("https://raw.githubusercontent.com/analyticsinmotion/julia-packages-data/main/data/", file_name)
    response = HTTP.get(url)
    response.status == 200 || error("Failed to retrieve data from the URL")
    df_julia_package_names = IOBuffer(response.body) |> CSV.File |> DataFrame    
    download_csv ? CSV.write("julia_package_names.csv", df_julia_package_names) : nothing  
    return return_dataframe ? df_julia_package_names : nothing
end
```

4. Call the following helper functions

<br />
   
For *Julia Package Names*
```julia
# Variable values of true, true will return the DataFrame within Julia and also export it as a CSV file
file_name = "julia_package_names.csv"
get_julia_master_file(file_name, true, true)
```

For *Julia Package Requests*
```julia
# Variable values of true, true will return the DataFrame within Julia and also export it as a CSV file
file_name = "julia_package_requests.csv"
get_julia_master_file(file_name, true, true)
```

For *Julia Package Requests by Date*
```julia
# Variable values of true, true will return the DataFrame within Julia and also export it as a CSV file
file_name = "julia_package_requests_by_date.csv"
get_julia_master_file(file_name, true, true)
```

For *Julia Package Requests by Region*
```julia
# Variable values of true, true will return the DataFrame within Julia and also export it as a CSV file
file_name = "julia_package_requests_by_region.csv"
get_julia_master_file(file_name, true, true)
```

For *Julia Package Requests by Region by Date*
```julia
# Variable values of true, true will return the DataFrame within Julia and also export it as a CSV file
file_name = "julia_package_requests_by_region_by_date.csv"
get_julia_master_file(file_name, true, true)
```

<br /><br />

<!-- DATA DICTIONARY -->
## Data Dictionary

### Julia Package Names

The <a href="https://github.com/analyticsinmotion/julia-packages-data/blob/main/data/julia_package_names.csv" target="_blank">julia_package_names.csv</a> file contains a list of all current Julia package names along with their corresponding Universally Unique Identifier (UUID).

<br />

**File Details**
<br />
*Filename:* julia_package_names
<br />
*Extension:* .csv
<br />
*Delimiter:* Comma (,)
<br />
*Header:* True

<br />

**File Schema**
| Column Name  | Data Type | Description |
| ------------- | ------------- | ------------- |
| package_name  | String | The name of the Julia Package |
| package_uuid  | String | The Universally Unique Identifier (UUID) for the Julia Package |





