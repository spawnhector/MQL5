//+------------------------------------------------------------------+
//|                                                        chart.mqh |
//|                                                    ronald Hector |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "ronald Hector"
#property link      "https://www.mql5.com"
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Chart
  {
public:
   datetime          TimeI[];
   double            CloseI[];
   double            OpenI[];
   double            HighI[];
   double            LowI[];
   double            ChartPoint;//size of the point of the current chart
   double            ChartAsk;//chart Ask
   double            ChartBid;//chart Bid

   datetime          tTimeI[];//auxiliary array to control the emergence of a new bar

   static int        TCN;//tcn

   string            CurrentSymbol;//adjusted symbol
   ENUM_TIMEFRAMES   Timeframe;//chart period
   int               copied;//amount of data copied
   int               lastcopied;//last amount of data copied
   datetime          LastCloseTime;//last bar time
   MqlTick           LastTick;

                     Chart()
     {
      ArrayResize(tTimeI,2);
     }

   void              ChartTick()//chart tick
     {
      SymbolInfoTick(CurrentSymbol,LastTick);
      ArraySetAsSeries(tTimeI,false);
      copied=CopyTime(CurrentSymbol,Timeframe,0,2,tTimeI);
      ArraySetAsSeries(tTimeI,true);
      if(copied == 2 && tTimeI[1] > LastCloseTime)
        {
         ArraySetAsSeries(CloseI,false);
         ArraySetAsSeries(OpenI,false);
         ArraySetAsSeries(HighI,false);
         ArraySetAsSeries(LowI,false);
         ArraySetAsSeries(TimeI,false);
         lastcopied=CopyClose(CurrentSymbol,Timeframe,0,Chart::TCN+2,CloseI);
         lastcopied=CopyOpen(CurrentSymbol,Timeframe,0,Chart::TCN+2,OpenI);
         lastcopied=CopyHigh(CurrentSymbol,Timeframe,0,Chart::TCN+2,HighI);
         lastcopied=CopyLow(CurrentSymbol,Timeframe,0,Chart::TCN+2,LowI);
         lastcopied=CopyTime(CurrentSymbol,Timeframe,0,Chart::TCN+2,TimeI);
         ArraySetAsSeries(CloseI,true);
         ArraySetAsSeries(OpenI,true);
         ArraySetAsSeries(HighI,true);
         ArraySetAsSeries(LowI,true);
         ArraySetAsSeries(TimeI,true);
         LastCloseTime=tTimeI[1];
        }
      ChartBid=LastTick.bid;
      ChartAsk=LastTick.ask;
      ChartPoint=SymbolInfoDouble(CurrentSymbol,SYMBOL_POINT);
     }
  };