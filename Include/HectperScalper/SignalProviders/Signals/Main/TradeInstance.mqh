
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
    enum EventCustom
    {
        // add custom event here
    };

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

    __Trader* GetTrader() override
    {
        trader = new MainTrader(providerData);
        return trader;
    }
    
    void DispatchMessage(const int id, const long &lparam, const double &dparam, const string &sparam)
    {
        // Widget.DispatchMessage(id, lparam, dparam, sparam);
    }

    void clearBase() override
    {
        delete trader;
    }
}
