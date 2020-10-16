//+------------------------------------------------------------------+
//|                                              WIP_JOSH_S&R_EA.mq4 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

extern int MaxLimit = 250;
extern int MaxCrossesLevel = 10;
extern double MaxR = 0.001;
extern color LineColor = White;
extern int LineWidth = 0;
extern int LineStyle = 0;
extern int TimePeriod = 0;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---

   
   double indicator = iCustom(NULL, 0, "JoshSupportResistance1", MaxLimit, MaxCrossesLevel, MaxR, LineColor, LineWidth, LineStyle, TimePeriod, 1, 0);
   Alert(indicator);
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
   
  }
//+------------------------------------------------------------------+
