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

  BotInstance(int _chartindex) : _Trader()
  {
    chartindex = _chartindex;
    CurrentSymbol = Charts[chartindex].CurrentSymbol;
    ArrayResize(_DCS, ArraySize(_PROVIDERS));
    // ArrayResize(_SDCS, ArraySize(S));
    for (int i = 0; i < ArraySize(_PROVIDERS); i++)
    {
      _INTERFACE = _PROVIDERS[i].getChartInterface();
      _DC = _INTERFACE.getChartAnalizer();
      _DC.analyzeChart(this);
      _DCS[i] = _DC;
    }
    // _SDCS[__chartSymbol.symbolIndex(CurrentSymbol)] = _DCS;
  };

  ~BotInstance(){};

  void InstanceTick()
  {
    MagicF = order_magic;
    index = chartindex;
    PriceBid = Charts[chartindex].ChartBid;
    PriceAsk = Charts[chartindex].ChartAsk;
    CurrentSymbol = Charts[chartindex].CurrentSymbol;
    shoulder = MAX_CANDELS * 2;
    timeframe = "m1";
    clr = clrGainsboro;
    currentBar = iBarShift(CurrentSymbol, PERIOD_M1, TimeCurrent());
    previousBar = currentBar + 1;
    DCID.root.update();
    if (strat_trade && bNewBar())
    {
      _SetState();
      // Print(ArraySize(_SDCS));
      // for (int i = 0; i < ArraySize(_PROVIDERS); i++)
      // {
      //   ProviderData providerStorage = _PROVIDERS[i].GetProviderData();
      //   int isSelected = IsInArray(selectedProviders, providerStorage.ProviderIndex);
      //   if (isSelected != -1)
      //   {
      //     for (int l = 0; l < ArraySize(_DCS); l++)
      //     {
      //     // Print(_DCS[l].);
      //       __root = _DCS[l].GetRootData();
      //       if (__root.symbol == CurrentSymbol)
      //         _DCS[l].OnTick(this);
      //     }
      //   }
      // }
      // Optimizer.checkCloseTrades(this);
    }
  };

private:
  datetime Time0;
  bool bNewBar() // new bar
  {
    if (Time0 < Charts[chartindex].TimeI[1] && Charts[chartindex].ChartPoint != 0.0)
    {
      if (Time0 != 0)
      {
        Time0 = Charts[chartindex].TimeI[1];
        return true;
      }
      else
      {
        Time0 = Charts[chartindex].TimeI[1];
        return false;
      }
    }
    else
      return false;
  }
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
