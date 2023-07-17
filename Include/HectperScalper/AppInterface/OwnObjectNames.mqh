//+------------------------------------------------------------------+
//|                                               OwnObjectNames.mqh |
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

//Names of future interface objects
string OwnObjectNames[] =
  {
   "template-BorderPanel",//RectLabel
   "template-MainPanel",//RectLabel
   "template-Name",//Label
   "template-Symbols",//Label ** new element
   "template-Balance",//Label
   "template-Equity",//Label
   "template-Profit",//Label
   "template-Broker",//Label
   "template-Leverage",//Label
   "template-BuyPositions",//Label
   "template-SellPositions",//Label
   "template-CurrentUnitsBuy",//Label
   "template-CurrentUnitsSell",//Label
   "template-UNSIGNED1",//UNSIGNED1
   "template-UNSIGNED2",//UNSIGNED2
   "template-UNSIGNED3",//UNSIGNED3
   "template-CloseOwn",//Button
   "template-CloseAll",//Button
   "template-Line-Divider1",//RectLabel separator 1
   "template-Line-Divider2",//RectLabel separator 2
   "template-Line-Divider3",//RectLabel separator 3
   "template-Line-Divider4"//RectLabel separator 4
  };
