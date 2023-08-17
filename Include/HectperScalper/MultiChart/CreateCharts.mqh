//+------------------------------------------------------------------+
//|                                                 CreateCharts.mqh |
//|                                                    ronald Hector |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "ronald Hector"
#property link "https://www.mql5.com"
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

void CreateCharts() // create the chart objects
{
  bool bAlready;
  int num = 0;
  string TempSymbols[];
  string Symbols[];
  ConstructArrays();                      // prepare the arrays
  ArrayResize(TempSymbols, ArraySize(S)); // temporary symbol array
  for (int i = 0; i < ArraySize(S); i++)  // fill the temporary array with empty strings
  {
    TempSymbols[i] = "";
  }
  for (int i = 0; i < ArraySize(S); i++) // calculate the required number of unique symbols
  {
    bAlready = false;
    for (int j = 0; j < ArraySize(TempSymbols); j++)
    {
      if (S[i] == TempSymbols[j])
      {
        bAlready = true;
        break;
      }
    }
    if (!bAlready) // if there is no such chart, add it
    {
      for (int j = 0; j < ArraySize(TempSymbols); j++)
      {
        if (TempSymbols[j] == "")
        {
          TempSymbols[j] = S[i];
          break;
        }
      }
      num++;
    }
  }
  ArrayResize(Symbols, num);                   // assign size to symbol arrays
  for (int j = 0; j < ArraySize(Symbols); j++) // now we can fill them in
  {
    Symbols[j] = TempSymbols[j];
  }
  ArrayResize(Charts, num); // set the size of the chart array
  int tempcnum = 0;
  for (int j = 0; j < num; j++) // determine the maximum number of required candles for the largest variant
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
    Charts[j].CurrentSymbol = Symbols[j];        // symbol
    Charts[j].Timeframe = T[j];                  // period
  }
  // Print(Charts[1].CloseI);
  // ArrayResize(Bots, ArraySize(S)); // set the size of the bot array
}