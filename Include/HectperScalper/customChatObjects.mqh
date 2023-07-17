//+------------------------------------------------------------------+
//|                                            customChatObjects.mqh |
//|                                   Copyright 2022, Ronald Hector. |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, Ronald Hector."
#property link      ""
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
int chartArrow(string charttype)
  {
   if(charttype == "High")
      return OBJ_ARROW_DOWN;
   return OBJ_ARROW_UP;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int chartArrowColor(string charttype)
  {
   if(charttype == "High")
      return clrRed;
   return clrBlue;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int chartFixedTrendingLineColor(string charttype)
  {
   if(charttype == "High")
      return clrRed;
   return clrBlue;
  }
//+------------------------------------------------------------------+
