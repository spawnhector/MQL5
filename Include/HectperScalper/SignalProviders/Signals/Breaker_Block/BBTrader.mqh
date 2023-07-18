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
#include <HectperScalper\SignalProviders\duplicatedChartInterface.mqh>;
#include <HectperScalper\SignalProviders\Struct\interfaceData.mqh>;
#include <HectperScalper\SignalProviders\Signals\Breaker_Block\Analyzer\BBAnalizer.mqh>;
#include <HectperScalper\SignalProviders\Signals\Breaker_Block\Analyzer\ChartAnalyzer.mqh>;

class BBTrader : public __Trader
{
protected:
    ProviderData providerData;
    ChartAnalyzer *chartAnalyzer;

public:
    BBTrader(BBAnalyzer &_Analyzer,ProviderData &_providerData)
    {
        providerData = _providerData;
        chartAnalyzer = _Analyzer.GetChartAnalyzer();
    }

    ~BBTrader()
    {
        delete chartAnalyzer;
    }

    void _Trade(_Trader &parent)
    {
        if (chartAnalyzer.root.analyzing)
        {
            Print("chart analyzing ", parent.CurrentSymbol);
        }else{
            chartAnalyzer.analyzeChart();
        }
        
        // Analyze._analyzeInterface.onTick(parent);
    }

    ProviderData GetProviderData() const override
    {
        return providerData;
    }

    // DCInterface *GetDCInterface() override
    // {
    //     // return __Interface;
    // }

    void DispatchMessage(const int id, const long &lparam, const double &dparam, const string &sparam){
        Widget.DispatchMessage(id, lparam, dparam, sparam);
    }

    virtual void clearBase(){};

private:
};