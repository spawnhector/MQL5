//+------------------------------------------------------------------+
//|                                                      Helpers.mqh |
//|                                    Copyright 2023, Ronald hector |
//|                                          https://www.mysite.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Ronald hector"
#property link "https://www.mysite.com/"
#property version "Version = 1.00"
#include <HectperScalper\SignalProviders\duplicatedChartInterface.mqh>;
#include <HectperScalper\SignalProviders\Struct\interfaceData.mqh>;

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

class Helpers : public DCInterface
{
protected:
    DrawRSLine* DrawRSLines;
    DCInterfaceData DCID;
    _Trader parent;

public:
    Helpers(){ DrawRSLines = new DrawRSLine();}
    ~Helpers(){
        delete DrawRSLines;
    }

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

private:
};
//+------------------------------------------------------------------+