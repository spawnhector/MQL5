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

  BotInstance(int _providerindex, int _chartindex) : _Trader()
  {
    chartindex = _chartindex;
    ProviderIndex = _providerindex;
    CurrentSymbol = Charts[chartindex].CurrentSymbol;
    _INTERFACE = _PROVIDERS[ProviderIndex].getChartInterface();
    _DC = _INTERFACE.getChartAnalizer();
    _DC.analyzeChart(this);
    _SDCS[chartindex].DCS[ProviderIndex] = _DC;
  };

  ~BotInstance(){
  };

  void InstanceTick()
  {
    shoulder = MAX_CANDELS * 2;
    timeframe = "m1";
    clr = clrGainsboro;
    PriceBid = Charts[chartindex].ChartBid;
    PriceAsk = Charts[chartindex].ChartAsk;
    CurrentSymbol = Charts[chartindex].CurrentSymbol;
    currentBar = iBarShift(CurrentSymbol, PERIOD_M1, TimeCurrent());
    previousBar = currentBar + 1;

    _SDCS[chartindex].DCS[ProviderIndex].UpdateInterface();
    _point = NormalizeDouble(SymbolInfoDouble(CurrentSymbol, SYMBOL_POINT), _Digits);
    _SDCS[chartindex].DCS[ProviderIndex].OnTestTick(this);
    _SDCS[chartindex].DCS[ProviderIndex].Optimize(this);

    if (strat_trade && bNewBar())
    {
      _SetState();
      int isSelected = IsInArray(selectedProviders, ProviderIndex);
      if (isSelected != -1)
      {
        // _SDCS[chartindex].DCS[ProviderIndex].OnTick(this);
      }
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
  // bool bOurMagic(ulong ticket, int magiccount) // whether the magic number of the current deal matches one of the possible magic numbers of our robot
  // {
  //   int MagicT[];
  //   ArrayResize(MagicT, magiccount);
  //   for (int i = 0; i < magiccount; i++)
  //   {
  //     MagicT[i] = order_magic + i;
  //   }
  //   for (int i = 0; i < ArraySize(MagicT); i++)
  //   {
  //     if (HistoryDealGetInteger(ticket, DEAL_MAGIC) == MagicT[i])
  //       return true;
  //   }
  //   return false;
  // };
};

//+------------------------------------------------------------------+
