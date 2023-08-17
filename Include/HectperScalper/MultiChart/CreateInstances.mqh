//+------------------------------------------------------------------+
//|                                              CreateInstances.mqh |
//|                                                    ronald Hector |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "ronald Hector"
#property link "https://www.mql5.com"
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

void CreateInstances() // attach all virtual robots to charts
{

  ArrayResize(_SDCS, ArraySize(Charts));
  for (int j = 0; j < ArraySize(Charts); j++)
  {
    int _index = __chartSymbol.symbolIndex(Charts[j].CurrentSymbol);
    if (_index != -1)
    {
      _SDCS[_index] = new SDCS();
      ArrayResize(_SDCS[_index].DCS, ArraySize(_PROVIDERS));
      for (int i = 0; i < ArraySize(_PROVIDERS); i++)
      {
          BI = new BotInstance(i, _index);

          ArrayResize(Bots, ArraySize(Bots) + 1);
          Bots[ArraySize(Bots) - 1] = BI;
      }
    }
  }
};
