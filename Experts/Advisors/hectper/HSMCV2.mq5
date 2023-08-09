
#include <Trade\PositionInfo.mqh>
#include <Trade\Trade.mqh>
CPositionInfo m_position; // trade position object
CTrade m_trade;           // trading object

#include "includes/V2/init.mqh";

// int Chart::TCN = 0;
// Chart *Charts[];
// BotInstance *Bots[];
// SignalProvider *Signals;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
//   if (TerminalInfoInteger(TERMINAL_TRADE_ALLOWED) == 0)
//   {
//     Print("Automated trading is currently disabled. Please enable automated trading to use this Expert Advisor.");
//     return INIT_FAILED;
//   }

//   if (isTestAccount)
//   {
//     addToArray(selectedProviders, 1);
//     strat_trade = true;
//     startButtonClicked = true;
//   }

//   if (enableServer)
//   {
//     if (ConnectServer())
//       return INIT_SUCCEEDED;
//     return INIT_FAILED;
//   }

//   Signals = new SignalProvider();
//   CreateCharts();
//   CreateInstances();
//   if (bInterfaceE)
//     CreateSimpleInterface();
  return (INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
//   DeleteSimpleInterface();
//   if (Signals)
//     Signals.removeProviders();
//   delete Signals; 

//   for (int j = 0; j < ArraySize(Charts); j++)
//     delete Charts[j];
//   for (int j = 0; j < ArraySize(Bots); j++)
//     delete Bots[j]; 

//   EventKillTimer();
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
//   AllChartsTick();
//   AllBotsTick();
//   if (bInterfaceE)
//     UpdateStatus();
}

void OnTimer()
{
//   if (TerminalInfoInteger(TERMINAL_TRADE_ALLOWED) == 0)
//   {
//     Print("Automated trading is currently disabled. Please enable automated trading to use this Expert Advisor.");
//     EventKillTimer();
//     return;
//   }
//   EventChartCustom(0, Ev_RollingTo, user01, 0.0, "");

//   if (enableServer)
//   {
//     Print("waiting on curreny settings");
//     // check if data is available to read
//     if (SocketIsReadable(socket2))
//     {
//       // data is available to read
//       string settings = socketreceive(socket2, 10);
//       if (settings != "")
//       {
//         Print(settings);
//         signalChannelOpen = true;
//         EventKillTimer();
//         return;
//       }
//     }
//   }
}

// bool bInterfaceE = true; // Interface
// void OnChartEvent(const int id,
//                   const long &lparam,
//                   const double &dparam,
//                   const string &sparam)
// {

//   if (id == CHARTEVENT_OBJECT_CLICK)
//   {
//     ButtonsCheck(sparam);
//   }
//   if (Signals)
//     for (int i = 0; i < ArraySize(_PROVIDERS); i++)
//     {
//       _PROVIDERS[i].DispatchMessage(id, lparam, dparam, sparam);
//     };
// }

//////////////////////////////////////
