//+------------------------------------------------------------------+
//|                                             peakFindAndTrade.mqh |
//|                                   Copyright 2022, Ronald Hector. |
//|                                                         https:// |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, Ronald Hector."
#property link "https://"
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
int FindPeak(int MagicF, int index, double PriceBid, double PriceAsk, string CurrentSymbol, int mode, int count, int startBar, string barType)
{
   double Bid = PriceBid;
   double Equity = AccountInfoDouble(ACCOUNT_EQUITY);
   double Profit = AccountInfoDouble(ACCOUNT_PROFIT);
   double ask = PriceAsk;
   double point = NormalizeDouble(SymbolInfoDouble(CurrentSymbol, SYMBOL_POINT), _Digits);

   if (mode != MODE_HIGH && mode != MODE_LOW)
      return (-1);

   int currentBar = startBar;
   int foundBar = FindNextPeak(index, CurrentSymbol, mode, count * 2 + 1, currentBar - count);
   while (foundBar != currentBar)
   {
      currentBar = FindNextPeak(index, CurrentSymbol, mode, count, currentBar + 1);
      foundBar = FindNextPeak(index, CurrentSymbol, mode, count * 2 + 1, currentBar - count);

      ObjectDelete(0, "highPointIndicator-" + IntegerToString(foundBar) + CurrentSymbol);
      ObjectCreate(0, "highPointIndicator-" + IntegerToString(foundBar) + CurrentSymbol, (ENUM_OBJECT)chartArrow(barType), 0, iTime(CurrentSymbol, T[index], foundBar), iHigh(CurrentSymbol, T[index], foundBar));
      ObjectSetInteger(0, "highPointIndicator-" + IntegerToString(foundBar) + CurrentSymbol, OBJPROP_COLOR, chartArrowColor(barType));
      ObjectSetInteger(0, "highPointIndicator-" + IntegerToString(foundBar) + CurrentSymbol, OBJPROP_WIDTH, 3);

      CopyRates(CurrentSymbol, T[index], 0, MAX_CANDELS / 2, candels);
      CopyClose(CurrentSymbol, T[index], 0, MAX_CANDELS / 2, closes);

      int index_highest = ArrayMaximum(closes, 0, MAX_CANDELS);
      int index_lowest = ArrayMinimum(closes, 0, MAX_CANDELS);

      ObjectDelete(0, "TrendLineHigh" + CurrentSymbol);
      ObjectCreate(0, "TrendLineHigh" + CurrentSymbol, OBJ_HLINE, 0, 0, candels[index_highest].close);

      ObjectDelete(0, "TrendLineLow" + CurrentSymbol);
      ObjectCreate(0, "TrendLineLow" + CurrentSymbol, OBJ_HLINE, 0, 0, candels[index_lowest].close);

      ObjectSetInteger(0, "TrendLineHigh" + CurrentSymbol, OBJPROP_COLOR, clrGold);
      ObjectSetInteger(0, "TrendLineLow" + CurrentSymbol, OBJPROP_COLOR, clrGold);

      ObjectSetInteger(0, "TrendLineHigh" + CurrentSymbol, OBJPROP_WIDTH, 2);
      ObjectSetInteger(0, "TrendLineLow" + CurrentSymbol, OBJPROP_WIDTH, 2);

      ObjectMove(0, "TrendLineHigh" + CurrentSymbol, 0, 0, candels[index_highest].close);
      ObjectMove(0, "TrendLineLow" + CurrentSymbol, 0, 0, candels[index_lowest].close);

      int index_highest2 = ArrayMaximum(prevFoundHigh, (ArraySize(prevFoundHigh) - 1), MAX_CANDELS);
      int index_lowest2 = ArrayMinimum(prevFoundLow, (ArraySize(prevFoundLow) - 1), MAX_CANDELS);
      double prevHigh = (index_highest2 != -1) ? prevFoundHigh[index_highest2] : 0.0;
      double prevLow = (index_lowest2 != -1) ? prevFoundLow[index_lowest2] : 0.0;

      // double prevHigh = (ArraySize(prevFoundHigh) > 0) ? prevFoundHigh[ArraySize(prevFoundHigh)-1] : 0.0;
      // double prevLow = (ArraySize(prevFoundLow) > 0) ? prevFoundLow[ArraySize(prevFoundLow)-1] : 0.0;
      double foundBarLowprice = iHigh(CurrentSymbol, T[index], foundBar);
      double foundBarHighprice = iHigh(CurrentSymbol, T[index], foundBar);
      double currentBarLowprice = iHigh(CurrentSymbol, T[index], currentBar);
      double currentBarHighprice = iHigh(CurrentSymbol, T[index], currentBar);
      if ((foundBarHighprice != 0.0) && (prevLow != foundBarLowprice))
      {

         ObjectDelete(0, "TrendLineHigh-" + DoubleToString(ask) + CurrentSymbol);
         ObjectCreate(0, "TrendLineHigh-" + DoubleToString(ask) + CurrentSymbol, OBJ_HLINE, 0, iTime(CurrentSymbol, T[index], foundBar), iHigh(CurrentSymbol, T[index], foundBar));
         ObjectSetInteger(0, "TrendLineHigh-" + DoubleToString(ask) + CurrentSymbol, OBJPROP_COLOR, chartFixedTrendingLineColor(barType));
         ObjectSetInteger(0, "TrendLineHigh-" + DoubleToString(ask) + CurrentSymbol, OBJPROP_WIDTH, 2);

         if (barType == "High")
         {
            // double tp = (candels[index_highest].close - ((point*getSpread()) + (point*2)));
            double tp = foundBarHighprice ;
            // modifySellTrade(Bid, point, barType, ask);
            addPrevFoundHigh(foundBarHighprice);
            // if (
            //     (prevHigh != 0.0) 
            //     && (candels[index_lowest].close == Bid) 
            //     && ask < tp)
            if(
               (prevHigh != 0.0) 
               && ( foundBarLowprice > Bid)
            && (candels[index_lowest].close == Bid) 
            )
            {
               if (
                   !searchArray(ArraySize(openBuyOrder), ask, 1)
                  // !searchArray(ArraySize(openOrders),candels[index_highest].close,5)
                   //&& !searchArray(ArraySize(prevFoundHigh),foundBarHighprice,4)
               )
               {
                  if (
                     isMintradeSize(ask, 1, point)
                     )
                  {
                  
                     // int MagicNumber = GetNextMagicNumber();
                     
                     /////////// buy config /////////////
                     m_trade.SetExpertMagicNumber(MagicF);
                     double takeProfitPips = tp - ask;
                     double sl = ask-(takeProfitPips);
                     // double sl = candels[index_highest].close;
                     /////////// buy config /////////////

                     double CorrectedLot = OptimalLot( CurrentSymbol, takeProfitPips);
                     if (m_trade.Buy(CorrectedLot, CurrentSymbol, ask, sl, tp, NULL))
                     {
                        ulong Ticket = m_trade.ResultOrder();
                        addOpenBuyOrderBar(ask);
                        addPrevFoundHigh(foundBarHighprice);
                        addOpenOrder(MagicF);
                        order_magic = order_magic + 1;
                        sendSignal("'trade_status':'Open','trade_ticket':" + IntegerToString(Ticket) + ",'trade_type':'Buy','trade_price':" + DoubleToString(ask) + ",'take_profit':" + DoubleToString(tp) + ",'magic':" + IntegerToString(MagicF));
                     }
                  }
               }
            }
         }
      }
      if ((foundBarLowprice != 0.0) && (prevHigh != foundBarHighprice))
      {
         ObjectDelete(0, "TrendLineLow-" + DoubleToString(Bid) + CurrentSymbol);
         ObjectCreate(0, "TrendLineLow-" + DoubleToString(Bid) + CurrentSymbol, OBJ_HLINE, 0, iTime(CurrentSymbol, T[index], foundBar), iHigh(CurrentSymbol, T[index], foundBar));
         ObjectSetInteger(0, "TrendLineLow-" + DoubleToString(Bid) + CurrentSymbol, OBJPROP_COLOR, chartFixedTrendingLineColor(barType));
         ObjectSetInteger(0, "TrendLineLow-" + DoubleToString(Bid) + CurrentSymbol, OBJPROP_WIDTH, 2);

         if (barType == "Low")
         {
            // double tp = (candels[index_lowest].close - ((point*getSpread()) + (point*2)));
            double tp = foundBarLowprice;
            addPrevFoundLow(foundBarLowprice);
            // if (
            //     (prevLow != 0.0) 
            //     && (candels[index_highest].close == ask) 
            //     && Bid > tp)
            
            if((prevLow != 0.0) 
               && ( foundBarHighprice < ask)
            && (candels[index_highest].close == ask) )
            {
               if (
                   !searchArray(ArraySize(openSellOrder), Bid, 2)
                  // !searchArray(ArraySize(openOrders),candels[index_lowest].close,5)
                   //&& !searchArray(ArraySize(prevFoundLow),foundBarLowprice,3)
               )
               {
                  if (
                     isMintradeSize(Bid, 2, point)
                     )
                  {
                     // int MagicNumber = GetNextMagicNumber();
                     
                     /////////// sell config /////////////
                     m_trade.SetExpertMagicNumber(MagicF);
                     double takeProfitPips = Bid - tp;
                     double sl = Bid +(takeProfitPips);
                     // double sl = candels[index_highest].close;
                     /////////// sell config /////////////

                     double CorrectedLot = OptimalLot( CurrentSymbol, takeProfitPips);
                     if (m_trade.Sell(CorrectedLot, CurrentSymbol, Bid, sl, tp, NULL))
                     {
                        ulong Ticket = m_trade.ResultOrder();
                        addOpenSellOrderBar(Bid);
                        addPrevFoundLow(foundBarLowprice);
                        addOpenOrder(MagicF);
                        order_magic = order_magic + 1;
                        sendSignal("'trade_status':'Open','trade_ticket':" + IntegerToString(Ticket) + ",'trade_type':'Sell','trade_price':" + DoubleToString(Bid) + ",'take_profit':" + DoubleToString(tp) + ",'magic':" + IntegerToString(MagicF));
                     }
                  }
               }
            }
         }
      }
   }
   return (currentBar);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int FindNextPeak(int index, string CurrentSymbol, int mode, int count, int startBar)
{
   if (startBar < 0)
   {
      count += startBar;
      startBar = 0;
   }
   return ((mode == MODE_HIGH) ? iHighest(CurrentSymbol, T[index], (ENUM_SERIESMODE)mode, count, startBar) : iLowest(CurrentSymbol, T[index], (ENUM_SERIESMODE)mode, count, startBar));
}
//+------------------------------------------------------------------+
