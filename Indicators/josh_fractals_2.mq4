//+------------------------------------------------------------------+
//|                                              josh_fractals_2.mq4 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
<<<<<<< HEAD
#property script_show_inputs
=======
>>>>>>> 13fa96131f0c536357879ddc52a9fc545ac92550

// externs
extern bool CheckOncePerBar = true;
extern int barsToCheck = 200;
extern int fractalSensitivity = 5;
<<<<<<< HEAD
extern double clusterMarginPercentage = 0.02;
extern bool safemode = false; // hides lesser important lines (clusters less than 2)

#include <stdlib.mqh>
=======
>>>>>>> 13fa96131f0c536357879ddc52a9fc545ac92550

// new bar vars
int BarShift;
bool NewBar;
datetime CurrentTimeStamp;

// management vars
double UsePoint;
<<<<<<< HEAD
//++++ These are adjusted for 5 digit brokers.
int     pips2points;    // slippage  3 pips    3=points    30=points
double  pips2dbl;       // Stoploss 15 pips    0.0015      0.00150
int     digitsPips;    // DoubleToStr(dbl/pips2dbl, Digitspips)
=======
>>>>>>> 13fa96131f0c536357879ddc52a9fc545ac92550

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   UsePoint = PipPoint(Symbol());
<<<<<<< HEAD
   
   // set digits for jpy etc
    if (Digits == 5 || Digits == 3){    // Adjust for five (5) digit brokers.
                pips2dbl    = Point*10; pips2points = 10;   digitsPips = 1;
    } else {    pips2dbl    = Point;    pips2points =  1;   digitsPips = 0; }
    
   Alert("Initialised");
//---
   return(INIT_SUCCEEDED);
  }
  
  
int deinit() {
   Comment("De Init");
   ObjectsDeleteAll(0, 0, -1);
   return(0);
}


=======
//---
   return(INIT_SUCCEEDED);
  }
>>>>>>> 13fa96131f0c536357879ddc52a9fc545ac92550
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
<<<<<<< HEAD
   
   
    ObjectsDeleteAll(0, 0, -1);
   
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
     
    // only trigger indicator on new bar
    if (NewBar != true) return(0);
    Alert("New Bar:", NewBar);
      
    // get the current price range
    double allTimeHigh = iHigh(NULL, 0, iHighest(NULL, 0, MODE_HIGH, Period(), 0) );
    double allTimeLow = iLow(NULL, 0, iLowest(NULL, 0, MODE_LOW, Period(), 0) );
    double priceRange = allTimeHigh - allTimeLow;
    Alert("priceRange: " + priceRange);
    
    // get 1% of range to use as the margin for s/r levels
    double priceClusterMargin = priceRange * clusterMarginPercentage;
    Alert(clusterMarginPercentage * 100 + "% of range: " + priceRange * clusterMarginPercentage); // possibly make this smaller and set as ext
   
   int counted_bars = IndicatorCounted();
   int i = Bars - counted_bars - 1;           // Index of the first uncounted
   
   // get an arrow offset
   double TickValue = MarketInfo(Symbol(), MODE_TICKVALUE);
   double arrowOffset = TickValue * UsePoint;
   
 
 
   int highestArray[];
   double highestPriceArray[];
   int iterationCount = 0;
   
  // Alert("barsToCheck: "+ barsToCheck + " Fractal Sensitivity: " + fractalSensitivity);
  
   for(int searchArea = 0; searchArea < barsToCheck; searchArea += StringToInteger(fractalSensitivity)) { // if loops arent finishing slow down backtester playback
   
      if (searchArea >= Bars) {
         Alert("no more bars available for analysis");
         break;
      }
      
      // Alert("iteration: " + iterationCount +  " starting at bar " + (searchArea + 1) + " with area of " + fractalSensitivity + " and bars to check: " + barsToCheck + " bars avail: " + Bars);
      
      int highestBar = iHighest(Symbol(), 0, MODE_HIGH, StringToInteger(fractalSensitivity), StringToInteger(searchArea));
      
      if (highestBar == -1) { // error handling
      
         int errorCode = GetLastError();
         string errorDesc = ErrorDescription(errorCode);
         string errorAlert = StringConcatenate("Error: ", errorCode,": ", errorDesc);
         Alert(errorAlert);
         
      } else {
      
         Alert("highest bar: " + highestBar + " searchArea: " + searchArea + " iterationCount: " + iterationCount, " bars to check: " + barsToCheck);
         intArrayPush(highestArray, highestBar);
         
         if (highestBar > 0) {
            // draw the arrow
            DrawArrowDown("arrow_down_" + iterationCount, (High[highestBar] + arrowOffset), Time[highestBar], Yellow);
            // add the price to the highest price array 
           doubleArrayPush(highestPriceArray, High[highestBar]);
         }
         
      }
      iterationCount++;  
   }
   
   // go through price array and find values within X deviation of each other
   int countArray = ArraySize(highestPriceArray);
   Alert("count array " + countArray);
   
   // cluster array for storing groups of prices
   double clusterMultiPriceArr[1][40];
   
   for (int i = 0; i < ArraySize(highestPriceArray); i++) {
      
      double priceToCheck = highestPriceArray[i];
      Alert("HP: " + priceToCheck);
      
      // loop over the highest price array again and compare each value to look for clusters
      int clusterCount = 0; // total clusters for this specific comparison iteration (outer loop)
      for (int j = 0; j < ArraySize(highestPriceArray); j++) {
         
         double singlePriceFromArr = highestPriceArray[j]; // store each comparison price in a variable
         double upperMargin = singlePriceFromArr + priceClusterMargin;
         double lowerMargin = singlePriceFromArr - priceClusterMargin;
         
         // check if we have any clusters
         if (priceToCheck >= lowerMargin && priceToCheck <= upperMargin && i != j) { // i != j ensures the price isnt checking against itself
            
            // we have a cluster
            clusterCount++;
            Alert("Cluster! test price: " +  priceToCheck + " compare price: " + singlePriceFromArr);
            
            
            // push to cluster array
           //  [test price][prices that clustered]
           ArrayResize(clusterMultiPriceArr, i + 1, i + 1); // resize multi dimensional array
           clusterMultiPriceArr[i][0] = priceToCheck;
           clusterMultiPriceArr[i][j+1] = singlePriceFromArr;
           
           // Alert(clusterMultiPriceArr[0][0]);
            
         } else {
            // no cluster but still a fractal, add to another array for single lines.
            ArrayResize(clusterMultiPriceArr, i + 1, i + 1); // resize multi dimensional array
            clusterMultiPriceArr[i][0] = priceToCheck;
         }
      }
      
      string name = "H_LINE_" + i;
      if (clusterCount > 0) {
         Alert("cluster count for i:" + i + " - " + clusterCount);
         int lineWidth;
         if (clusterCount >= 1 && clusterCount < 3) lineWidth = 1;
         if (clusterCount >= 3 && clusterCount < 4) lineWidth = 2;
         if (clusterCount >= 4 && clusterCount < 5) lineWidth = 3;
         if (clusterCount >= 5 && clusterCount < 7) lineWidth = 4;
         if (clusterCount >= 7)                     lineWidth = 5;
         
         // HLine(name, priceToCheck, Yellow, STYLE_SOLID, lineWidth);
         if (safemode) {
            if (lineWidth >= 2) HLine(name, priceToCheck, Yellow, STYLE_SOLID, lineWidth);
         } else {
            HLine(name, priceToCheck, Yellow, STYLE_SOLID, lineWidth);
         }
      } else {
         Alert("fractal but no cluster for i: " + i);
         if (!safemode) HLine(name, priceToCheck, Yellow, STYLE_DOT, 1);
      }
      
      
//     Alert("CLUSTER ARRAY RANGE: " + ArrayRange(clusterMultiPriceArr, 0));
//      
//      // TEST
//      Alert("WHATS IN THE FIRST DIM OF THE ARR");
//      for (int i = 0; i < ArrayRange(clusterMultiPriceArr, 1); i++) {
//          Alert(i + ": " + clusterMultiPriceArr[0][i]);
//      }
   }
   
   
   
       
   
      return(1);
}
=======
//---
   
//--- return value of prev_calculated for next call
   return(rates_total);
  }
>>>>>>> 13fa96131f0c536357879ddc52a9fc545ac92550
//+------------------------------------------------------------------+


// ------ FUNCTIONS ----------

void DrawArrowUp(string ArrowName,double LinePrice, datetime time, color LineColor)
{
   ObjectCreate(ArrowName, OBJ_ARROW, 0, time, LinePrice); //draw an up arrow
   ObjectSet(ArrowName, OBJPROP_STYLE, STYLE_SOLID);
   ObjectSet(ArrowName, OBJPROP_ARROWCODE, SYMBOL_ARROWUP);
   ObjectSet(ArrowName, OBJPROP_COLOR,LineColor);
}

void DrawArrowDown(string ArrowName,double LinePrice, datetime time, color LineColor)
{
   ObjectCreate(ArrowName, OBJ_ARROW, 0, time, LinePrice); //draw an up arrow
   ObjectSet(ArrowName, OBJPROP_STYLE, STYLE_SOLID);
   ObjectSet(ArrowName, OBJPROP_ARROWCODE, SYMBOL_ARROWDOWN);
   ObjectSet(ArrowName, OBJPROP_COLOR,LineColor);
}

double PipPoint(string Currency)
  {
  
  double CalcPoint;
  
   int CalcDigits = MarketInfo(Currency,MODE_DIGITS);
   if(CalcDigits == 2 || CalcDigits == 3)
      CalcPoint = 0.01;
   else
      if(CalcDigits == 4 || CalcDigits == 5)
         CalcPoint = 0.0001;
   return(CalcPoint);
  }
  
int countOccurrences(const double condition, int &array[]) {
   int cnt = 0;
   for (int i = ArraySize(array) - 1; i > 0; i--) {
      if (condition == array[i])
         cnt++;
   }
<<<<<<< HEAD
   return cnt;
}

// Helper function to "push" int to int array
void intArrayPush(int & array[] , int dataToPush){
    int count = ArrayResize(array, ArraySize(array) + 1);
    array[ArraySize(array) - 1] = dataToPush;
}

// Helper function to "push" double to double array
void doubleArrayPush(double & array[] , double dataToPush){
    int count = ArrayResize(array, ArraySize(array) + 1);
    array[ArraySize(array) - 1] = dataToPush;
}

// TEST multi dim array push
void multiDimDoubleArrayPush(double & array[] , double dataToPush){
    int count = ArrayResize(array, ArraySize(array) + 1);
    array[ArraySize(array) - 1] = dataToPush;
}

void HLine(string name, double P0, color clr, int style, int lineThickness) {
#define WINDOW_MAIN 0
    if (ObjectMove( name, 0, Time[0], P0 )){}
    else if(!ObjectCreate( name, OBJ_HLINE, WINDOW_MAIN, Time[0], P0 ))
        Alert("ObjectCreate(",name,",HLINE) failed: ", GetLastError() );
    if (!ObjectSet(name, OBJPROP_COLOR, clr )) // Allow color change
        Alert("ObjectSet(", name, ",Color) [1] failed: ", GetLastError() );
         if (!ObjectSet(name, OBJPROP_WIDTH, lineThickness )) // Allow width change
        Alert("ObjectSet(", name, ",Width) [1] failed: ", GetLastError() );
           if (!ObjectSet(name, OBJPROP_STYLE, style )) // Allow style change
        Alert("ObjectSet(", name, ",level style) [1] failed: ", GetLastError() );
    if (!ObjectSetText(name, PriceToStr(P0), 10))
        Alert("ObjectSetText(",name,") [1] failed: ", GetLastError());
}

string  PriceToStr(double p){
    string pFrc = DoubleToStr(p, Digits);       if(digitsPips==0) return(pFrc);
    string pPip = DoubleToStr(p, Digits-1);
    if (pPip+"0" == pFrc)       return(pPip);           return(pFrc);
}
=======
   return cnt;
>>>>>>> 13fa96131f0c536357879ddc52a9fc545ac92550
