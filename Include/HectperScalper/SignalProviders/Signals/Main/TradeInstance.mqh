
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

#include <HectperScalper\SignalProviders\Signals\Main\HSInterface.mqh>;

class TradeInstance : public Provider
{

private:
    ProviderData providerData;
    HSInterface *__Interface;
    enum EventCustom
    {
        // add custom event here
    };

public:
    TradeInstance()
    {
        providerData.ProviderName = "TradeInstance";
        __Interface = new HSInterface(providerData);
    }

    ~TradeInstance()
    {
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
    
    DCInterface* getChartInterface() override{
        return __Interface;
    }

    // void startAnalizer(_Trader &_parent) override{
    //     // parent = _parent;
    // }

    // void analizeOnTick(_Trader &_parent) override{
    //     // __Interface.chartAnalyzer.analyzeOnTick(_parent);
    // }

    void DispatchMessage(const int id, const long &lparam, const double &dparam, const string &sparam) override
    {
        // Widget.DispatchMessage(id, lparam, dparam, sparam);
    }

    void clearBase() override
    {
    }
}
