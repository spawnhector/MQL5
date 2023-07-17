//+------------------------------------------------------------------+
//|                                     hectperScalperMultiChart.mq5 |
//|                                                    ronald Hector |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property strict
#property copyright "ronald Hector"
#property link "https://www.mql5.com"
#property version "1.00"

//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
// #property tester_indicator "Examples\\InterfacePriceButton.mq5"

#include <Trade\PositionInfo.mqh>
#include <Trade\Trade.mqh>
CPositionInfo m_position; // trade position object
CTrade m_trade;           // trading object

#include <HectperScalper\AppInterface\CreateSimpleInterface.mqh>;
#include <HectperScalper\AppInterface\DeleteSimpleInterface.mqh>;
#include <HectperScalper\AppInterface\ButtonCheck.mqh>;
#include <HectperScalper\AppInterface\RectLabelCreate.mqh>;
#include <HectperScalper\AppInterface\LabelCreate.mqh>;
#include <HectperScalper\AppInterface\ButtonCreate.mqh>;
#include <HectperScalper\AppInterface\OwnObjectNames.mqh>;
#include <HectperScalper\AppInterface\UpdateStatus.mqh>;
#include <HectperScalper\AppInterface\InterfaceEvents.mqh>;
#include <HectperScalper\MultiChart\StringToPeriod.mqh>;
#include <HectperScalper\MultiChart\StringToDoubleP.mqh>;
#include <HectperScalper\MultiChart\ConstructArrays.mqh>;
#include <HectperScalper\MultiChart\ConstructLots.mqh>;
#include <HectperScalper\MultiChart\ConstructTimeframe.mqh>;
#include <HectperScalper\MultiChart\CreateCharts.mqh>;
#include <HectperScalper\MultiChart\CreateInstances.mqh>;
#include <HectperScalper\MultiChart\ticks.mqh>;

#include <HectperScalper\wsc\connection.mqh>;
#include <HectperScalper\customChatObjects.mqh>;
// #include <HectperScalper\peakFindAndTrade.mqh>;
#include <HectperScalper\CustomTicket.mqh>;

#include <HectperScalper\init\start.mqh>;

#include <HectperScalper\MultiChart\chart.mqh>;
int Chart::TCN = 0;
Chart *Charts[];

#include <HectperScalper\MultiChart\BotInstance.mqh>;
BotInstance *Bots[];

#include <HectperScalper\SignalProviders\signalprovider.mqh>
SignalProvider *Signals;
#include <HectperScalper\SignalProviders\duplicatedChartInterface.mqh>;

// #include <HectperScalper\Data\sharedData.mqh>

// DCIDMEMORY dCID;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
  if (TerminalInfoInteger(TERMINAL_TRADE_ALLOWED) == 0)
  {
    Print("Automated trading is currently disabled. Please enable automated trading to use this Expert Advisor.");
    return INIT_FAILED;
  }
  Signals = new SignalProvider();

  if (isTestAccount)
  {
    addToArray(selectedProviders, 1);
    strat_trade = true;
    startButtonClicked = true;
  }

  if (enableServer)
  {
    if (ConnectServer())
    {
      return INIT_SUCCEEDED;
    }
    return INIT_FAILED;
  }

  CreateCharts();
  CreateInstances();
  if (bInterfaceE)
    CreateSimpleInterface();
  return (INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
  DeleteSimpleInterface();
  Signals.removeProviders();
  delete Signals;

  for (int j = 0; j < ArraySize(Charts); j++)
    delete Charts[j];
  for (int j = 0; j < ArraySize(Bots); j++)
  {
    // Bots[j].clearBase();
    delete Bots[j];
  }
  EventKillTimer();
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
  AllChartsTick();
  AllBotsTick();
  if (bInterfaceE)
    UpdateStatus();
}

void OnTimer()
{
  if (TerminalInfoInteger(TERMINAL_TRADE_ALLOWED) == 0)
  {
    Print("Automated trading is currently disabled. Please enable automated trading to use this Expert Advisor.");
    EventKillTimer();
    return;
  }
	EventChartCustom(0, BBWidget::Ev_RollingTo, user01, 0.0, "");

  if (enableServer)
  {
    Print("waiting on curreny settings");
    // check if data is available to read
    if (SocketIsReadable(socket2))
    {
      // data is available to read
      string settings = socketreceive(socket2, 10);
      if (settings != "")
      {
        Print(settings);
        signalChannelOpen = true;
        EventKillTimer();
        return;
      }
    }
  }
}

// bool bInterfaceE = true; // Interface
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
  for (int i = 0; i < ArraySize(BotSignals); i++)
  {
    BotSignals[i].DispatchMessage(id, lparam, dparam, sparam);
  }

  if (id == CHARTEVENT_OBJECT_CLICK) //
  {
    ButtonsCheck(sparam);
  }

  if (id == CHARTEVENT_CHART_CHANGE)
  {
    for (int i = 0; i < ArraySize(BotSignals); i++)
    {
      // DCInterface* providerStorage = BotSignals[i].GetDCInterface();
      // // DCInterfaceData providerStorage = BotSignals[i].;
      // Print("here ",providerStorage);
    }
  }
}

//////////////////////////////////////
