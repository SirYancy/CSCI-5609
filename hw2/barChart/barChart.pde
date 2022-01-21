import org.gicentre.utils.stat.*;        // For chart classes. //<>// //<>// //<>// //<>// //<>//

// Adapted for CSci-5609 Assignment on St. Paul Budget Data
// January 31, 2019
// Author Dan Keefe, Univ. of Minnesota

// Sketch to demonstrate the use of the BarChart class to draw simple bar charts.
// Version 1.3, 6th February, 2016.
// Author Jo Wood, giCentre.

// --------------------- Sketch-wide variables ----------------------

BarChart barChartApp;
BarChart barChartProp;
PFont titleFont,smallFont;
color appColor, propColor;

BudgetData budgetData;

// ------------------------ Initialisation --------------------------

// Initialises the data and bar chart.
void setup()
{
  size(1280, 720);
  smooth();

  appColor = color(255,94,91,95);
  propColor = color(255,237,102);
  titleFont = loadFont("Helvetica-22.vlw");
  smallFont = loadFont("Helvetica-12.vlw");
  textFont(smallFont);

  // here's how to load the budget data
  budgetData = new BudgetData();
  budgetData.loadFromFile("operating_budget-2019-01-17.csv");

  // here's how to get the years available in the budget data as an array of ints
  int [] years = budgetData.getYears();  
  
  float[] barDataProposed = new float[years.length];
  float[] barDataApproved = new float[years.length];
  String[] barLabels = new String[years.length];
  

  for(int i = 0; i < years.length; i++){
    barLabels[i] = str(years[i]);
    
    YearlyData yd = budgetData.getYearlyData(years[i]);
    barDataProposed[i] = yd.getTotalProposed();
    barDataApproved[i] = yd.getTotalApproved();
  }

  barChartProp = new BarChart(this);
  barChartProp.setData(barDataProposed);
  barChartProp.setBarLabels(barLabels);
  barChartProp.setBarColour(propColor);
  barChartProp.setBarGap(2); 
  barChartProp.setValueFormat("$###,###");
  barChartProp.showValueAxis(true); 
  barChartProp.showCategoryAxis(true);
  barChartProp.setMinValue(550000000);
  barChartProp.setMaxValue(800000000);

  barChartApp = new BarChart(this);
  barChartApp.setData(barDataApproved);
  barChartApp.setBarLabels(barLabels);
  barChartApp.setBarColour(appColor);
  barChartApp.setBarGap(2); 
  barChartApp.setValueFormat("$###,###");
  barChartApp.showValueAxis(true); 
  barChartApp.showCategoryAxis(true); 
  barChartApp.setMinValue(550000000);
  barChartApp.setMaxValue(800000000);

}

// ------------------ Processing draw --------------------

// Draws the graph in the sketch.
void draw()
{
  background(255);

  barChartProp.draw(80,10,width-60,height-20);
  barChartApp.draw(80,10,width-60,height-20);
  
  noStroke();
  fill(propColor);
  rect(190,100,20,20);
  fill(appColor);
  rect(190,150,20,20);
  
  fill(120);
  textFont(titleFont);
  text("St. Paul Expense Budgets 2014-2019", 170,30);
  //float textHeight = textAscent();
  textFont(smallFont);
  float textHeight = textAscent();
  text("Proposed", 220, 105+textHeight);
  text("Approved", 220, 155+textHeight);
  //text("Gross domestic product measured in inflation-corrected $US", 70,30+textHeight);
}
