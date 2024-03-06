# Spotify

# Spotify Data Analytics Spring Project '23

Leveraged Knowledge in: R, Machine Learning, Regression, Classification, Python

Situation:
A dataset containing information about songs, including features like artist name, duration, and popularity (ranging from 0 to 100), was available. The goal was to predict song popularity based on various features.

Task:

Preprocess the dataset by handling duplicates, missing values, and converting variables.
Perform exploratory data analysis and feature engineering.
Split the dataset into training and testing sets.
Utilize both classification and regression models to predict song popularity.
Evaluate model performance and compare the results.
Action:

Imported the dataset and preprocessed it by dropping duplicates, filtering out rows with zero popularity, and handling missing values.
Engineered features by converting duration from milliseconds to seconds, converting popularity into a categorical variable, and one-hot encoding categorical variables.
Standardized the data using StandardScaler and viewed the correlation matrix to identify and remove highly correlated features.
Split the dataset into an 80-20 train-test split.
Implemented classification models including LDA, QDA, KNN, and RF to predict song popularity categories. RF outperformed other models with an accuracy of 64%.
Ran regression models including Linear Regression, Ridge Regression with Cross Validation, Lasso Regression with Cross Validation, and Decision Tree Regression to predict continuous song popularity.
Evaluated model performance and observed that classification models yielded better results than regression models.
Result:
The project successfully analyzed the dataset and predicted song popularity using both classification and regression techniques. Classification models demonstrated better performance compared to regression models, providing insights into factors influencing song popularity.


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


