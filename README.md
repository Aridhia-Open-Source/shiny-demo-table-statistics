# Table Statistics

This RShiny mini-app allows you to quickly visualize a dataset structure (columns, type, missing values...) and a selection of summary statistics. For each variable within the dataset, you can view statistics according to the type:

- Polynominal Variables: Least and Most prevalent categories and all the unique values
- Integers: Minimum and maximum values and the average

Moreover, each variable can be displayed as a histogram, showing the distribution of the data.


## About the Table Statistics test app

This mini-app is very easy to use, just select a dataset from the drop-down menu and scroll down to see all the variables within your dataset. To see the graph of a variable, click on the row; to see more statistics you can click on 'Details' or 'More stats'.

The datasets appearing in the drop-down menu are located in the 'data' folder of this repository, you can add there you own datasets to use them in the app.

### Checkout and run

You can clone this repository by using the command:

```
git clone https://github.com/aridhia/demo-table-statistics
```

Open the .Rproj file in RStudio, source the script `dependencies.R` to install all the packages required by the app, and run `runApp()` to start the app.

### Deploying to the workspace

1. Download this GitHub repo as a .zip file.
2. Create a new blank Shiny app in your workspace called "table-statistics".
3. Navigate to the `table-statistics` folder under "files".
4. Delete the `app.R` file from the `table-statistics` folder. Make sure you keep the `.version` file!
5. Upload the .zip file to the `table-statistics` folder.
6. Extract the .zip file. Make sure "Folder name" is blank and "Remove compressed file after extracting" is ticked.
7. Navigate into the unzipped folder.
8. Select all content of the unzipped folder, and move it to the `table-statistics` folder (so, one level up).
9. Delete the now empty unzipped folder.
10. Start the R console and run the `dependencies.R` script to install all R packages that the app requires.
11. Run the app in your workspace.

For more information visit https://knowledgebase.aridhia.io/article/how-to-upload-your-mini-app/
