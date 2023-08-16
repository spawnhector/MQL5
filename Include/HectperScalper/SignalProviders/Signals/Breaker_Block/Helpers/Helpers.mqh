//+------------------------------------------------------------------+
//|                                                      Helpers.mqh |
//|                                    Copyright 2023, Ronald hector |
//|                                          https://www.mysite.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Ronald hector"
#property link "https://www.mysite.com/"
#property version "Version = 1.00"

class DrawRSLine
{
public:
    double rangeLow;
    double rangeHigh;
    datetime rangeTime;

    void plot(string syb, ENUM_TIMEFRAMES _prd)
    {
        MqlRates rates[];
        // int rangeStartBar = DCID.startBar.barIndex; // Start bar index of the range
        int rangeStartBar = 1;                // Start bar index of the range
        int rangeEndBar = rangeStartBar + 50; // End bar index of the range

        int copiedBars = CopyRates(syb, _prd, rangeStartBar, rangeEndBar - rangeStartBar + 1, rates);
        if (copiedBars <= 0)
        {
            Print("Failed to retrieve price data for the specified range.");
            return;
        }
        rangeLow = rates[0].low;
        rangeHigh = rates[0].high;
        rangeTime = rates[0].time;

        for (int i = 1; i < copiedBars; i++)
        {
            if (rates[i].low < rangeLow)
            {
                rangeLow = rates[i].low;
                rangeTime = rates[i].time;
            }

            if (rates[i].high > rangeHigh)
            {
                rangeHigh = rates[i].high;
                rangeTime = rates[i].time;
            }
        }
    }
};


class BBDCInterfaceHelpers : public DCInterface
{
protected:
    DrawRSLine* DrawRSLines;
    _Trader parent;

public:
    BBDCInterfaceHelpers(){ DrawRSLines = new DrawRSLine();};
    ~BBDCInterfaceHelpers(){
        delete DrawRSLines;
    };
    ProviderData providerData;

};

class BBDCHelpers : public D_c
{
protected:
    DrawRSLine* DrawRSLines;
    _Trader parent;

public:
    BBDCHelpers(){ DrawRSLines = new DrawRSLine();};
    ~BBDCHelpers(){
        delete DrawRSLines;
    };
    stc01 ROOT;
    ProviderData providerData;

    void addRootObject(chartObjects &cob){
        ArrayResize(ROOT.__COBS, ArraySize(ROOT.__COBS) + 1);
        ROOT.__COBS[ArraySize(ROOT.__COBS) - 1] = cob;
    };

};
//+------------------------------------------------------------------+