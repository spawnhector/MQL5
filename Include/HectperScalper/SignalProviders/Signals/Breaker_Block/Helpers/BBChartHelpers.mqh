#include "Helpers.mqh";

class BBChartHelpers : public Helpers
{
public:
    BBChartHelpers(){}
    
    DCInterfaceData GetInterfaceData() const override
    {
        return DCID;
    }

    
    void IdentifySupportResistanceLevels()
    {
        DrawRSLines.plot((string)parent.CurrentSymbol, Period());
        root.SupportLevel = DrawRSLines.rangeLow;
        root.ResistanceLevel = DrawRSLines.rangeHigh;
    }

    void CheckPriceBreakOut()
    {
        if (parent.PriceBid < root.SupportLevel) 
        {
            Print("less than support");
        }
        if (parent.PriceBid > root.ResistanceLevel)
        {
            Print("greater than resistance");
        }
    }
}