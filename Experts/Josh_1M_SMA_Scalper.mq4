// Preprocessor #property copyright "Josh Van Riel"
#include <EAP_common_functions.mqh>

// External variables
extern bool DynamicLotSize = true;
extern double EquityPercent = 2;
extern double FixedLotSize = 0.1;
extern double StopLoss = 20;
extern double TakeProfit = 10;
extern int TrailingStop = 20;
extern int MinimumProfit = 10;
extern int Slippage = 5;
extern int MagicNumber = 74839265;
extern int FastMAPeriod = 50;
extern int MedMAPeriod = 100;
extern int SlowMAPeriod = 200;
extern bool CheckOncePerBar = true;

// TODO: shutdown if drawdown exceeds 30/35%

// Global variables
int BuyTicket;
int SellTicket;

double UsePoint;
int UseSlippage;

datetime CurrentTimeStamp;

// Init function
int init()
  {
   UsePoint = PipPoint(Symbol());
   UseSlippage = GetSlippage(Symbol(),Slippage);
  }


// Start function
int start()
  {
// Execute on bar open
   if(CheckOncePerBar == true)
     {
      int BarShift = 1;
      if(CurrentTimeStamp != Time[0])
        {
         CurrentTimeStamp = Time[0];
         bool NewBar = true;
        }
      else
         NewBar = false;
     }
   else
     {
      NewBar = true;
      BarShift = 0;
     }

// Price
   double lastClose = iClose(Symbol(),0 , BarShift + 1);

// Moving averages
   double FastMA = iMA(NULL,0,FastMAPeriod,0,0,0,BarShift);
   double MedMA = iMA(NULL,0,MedMAPeriod,0,0,0,BarShift);
   double SlowMA = iMA(NULL,0,SlowMAPeriod,0,0,0,BarShift);
   double LastFastMA = iMA(NULL,0,FastMAPeriod,0,0,0,BarShift+1);
   double LastMedMA = iMA(NULL,0,MedMAPeriod,0,0,0,BarShift+1);
   double LastSlowMA = iMA(NULL,0,SlowMAPeriod,0,0,0,BarShift+1);

// Calculate lot size
   double LotSize = CalcLotSize(DynamicLotSize,EquityPercent,StopLoss,FixedLotSize);
   LotSize = VerifyLotSize(LotSize);

// Begin trade block
   if(NewBar == true)
     {
      // Buy order
     // if(FastMA > SlowMA && LastFastMA <= LastSlowMA && BuyMarketCount(Symbol(),MagicNumber) == 0)
     if(lastClose > LastFastMA && LastFastMA > LastMedMA && LastMedMA > LastSlowMA && BuyMarketCount(Symbol(),MagicNumber) == 0)
        {
         // Close sell orders
         if(SellMarketCount(Symbol(),MagicNumber) > 0)
           {
            CloseAllSellOrders(Symbol(),MagicNumber,Slippage);
           }

         // Open buy order
         BuyTicket = OpenBuyOrder(Symbol(),LotSize,UseSlippage,MagicNumber);

         // Order modification
         if(BuyTicket > 0 && (StopLoss > 0 || TakeProfit > 0))
           {
            OrderSelect(BuyTicket,SELECT_BY_TICKET);
            double OpenPrice = OrderOpenPrice();
            
            // TODO: calculate lowest low in last x bars with iLowest, if that is less than stoploss price then use that.

            // Calculate and verify stop loss and take profit
            double BuyStopLoss = CalcBuyStopLoss(Symbol(),StopLoss,OpenPrice);
            if(BuyStopLoss > 0)
               BuyStopLoss = AdjustBelowStopLevel(Symbol(), BuyStopLoss,5);

            double BuyTakeProfit = CalcBuyTakeProfit(Symbol(),TakeProfit, OpenPrice);
            if(BuyTakeProfit > 0)
               BuyTakeProfit = AdjustAboveStopLevel(Symbol(), BuyTakeProfit,5);

            // Add stop loss and take profit
            AddStopProfit(BuyTicket,BuyStopLoss,BuyTakeProfit);
           }
        }
      // Sell Order
     // if(FastMA < SlowMA && LastFastMA >= LastSlowMA && SellMarketCount(Symbol(),MagicNumber) == 0)
      if (lastClose < LastFastMA && LastFastMA < LastMedMA && LastMedMA < LastSlowMA && SellMarketCount(Symbol(),MagicNumber) == 0)
        {
         if(BuyMarketCount(Symbol(),MagicNumber) > 0)
           {
            CloseAllBuyOrders(Symbol(),MagicNumber,Slippage);
           }
         SellTicket = OpenSellOrder(Symbol(),LotSize,UseSlippage,MagicNumber);

         if(SellTicket > 0 && (StopLoss > 0 || TakeProfit > 0))
           {
            OrderSelect(SellTicket,SELECT_BY_TICKET);
            OpenPrice = OrderOpenPrice();
            double SellStopLoss = CalcSellStopLoss(Symbol(),StopLoss,OpenPrice);
            if(SellStopLoss > 0)
               SellStopLoss = AdjustAboveStopLevel(Symbol(), SellStopLoss,5);
            double SellTakeProfit = CalcSellTakeProfit(Symbol(),TakeProfit, OpenPrice);

            if(SellTakeProfit > 0)
               SellTakeProfit = AdjustBelowStopLevel(Symbol(), SellTakeProfit,5);
            AddStopProfit(SellTicket,SellStopLoss,SellTakeProfit);
           }
        }
     }
// End trade block

// Adjust trailing stops
   if(BuyMarketCount(Symbol(),MagicNumber) > 0 && TrailingStop > 0)
     {
      BuyTrailingStop(Symbol(),TrailingStop,MinimumProfit,MagicNumber);
     }

   if(SellMarketCount(Symbol(),MagicNumber) > 0 && TrailingStop > 0)
     {
      SellTrailingStop(Symbol(),TrailingStop,MinimumProfit,MagicNumber);
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   return(0);
  }
//+------------------------------------------------------------------+
