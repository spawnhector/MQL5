//+------------------------------------------------------------------+
//|                                                 CreateCharts.mqh |
//|                                                    ronald Hector |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "ronald Hector"
#property link "https://www.mql5.com"

void CreateCharts() // create the chart objects
{
  ArrayResize(CN,__chartSymbol.symbolLength);//set the size of the array of using bars for each symbol
  for (int i = 0; i < __chartSymbol.symbolLength; i++) // set the requested number of bars
  {
    CN[i] = LastBars;
  }
  ArrayResize(Charts, __chartSymbol.symbolLength); // set the size of the chart array
  int tempcnum = 0;
  for (int j = 0; j < __chartSymbol.symbolLength; j++) // determine the maximum number of required candles for the largest variant
  {
    if (CN[j] > tempcnum)
      tempcnum = CN[j];
  }
  Chart::TCN = tempcnum;
  for (int j = 0; j < ArraySize(Charts); j++) // fill in all the names and set the dimensions of all timeseries of each chart
  {
    Charts[j] = new Chart();
    Charts[j].lastcopied = 0;
    ArrayResize(Charts[j].CloseI, tempcnum + 2); // assign size to symbol arrays
    ArrayResize(Charts[j].OpenI, tempcnum + 2);  // assign size to symbol arrays
    ArrayResize(Charts[j].HighI, tempcnum + 2);  // assign size to symbol arrays
    ArrayResize(Charts[j].LowI, tempcnum + 2);   // assign size to symbol arrays
    ArrayResize(Charts[j].TimeI, tempcnum + 2);  // assign size to symbol arrays
    Charts[j].CurrentSymbol = __chartSymbol.Symbols[j];        // symbol
    Charts[j].Timeframe = PERIOD_M1;                  // period
  }
}