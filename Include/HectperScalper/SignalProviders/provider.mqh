//+------------------------------------------------------------------+
//|                                                     provider.mqh |
//|                                    Copyright 2023, Ronald hector |
//|                                          https://www.mysite.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Ronald hector"
#property link      "https://www.mysite.com/"
#property version   "Version = 1.00"

#include <HectperScalper\SignalProviders\Signals\Main\Trader.mqh>;
#include <HectperScalper\SignalProviders\traderInterface.mqh>;
#include <HectperScalper\SignalProviders\providerData.mqh>;

__Trader* trader;
interface Provider
{
public:
    virtual ProviderData GetProviderData() const = 0;
    virtual __Trader* GetTrader() { return trader;};
    virtual void addIndex(int index){};
    virtual void clearBase(){};
    
};
//+------------------------------------------------------------------+