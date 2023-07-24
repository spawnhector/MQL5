//+------------------------------------------------------------------+
//|                                                 BreakerBlock.mqh |
//|                                    Copyright 2023, Ronald hector |
//|                                          https://www.mysite.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Ronald hector"
#property link "https://www.mysite.com/"
#property version "Version = 1.00"

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
        delete Analyzer;
        delete __Interface;
    }

    void createInterface(string _symb)
    {
        __Interface = new BBInterface();
        __Interface.createInterFace(_symb);
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

    D_C *getChartInterface() override
    {
        return __Interface.getChartAnalizer();
    }
    
    // void startAnalizer(_Trader &_parent) override{
    //     __Interface.chartAnalyzer.analyzeChart(_parent);
    // }

    // void analizeOnTick(_Trader &_parent) override{
    //     __Interface.chartAnalyzer.analyzeOnTick(_parent);
    // }

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