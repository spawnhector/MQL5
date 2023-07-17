//+------------------------------------------------------------------+
//|                                                       trader.mqh |
//|                                    Copyright 2023, Ronald hector |
//|                                          https://www.mysite.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Ronald hector"
#property link "https://www.mysite.com/"
#property version "Version = 1.00"
#include <HectperScalper\SignalProviders\provider.mqh>;
#include <HectperScalper\SignalProviders\traderInterface.mqh>;
#include <HectperScalper\SignalProviders\Signals\Main\Trader.mqh>;
#include <HectperScalper\SignalProviders\Signals\Breaker_Block\BBInterface.mqh>;
#include <HectperScalper\SignalProviders\Signals\Breaker_Block\Analyzer\BBAnalizer.mqh>;
#include <HectperScalper\SignalProviders\duplicatedChartInterface.mqh>;
#include <HectperScalper\SignalProviders\Struct\interfaceData.mqh>;

class BBTrader : public __Trader
{
protected:
    ProviderData providerData;
    BBInterface *__Interface;
    BBAnalyzer *Analyze;

public:
    DCInterfaceData interfaceData;
    BBTrader(_Trader &parent, ProviderData &_providerData)
    {
        providerData = _providerData;
        __Interface = new BBInterface(parent);
        interfaceData = __Interface.GetInterfaceData();
        if (interfaceData.redRectangle && interfaceData.greenRectangle)
        {
            __Interface.GetObjectStartBar();
            __Interface.PlotBB();
            Analyze = new BBAnalyzer(__Interface);
        }
    }

    ~BBTrader()
    {
        delete __Interface;
        delete Analyze;
    }

    void _Trade(_Trader &parent)
    {
        Analyze._analyzeInterface.onTick(parent);
    }

    ProviderData GetProviderData() const override
    {
        return providerData;
    }

    DCInterface *GetDCInterface() override
    {
        return __Interface;
    }

    void DispatchMessage(const int id, const long &lparam, const double &dparam, const string &sparam){
        Widget.DispatchMessage(id, lparam, dparam, sparam);
    }

    virtual void clearBase(){};

private:
};