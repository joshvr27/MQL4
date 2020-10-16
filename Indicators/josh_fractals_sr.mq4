//+------------------------------------------------------------------+
//|                                             josh_fractals_sr.mq4 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property script_show_inputs

extern bool CheckOncePerBar = true;
extern int barsToCheck = 200;

int BarShift;
bool NewBar;
datetime CurrentTimeStamp;
extern int fractalSensitivity = 5;

double UsePoint;


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   UsePoint = PipPoint(Symbol());
//---
   return(INIT_SUCCEEDED);
  }
  
int deinit() {
   Comment("De Init");
   ObjectsDeleteAll(0, 0, -1);
   return(0);
}
  
int OnStart() {

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
     
     if (NewBar != true) return(1);
     
   
   int counted_bars = IndicatorCounted();
   int i = Bars - counted_bars - 1;           // Index of the first uncounted
  //  Alert("start!, counted bars: " +  counted_bars + " i: " + i + " Period: " + Period() );
   // Comment("\n close price: " + Close[i]);
   
   // get an arrow offset
       double TickValue = MarketInfo(Symbol(),MODE_TICKVALUE);
       double arrowOffset = TickValue * UsePoint * 10;
   
   // loop through last x amount of bars and get fractals
   
   /* 
  for (int i = fractalSensitivity -1; i < barsToCheck; i++) { // TODO: int i needs to be offset from the fractal sensitivity
   
        Alert("index: " + i);   
        
   
       // if high is the highest out of the two either side, its a high fractal (make this dynamic)
       //if (High[i] > High[i +1] && High[i] > High[i +2] && High[i] > High[i -1] && High[i] > High[i -2]) {
       //  Comment("\n \n Fractal: High price of " + High[i] + " at " + Time[i]);
       //  DrawArrowDown("arrow_down_"+i, (High[i] + arrowOffset), Time[i], Yellow);
       // }
       
       // TEST sensitivity count (sCount)
       int failArray[];
       ArrayResize(failArray, fractalSensitivity); // create array of same length as fractal sensitivity
       ArrayFill(failArray, 0, fractalSensitivity, 0); // fill array with false values
       ArrayInitialize(failArray, 0);
           
       for (int sCount = 0; sCount < fractalSensitivity; sCount++) {
         if (High[i] > High[i + sCount] && High[i] > High[i - sCount]) {
            Alert("sCount ", sCount);
            // Alert("Fractal: High price of " + High[i] + " at " + Time[i]);
            Comment("\n \n Fractal: High price of " + High[i] + " at " + Time[i]);
         }
          else {    
          // set fail flag
          failArray[sCount] = 1;
         }
       }
       
      int didFail = countOccurrences(1, failArray);
      
      // Alert("i: " + i + " didFail: " + didFail);
      
      if (didFail > 0) {
          // do nothing, 
       } else {
          // Alert("DID NOT FAIL");
          // if all steps of the step function passed, draw the arrow
         DrawArrowDown("arrow_down_" + i, (High[i] + arrowOffset), Time[i], Yellow);
       }
        
      
       // do same again for lows (Minima)
   }
   
   */
   int highestArray[];
   int count = 0;
   for (int i = 0; i < barsToCheck; i + fractalSensitivity) {
      int highestBar = iHighest(Symbol(), 0, MODE_HIGH, fractalSensitivity, i + 1);
      Alert("highest bar: " + highestBar + " i: " + i + " count: " + count, " bars to check: " + barsToCheck);
      // highestArray[count] = highestBar;
      // DrawArrowDown("arrow_down_" + count, (High[highestBar] + arrowOffset), Time[highestBar], Yellow);
      count++;
   }
   
    // DrawArrowDown("arrow_down_" + i, (High[i] + arrowOffset), Time[i], Yellow);
    
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
//---
   
   Alert("calc");
   
//--- return value of prev_calculated for next call
   return(0);
  }
//+------------------------------------------------------------------+


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
   return cnt;
}