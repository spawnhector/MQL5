//+------------------------------------------------------------------+
//|                                                      _trader.mqh |
//|                                    Copyright 2023, Ronald hector |
//|                                          https://www.mysite.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Ronald hector"
#property link "https://www.mysite.com/"
#property version "Version = 1.00"
#include <HectperScalper\SignalProviders\Signals\Main\PeakInstance.mqh>;
#include <HectperScalper\SignalProviders\Signals\Main\HSInterface.mqh>;

class MainTrader : public __Trader
{
protected:
   int bar1;
   int bar2;
   TraderFindPeak *PeakFinder;
   ProviderData providerData;
   // HSInterface *__Interface;

public:
   MainTrader(ProviderData &_providerData)
   {
      providerData = _providerData;
      //   __Interface = new HSInterface(parent);
   }
   ~MainTrader()
   {
      // delete __Interface;
   }

   void _Trade(_Trader &parent)
   {
      PeakFinder = new TraderFindPeak();
      // CreateHighLow(parent);
   }

   ProviderData GetProviderData() const override
   {
      return providerData;
   }

   void DispatchMessage(const int id, const long &lparam, const double &dparam, const string &sparam)
   {
      //   Print("dispatch");
   }

   void clearBase() override
   {
      delete PeakFinder;
   }

private:
   void CreateHighLow(_Trader &parent)
   {
      // bar1 = PeakFinder.FindNextPeak(parent,MODE_HIGH, parent.shoulder,1+1);
      // bar2 = PeakFinder.FindNextPeak(parent,MODE_HIGH, parent.shoulder,bar1 + 1);
      bar1 = PeakFinder.FindPeak(parent, MODE_HIGH, parent.shoulder, 1, "High");
      bar2 = PeakFinder.FindPeak(parent, MODE_HIGH, parent.shoulder, bar1 + 1, "High");

      ObjectDelete(0, "upper" + parent.GetTimeframe() + parent.GetCurrentSymbol());
      ObjectCreate(0, "upper" + parent.GetTimeframe() + parent.GetCurrentSymbol(), OBJ_TREND, 0, iTime(parent.GetCurrentSymbol(), T[parent.index], bar2), iHigh(parent.GetCurrentSymbol(), T[parent.index], bar2), iTime(parent.GetCurrentSymbol(), T[parent.index], bar1), iHigh(parent.GetCurrentSymbol(), T[parent.index], bar1));
      ObjectSetInteger(0, "upper" + parent.GetTimeframe() + parent.GetCurrentSymbol(), OBJPROP_COLOR, parent.GetClr());
      ObjectSetInteger(0, "upper" + parent.GetTimeframe() + parent.GetCurrentSymbol(), OBJPROP_WIDTH, 2);

      //--- create point indication
      bar1 = PeakFinder.FindPeak(parent, MODE_LOW, parent.shoulder, 1, "Low");
      bar2 = PeakFinder.FindPeak(parent, MODE_LOW, parent.shoulder, bar1 + 1, "Low");

      // bar1 = PeakFinder.FindNextPeak(parent,MODE_LOW, parent.shoulder,1+1);
      // bar2 = PeakFinder.FindNextPeak(parent,MODE_LOW, parent.shoulder,bar1 + 1);
      ObjectDelete(0, "lower" + parent.GetTimeframe() + parent.GetCurrentSymbol());
      ObjectCreate(0, "lower" + parent.GetTimeframe() + parent.GetCurrentSymbol(), OBJ_TREND, 0, iTime(parent.GetCurrentSymbol(), T[parent.index], bar2), iLow(parent.GetCurrentSymbol(), T[parent.index], bar2), iTime(parent.GetCurrentSymbol(), T[parent.index], bar1), iLow(parent.GetCurrentSymbol(), T[parent.index], bar1));
      ObjectSetInteger(0, "lower" + parent.GetTimeframe() + parent.GetCurrentSymbol(), OBJPROP_COLOR, parent.GetClr());
      ObjectSetInteger(0, "lower" + parent.GetTimeframe() + parent.GetCurrentSymbol(), OBJPROP_WIDTH, 2);

      // PeakFinder.FindPeak(parent,optimizer, MODE_HIGH, parent.shoulder, 1, "High");
      // PeakFinder.FindPeak(parent,optimizer, MODE_LOW, parent.shoulder, 1, "Low");
   }
};