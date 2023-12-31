//+------------------------------------------------------------------+
//|                                        CreateSimpleInterface.mqh |
//|                                                    ronald Hector |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "ronald Hector"
#property link "https://www.mql5.com"
#include <ChartObjects\ChartObject.mqh>

void CreateSimpleInterface() // create a simple interface
{
   // long chartWidth = ChartGetInteger(0, CHART_WIDTH_IN_PIXELS);
   // long chartHeight = ChartGetInteger(0, CHART_HEIGHT_IN_PIXELS);
   // ArrayPrint(provs.providers);
   ENUM_BASE_CORNER corner = CORNER_LEFT_UPPER; // position all elements in the left corner
   long x = 0;                                  // offset along X;
   long y = 0;                                  // offset along Y;
   long Width = 510;                            // width
   long SignalPanelWidth = Width / 2;           // width
   long Height = 470;                           // height
   int Border = 3;                              // border
   long xx = Width + x + Border;                // offset along X;
   long yy = 0;                                 // offset along Y;

   RectLabelCreateResizable(0, OwnObjectNames[0], 0, x, y, Width + 2 * Border, Height + 2 * Border, clrPink, BORDER_RAISED, corner, clrOrchid, STYLE_SOLID, 3, false, false, true, 0); // border
   RectLabelCreateResizable(0, OwnObjectNames[1], 0, x + Border, y + Border, Width, Height, clrBlueViolet, BORDER_RAISED, corner, clrOrchid, STYLE_SOLID, 3, false, false, true, 0);   // main panel
   // text elements
   LabelCreate(0, OwnObjectNames[2], 0, x + Border + 21, y + Border + 4, corner, " Hectper Scalper Multi Charts Scalping", "Arial", 11, clrWhite, 0.0); // EA name
   //
   RectLabelCreateResizable(0, OwnObjectNames[18], 0, x + Border, y + Border + 30, Width, 5, clrWhite, BORDER_RAISED, corner, clrOrchid, STYLE_SOLID, 0, false, false, true, 0); // first separator
   // text elements
   LabelCreate(0, OwnObjectNames[3], 0, x + Border + 2, y + 17 + Border + 30 * 1, corner, "Instruments-timeframes : ", "Arial", 11, clrWhite, 0.0, ANCHOR_LEFT); // balance
   LabelCreate(0, OwnObjectNames[4], 0, x + Border + 2, y + 17 + Border + 25 * 2, corner, "Balance : ", "Arial", 11, clrWhite, 0.0, ANCHOR_LEFT);                // equity
   LabelCreate(0, OwnObjectNames[7], 0, x + Border + 2, y + 17 + Border + 25 * 3, corner, "Broker : ", "Arial", 11, clrWhite, 0.0, ANCHOR_LEFT);                 // leverage
   LabelCreate(0, OwnObjectNames[6], 0, x + Border + 2, y + 17 + Border + 25 * 4, corner, "Profit : ", "Arial", 11, clrWhite, 0.0, ANCHOR_LEFT);                 // broker
   LabelCreate(0, OwnObjectNames[8], 0, x + Border + 2, y + 17 + Border + 25 * 5, corner, "Leverage : ", "Arial", 11, clrWhite, 0.0, ANCHOR_LEFT);               // spread
   //
   RectLabelCreateResizable(0, OwnObjectNames[19], 0, x + Border, y + Border + 55 + 100, Width, 5, clrWhite, BORDER_RAISED, corner, clrOrchid, STYLE_SOLID, 0, false, false, true, 0); // second separator
   // text elements
   LabelCreate(0, OwnObjectNames[9], 0, x + Border + 2, y + 17 + Border + 28 * 5 + 20, corner, "Buy positions : ", "Arial", 11, clrWhite, 0.0, ANCHOR_LEFT);            // buy positions
   LabelCreate(0, OwnObjectNames[10], 0, x + Border + 2, y + 17 + Border + 30 * 5 + 20 * 2, corner, "Sell positions : ", "Arial", 11, clrWhite, 0.0, ANCHOR_LEFT);      // sell positions
   LabelCreate(0, OwnObjectNames[11], 0, x + Border + 2, y + 17 + Border + 30 * 5 + 25 * 3, corner, "Buy lots : ", "Arial", 11, clrWhite, 0.0, ANCHOR_LEFT);            // volume of buy positions
   LabelCreate(0, OwnObjectNames[12], 0, x + Border + 2, y + 17 + Border + 30 * 5 + 25 * 4, corner, "Sell lots : ", "Arial", 11, clrWhite, 0.0, ANCHOR_LEFT);           // volume of sell positions
   LabelCreate(0, OwnObjectNames[5], 0, x + Border + 2, y + 17 + Border + 30 * 5 + 25 * 5, corner, "Equity : ", "Arial", 11, clrWhite, 0.0, ANCHOR_LEFT);               // profit of floating positions
   LabelCreate(0, "template-DrawDown", 0, x + Border + 2, y + 17 + Border + 30 * 5 + 25 * 6, corner, "Draw Down : ", "Arial", 11, clrWhite, 0.0, ANCHOR_LEFT);          // drawdown of floating positions
   LabelCreate(0, "template-ClosedTrades", 0, x + Border + 2, y + 17 + Border + 30 * 5 + 25 * 7, corner, "Closed Trades : ", "Arial", 11, clrWhite, 0.0, ANCHOR_LEFT);  // drawdown of floating positions
   LabelCreate(0, "template-TradesWon", 0, x + Border + 2, y + 17 + Border + 30 * 5 + 25 * 8, corner, "Trades Won : ", "Arial", 11, clrWhite, 0.0, ANCHOR_LEFT);        // drawdown of floating positions
   LabelCreate(0, "template-TradesLoss", 0, x + Border + 2, y + 17 + Border + 30 * 5 + 25 * 9, corner, "Trades Loss : ", "Arial", 11, clrWhite, 0.0, ANCHOR_LEFT);      // drawdown of floating positions
   LabelCreate(0, "template-Accracy", 0, x + Border + 2, y + 17 + Border + 30 * 5 + 25 * 10, corner, "Percentage Accuracy: ", "Arial", 11, clrWhite, 0.0, ANCHOR_LEFT); // drawdown of floating positions
   //
   RectLabelCreateResizable(0, OwnObjectNames[20], 0, x + Border, y + Border + 25 + 100 + 100, Width, 5, clrWhite, BORDER_RAISED, corner, clrOrchid, STYLE_SOLID, 0, false, false, true, 0); // third separator
   // text elements
   // LabelCreate(0,OwnObjectNames[13],0,x+Border+2,y+17+Border+20*5+20*5+23,corner,"","Arial",11,clrWhite,0.0,ANCHOR_LEFT);//UNSIGNED1
   // LabelCreate(0,OwnObjectNames[14],0,x+Border+2,y+17+Border+20*5+20*5+23+20*1,corner,"","Arial",11,clrWhite,0.0,ANCHOR_LEFT);//UNSIGNED1
   // LabelCreate(0,OwnObjectNames[15],0,x+Border+2,y+17+Border+20*5+20*5+23+20*2,corner,"","Arial",11,clrWhite,0.0,ANCHOR_LEFT);//UNSIGNED2
   //
   RectLabelCreateResizable(0, OwnObjectNames[21], 0, x + Border, y + 130 + Border + 40 + 100 + 95 + 72, Width, 5, clrWhite, BORDER_RAISED, corner, clrOrchid, STYLE_SOLID, 0, false, false, true, 0); // fourth separator
   ButtonCreate(0, "template-StartTrader", 0, x + Border, y + 160 + Border + 20 * 5 + 20 * 5 + 23 + 20 * 2 + 20, 150, 25, corner, "Start", "Arial", 11, clrWhite, clrCrimson, clrNONE, false, false, false, true, 0);
   LabelCreate(0, "template-Interface-Error", 0, x + Border + 190, y + 170 + Border + 20 * 5 + 20 * 5 + 23 + 20 * 2 + 20, corner, " ", "Arial", 11, clrWhite, 0.0, ANCHOR_LEFT); // balance
   // ButtonCreate(0,"template-Setting",0,x+Border+30+180+200,y+Border+4,50,24,corner,"⚙","Arial",11,clrWhite,clrDarkGray,clrNONE,false,false,false,true,0);

   RectLabelCreateResizable(0, "template-SignalPanelBorder", 0, xx, yy, SignalPanelWidth + 2 * Border, Height + 2 * Border, clrPink, BORDER_RAISED, corner, clrOrchid, STYLE_SOLID, 3, false, false, true, 0); // border
   RectLabelCreateResizable(0, "template-SignalPanel", 0, xx + Border, yy + Border, SignalPanelWidth, Height, clrBlueViolet, BORDER_RAISED, corner, clrOrchid, STYLE_SOLID, 3, false, false, true, 0);         // main panel
   LabelCreate(0, "template-SelectSignalproviderLabel", 0, xx + Border + 21, yy + Border + 4, corner, " Select Signal Provider", "Arial", 11, clrWhite, 0.0);
   RectLabelCreateResizable(0, "template-Signalprovider-first-separtor", 0, xx + Border, yy + Border + 30, SignalPanelWidth, 5, clrWhite, BORDER_RAISED, corner, clrOrchid, STYLE_SOLID, 0, false, false, true, 0); // first separator                                // EA name

   int selectStep = 35;
   int countSelect = selectStep;
   if (Signals)
      for (int i = 0; i < ArraySize(_PROVIDERS); i++)
      {
         ProviderData providerStorage = _PROVIDERS[i].GetProviderData();
         LabelCreate(0, "template-Signalprovider-select-" + providerStorage.ProviderName, 0, xx + Border + 4, yy + 17 + Border + countSelect * 1, corner, providerStorage.ProviderName, "Arial", 11, clrWhite, 0.0, ANCHOR_LEFT); // balance
         ButtonCreate(0, "template-Signalprovider-select-button-" + providerStorage.ProviderName, 0, Width + SignalPanelWidth - 50, yy + 6 + Border + countSelect * 1, 50, 28, corner, "▶️", "Arial", 11, clrWhite, clrDarkGray, clrNONE, false, false, false, true, 0);
         countSelect = countSelect + selectStep;
      };
}
