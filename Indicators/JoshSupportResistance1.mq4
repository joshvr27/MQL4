//+------------------------------------------------------------------+
//|                                                ExportLevels2.mq4 |
//|                      Copyright © 2006, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2006, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_chart_window

extern int MaxLimit = 250;
extern int MaxCrossesLevel = 10;
extern double MaxR = 0.001;
extern color LineColor = White;
extern int LineWidth = 0;
extern int LineStyle = 0;
extern int TimePeriod = 0;

#property indicator_buffers 8;
#property indicator_color1 clrTurquoise;         // Color of the 1st line
#property indicator_color2 clrLimeGreen;               // Color of the 2nd line
#property indicator_color3 Red;             // Color of the 3rd line
#property indicator_color4 Yellow;            // Color of the 4th line
#property indicator_color5 Pink;              // Color of the 5th line
#property indicator_color6 Orange;            // Color of the 6th line
#property indicator_color7 White;             // Color of the 7th line

double sr1_array[], sr2_array[], sr3_array[] , sr4_array[] , sr5_array[] , sr6_array[] , sr7_array[] , sr8_array[]; // create global support and resistance array

color  Colors[] = { Red, Maroon, Sienna, OrangeRed, Yellow, Yellow, Yellow, Yellow, Yellow, Yellow, Yellow, Purple, Indigo,
                     DarkViolet, MediumBlue, DarkSlateGray};
int    Widths[] = {1,2,3,4,5,6,7,8,9};
string Alphabet[] = {"i","h","g","f","e","d","c","b","a"};

int CrossBarsNum[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
double prLow(int i)
{
  return (iLow(NULL,TimePeriod,i));
}
double prHigh(int i)
{
  return (iHigh(NULL,TimePeriod,i));
}

int PerioprHiInt(int TmPeriod)
{
  switch (TmPeriod)
  {
    case PERIOD_M1  : return(0);
    case PERIOD_M5  : return(1);
    case PERIOD_M15 : return(2);
    case PERIOD_M30 : return(3);
    case PERIOD_H1  : return(4);
    case PERIOD_H4  : return(5);
    case PERIOD_D1  : return(6);
    case PERIOD_W1  : return(7);
    case PERIOD_MN1 : return(8);
  }
  return (0);
}

string Period2AlpthabetString(int TmPeriod)
{
   return (Alphabet[PerioprHiInt(TmPeriod)]);
}

datetime TMaxI = 0;
//++++ These are adjusted for 5 digit brokers.
int     pips2points;    // slippage  3 pips    3=points    30=points
double  pips2dbl;       // Stoploss 15 pips    0.0015      0.00150
int     Digitspips;    // DoubleToStr(dbl/pips2dbl, Digitspips)
int     init()
   {
   
     SetIndexBuffer(0,sr1_array);         // Assigning an array to a buffer
     SetIndexStyle (0,DRAW_LINE,STYLE_SOLID,1);// Line style
     SetIndexBuffer(1,sr2_array);         // Assigning an array to a buffer
     SetIndexStyle (1,DRAW_LINE,STYLE_DOT,1);// Line style
     SetIndexBuffer(2,sr3_array);         // Assigning an array to a buffer
     SetIndexStyle (2,DRAW_LINE,STYLE_SOLID,1);// Line style
     SetIndexBuffer(3,sr4_array);         // Assigning an array to a buffer
     SetIndexStyle (3,DRAW_LINE,STYLE_SOLID,1);// Line style
     SetIndexBuffer(4,sr5_array);         // Assigning an array to a buffer
     SetIndexStyle (4,DRAW_LINE,STYLE_SOLID,1);// Line style
     SetIndexBuffer(5,sr6_array);         // Assigning an array to a buffer
     SetIndexStyle (5,DRAW_LINE,STYLE_SOLID,1);// Line style
     SetIndexBuffer(6,sr7_array);         // Assigning an array to a buffer
     SetIndexStyle (6,DRAW_LINE,STYLE_SOLID,1);// Line style
     SetIndexBuffer(7,sr8_array);         // Assigning an array to a buffer
     SetIndexStyle (7,DRAW_LINE,STYLE_SOLID,1);// Line style
      
    if (Digits == 5 || Digits == 3){    // Adjust for five (5) digit brokers.
                pips2dbl    = Point*10; pips2points = 10;   Digitspips = 1;
    } else {    pips2dbl    = Point;    pips2points =  1;   Digitspips = 0; }
    // OrderSend(... Slippage.Pips * pips2points, Bid - StopLossPips * pips2dbl

//---- indicators
    TMaxI = 0;
//----
   if (TimePeriod==0)
     TimePeriod=Period();

   if (TimePeriod!=0&&LineWidth==0)
     if (PerioprHiInt(TimePeriod)-PerioprHiInt(Period())>=0)
       LineWidth=Widths[PerioprHiInt(TimePeriod)-PerioprHiInt(Period())];
     else
       {
         LineWidth=0;
         if (LineStyle==0)
           LineStyle=STYLE_DASH;
       }
   if (TimePeriod!=0&&LineColor==White)
     LineColor=Colors[PerioprHiInt(TimePeriod)];


   return(0);
  }
  
  
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
    string name=Period2AlpthabetString(TimePeriod)+TimePeriod+"_";
    for(int obj=ObjectsTotal()-1; obj >= 0; obj--){
        string objectName = ObjectName(obj);
        if (StringFind(objectName, name) == 0)  ObjectDelete(objectName);
    }
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start(){
    if (Time[0] == TMaxI)   return;     TMaxI = Time[0];

    int counted_bars = IndicatorCounted();
    int i = Bars - counted_bars - 1;           // Index of the first uncounted
    int    limit = MathMin(Bars               ,MaxLimit);

    // Adjust array sizes
    double  prLo = prLow(Lowest(NULL,TimePeriod,MODE_LOW,limit,0));
    double  prHi = prHigh(Highest(NULL,TimePeriod,MODE_HIGH,limit,0));
    int     pipLo   = prLo / pips2dbl;
    int     pipHi   = prHi / pips2dbl;
    int     pipLoArr= pipLo - 1;    // include the hi/lo
    int     pipHiArr= pipHi + 1;    // as support & resistance.
    int     range   = pipHiArr-pipLoArr+1;
    ArrayResize(CrossBarsNum, range);
    for (int index=0; index<range; index++) CrossBarsNum[index]=0;

    for (int shift=limit-1; shift>0; shift--){
        prLo = prLow(shift);        pipLo = prLo / pips2dbl -pipLoArr;
        prHi = prHigh(shift);       pipHi = prHi / pips2dbl -pipLoArr;
        while (pipLo <= pipHi){     CrossBarsNum[pipLo]++; pipLo++; }
    }

    deinit();   // Remove existing objects
    int MaxL=MaxR / pips2dbl;
    int count = 0;
    // Alert("starting single iteration loop");
    for (pipLo=0; pipLo < range; pipLo++){
        // Find local low
        int to   = pipLo  + MaxL; if (to   >= range)   to  = range-1;
        int size = to - pipLo + 1;
        pipLo = LocalExtreme(size, pipLo, -1);
        double d = (pipLo + pipLoArr) * pips2dbl;
        
        
        // my custom stuff
        
        // if (count == 0) sr1_array[i] = d;
        
       // if (count == 0) sr1_array[i] = d; // if we have 1st s/r, set it to buffer 0..
       // if (count == 1) sr2_array[i] = d; // if we have a second s/r level, set it to buffer 1..
       // if (count == 2) sr3_array[i] = d;
       // if (count == 3) sr4_array[i] = d;
       // if (count == 4) sr5_array[i] = d;
       // if (count == 5) sr6_array[i] = d;
       // if (count == 6) sr7_array[i] = d;
       // if (count == 7) sr8_array[i] = d;
        
        // Alert("count: " + count + " pipLo: " + pipLo + " d: " + d);
        count++;
        
        
        string name=Period2AlpthabetString(TimePeriod)+TimePeriod+"_"+PriceToStr(d);
        // string name="obj_"+i;
         // HLine(name,d,LineColor);
         // ObjectsDeleteAll(0, 0, OBJ_TREND); 
         TLine(name, d, LineColor);
         
         ObjectSet(name,OBJPROP_WIDTH,LineWidth);
         ObjectSet(name,OBJPROP_STYLE,LineStyle);

        // Find next local high
        pipLo++;
        to   = pipLo  + MaxL; if (to   >= range)   to  = range-1;
        size = to - pipLo + 1;
        if (size > 0){  
            pipLo = LocalExtreme(size, pipLo, +1);
        }
    }
    
  // for (int i = 0; i < ArraySize(sr_array); i++ ) {
  //  Alert("array index: " + i + " - value: " + sr_array[i]);
  // }
    
   return(0);
  }
int     LocalExtreme(int WS, int LEbar, int d){
int count=0;
    while(true){
        int LEbarPrev = LEbar;      LEbar = MaximalBar(WS, LEbarPrev, d);
        if (LEbar == LEbarPrev)     return(LEbar);
    }
    //NOTREACHED
}
int     MaximalBar(int length, int start, int d){
    int range = ArraySize(CrossBarsNum);
    if (start+length > range)   length = range - start;
    int maxC=-d*MaxLimit;
    for (int limit = start+length; start < limit; start++){
        if ( (CrossBarsNum[start]-maxC)*d >= 0){
            int maxB=start;     maxC=CrossBarsNum[maxB];
        }
    }
    return(maxB);
}

void HLine(string name, double P0, color clr){          #define WINDOW_MAIN 0
    /**/ if (ObjectMove( name, 0, Time[0], P0 )){}
    else if(!ObjectCreate( name, OBJ_HLINE, WINDOW_MAIN, Time[0], P0 ))
        Alert("ObjectCreate(",name,",HLINE) failed: ", GetLastError() );
    if (!ObjectSet(name, OBJPROP_COLOR, clr )) // Allow color change
        Alert("ObjectSet(", name, ",Color) [1] failed: ", GetLastError() );
    if (!ObjectSetText(name, PriceToStr(P0), 10))
        Alert("ObjectSetText(",name,") [1] failed: ", GetLastError());
}

void TLine(string name, double P0, color clr){          #define WINDOW_MAIN 0
    /**/ if (ObjectMove( name, 0, Time[0], P0 )){
    ObjectDelete(0, name);
    }
    else if(!ObjectCreate( name, OBJ_TREND, WINDOW_MAIN, Time[0], P0, Time[10], P0 ))
        Alert("ObjectCreate(",name,",HLINE) failed: ", GetLastError() );
    if (!ObjectSet(name, OBJPROP_COLOR, clr )) // Allow color change
        Alert("ObjectSet(", name, ",Color) [1] failed: ", GetLastError() );
    if (!ObjectSetText(name, PriceToStr(P0), 10))
        Alert("ObjectSetText(",name,") [1] failed: ", GetLastError());
}



string  PriceToStr(double p){
    string pFrc = DoubleToStr(p, Digits);       if(Digitspips==0) return(pFrc);
    string pPip = DoubleToStr(p, Digits-1);
    if (pPip+"0" == pFrc)       return(pPip);           return(pFrc);          }
//+------------------------------------------------------------------+

// Helper function to "push" to array
void arrayPush(double & array[] , double dataToPush){
    int count = ArrayResize(array, ArraySize(array) + 1);
    array[ArraySize(array) - 1] = dataToPush;
}