//+------------------------------------------------------------------+
//|                                                 UpdateStatus.mqh |
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

void UpdateStatus() // update interface state
{
   // ArrayPrint(provs.providers);
   ENUM_BASE_CORNER corner = CORNER_LEFT_UPPER; // position all elements in the left corner
   int x = 0;                                   // offset along X;
   int y = 0;                                  // height
   int Border = 3;
   string TempText = "Instruments-timeframes : ";
   TempText += IntegerToString(ArraySize(CN)); // number of symbol-timeframe pairs
   ObjectSetString(0, OwnObjectNames[3], OBJPROP_TEXT, TempText);
   TempText = "Balance : ";
   TempText += DoubleToString(NormalizeDouble(AccountInfoDouble(ACCOUNT_BALANCE), 2), 2);
   ObjectSetString(0, OwnObjectNames[4], OBJPROP_TEXT, TempText);
   TempText = "Equity : ";
   TempText += DoubleToString(NormalizeDouble(AccountInfoDouble(ACCOUNT_EQUITY), 2), 2);
   ObjectSetString(0, OwnObjectNames[5], OBJPROP_TEXT, TempText);
   TempText = "Leverage : 1/";
   TempText += DoubleToString(AccountInfoInteger(ACCOUNT_LEVERAGE), 0);
   ObjectSetString(0, OwnObjectNames[8], OBJPROP_TEXT, TempText);
   TempText = "Broker : ";
   TempText += AccountInfoString(ACCOUNT_COMPANY);
   ObjectSetString(0, OwnObjectNames[7], OBJPROP_TEXT, TempText);
   ///////////////////////////
   TempText = "Buy positions : ";
   TempText += DoubleToString(NormalizeDouble(CalculateBuyQuantity(), 0), 0);
   ObjectSetString(0, OwnObjectNames[9], OBJPROP_TEXT, TempText);
   TempText = "Sell positions : ";
   TempText += DoubleToString(NormalizeDouble(CalculateSellQuantity(), 0), 0);
   ObjectSetString(0, OwnObjectNames[10], OBJPROP_TEXT, TempText);
   TempText = "Buy lots : ";
   TempText += DoubleToString(NormalizeDouble(CalculateBuyLots(), 3), 3);
   ObjectSetString(0, OwnObjectNames[11], OBJPROP_TEXT, TempText);
   TempText = "Sell lots : ";
   TempText += DoubleToString(NormalizeDouble(CalculateSellLots(), 3), 3);
   ObjectSetString(0, OwnObjectNames[12], OBJPROP_TEXT, TempText);
   TempText = "Profit : ";
   TempText += DoubleToString(NormalizeDouble(AccountInfoDouble(ACCOUNT_EQUITY) - AccountInfoDouble(ACCOUNT_BALANCE), 2), 2);
   ObjectSetString(0, OwnObjectNames[6], OBJPROP_TEXT, TempText);
   TempText = "Draw Down : ";
   TempText += DoubleToString(NormalizeDouble(CalculateDrawDown(), 3), 3);
   TempText += " / ";
   TempText += DoubleToString(MathAbs(NormalizeDouble(CalculatePercentage(), 3)), 1);
   TempText += "%";
   ObjectSetString(0, "template-DrawDown", OBJPROP_TEXT, TempText);
   TempText = "Closed Trades : ";
   TempText += IntegerToString(ClosedTades);
   ObjectSetString(0, "template-ClosedTrades", OBJPROP_TEXT, TempText);
   TempText = "Trades Won : ";
   TempText += IntegerToString(won);
   ObjectSetString(0, "template-TradesWon", OBJPROP_TEXT, TempText);
   TempText = "Trades Loss : ";
   TempText += IntegerToString(loss);
   ObjectSetString(0, "template-TradesLoss", OBJPROP_TEXT, TempText);
   TempText = "Percentage Accuracy: ";
   TempText += DoubleToString(CalculateAccuracy(), 1);
   TempText += "%";
   ObjectSetString(0, "template-Accracy", OBJPROP_TEXT, TempText);

   if (startButtonClicked)
   {
      int proSize = ArraySize(selectedProviders);
      if (proSize == 0)
      {
         strat_trade = false;
         ObjectsDeleteAll(0, OwnObjectNames[16]);
         ObjectsDeleteAll(0, OwnObjectNames[17]);
         startButtontext = "Waiting";
         interfaceError = "Please select a signal provider";
      }
      else
      {
         if (!strat_trade)
         {
            ButtonCreate(0, OwnObjectNames[16], 0, x + Border + 150, y + 160 + Border + 20 * 5 + 20 * 5 + 23 + 20 * 2 + 20, 180, 25, corner, "Close own orders", "Arial", 11, clrWhite, clrCrimson, clrNONE, false, false, false, true, 0);
            ButtonCreate(0, OwnObjectNames[17], 0, x + Border + 150 + 180, y + 160 + Border + 20 * 5 + 20 * 5 + 23 + 20 * 2 + 20, 180, 25, corner, "Close all orders", "Arial", 11, clrWhite, clrDarkGray, clrNONE, false, false, false, true, 0);
            startButtontext = "Pause";
            strat_trade = true;
         }
      }
   }
   else
   {
      ObjectsDeleteAll(0, OwnObjectNames[16]);
      ObjectsDeleteAll(0, OwnObjectNames[17]);
      startButtontext = "Start";
      interfaceError = " ";
      strat_trade = false;
   }
   ObjectSetString(0, "template-StartTrader", OBJPROP_TEXT, startButtontext);

   if (interfaceError != " ")
      ObjectSetString(0, "template-Interface-Error", OBJPROP_TEXT, interfaceError);
   else
      ObjectSetString(0, "template-Interface-Error", OBJPROP_TEXT, " ");
   ////////////////////////////
}

double CalculatePercentage()
{
   double total = NormalizeDouble(AccountInfoDouble(ACCOUNT_BALANCE), 2);
   double value = CalculateDrawDown();
   return (value / total) * 100;
}
double CalculateAccuracy()
{
   double accuracy = 0.0;

   if (ClosedTades > 0)
   {
      accuracy = (double)won / ClosedTades * 100.0;
   }

   return accuracy;
}