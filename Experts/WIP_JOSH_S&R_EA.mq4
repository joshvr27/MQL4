//+------------------------------------------------------------------+
//|                                              WIP_JOSH_S&R_EA.mq4 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

// custom indicator inputs
extern bool CheckOncePerBar = true;
extern int barsToCheck = 200;
extern int fractalSensitivity = 15;
extern double clusterMarginPercentage = 0.1;
extern bool safemode = true;
// hides lesser important lines (clusters less than 2)
extern int safetyLevel = 2;

// new bar vars
int BarShift;
bool NewBar;
datetime CurrentTimeStamp;


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---

// Execute on bar open
   if(CheckOncePerBar == true)
     {
      BarShift = 1;
      if(CurrentTimeStamp != Time[0])
        {
         CurrentTimeStamp = Time[0];
         NewBar = true;
        }
      else
         NewBar = false;
     }
   else
     {
      NewBar = true;
      BarShift = 0;
     }
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---

   // only trigger indicator on new bar
   if(NewBar != true)
      return;
   // Alert("New Bar:", NewBar);
   
   // s&r price arrays
   double upperPriceArray[];
   double lowerPriceArray[];
   double priceClusterMargin = getPriceClusterMargin();
    

   // add the custom S&R indicator to chart
   iCustom(NULL, 0, "josh_fractals_3_funcs", CheckOncePerBar, barsToCheck, fractalSensitivity, clusterMarginPercentage, safemode, safetyLevel);
   
   // loop through all horizontal lines, 
   createNearestPriceArrays(upperPriceArray,lowerPriceArray);
   
   // sort price arrays higher from 0 -> low to high, lower 0 -> high to low
   sortArraysIntoNumericalOrder(upperPriceArray,lowerPriceArray);
   
   
   
   // ----------------- UPPER CHECKS
   // check if any of the lines are on or close to the UPPER price
   for (int i = 0; i <= ArraySize(upperPriceArray) -1; i++) {
   
      // is Price at upper band?
      if (Ask > upperPriceArray[i] - priceClusterMargin && Ask <= upperPriceArray[i]) {
         // price is within X percent of upper
         
         // filter to remove false positives if theres a lower within close proximity as well
         //if (ArraySize(lowerPriceArray) > 0 && Ask < lowerPriceArray[i] + priceClusterMargin) {
         //   Alert("we are inbetween an upper and lower that are close together");
         //   continue;
         //}
         
         Alert("Price Near Upper!");
         // check  entry candle patterns
         // Alert(" prev: " +  Close[1] + "current: " + Close[0]);
         
         // check for candle reversals
         if (Close[1] > Close[0]) {
         
            // ranging toward lower bands or on a new downtrend
            string name = "arrow_down_" + i + TimeToString(Time[0]);
            DrawArrowDown(name, Close[0], Time[0], White);
            // TODO:check MA here
            
         } else if (Close[1] < Close[0]) {
            // still moving up, possible new uptrend or may reverse later
            // ----> do nothing here
         }
      }      
   }
   
   // --------------- LOWER CHECKS
   // check if any of the lines are on or close to the LOWER price
   for (int i = 0; i <= ArraySize(lowerPriceArray) -1; i++) {
         // is price at lower band?
      if (Ask < lowerPriceArray[i] + priceClusterMargin && Ask >= lowerPriceArray[i]) {
         // price is within X percent of lower
         
         // filter to remove false positives if theres a upper within close proximity as well
         ////if (ArraySize(upperPriceArray) > 0 && Ask < upperPriceArray[i] - priceClusterMargin) {
         ////   Alert("we are inbetween a lower  and upper that are close together");
         ////   continue;
         ////}
         
         
         Alert("Price Near Lower!");

         // check for candle reversals
         if (Close[1] < Close[0]) {
            Alert("Price is ranging upwards");
            // ranging toward upper bands  or on a new uptrend
            string name = "arrow_up_" + i + TimeToString(Time[0]);
            DrawArrowUp(name, Close[0], Time[0], White);
            // todo: Check MA here
            
         } else if (Close[1] > Close[0]) {
            // still moving down, possible new downtrend or may reverse later
            // ----> do nothing here
         }
      } 
      
     }
     
   
   // TODO: one trade at a time
   
   // TODO: if it is, set a flag to wait for entry
   
   // sort lines in numerical order, select the SL & TP lines (make sure they have correct ratio,
   // if ratio or gap compared to volatility is bad, choose the next line up for TP & SL
   
   // add in trailing stop
   
   // use 100 & 200 ema to decide whether to bounce between lines or to move with trend


 }
//+------------------------------------------------------------------+
//  FUNCTIONS
//+------------------------------------------------------------------+

void createNearestPriceArrays(double &upperPriceArray[], double &lowerPriceArray[]){
   string name;
   double price;
   double nearest_up_price = EMPTY_VALUE;
   double nearest_down_price = 0;
   string nearest_up_name;
   string nearest_down_name;
   
   for (int i = ObjectsTotal() - 1; i >= 0; i--) {
   
     name  = ObjectName(0, i);
     if(ObjectGetInteger(0, name, OBJPROP_TYPE)!= OBJ_HLINE) continue;
     price = ObjectGetDouble(0, name, OBJPROP_PRICE1);
     
     if (price > Ask ) {
      // push into upper price array
      doubleArrayPush(upperPriceArray, price);
      Alert("pushed into upper array" + upperPriceArray[0]);
      
     } else {
      // push into lower price array
      doubleArrayPush(lowerPriceArray, price);
      Alert("pushed into lower array" + lowerPriceArray[0]);
     }

   }
}

// Helper function to "push" double to double array
void doubleArrayPush(double & array[] , double dataToPush){
    int count = ArrayResize(array, ArraySize(array) + 1);
    array[ArraySize(array) - 1] = dataToPush;
}

void sortArraysIntoNumericalOrder(double &upperPriceArray[], double &lowerPriceArray[]){
// sort arrays into numerical order
   if (ArraySize(upperPriceArray) > 0) {
      // sort price arrays into numerical order
      ArraySort(upperPriceArray, WHOLE_ARRAY, 0, MODE_ASCEND);   
      for (int i = 0; i <= ArraySize(upperPriceArray) -1; i++){
         Alert("upper price array: i" + i + " price: " + upperPriceArray[i]);
      }
   }
   
   if (ArraySize(lowerPriceArray) > 0) {
      // sort price arrays into numerical order
      ArraySort(lowerPriceArray, WHOLE_ARRAY, 0, MODE_DESCEND);
      for (int i = 0; i <= ArraySize(lowerPriceArray) -1; i++){
         Alert("lower price array: i" + i + " price: " + lowerPriceArray[i]);
      }    
   }
}

double getPriceClusterMargin(){
   // get the current price range
    double allTimeHigh = iHigh(NULL, 0, iHighest(NULL, 0,MODE_HIGH, barsToCheck, 0) );
    double allTimeLow = iLow(NULL, 0, iLowest(NULL, 0, MODE_LOW, barsToCheck, 0) );
    double priceRange = allTimeHigh - allTimeLow;
    // Alert("priceRange: " + priceRange);
    
    // get 1% of range to use as the margin for s/r levels
    double priceClusterMargin = priceRange * clusterMarginPercentage;
    // Alert(clusterMarginPercentage * 100 + "% of range: " + priceRange * clusterMarginPercentage);
    return priceClusterMargin;
}

void DrawArrowUp(string ArrowName,double LinePrice, datetime time, color LineColor)
{
   ObjectCreate(0, ArrowName, OBJ_ARROW, 0, time, LinePrice); // draw an up arrow
   ObjectSet(ArrowName, OBJPROP_STYLE, STYLE_SOLID);
   ObjectSet(ArrowName, OBJPROP_ARROWCODE, SYMBOL_ARROWUP);
   ObjectSet( ArrowName, OBJPROP_COLOR,LineColor);
   ObjectSet( ArrowName, OBJPROP_WIDTH,5);
}

void DrawArrowDown(string ArrowName,double LinePrice, datetime time, color LineColor)
{
   ObjectCreate(0, ArrowName, OBJ_ARROW, 0, time, LinePrice); // draw an up arrow
   ObjectSet(ArrowName, OBJPROP_STYLE, STYLE_SOLID);
   ObjectSet(ArrowName, OBJPROP_ARROWCODE, SYMBOL_ARROWDOWN);
   ObjectSet(ArrowName, OBJPROP_COLOR,LineColor);
   ObjectSet( ArrowName, OBJPROP_WIDTH,5);
}