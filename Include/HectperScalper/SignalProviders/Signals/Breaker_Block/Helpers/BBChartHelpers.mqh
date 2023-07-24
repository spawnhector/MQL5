#include "Helpers.mqh";

class BBChartHelpers : public BBDCHelpers
{
public:
    BBChartHelpers(){}

    
    void IdentifySupportResistanceLevels()
    {
        DrawRSLines.plot((string)parent.CurrentSymbol, Period());
        root.SupportLevel = DrawRSLines.rangeLow;
        root.ResistanceLevel = DrawRSLines.rangeHigh;
    }

    void CheckPriceBreakOut()
    {
        Print("bid ",parent.PriceBid);
        Print("res ",root.ResistanceLevel);
        if (parent.PriceBid < root.SupportLevel) 
        {
            Print("less than support ",parent.CurrentSymbol);
        }
        if (parent.PriceBid > root.ResistanceLevel)
        {
            Print("greater than resistance ",parent.CurrentSymbol);
        }
    }
}