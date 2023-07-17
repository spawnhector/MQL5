//+------------------------------------------------------------------+
//|                                            BBInterfaceHelper.mqh |
//|                                    Copyright 2023, Ronald hector |
//|                                          https://www.mysite.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Ronald hector"
#property link "https://www.mysite.com/"
#property version "Version = 1.00"
#include <HectperScalper\SignalProviders\duplicatedChartInterface.mqh>;
#include <HectperScalper\SignalProviders\Struct\interfaceData.mqh>;
#include <HectperScalper\SignalProviders\Signals\Main\Trader.mqh>;

class BBInterfaceHelper : public DCInterface
{

private:
    _Trader *parent;

protected:
    DCInterfaceData DCID;

public:
    BBInterfaceHelper(_Trader &_parent)
    {
        parent = &_parent;
    }
    
    DCInterfaceData GetInterfaceData() const override
    {
        return DCID;
    }
    
    void IdentifySupportResistanceLevels()
    {
        MqlRates rates[];
        double rangeLow, rangeHigh;
        datetime rangeTime;
        int rangeStartBar = DCID.startBar.barIndex; // Start bar index of the range
        int rangeEndBar = DCID.startBar.barIndex + 50;   // End bar index of the range

        int copiedBars = CopyRates(Symbol(), Period(), rangeStartBar, rangeEndBar - rangeStartBar + 1, rates);
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
        DCID.SupportLevel = rangeLow;
        DCID.ResistanceLevel = rangeHigh;
        string objectName = "BB-Plot-"+parent.CurrentSymbol+"-SupportLevel";
        ObjectCreate(DCID.chartID, objectName, OBJ_HLINE, 0, rangeTime, rangeLow);
        ObjectSetInteger(DCID.chartID, objectName, OBJPROP_COLOR, clrBlue);
        objectName = "BB-Plot-"+parent.CurrentSymbol+"-ResistanceLevel";
        ObjectCreate(DCID.chartID, objectName, OBJ_HLINE, 0, rangeTime, rangeHigh);
        ObjectSetInteger(DCID.chartID, objectName, OBJPROP_COLOR, clrBlue);
    }

    int GetBarIndexByTime(const datetime &targetTime)
    {
        int barIndex = iBarShift(parent.CurrentSymbol, PERIOD_CURRENT, targetTime, true);
        if (barIndex != -1)
        {
            return barIndex;
        }
        return -1;
    }

};
//+------------------------------------------------------------------+