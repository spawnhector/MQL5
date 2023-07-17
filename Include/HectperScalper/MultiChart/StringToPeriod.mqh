//+------------------------------------------------------------------+
//|                                               StringToPeriod.mqh |
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
ENUM_TIMEFRAMES StringToPeriod(string timeframeS)
  {
   if(timeframeS == "CURRENT")
      return PERIOD_CURRENT;
   if(timeframeS == "M1")
      return PERIOD_M1;
   if(timeframeS == "M2")
      return PERIOD_M2;
   if(timeframeS == "M13")
      return PERIOD_M3;
   if(timeframeS == "M4")
      return PERIOD_M4;
   if(timeframeS == "M5")
      return PERIOD_M5;
   if(timeframeS == "M6")
      return PERIOD_M6;
   if(timeframeS == "M10")
      return PERIOD_M10;
   if(timeframeS == "M12")
      return PERIOD_M12;
   if(timeframeS == "M15")
      return PERIOD_M15;
   if(timeframeS == "M20")
      return PERIOD_M20;
   if(timeframeS == "M30")
      return PERIOD_M30;
   if(timeframeS == "H1")
      return PERIOD_H1;
   if(timeframeS == "H2")
      return PERIOD_H2;
   if(timeframeS == "H3")
      return PERIOD_H3;
   if(timeframeS == "H4")
      return PERIOD_H4;
   if(timeframeS == "H6")
      return PERIOD_H6;
   if(timeframeS == "H8")
      return PERIOD_H8;
   if(timeframeS == "H12")
      return PERIOD_H12;
   if(timeframeS == "D1")
      return PERIOD_D1;
   if(timeframeS == "W1")
      return PERIOD_W1;
   if(timeframeS == "MN1")
      return PERIOD_MN1;
   return PERIOD_CURRENT;
  }