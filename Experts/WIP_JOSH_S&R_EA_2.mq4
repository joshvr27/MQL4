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
      if (Ask > upperPriceArray[i] - (priceClusterMargin / 2) && Ask <= upperPriceArray[i]) {
         // price is within X percent of upper
         
         // filter to remove false positives if theres a lower within close proximity as well (should only be indicator arrows on outermost signal cluster lines now)
         if (ArraySize(lowerPriceArray) > 0 && Ask < lowerPriceArray[0] + priceClusterMargin) {
            Alert("we are inbetween an upper and lower that are close together");
            break;
         }
         
         Alert("Price Near Upper!");
         // Alert(" prev: " +  Close[1] + "current: " + Close[0]);
         
            
        // get 200, 100 & 50 MAs
         
       /// IF PRICE BELOW ALL MAs and they are in order from large (top) to small (bottom), 
         // LOOK FOR SHORT ENTRIES, PRICE IS BREAKING SUPPORT & MOVING DOWN
         // OUT & DOWN - price could continue to trend down, look for strong signs of continuation (may involve retest)
         // IN AND UP - Price could break through and range up  ########-------------> let lower rules handle this when it moves above the resistance and it becomes support
         
       /// ELSE   
         // IF PRICE ABOVE MAS & MAS ARE ALIGNED LARGEST (BOTTOM) TO SMALLEST (TOP)
         // LOOK FOR ENTRIES...
         // OUT & UP - Price could trend upwards and through #########-------------> let the lower rule catch it once it breaks resistance (entry candles will help filter, possible retest of resistance as it turns support moving upwards)
         // IN AND DOWN - price reverse off resistance and range down, look for a reversal just occurring and SHORT ENTRY

         //// (ignore?) CHECK DEVIATION OF 200MA/500MA, IF ITS GENTLE PRICE IS LIKEY TO STAY RANGING RATHER THAN GO DOWN

      }      
   }
   
   // --------------- LOWER CHECKS
   // check if any of the lines are on or close to the LOWER price
   for (int i = 0; i <= ArraySize(lowerPriceArray) -1; i++) {
         // is price at lower band?
      if (Ask < lowerPriceArray[i] + (priceClusterMargin / 2) && Ask >= lowerPriceArray[i]) {
         // price is within X percent of lower
         
         // filter to remove false positives if theres a upper within close proximity as well
         if (ArraySize(upperPriceArray) > 0 && Ask < upperPriceArray[0] - priceClusterMargin) {
            Alert("we are inbetween a lower  and upper that are close together");
            break;
         }
         
         
         Alert("Price Near Lower!");
                 
        // get 200, 100 & 50 MAs
         
       /// IF PRICE BELOW ALL MAs and they are in order from large (top) to small (bottom), 
         // LOOK FOR SHORT ENTRIES, PRICE IS BREAKING SUPPORT & MOVING DOWN
         // OUT & DOWN - ########-------------> let higher rules handle this, price has ranged down to support and will likely go through it and become resistance on downtrend (possible retest)
         // IN AND UP - could either be in a range and about to bounce back up, or retest) 
         
       /// ELSE   
         // IF PRICE ABOVE MAS & MAS ARE ALIGNED LARGEST (BOTTOM) TO SMALLEST (TOP)
         // LOOK FOR ENTRIES...
         // OUT & UP - Price could trend upwards. it may have just recently broken previous range/resistance and turned into support to continue up
         // IN AND DOWN - #########-------------> let higher rules handle this, price may be about to brea this support on downtrend and will carry on down into next range

         //// (ignore?) CHECK DEVIATION OF 200MA/500MA, IF ITS GENTLE PRICE IS LIKEY TO STAY RANGING RATHER THAN GO DOWN

      
     }
     
   
   // TODO: one trade at a time?
   
   // TODO -- REFINE ENTRY!! - too many false positives, double the cluster percentage margin check 
   // and looks for longer term entry candlestick patterns that alsign with trend/MA
   
   // use 100 & 200 ema to decide whether to bounce between lines or to move with trend
   
   // get 200 & 100 MA sent from custom indicator
   
   // add in a highest high and lowest low line as a significant HLINE in indicator
   
   // TODO: if it is, set a flag to wait for entry
   
   // select the SL & TP lines (make sure they have correct ratio,
   // if ratio or gap compared to volatility is bad, choose the next line up for TP & SL
   
   // add in trailing stop
   
   


 }
 
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
      // Alert("pushed into upper array" + upperPriceArray[0]);
      
     } else {
      // push into lower price array
      doubleArrayPush(lowerPriceArray, price);
      // Alert("pushed into lower array" + lowerPriceArray[0]);
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
         // Alert("upper price array: i" + i + " price: " + upperPriceArray[i]);
      }
   }
   
   if (ArraySize(lowerPriceArray) > 0) {
      // sort price arrays into numerical order
      ArraySort(lowerPriceArray, WHOLE_ARRAY, 0, MODE_DESCEND);
      for (int i = 0; i <= ArraySize(lowerPriceArray) -1; i++){
         // Alert("lower price array: i" + i + " price: " + lowerPriceArray[i]);
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
//
//void detectBearishEngulfingCandle(){
//
//   if(Close [1 + BarShift] < Open[1 + BarShift]
//      && Close[0 + BarShift] > Open[0 + BarShift] 
//      && Open[0 + BarShift] <= Close[1 + BarShift] 
//      && Close[0 + BarShift] > Open[1 + BarShift] ) {
//         Print (Close[0 + BarShift], " Bearish Engulfing Candle at " + Close[0 + BarShift]);
//    }
//    
// }
// 
// void detectBullishEngulfingCandle(){
// 
//   if(Close [1 + BarShift] > Open[1 + BarShift]
//      && Close[0 + BarShift] < Open[0 + BarShift] 
//      && Open[0 + BarShift] >= Close[1 + BarShift] 
//      && Close[0 + BarShift] < Open[1 + BarShift] ) {
//         Print (Close[0 + BarShift], " Bullish Engulfing Candle at " + Close[0 + BarShift]);
//    }
//    
// }

