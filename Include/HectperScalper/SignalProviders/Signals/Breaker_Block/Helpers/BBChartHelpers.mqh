class BBChartHelpers
{
public:
    struct stc01
    {
        bool analyzing;
        bool redRectangle;
        bool greenRectangle;
        long chartWidth;
        long chartHeight;
        long bidY;
        long onew;
        long twow;
        long x1;
        long y1;
        double SupportLevel;
        double ResistanceLevel;
    } root;

    void IdentifySupportResistanceLevels(_Trader &parent)
    {
        MqlRates rates[];
        double rangeLow, rangeHigh;
        datetime rangeTime;
        int rangeStartBar = 1;    // Start bar index of the range
        int rangeEndBar = rangeStartBar + 50; // End bar index of the range

        int copiedBars = CopyRates(parent.CurrentSymbol, Period(), rangeStartBar, rangeEndBar - rangeStartBar + 1, rates);
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
        root.SupportLevel = rangeLow;
        root.ResistanceLevel = rangeHigh;
    }
}