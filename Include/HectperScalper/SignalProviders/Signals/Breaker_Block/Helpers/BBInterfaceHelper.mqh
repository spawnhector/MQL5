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
    }
    
    DCInterfaceData GetInterfaceData() const override
    {
        return DCID;
    }
    
    void IdentifySupportResistanceLevels()
    {
        DrawRSLines.plot(DCID.symbol, Period());
        DCID.SupportLevel = DrawRSLines.rangeLow;
        DCID.ResistanceLevel = DrawRSLines.rangeHigh;
        string objectName = "BB-Plot-"+_Symbol+"-SupportLevel";
        ObjectCreate(DCID.chartID, objectName, OBJ_HLINE, 0, DrawRSLines.rangeTime, DrawRSLines.rangeLow);
        ObjectSetInteger(DCID.chartID, objectName, OBJPROP_COLOR, clrBlue);
        objectName = "BB-Plot-"+_Symbol+"-ResistanceLevel";
        ObjectCreate(DCID.chartID, objectName, OBJ_HLINE, 0, DrawRSLines.rangeTime, DrawRSLines.rangeHigh);
        ObjectSetInteger(DCID.chartID, objectName, OBJPROP_COLOR, clrBlue);
    }

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