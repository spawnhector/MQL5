//+------------------------------------------------------------------+
//|                                                 BreakerBlock.mqh |
//|                                    Copyright 2023, Ronald hector |
//|                                          https://www.mysite.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Ronald hector"
#property link "https://www.mysite.com/"
#property version "Version = 1.00"
#include <HectperScalper\SignalProviders\provider.mqh>;
#include <HectperScalper\SignalProviders\Signals\Breaker_Block\BBTrader.mqh>;
#include <HectperScalper\SignalProviders\Signals\Main\Trader.mqh>;
#include <HectperScalper\SignalProviders\Signals\Breaker_Block\BBInterface.mqh>;
#include <HectperScalper\SignalProviders\Signals\Breaker_Block\Analyzer\BBAnalizer.mqh>;

class BreakerBlock : public Provider
{
private:
    ProviderData providerData;
    BBTrader *trader;
    BBInterface *__Interface;
    BBAnalyzer *Analyzer;
    DCInterfaceData interfaceData;
    enum EventCustom
    {
        Recieve_Ev = CHARTEVENT_CUSTOM + DataHandshake
    };

public:
    BreakerBlock()
    {
        providerData.ProviderName = "BreakerBlock";
        createInterface(_Symbol);
    }

    ~BreakerBlock()
    {
        delete trader;
        delete __Interface;
        delete Analyzer;
    }

    void createInterface(string _symb)
    {
        __Interface = new BBInterface(_symb);
        interfaceData = __Interface.GetInterfaceData();
        if (interfaceData.redRectangle && interfaceData.greenRectangle)
        {
            __Interface.GetObjectStartBar();
            __Interface.PlotBB();
            Analyzer = new BBAnalyzer(__Interface);
        }
    }

    void addIndex(int index) override
    {
        providerData.ProviderIndex = index;
    }

    ProviderData GetProviderData() const override
    {
        return providerData;
    }

    __Trader *GetTrader() override
    {
        trader = new BBTrader(providerData);
        return trader;
    }

    void DispatchMessage(const int id, const long &lparam, const double &dparam, const string &sparam)
    {
        string szRet[];
        switch (id)
        {
        case Recieve_Ev:
            if (StringSplit(sparam, '#', szRet) == 3)
            {
                if (szRet[0] == "CHARTCHANGE")
                {
                    delete __Interface;
                    delete Analyzer;
                    ChartClose(interfaceData.chartID);
                    createInterface(szRet[1]);
                }
            }
            break;
        }
        trader.DispatchMessage(id, lparam, dparam, sparam);
    }
    void clearBase() override
    {
        delete trader;
    }
};

//+------------------------------------------------------------------+