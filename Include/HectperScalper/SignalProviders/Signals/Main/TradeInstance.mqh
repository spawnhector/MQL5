
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

#include <HectperScalper\SignalProviders\Signals\Main\Trader.mqh>;
#include <HectperScalper\SignalProviders\provider.mqh>;
#include <HectperScalper\SignalProviders\Signals\Main\HSTrader.mqh>;
#include <HectperScalper\SignalProviders\traderInterface.mqh>;

class TradeInstance : public Provider
{

private:
    ProviderData providerData;
    MainTrader* trader;

public:
    TradeInstance()
    {
        providerData.ProviderName = "TradeInstance";
    }

    ~TradeInstance()
    {
        delete trader;
    }

    void addIndex(int index) override
    {
        providerData.ProviderIndex = index;
    }

    ProviderData GetProviderData() const override
    {
        return providerData;
    }

    __Trader* GetTrader(_Trader &parent) override
    {
        trader = new MainTrader(parent,providerData);
        return trader;
    }
    
    void clearBase() override
    {
        delete trader;
    }
}
