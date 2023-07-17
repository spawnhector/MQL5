//+------------------------------------------------------------------+
//|                                                  ButtonCheck.mqh |
//|                                                    ronald Hector |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "ronald Hector"
#property link ""
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
void ButtonsCheck(string sparam0) // check buttons, unpress and close relevant orders
{
  if (sparam0 == OwnObjectNames[16]) // close own
  {
    CloseAllI(0);
  }

  if (sparam0 == OwnObjectNames[17]) // close all
  {
    CloseAllI(-1);
  }

  if (sparam0 == OwnObjectNames[16] || sparam0 == OwnObjectNames[17])
  {
    if (ObjectGetInteger(0, sparam0, OBJPROP_STATE, 0))
    {
      ObjectSetInteger(0, OwnObjectNames[16], OBJPROP_STATE, false);
      ObjectSetInteger(0, OwnObjectNames[17], OBJPROP_STATE, false);
    }
  }

  if (sparam0 == "template-StartTrader")
  {
    if (!startButtonClicked)
    {
      startButtonClicked = true;
    }
    else
    {
      startButtonClicked = false;
    }
    
  }

  for (int i = 0; i < ArraySize(Signals.providers); i++)
  {
    ProviderData providerStorage = Signals.providers[i].GetProviderData();
    if (sparam0 == "template-Signalprovider-select-button-" + providerStorage.ProviderName)
    {
      int isSelected = IsInArray(selectedProviders, providerStorage.ProviderIndex);
      if (isSelected == -1)
        addToArray(selectedProviders, providerStorage.ProviderIndex);
      else
        RemoveFromArray(selectedProviders, isSelected);
    }
  }
}