
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

#include <HectperScalper\SignalProviders\Signals\Main\HSTrader.mqh>;
#include <HectperScalper\SignalProviders\Signals\Main\HSInterface.mqh>;

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
    HSInterface *__Interface;
    TradeInstance()
    {
        providerData.ProviderName = "TradeInstance";
        __Interface = new HSInterface();
    }

    ~TradeInstance()
    {
        delete trader;
        delete __Interface;
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
    
    D_C* getChartInterface() override{
        return __Interface.getChartAnalizer();
    }

    // void startAnalizer(_Trader &_parent) override{
    //     // parent = _parent;
    // }

    // void analizeOnTick(_Trader &_parent) override{
    //     // __Interface.chartAnalyzer.analyzeOnTick(_parent);
    // }

    void DispatchMessage(const int id, const long &lparam, const double &dparam, const string &sparam)
    {
        // Widget.DispatchMessage(id, lparam, dparam, sparam);
    }

    void clearBase() override
    {
        delete trader;
    }
}
