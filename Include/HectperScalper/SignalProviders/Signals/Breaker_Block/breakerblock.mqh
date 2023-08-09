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
    BBInterface *_interface;
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
        this.createInterface(_Symbol);
    }

    ~BreakerBlock()
    {
        delete trader;
        delete Analyzer;
        delete _interface;
    }

    void createInterface(string _symb)
    {
        _interface = new BBInterface();
        _interface.createInterFace(_symb);
        interfaceData = _interface.GetInterfaceData();
        if (interfaceData.redRectangle && interfaceData.greenRectangle)
        {
            _interface.GetObjectStartBar();
            _interface.PlotBB();
            Analyzer = new BBAnalyzer(_interface);
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

    DCInterface *getChartInterface() override
    {
        return _interface;
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
                    delete _interface;
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