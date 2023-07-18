//+------------------------------------------------------------------+
//|                                                  BotInstance.mqh |
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

#include <HectperScalper\SignalProviders\Signals\Main\Trader.mqh>;
#include <HectperScalper\MultiChart\TradeOptimizer.mqh>;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class BotInstance : public _Trader // separate robot object
{
public:
  CPositionInfo m_position;
  CTrade m_trade;
  double CurrentLot;
  int chartindex;
  double CorrectedLot;
  TradeOptimizer *Optimizer;

  BotInstance(int _index, int _chartindex) : _Trader()
  {
    chartindex = _chartindex;
    CurrentSymbol = Charts[chartindex].CurrentSymbol;
    Optimizer = new TradeOptimizer();
  }

  ~BotInstance()
  {
    delete Optimizer;
  }

  void InstanceTick()
  {
    MagicF = order_magic;
    if (strat_trade)
    {
      _SetState(
          MagicF,
          chartindex,
          Charts[chartindex].ChartBid,
          Charts[chartindex].ChartAsk,
          CurrentSymbol,
          MAX_CANDELS * 2,
          "m1",
          clrGainsboro);

      for (int i = 0; i < ArraySize(BotSignals); i++)
      {
        ProviderData providerStorage = BotSignals[i].GetProviderData();
        int isSelected = IsInArray(selectedProviders, providerStorage.ProviderIndex);
        if (isSelected != -1)
        {
          BotSignals[i]._Trade(this);
          BotSignals[i].clearBase();
        }
      }
      Optimizer.checkCloseTrades(this);
    }
  }

  // void clearBase()
  // {
  //   delete Optimizer;
  // }

private:
  bool bOurMagic(ulong ticket, int magiccount) // whether the magic number of the current deal matches one of the possible magic numbers of our robot
  {
    int MagicT[];
    ArrayResize(MagicT, magiccount);
    for (int i = 0; i < magiccount; i++)
    {
      MagicT[i] = order_magic + i;
    }
    for (int i = 0; i < ArraySize(MagicT); i++)
    {
      if (HistoryDealGetInteger(ticket, DEAL_MAGIC) == MagicT[i])
        return true;
    }
    return false;
  }
};
//+------------------------------------------------------------------+
