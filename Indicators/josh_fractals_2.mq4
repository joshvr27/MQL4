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

// externs
extern bool CheckOncePerBar = true;
extern int barsToCheck = 200;
extern int fractalSensitivity = 5;

// new bar vars
int BarShift;
bool NewBar;
datetime CurrentTimeStamp;

// management vars
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
   
//--- return value of prev_calculated for next call
   return(rates_total);
  }
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
   return cnt;