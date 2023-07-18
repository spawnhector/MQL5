//+------------------------------------------------------------------+
//|                                                 BreakerBlock.mqh |
//|                                    Copyright 2023, Ronald hector |
//|                                          https://www.mysite.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Ronald hector"
#property link "https://www.mysite.com/"
#property version "Version = 1.00"
#include <HectperScalper\SignalProviders\provider.mqh>;
#include <HectperScalper\SignalProviders\Signals\Breaker_Block\interface.mqh>;
#include <HectperScalper\SignalProviders\Signals\Breaker_Block\BBTrader.mqh>;
#include <HectperScalper\SignalProviders\Signals\Main\Trader.mqh>;
#include <HectperScalper\SignalProviders\Signals\Breaker_Block\BBInterface.mqh>;
#include <HectperScalper\SignalProviders\Signals\Breaker_Block\Analyzer\BBAnalizer.mqh>;

class BreakerBlock : public Provider
{
private:
    ProviderData providerData;
    BBTrader* trader;
    BBInterface *__Interface;
    BBAnalyzer *Analyzer;
    DCInterfaceData interfaceData;

public:
    BreakerBlock(){
        providerData.ProviderName = "BreakerBlock";
        __Interface = new BBInterface();
        interfaceData = __Interface.GetInterfaceData();
        if (interfaceData.redRectangle && interfaceData.greenRectangle)
        {
            __Interface.GetObjectStartBar();
            __Interface.PlotBB();
            Analyzer = new BBAnalyzer(__Interface);
        }
    }

    ~BreakerBlock(){
        delete trader;
        delete __Interface;
        delete Analyzer;
    }

    void addIndex(int index) override{
        providerData.ProviderIndex = index;
    }

    
    ProviderData GetProviderData() const override
    {
        return providerData;
    }

    __Trader* GetTrader() override
    {
        trader = new BBTrader(Analyzer,providerData);
        return trader;
    }

    void clearBase() override
    {
        delete trader;
    }
};

//+------------------------------------------------------------------+