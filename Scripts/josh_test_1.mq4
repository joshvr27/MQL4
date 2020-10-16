//+------------------------------------------------------------------+
//|                                                  josh_test_1.mq4 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property show_inputs
#include <CustomFunctions01.mqh>


//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   // Alert(GetPipValue());
   // DayOfWeekAlert();
   Alert(GetPipValue());
   Print("Acc Equity is: " + AccountEquity());
   Print("stop loss price: " + GetStopLossPrice(true, 1.18236, 36)); // bad - uses hardcoded 4 digits
   Print("calculate stop loss: " + CalculateStopLoss(true, 1.18236, 36));
   Print("calculate take profit: " + CalculateTakeProfit(true, 1.1836, 14));
   // Print("optimal lot size: " + OptimalLotSize(0.02, 1.18236, 1.18230));
   
  }
//+------------------------------------------------------------------+
