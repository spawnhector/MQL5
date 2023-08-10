//+------------------------------------------------------------------+
//|                                                  BotInstance.mqh |
//|                                                    ronald Hector |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "ronald Hector"
#property link "https://www.mql5.com"
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
    if (Signals)
      for (int i = 0; i < ArraySize(_PROVIDERS); i++)
      {
        _INTERFACE = _PROVIDERS[i].getChartInterface();
        _DC = _INTERFACE.getChartAnalizer();
        _DC.analyzeChart(this);
        this.addChartAnalizer();
      };
  };

  ~BotInstance()
  {
  };

  void InstanceTick()
  {
    MagicF = order_magic;
    CurrentSymbol = Charts[chartindex].CurrentSymbol;
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
      for (int i = 0; i < ArraySize(_DCS); i++)
      {
        __root = _DCS[i].GetRootData();
        if(__root.symbol == CurrentSymbol) _DCS[i].OnTick(this);
      };
      // // for (int i = 0; i < ArraySize(BotSignals); i++)
      // {
      //   ProviderData providerStorage = BotSignals[i].GetProviderData();
      //   int isSelected = IsInArray(selectedProviders, providerStorage.ProviderIndex);
      //   if (isSelected != -1)
      //   {
      //     // Signals.providers[providerStorage.ProviderIndex].analizeOnTick(this);
      //     BotSignals[i]._Trade(this);
      //     BotSignals[i].clearBase();
      //   }
      // }
      // Optimizer.checkCloseTrades(this);
    }
  };

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
  };
  
  void addChartAnalizer()
  {
    ArrayResize(_DCS, ArraySize(_DCS) + 1);
    _DCS[ArraySize(_DCS) - 1] = _DC;
  };
};
//+------------------------------------------------------------------+
