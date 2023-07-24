//+------------------------------------------------------------------+
//|                                            AnalyzerInterface.mqh |
//|                                    Copyright 2023, Ronald hector |
//|                                          https://www.mysite.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Ronald hector"
#property link "https://www.mysite.com/"
#property version "Version = 1.00"
#include <HectperScalper\SignalProviders\Signals\Breaker_Block\BBInterface.mqh>;

class AnalyzerInterface
{
private:
    BBInterface *tradeInterface;
    _Trader parent;
    DCInterfaceData interfaceData;

public:
    AnalyzerInterface(BBInterface &bbInterface)
    {
        tradeInterface = &bbInterface;
        interfaceData = tradeInterface.GetInterfaceData();
    }

    void onTick(_Trader &_parent)
    {
        parent = &_parent;
        analyzeMarketTick();
    }

    void analyzeMarketTick()
    {
        checkPriceBreakOut();
    }

    void checkPriceBreakOut()
    {
        if (parent.PriceBid < interfaceData.SupportLevel)
        {
            Print("less than support");
        }
        if (parent.PriceBid > interfaceData.ResistanceLevel)
        {
            Print("greater than resistance");
        }
    }
};
//+------------------------------------------------------------------+