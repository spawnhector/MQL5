//+------------------------------------------------------------------+
//|                                            HSInterfaceHelper.mqh |
//|                                    Copyright 2023, Ronald hector |
//|                                          https://www.mysite.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Ronald hector"
#property link "https://www.mysite.com/"
#property version "Version = 1.00"
#include "Helpers.mqh"

class HSInterfaceHelper : public HSDCInterfaceHelpers
{

public:
    HSInterfaceHelper() : HSDCInterfaceHelpers()
    {
    };
    
    DCInterfaceData GetInterfaceData() const override
    {
        return DCID;
    };

};
//+------------------------------------------------------------------+