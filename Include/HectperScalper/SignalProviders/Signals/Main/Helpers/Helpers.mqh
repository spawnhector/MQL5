//+------------------------------------------------------------------+
//|                                                      Helpers.mqh |
//|                                    Copyright 2023, Ronald hector |
//|                                          https://www.mysite.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Ronald hector"
#property link "https://www.mysite.com/"
#property version "Version = 1.00"


class HSDCHelpers : public D_c
{
protected:
    _Trader parent;

public:
    HSDCHelpers(){ };
    ~HSDCHelpers(){
    };
    stc01 ROOT;
    ProviderData providerData;
    DCInterfaceData DCID;

};

class HSDCInterfaceHelpers : public DCInterface
{
protected:
    DrawRSLine* DrawRSLines;
    _Trader parent;

public:
    HSDCInterfaceHelpers(){ };
    ~HSDCInterfaceHelpers(){
    };
    ProviderData providerData;
    DCInterfaceData DCID;

};
//+------------------------------------------------------------------+