import org.gicentre.utils.colour.*;      // For colour tables. //<>//
import java.text.NumberFormat;

// Support code for CSci-5609 Assignment on St. Paul Budget Data
// January 31, 2019
// Author Dan Keefe, Univ. of Minnesota

// --------------------- Sketch-wide variables ----------------------

PFont titleFont, smallFont;

BudgetData budgetData;
int [] years;
String [] services;
YearlyData [] yearlyData;
float[] yearTotals;
float largestBudget, smallestBudget;
float [][] serviceTotals;
color[] colors = {#b3e2cd, #fdcdac, #cbd5e8, #f4cae4, #e6f5c9, #fff2ae, #f1e2cc};
NumberFormat format;

// ------------------------ Initialisation --------------------------

// Initialises the data and bar chart.
void setup()
{
  size(1280, 720);
  smooth();

  titleFont = loadFont("Helvetica-22.vlw");
  smallFont = loadFont("Helvetica-12.vlw");
  textFont(smallFont);
  
  format = NumberFormat.getInstance();
  format.setMaximumFractionDigits(2);
  Currency currency = Currency.getInstance("USD");
  format.setCurrency(currency);

  budgetData = new BudgetData();
  budgetData.loadFromFile("operating_budget-2019-01-17.csv");

  // get the years available in the budget data and save in a global variable for easy access
  years = budgetData.getYears();  
  
  // get the services for the most recent year and save in a global variable.  it's smart to
  // use the ordered list of services from just the most recent budget for drawing all of the
  // flowers so that each flower has a consistent ordering of petals and we can compare the
  // same service categories across years.
  services = budgetData.getYearlyData(years[years.length-1]).getServices();
  
  serviceTotals = new float[years.length][services.length];
  yearlyData = new YearlyData[years.length];
  
  for(int i = 0; i < years.length; i++)
  {
    yearlyData[i] = budgetData.getYearlyData(years[i]);  
  }
  
  yearTotals = new float[years.length];
  
  for(int i = 0; i < years.length; i++){
    yearTotals[i] = yearlyData[i].getTotalProposed();
    for(int j = 0; j < services.length; j++){
      serviceTotals[i][j] = yearlyData[i].getTotalProposedByService(services[j]);
    }
  }
  
  smallestBudget = min(yearTotals);
  largestBudget = max(yearTotals);
}

// ------------------ Processing draw --------------------

// draws a single petal of the flower by drawing an ellipsed scaled in size
// by the data and rotated into position based on the index of the data var
// x = the x position of the center of the flower
// y = the y position of the center of the flower
// index = the index of the petal to draw, 0 for the first, 1 for the second, ...
// nPetals = the total number of petals that will be drawn for the flower
// col = the color to use for this petal
// size = a scaling factor for the petal that should range between 0.0 for the smallest
//        possible petal and 1.0 for the largest possible petal
void drawPetal(float x, float y, int index, int nPetals, color col, float size) {
  float minLen = 10;
  float maxLen = 200;
  float len = minLen + size*(maxLen - minLen);  
  stroke(120);
  fill(col);
  pushMatrix();
  float angle = (float)index/(float)(nPetals) * TWO_PI;
  translate(x, y);
  rotate(angle);
  ellipse(0, -len/2, len/4, len); 
  popMatrix();
}

/**
Draws one flower
*/
void drawFlower(float x, float y, int nPetals, int year, float[] totals)
{
  stroke(120);
  line(x, 680, x, y);
  for(int i = 0; i < nPetals; i++)
  {
    drawPetal(x, y, i, nPetals, colors[i], totals[i]/170000000);    
  }
  fill(120);
  textAlign(CENTER);
  textFont(titleFont);
  text(str(year), x, 700);
}

/**
Draws the legend for a particular year
*/
void drawLegend(float x, float y, int year)
{
  fill(120);
  stroke(120);
  
  
  rect(x, y, 450,200);
  textAlign(LEFT);
  fill(255);
  text(str(years[year]) + " Proposed Budget", x+5, y+20);
  textFont(smallFont);
  float h = textAscent();
  
  
  for(int i = 0; i < serviceTotals[year].length; i++)
  {
    fill(colors[i]);
    String label = String.format("%-50s", services[i]);
    String data = String.format("$%20s", format.format(serviceTotals[year][i]));
    textAlign(LEFT);
    text(label, x+5, y + h + 40 + (i*20));
    textAlign(RIGHT);
    text(data, x+400, y + h + 40 + (i*20));
    
  }
}

// Draws the graph in the sketch.
void draw()
{
  background(255); //<>//
  int nPetals = serviceTotals[0].length;
      
  for(int i = 0; i < years.length; i++){
    float budgetP = (yearTotals[i] - smallestBudget) / (largestBudget - smallestBudget);
    int y = 550 - int(budgetP * 300);
    drawFlower(100+(200*i), y, nPetals, years[i], serviceTotals[i]);
  }
  
  fill(120);
  textFont(titleFont);
  textAlign(CENTER);
  text("St. Paul Expense Budgets 2014-2019", 640, 30);
  int yearIndex = 0;
  int small = 1280;
  for(int i = 0; i < years.length; i++){
    int dist = abs(mouseX - (100 + (200*i)));
    if(dist < small)
    {
      small = dist;
      yearIndex = i;
    }
  }
  float perc = float(mouseX) / 1280.0;
  
  int legendX = mouseX - int(perc * 450);
  int legendY = mouseY - 200;
  
  drawLegend(legendX, legendY, yearIndex);
}
