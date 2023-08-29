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
    BBInterface *_interface;
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
        delete _interface;
    }

    void createInterface(string _symb)
    {
        _interface = new BBInterface(providerData);
        _interface.createInterFace(_symb);
        interfaceData = _interface.GetInterfaceData();
        // _interface.PlotBB();
    }

    void addIndex(int index) override
    {
        providerData.ProviderIndex = index;
    }

    ProviderData GetProviderData() const override
    {
        return providerData;
    }

    DCInterface *getChartInterface() override
    {
        return _interface;
    }

    void DispatchMessage(const int id, const long &lparam, const double &dparam, const string &sparam) override
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
                    ObjectsDeleteAll(interfaceData.chartID, "BB-Plot");
                    createInterface(szRet[1]);
                }
            }
            break;
        }
        Widget.DispatchMessage(id, lparam, dparam, sparam);
    }
    void clearBase() override
    {
    }
};

//+------------------------------------------------------------------+