//+------------------------------------------------------------------+
//|                                            BBInterfaceHelper.mqh |
//|                                    Copyright 2023, Ronald hector |
//|                                          https://www.mysite.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Ronald hector"
#property link "https://www.mysite.com/"
#property version "Version = 1.00"
#include "Helpers.mqh"

class BBInterfaceHelper : public BBDCInterfaceHelpers
{

public:
    BBInterfaceHelper() : BBDCInterfaceHelpers()
    {
    };

    DCInterfaceData GetInterfaceData() const override
    {
        return DCID;
    };

    void IdentifySupportResistanceLevels()
    {
        
        // int _index = __chartSymbol.symbolIndex(DCID.symbol);
        // if (_index != -1)
        // {
        //     __root = _SDCS[_index].DCS[providerData.ProviderIndex].GetRootData();
        //     __providerData = _SDCS[_index].DCS[providerData.ProviderIndex].GetProviderData();
        //     if (__providerData.ProviderName == providerData.ProviderName)
        //         if (__root.symbol == DCID.symbol)
        //         {
        //             DCID.SupportLevel = __root.SupportLevel;
        //             DCID.ResistanceLevel = __root.ResistanceLevel;
        //             DCID.rangeTime = __root.rangeTime;
        //         }
        // }
        // else
        // {
        //     DrawRSLines.plot(DCID.symbol, Period());
        //     DCID.SupportLevel = DrawRSLines.rangeLow;
        //     DCID.ResistanceLevel = DrawRSLines.rangeHigh;
        //     DCID.rangeTime = DrawRSLines.rangeTime;
        // }
        // string objectName = "BB-Plot-" + DCID.symbol + "-SupportLevel";
        // ObjectCreate(DCID.chartID, objectName, OBJ_HLINE, 0, DCID.rangeTime, DCID.SupportLevel);
        // ObjectSetInteger(DCID.chartID, objectName, OBJPROP_COLOR, clrBlue);
        // objectName = "BB-Plot-" + DCID.symbol + "-ResistanceLevel";
        // ObjectCreate(DCID.chartID, objectName, OBJ_HLINE, 0, DCID.rangeTime, DCID.ResistanceLevel);
        // ObjectSetInteger(DCID.chartID, objectName, OBJPROP_COLOR, clrBlue);
    };

    int GetBarIndexByTime(const datetime &targetTime)
    {
        int barIndex = iBarShift(_Symbol, PERIOD_CURRENT, targetTime, true);
        if (barIndex != -1)
        {
            return barIndex;
        }
        return -1;
    }
};
//+------------------------------------------------------------------+