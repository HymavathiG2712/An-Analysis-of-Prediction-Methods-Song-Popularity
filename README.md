# Spotify

# Spotify Data Analytics Spring Project '23

Predicting Song Popularity based on features like temp, pitch, loudness breaking the myth of Science behind music.

Leveraged Knowledge in: R, Machine Learning, Regression, Classification, Python

## Flowchart

```mermaid
graph LR
    Start --> Data_Collection_Preprocessing
    Data_Collection_Preprocessing --> Data_Collection
    Data_Collection_Preprocessing --> Data_Preprocessing
    Data_Preprocessing --> Remove_Duplicate_Entries
    Data_Preprocessing --> Fill_Missing_Values
    Data_Preprocessing --> Remove_Zero_Popularity
    Data_Preprocessing --> Encode_Categorical_Variables
    Data_Collection --> Kaggle_Dataset(spotify_combined.csv)
    Remove_Duplicate_Entries --> Regression_Analysis
    Fill_Missing_Values --> Regression_Analysis
    Remove_Zero_Popularity --> Regression_Analysis
    Encode_Categorical_Variables --> Regression_Analysis
    Regression_Analysis --> Target_Variable(Popularity)
    Regression_Analysis --> Models
    Models --> Linear_Regression
    Models --> Ridge_Regression
    Models --> Lasso_Regression
    Models --> Decision_Tree_Regression
    Linear_Regression --> Evaluation_Metrics
    Ridge_Regression --> Evaluation_Metrics
    Lasso_Regression --> Evaluation_Metrics
    Decision_Tree_Regression --> Evaluation_Metrics
    Evaluation_Metrics --> MSE
    Evaluation_Metrics --> R2
    Evaluation_Metrics --> Adjusted_R2
    Models --> Classification_Analysis
    Classification_Analysis --> Target_Two_Categories(Popular, Non-Popular)
    Classification_Analysis --> Categorization
    Categorization --> Based_on_Median_Popularity
    Categorization --> Classification_Report
    Classification_Report --> Normalization_Feature_Scaling
    Normalization_Feature_Scaling --> Standard_Scaling
    Normalization_Feature_Scaling --> Correlation_Analysis
    Correlation_Analysis --> Determine_Variable_Relations
    Determine_Variable_Relations --> End
    End


