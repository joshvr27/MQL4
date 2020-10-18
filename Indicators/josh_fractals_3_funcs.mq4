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
#property script_show_inputs
<<<<<<< HEAD
#property indicator_buffers 2;        // Number of buffers
#property indicator_color1 Red;      // Color of the 1st line
#property indicator_color2 White      // Color of the 2nd line
//#property indicator_color3 White      // Color of the 3rd line
//#property indicator_color4 White      // Color of the 4th line
//#property indicator_color5 White      // Color of the 5th line
//#property indicator_color6 White      // Color of the 6th line
//#property indicator_color7 White      // Color of the 7th line
//#property indicator_color8 White      // Color of the 8th line
// 
double Buf_0[], Buf_1[], Buf_2[], Buf_3[], Buf_4[], Buf_5[], Buf_6[], Buf_7[]; // Declaring arrays (for indicator buffers)

// TODO: BIG IMPROVEMENT! for getting the ihighest search, also check if this bar is higher than +- 1 bar either side, else disregard the fractal

// TODO: IF ON UPTREND & MAKING NEW HHs and HLs we wont have an upper cluster, so filter for this with trend & MA then use the next lowest supt as a trailing stop and dont set a TP.
// TODO: SET MACRO CONDITIONS TO LOOKS FOR RANGING VS TRENDING MARKETS
// TODO: staggered TPs (tp1 at closer linewidth / dashed levels, tp2 and tp3 at thicker ones, all share same SL AND ts)
// TODO: if price jumps too much it will change the iLowest/Ihighest range and mess with the margin percentage (lines will become diff color)
// TODO: give Highest high and lowest low (even if current a +1 priority (atleast 1 linewidth)
// TODO: for trending markets, rate the smoothness & angle of the trend
// TODO: Possibly do the search and sweep from the last to current ( Bars -1) instead to prevent lines shifting)
// TODO: stop values from scanning (arrows scanning up and over a fractal, creating a double line when on top then removing the line)
// TODO: Rule to check where most of the volume of previous 200 period trades are... if theres a clear channel we are re-entering up into a supt line then we know 
// it is a high probability trade
=======
>>>>>>> 13fa96131f0c536357879ddc52a9fc545ac92550

// externs
extern bool CheckOncePerBar = true;
extern int barsToCheck = 200;
<<<<<<< HEAD
extern int fractalSensitivity = 15;
extern double clusterMarginPercentage = 0.1;
extern bool safemode = true;
// hides lesser important lines (clusters less than 2)
extern int safetyLevel = 2; 
// only needed if safemode = true, 1 = low but safe 5 is safest but extremely rare
=======
extern int fractalSensitivity = 5;
extern double clusterMarginPercentage = 0.02;
extern bool safemode = false; // hides lesser important lines (clusters less than 2)
>>>>>>> 13fa96131f0c536357879ddc52a9fc545ac92550

#include <stdlib.mqh>

// new bar vars
int BarShift;
bool NewBar;
datetime CurrentTimeStamp;

// management vars
double UsePoint;
//++++ These are adjusted for 5 digit brokers.
int     pips2points;    // slippage  3 pips    3=points    30=points
double  pips2dbl;       // Stoploss 15 pips    0.0015      0.00150
int     digitsPips;    // DoubleToStr(dbl/pips2dbl, Digitspips)

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
<<<<<<< HEAD

=======
//--- indicator buffers mapping
>>>>>>> 13fa96131f0c536357879ddc52a9fc545ac92550
   UsePoint = PipPoint(Symbol());
   
   // set digits for jpy etc
    if (Digits == 5 || Digits == 3){    // Adjust for five (5) digit brokers.
                pips2dbl    = Point*10; pips2points = 10;   digitsPips = 1;
    } else {    pips2dbl    = Point;    pips2points =  1;   digitsPips = 0; }
    
<<<<<<< HEAD
   //--- indicator buffers mapping
SetIndexBuffer(0, Buf_0);
SetIndexStyle (0, DRAW_LINE, STYLE_SOLID, 1);
   
SetIndexBuffer(1, Buf_1);
SetIndexStyle (1, DRAW_LINE, STYLE_SOLID, 1);
//   
//   SetIndexBuffer(2, Buf_2);
//   SetIndexStyle (2, DRAW_LINE, STYLE_SOLID, 1);
//   
//   SetIndexBuffer(3, Buf_3);
//   SetIndexStyle (3, DRAW_LINE, STYLE_SOLID, 1);
//   
//   SetIndexBuffer(4, Buf_4);
//   SetIndexStyle (4, DRAW_LINE, STYLE_SOLID, 1);
//   
//   SetIndexBuffer(5, Buf_5);
//   SetIndexStyle (5, DRAW_LINE, STYLE_SOLID, 1);
//   
//   SetIndexBuffer(6, Buf_6);
//   SetIndexStyle (6, DRAW_LINE, STYLE_SOLID, 1);
//   
//   SetIndexBuffer(7, Buf_7);
//   SetIndexStyle (7, DRAW_LINE, STYLE_SOLID, 1);
    
   Alert("Initialised");
   
=======
   Alert("Initialised");
//---
>>>>>>> 13fa96131f0c536357879ddc52a9fc545ac92550
   return(INIT_SUCCEEDED);
  }
  
  
int deinit() {
   Comment("De Init");
<<<<<<< HEAD
   ObjectsDeleteAll(0, 0, OBJ_HLINE);
=======
   ObjectsDeleteAll(0, 0, -1);
>>>>>>> 13fa96131f0c536357879ddc52a9fc545ac92550
   return(0);
}


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
    ObjectsDeleteAll(0, 0, OBJ_HLINE);
=======
    ObjectsDeleteAll(0, 0, -1);
>>>>>>> 13fa96131f0c536357879ddc52a9fc545ac92550
   
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
<<<<<<< HEAD
    // Alert("New Bar:", NewBar); 
      
    // get the current price range
    double allTimeHigh = iHigh(NULL, 0, iHighest(NULL, 0,MODE_HIGH, barsToCheck, 0) );
    double allTimeLow = iLow(NULL, 0, iLowest(NULL, 0, MODE_LOW, barsToCheck, 0) );
    double priceRange = allTimeHigh - allTimeLow;
    // Alert("priceRange: " + priceRange);
    
    // get 1% of range to use as the margin for s/r levels
    double priceClusterMargin = priceRange * clusterMarginPercentage;
    // Alert(clusterMarginPercentage * 100 + "% of range: " + priceRange * clusterMarginPercentage); // possibly make this smaller and set as ext
=======
    Alert("New Bar:", NewBar);
      
    // get the current price range
    double allTimeHigh = iHigh(NULL, 0, iHighest(NULL, 0, MODE_HIGH, Period(), 0) );
    double allTimeLow = iLow(NULL, 0, iLowest(NULL, 0, MODE_LOW, Period(), 0) );
    double priceRange = allTimeHigh - allTimeLow;
    Alert("priceRange: " + priceRange);
    
    // get 1% of range to use as the margin for s/r levels
    double priceClusterMargin = priceRange * clusterMarginPercentage;
    Alert(clusterMarginPercentage * 100 + "% of range: " + priceRange * clusterMarginPercentage); // possibly make this smaller and set as ext
>>>>>>> 13fa96131f0c536357879ddc52a9fc545ac92550
   
   int counted_bars = IndicatorCounted();
   int i = Bars - counted_bars - 1;           // Index of the first uncounted
   
<<<<<<< HEAD
   // simple 200 MA
   Alert("COUNTED BARS " + i);
   Buf_0[i] = 0.75115; // iMA(Symbol(),0 , 200, 0, MODE_SMA, PRICE_CLOSE, 0);
   Buf_1[i] = High[0];
   
=======
>>>>>>> 13fa96131f0c536357879ddc52a9fc545ac92550
   // get an arrow offset
   double TickValue = MarketInfo(Symbol(), MODE_TICKVALUE);
   double arrowOffset = TickValue * UsePoint;
   
 
<<<<<<< HEAD
   // add resistance lines ------------------------------------------>
   addResistanceLines(arrowOffset, priceClusterMargin, Yellow, Magenta, safetyLevel);
   
   // add support lines ------------------------------------------>
   addSupportLines(arrowOffset, priceClusterMargin, clrTurquoise, Magenta, safetyLevel);
=======
   // add resistance lines -------------------------------------------------->
   addResistanceLines(arrowOffset, priceClusterMargin);
   
   
   
       
>>>>>>> 13fa96131f0c536357879ddc52a9fc545ac92550
   
      return(1);
}
//+------------------------------------------------------------------+


// ------ FUNCTIONS ----------

void DrawArrowUp(string ArrowName,double LinePrice, datetime time, color LineColor)
{
<<<<<<< HEAD
   ObjectCreate(0, ArrowName, OBJ_ARROW, 0, time, LinePrice); //draw an up arrow
   ObjectSet(ArrowName, OBJPROP_STYLE, STYLE_SOLID);
   ObjectSet(ArrowName, OBJPROP_ARROWCODE, SYMBOL_ARROWUP);
   ObjectSet( ArrowName, OBJPROP_COLOR,LineColor);
=======
   ObjectCreate(ArrowName, OBJ_ARROW, 0, time, LinePrice); //draw an up arrow
   ObjectSet(ArrowName, OBJPROP_STYLE, STYLE_SOLID);
   ObjectSet(ArrowName, OBJPROP_ARROWCODE, SYMBOL_ARROWUP);
   ObjectSet(ArrowName, OBJPROP_COLOR,LineColor);
>>>>>>> 13fa96131f0c536357879ddc52a9fc545ac92550
}

void DrawArrowDown(string ArrowName,double LinePrice, datetime time, color LineColor)
{
<<<<<<< HEAD
   ObjectCreate(0, ArrowName, OBJ_ARROW, 0, time, LinePrice); //draw an up arrow
=======
   ObjectCreate(ArrowName, OBJ_ARROW, 0, time, LinePrice); //draw an up arrow
>>>>>>> 13fa96131f0c536357879ddc52a9fc545ac92550
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
<<<<<<< HEAD
//void multiDimDoubleArrayPush(double & array[] , double dataToPush){
//    int count = ArrayResize(array, ArraySize(array) + 1);
//    array[ArraySize(array) - 1] = dataToPush;
//}
=======
void multiDimDoubleArrayPush(double & array[] , double dataToPush){
    int count = ArrayResize(array, ArraySize(array) + 1);
    array[ArraySize(array) - 1] = dataToPush;
}
>>>>>>> 13fa96131f0c536357879ddc52a9fc545ac92550

void HLine(string name, double P0, color clr, int style, int lineThickness) {
#define WINDOW_MAIN 0
    if (ObjectMove( name, 0, Time[0], P0 )){}
<<<<<<< HEAD
    else if(!ObjectCreate( 0, name, OBJ_HLINE, WINDOW_MAIN, Time[0], P0 ))
=======
    else if(!ObjectCreate( name, OBJ_HLINE, WINDOW_MAIN, Time[0], P0 ))
>>>>>>> 13fa96131f0c536357879ddc52a9fc545ac92550
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

<<<<<<< HEAD
// ----------------------------------------------------------------------------------------> RESISTANCE LINES FUNCTION
void addResistanceLines(double arrowOffset, double priceClusterMargin, color resistanceColor, color signalColor, int safetyLevel) {
=======
// function to add resistance Lines
void addResistanceLines(double arrowOffset, double priceClusterMargin) {
>>>>>>> 13fa96131f0c536357879ddc52a9fc545ac92550
   int highestArray[];
   double highestPriceArray[];
   int iterationCount = 0;
   
   
  // Alert("barsToCheck: "+ barsToCheck + " Fractal Sensitivity: " + fractalSensitivity);
  
   for(int searchArea = 0; searchArea < barsToCheck; searchArea += StringToInteger(fractalSensitivity)) { // if loops arent finishing slow down backtester playback
   
      if (searchArea >= Bars) {
<<<<<<< HEAD
         // Alert("no more bars available for analysis");
=======
         Alert("no more bars available for analysis");
>>>>>>> 13fa96131f0c536357879ddc52a9fc545ac92550
         break;
      }
      
      // Alert("iteration: " + iterationCount +  " starting at bar " + (searchArea + 1) + " with area of " + fractalSensitivity + " and bars to check: " + barsToCheck + " bars avail: " + Bars);
      
<<<<<<< HEAD
      int highestBar = iHighest(Symbol(), 0, MODE_HIGH, StringToInteger(fractalSensitivity), StringToInteger(searchArea) + ( searchArea % fractalSensitivity)); // added the modulo to stop the Hlines refreshing each candle
      
      // Alert("highest bar: " + highestBar + " Bars: " + Bars);
      // filter to disregard highest bars that have higher bars either side (not a fractal)
      if (highestBar > 0) {
         if (highestBar != Bars && highestBar+1 != Bars && High[highestBar] < High[highestBar + 1] || High[highestBar] < High[highestBar -1]) {
            // Alert("False high fractal detected");
            highestBar = 0; // set to 0 so that it gets disregarded
         }
      }
=======
      int highestBar = iHighest(Symbol(), 0, MODE_HIGH, StringToInteger(fractalSensitivity), StringToInteger(searchArea));
>>>>>>> 13fa96131f0c536357879ddc52a9fc545ac92550
      
      if (highestBar == -1) { // error handling
      
         int errorCode = GetLastError();
         string errorDesc = ErrorDescription(errorCode);
         string errorAlert = StringConcatenate("Error: ", errorCode,": ", errorDesc);
         Alert(errorAlert);
         
      } else {
      
<<<<<<< HEAD
         // Alert("highest bar: " + highestBar + " searchArea: " + searchArea + " iterationCount: " + iterationCount, " bars to check: " + barsToCheck);
=======
         Alert("highest bar: " + highestBar + " searchArea: " + searchArea + " iterationCount: " + iterationCount, " bars to check: " + barsToCheck);
>>>>>>> 13fa96131f0c536357879ddc52a9fc545ac92550
         intArrayPush(highestArray, highestBar);
         
         if (highestBar > 0) {
            // draw the arrow
<<<<<<< HEAD
            DrawArrowDown("arrow_down_" + iterationCount, (High[highestBar] + arrowOffset), Time[highestBar], resistanceColor);
=======
            DrawArrowDown("arrow_down_" + iterationCount, (High[highestBar] + arrowOffset), Time[highestBar], Yellow);
>>>>>>> 13fa96131f0c536357879ddc52a9fc545ac92550
            // add the price to the highest price array 
           doubleArrayPush(highestPriceArray, High[highestBar]);
         }
         
      }
      iterationCount++;  
   }
   
   // -----------------------------------------------------------------------------> Part 2, clustering
   
   // go through price array and find values within X deviation of each other
   int countArray = ArraySize(highestPriceArray);
<<<<<<< HEAD
   // Alert("count array " + countArray);
=======
   Alert("count array " + countArray);
>>>>>>> 13fa96131f0c536357879ddc52a9fc545ac92550
   
   // cluster array for storing groups of prices
   double clusterMultiPriceArr[1][40];
   
   for (int i = 0; i < ArraySize(highestPriceArray); i++) {
      
      double priceToCheck = highestPriceArray[i];
<<<<<<< HEAD
      // Alert("HP: " + priceToCheck);
=======
      Alert("HP: " + priceToCheck);
>>>>>>> 13fa96131f0c536357879ddc52a9fc545ac92550
      
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
<<<<<<< HEAD
            // Alert("Cluster! test price: " +  priceToCheck + " compare price: " + singlePriceFromArr);
=======
            Alert("Cluster! test price: " +  priceToCheck + " compare price: " + singlePriceFromArr);
>>>>>>> 13fa96131f0c536357879ddc52a9fc545ac92550
            
            
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
<<<<<<< HEAD
         // Alert("cluster count for i:" + i + " - " + clusterCount);
         int lineWidth;
         if (clusterCount >= 1 && clusterCount < 3) lineWidth = 1;
         if (clusterCount >= 3 && clusterCount < 4) lineWidth = 2;
         if (clusterCount >= 4 && clusterCount < 5) lineWidth = 3;
         if (clusterCount >= 5 && clusterCount < 7) lineWidth = 4;
         if (clusterCount >= 7)                     lineWidth = 5;
         
         // HLine(name, priceToCheck, Yellow, STYLE_SOLID, lineWidth);
         if (safemode) {
            if (lineWidth >= safetyLevel) HLine(name, priceToCheck, signalColor, STYLE_SOLID, lineWidth); // todo: safety level
            
             // SetIndexStyle (1, DRAW_LINE, STYLE_SOLID, 1);
             //Buf_0[i] = priceToCheck;
             
         } else {
            HLine(name, priceToCheck, resistanceColor, STYLE_SOLID, lineWidth);
         }
      } else {
         // Alert("fractal but no cluster for i: " + i);
         if (!safemode) HLine(name, priceToCheck, resistanceColor, STYLE_DOT, 1);
      } 
   }
}


// --------------------------------------------------------> FUNCTION FOR SUPPORT LINES


// function to add resistance Lines
void addSupportLines(double arrowOffset, double priceClusterMargin, color suptColor, color signalColor, int safetyLevel) {
   int lowestArray[];
   double lowestPriceArray[];
   int iterationCount = 0;
   
  
   for(int searchArea = 0; searchArea < barsToCheck; searchArea += StringToInteger(fractalSensitivity)) { // if loops arent finishing slow down backtester playback
   
      if (searchArea >= Bars) {
        // Alert("no more bars available for analysis");
         break;
      }
      
      int lowestBar = iLowest(Symbol(), 0, MODE_LOW, StringToInteger(fractalSensitivity), StringToInteger(searchArea) + ( searchArea % fractalSensitivity)); // added modulo
      
      // filter to disregard lowest bars that have lower bars either side (not a fractal)
      if (lowestBar > 0) {
         if (lowestBar != Bars && lowestBar+1 != Bars && Low[lowestBar] > Low[lowestBar + 1] || Low[lowestBar] > Low[lowestBar -1]) {
            // Alert("False low fractal detected");
            lowestBar = 0; // set to 0 so that it gets disregarded
         }
      }
      
      if (lowestBar == -1) { // error handling
      
         int errorCode = GetLastError();
         string errorDesc = ErrorDescription(errorCode);
         string errorAlert = StringConcatenate("Error: ", errorCode,": ", errorDesc);
         Alert(errorAlert);
         
      } else {
      
         // Alert("lowest bar: " + lowestBar + " searchArea: " + searchArea + " iterationCount: " + iterationCount, " bars to check: " + barsToCheck);
         intArrayPush(lowestArray, lowestBar);
         
         if (lowestBar > 0) {
            // draw the arrow
            DrawArrowDown("arrow_down_supt" + iterationCount, (Low[lowestBar] + arrowOffset), Time[lowestBar], suptColor);
            // add the price to the highest price array 
           doubleArrayPush(lowestPriceArray, Low[lowestBar]);
         }
         
      }
      iterationCount++;  
   }
   
   // -----------------------------------------------------------------------------> Part 2, clustering
   
   // go through price array and find values within X deviation of each other
   int countArray = ArraySize(lowestPriceArray);
   // Alert("count array " + countArray);
   
   // cluster array for storing groups of prices
   double clusterMultiPriceArr[1][40];
   
   for (int i = 0; i < ArraySize(lowestPriceArray); i++) {
      
      double priceToCheck = lowestPriceArray[i];
      // Alert("LP: " + priceToCheck);
      
      // loop over the lowest price array again and compare each value to look for clusters
      int clusterCount = 0; // total clusters for this specific comparison iteration (outer loop)
      for (int j = 0; j < ArraySize(lowestPriceArray); j++) {
         
         double singlePriceFromArr = lowestPriceArray[j]; // store each comparison price in a variable
         double upperMargin = singlePriceFromArr + priceClusterMargin;
         double lowerMargin = singlePriceFromArr - priceClusterMargin;
         
         // check if we have any clusters
         if (priceToCheck >= lowerMargin && priceToCheck <= upperMargin && i != j) { // i != j ensures the price isnt checking against itself
            
            // we have a cluster
            clusterCount++;
            // Alert("Cluster! test price: " +  priceToCheck + " compare price: " + singlePriceFromArr);
            
            // push to cluster array
           ArrayResize(clusterMultiPriceArr, i + 1, i + 1); // resize multi dimensional array
           clusterMultiPriceArr[i][0] = priceToCheck;
           clusterMultiPriceArr[i][j+1] = singlePriceFromArr;
            
         } else {
         
            // no cluster but still a fractal, add to another array for single lines.
            ArrayResize(clusterMultiPriceArr, i + 1, i + 1); // resize multi dimensional array
            clusterMultiPriceArr[i][0] = priceToCheck;
         }
      }
      
      string name = "H_LINE_SUPT" + i;
      if (clusterCount > 0) {
         // Alert("cluster count for i:" + i + " - " + clusterCount);
=======
         Alert("cluster count for i:" + i + " - " + clusterCount);
>>>>>>> 13fa96131f0c536357879ddc52a9fc545ac92550
         int lineWidth;
         if (clusterCount >= 1 && clusterCount < 3) lineWidth = 1;
         if (clusterCount >= 3 && clusterCount < 4) lineWidth = 2;
         if (clusterCount >= 4 && clusterCount < 5) lineWidth = 3;
         if (clusterCount >= 5 && clusterCount < 7) lineWidth = 4;
         if (clusterCount >= 7)                     lineWidth = 5;
         
         // HLine(name, priceToCheck, Yellow, STYLE_SOLID, lineWidth);
         if (safemode) {
<<<<<<< HEAD
            if (lineWidth >= safetyLevel) HLine(name, priceToCheck, signalColor, STYLE_SOLID, lineWidth); // todo safety level
            
            // Buf_1[i] = priceToCheck;
            
         } else {
            HLine(name, priceToCheck, suptColor, STYLE_SOLID, lineWidth);
         }
      } else {
         // Alert("fractal but no cluster for i: " + i);
         if (!safemode) HLine(name, priceToCheck, suptColor, STYLE_DOT, 1);
      } 
   }
 }
=======
            if (lineWidth >= 2) HLine(name, priceToCheck, Yellow, STYLE_SOLID, lineWidth);
         } else {
            HLine(name, priceToCheck, Yellow, STYLE_SOLID, lineWidth);
         }
      } else {
         Alert("fractal but no cluster for i: " + i);
         if (!safemode) HLine(name, priceToCheck, Yellow, STYLE_DOT, 1);
      } 
   }
}
>>>>>>> 13fa96131f0c536357879ddc52a9fc545ac92550
