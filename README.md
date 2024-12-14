# File Structure

The repo is structured as:

-   `data` is the file that contains all the datasets, including the simulated,
     raw, and cleaned datasets. Detailed description of each are in the below
     three bullet points
-   `data/00-simulated_data` contains the simulated data as obtained from the 
     chosen Open Data Toronto dataset as a parquet file, which decreases the 
     size of the dataset, which ideally has the same structure as the cleaned
     dataset. The specific file is named as `simulated_data.parquet`.
-   `data/01-raw_data` contains the raw data as obtained from the chosen Open 
     Data Toronto dataset as a parquet file, which decreases the size of the 
     dataset. The specific file is named as `raw_data.parquet`.
-   `data/02-analysis_data` contains the cleaned dataset that was constructed
     based on the raw dataset obtained from the Open Data Toronto server. The
     analysis data is named as `analysis_data.parquet`.
-   `models` contains the fitted multivariate linear regression model, saved as
     a rds file that is named as `linear_regression_model.rds`. 
-   `other` contains the folder `sketches`, which contains relevant sketches 
     that are used to present my own general idea of how the cleaned dataset
     should ideally look like. The folder `llm_usage` provides the complete chat
     history between me and ChatGPT used in this paper.
-   `paper` contains the files used to generate the paper, including the Quarto 
     document, bibliography file, and the PDF of the paper. 
-   `scripts` contains the R scripts used to simulate, download and clean data,
     and test both the cleaned and simulated data.

# Dataset Used For This Paper

The raw dataset used for this paper is named 'Daily Shelter & Overnight Service 
Occupancy & Capacity', and the detailed citations for this dataset is in the file
`references.bib`, which is in the `paper` file. The specific citation is named
as 'Dataset'. Note that this raw dataset used is only updated to December 13, 2024.

# Statement on LLM usage

Parts of the code is written with the use of ChatGPT. Complete chat history
is included in the document inside the `llm_usage` file, which is part of the 
`others` folder.

