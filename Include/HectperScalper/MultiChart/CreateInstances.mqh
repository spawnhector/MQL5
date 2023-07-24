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
  if (Signals)
    for (int i = 0; i < ArraySize(Signals.providers); i++)
    {
      addSignalTrader(Signals.providers[i].GetTrader());
    };
    
  for (int i = 0; i < ArraySize(S); i++)
  {
    for (int j = 0; j < ArraySize(Charts); j++)
    {
      if (Charts[j].CurrentSymbol == S[i])
      {
        Bots[i] = new BotInstance(i, j);
        break;
      }
    }
  }
}

void addSignalTrader(__Trader &_signaltrader)
{
  ArrayResize(BotSignals, ArraySize(BotSignals) + 1);
  BotSignals[ArraySize(BotSignals) - 1] = &_signaltrader;
}