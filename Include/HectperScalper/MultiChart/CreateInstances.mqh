//+------------------------------------------------------------------+
//|                                              CreateInstances.mqh |
//|                                                    ronald Hector |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "ronald Hector"
#property link "https://www.mql5.com"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

void CreateInstances() // attach all virtual robots to charts
{
  InterfaceRoot.startTickCount = GetTickCount();
  ArrayResize(_SDCS, ArraySize(Charts));
  ArrayResize(_PARENTS, ArraySize(Charts));
  for (int j = 0; j < ArraySize(Charts); j++)
  {

    int _index = __chartSymbol.symbolIndex(Charts[j].CurrentSymbol);
    if (_index != -1)
    {
      
      _SDCS[_index] = new SDCS();
      ArrayResize(_SDCS[_index].DCS, ArraySize(_PROVIDERS));
      for (int i = 0; i < ArraySize(_PROVIDERS); i++)
      {
        BI = new BotInstance(i, _index);
        ArrayResize(Bots, ArraySize(Bots) + 1);
        Bots[ArraySize(Bots) - 1] = BI;
      }
    }
  }
  InterfaceRoot.LogExecutionTime("Create Instance", InterfaceRoot.startTickCount);
};
