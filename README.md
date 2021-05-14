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

Open the .Rproj file in RStudio and use `runApp()` to start the app.

### Deploying to the workspace

1. Create a new mini-app in the workspace called "table-statistics"" and delete the folder created for it
2. Download this GitHub repo as a .ZIP file, or zip all the files
3. Upload the .ZIP file to the workspace and upzip it inside a folder called "table-statistics"
4. Run the `dependencies.R` script to install all the packages required by the app
5. Run the app in your workspace

For more information visit https://knowledgebase.aridhia.io/article/how-to-upload-your-mini-app/
