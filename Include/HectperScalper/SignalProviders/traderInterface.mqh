#include <HectperScalper\SignalProviders\Signals\Main\Trader.mqh>;
#include <HectperScalper\SignalProviders\providerData.mqh>;
#include <HectperScalper\SignalProviders\duplicatedChartInterface.mqh>;

DCInterface* __Interface;
interface __Trader
{
public:
    virtual ProviderData GetProviderData() const = 0;
    // virtual DCInterface* GetDCInterface() { return __Interface;};
    virtual void _Trade(_Trader &parent){};
    virtual void clearBase(){};
    virtual void DispatchMessage(const int id, const long &lparam, const double &dparam, const string &sparam){};
};