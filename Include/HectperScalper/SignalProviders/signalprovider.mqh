//+------------------------------------------------------------------+
//|                                               signalprovider.mqh |
//|                                    Copyright 2023, Ronald hector |
//|                                          https://www.mysite.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Ronald hector"
#property link "https://www.mysite.com/"
#property version "Version = 1.00"

#include <HectperScalper\SignalProviders\Signals\Main\TradeInstance.mqh>;
#include <HectperScalper\SignalProviders\Signals\Breaker_Block\breakerblock.mqh>;

class SignalProvider
{
protected:
    TradeInstance *Trader;
    BreakerBlock *breakerblock;

public:
    // Provider *providers[];

    SignalProvider()
    {
        Trader = new TradeInstance();
        Trader.addIndex(this.getIndex());
        this.addProviders(Trader);

        breakerblock = new BreakerBlock();
        breakerblock.addIndex(this.getIndex());
        this.addProviders(breakerblock);
    }

    ~SignalProvider(){
        delete Trader;
        delete breakerblock;
    }
    
    void addProviders(Provider &_providers)
    {
        // ArrayResize(providers, ArraySize(providers) + 1);
        // providers[ArraySize(providers) - 1] = &_providers;
        ArrayResize(_PROVIDERS, ArraySize(_PROVIDERS) + 1);
        _PROVIDERS[ArraySize(_PROVIDERS) - 1] = &_providers;
    }

    void removeProviders(){
        delete Trader;
        delete breakerblock;
    }

    int getIndex(){
        return ArraySize(_PROVIDERS);
    }
};

//+------------------------------------------------------------------+