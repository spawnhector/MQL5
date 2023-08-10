#include "Helpers.mqh";

class BBChartHelpers : public BBDCHelpers
{
public:
    BBChartHelpers(){};
    ~BBChartHelpers(){};

    stc01 GetRootData() const override
    {
        return ROOT;
    };

    DCInterfaceData GetInterfaceData() const override
    {
        return DCID;
    };

    ProviderData GetProviderData() const override
    {
        return providerData;
    }
    
    void IdentifySupportResistanceLevels()
    {
        DrawRSLines.plot((string)parent.CurrentSymbol, Period());
        ROOT.SupportLevel = DrawRSLines.rangeLow;
        ROOT.ResistanceLevel = DrawRSLines.rangeHigh;
    };
    void CheckPriceBreakOut()
    {
        Print("bid ",parent.PriceBid);
        Print("res ",ROOT.ResistanceLevel);
        if (parent.PriceBid < ROOT.SupportLevel) 
        {
            Print("less than support ",parent.CurrentSymbol);
        }
        if (parent.PriceBid > ROOT.ResistanceLevel)
        {
            Print("greater than resistance ",parent.CurrentSymbol);
        }
    };
}