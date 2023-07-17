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

class BreakerBlock : public Provider
{
private:
    ProviderData providerData;
    BBTrader* trader;

public:
    BreakerBlock(){
        providerData.ProviderName = "BreakerBlock";
    }
    ~BreakerBlock(){
        delete trader;
    }

    void addIndex(int index) override{
        providerData.ProviderIndex = index;
    }

    
    ProviderData GetProviderData() const override
    {
        return providerData;
    }

    __Trader* GetTrader(_Trader &parent) override
    {
        trader = new BBTrader(parent,providerData);
        return trader;
    }

    void clearBase() override
    {
        delete trader;
    }
};

//+------------------------------------------------------------------+