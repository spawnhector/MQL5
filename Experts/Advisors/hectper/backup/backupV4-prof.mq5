//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2020, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#include<Trade\Trade.mqh>
CTrade trade;
#include <Trade\PositionInfo.mqh>
CPositionInfo  m_position;

double cls[];
MqlRates candels[];
double closes[];
MqlRates rte[];
double openBuyOrder[];
double openSellOrder[];
double prevFoundHigh[];
double prevFoundLow[];
double totalProfit;
double lot_size = 0.01;
long order_magic=55555;
int minTradeSize = 100;
const int MAX_CANDELS = 100;
int spBars = MAX_CANDELS; // must be greater than tpBars
int tpBars = MAX_CANDELS;
double Balance=AccountInfoDouble(ACCOUNT_BALANCE);

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int chartArrow(string charttype)
  {
   if(charttype == "High")
      return OBJ_ARROW_DOWN;
   return OBJ_ARROW_UP;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int chartArrowColor(string charttype)
  {
   if(charttype == "High")
      return clrRed;
   return clrBlue;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int chartFixedTrendingLineColor(string charttype)
  {
   if(charttype == "High")
      return clrRed;
   return clrBlue;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void closeOpenOrder(double orderprice)
  {

   for(int i=PositionsTotal()-1; i>=0; i--)  // returns the number of current positions
     {
      if(m_position.SelectByIndex(i))      // selects the position by index for further access to its properties
        {
         if(
            m_position.Symbol()==Symbol()
            && m_position.Magic()==order_magic
            && m_position.PriceOpen() == orderprice
         )
           {
            trade.PositionClose(m_position.Ticket());
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool isMintradeSize(double newtrade, int tradeType, double point)
  {
   switch(tradeType)
     {
      case 1:
         if((ArraySize(openBuyOrder) == 0))
            return true;
         if(
            (ArraySize(openBuyOrder) > 0)
            && (openBuyOrder[ArraySize(openBuyOrder)-1] - newtrade)
            >= (point * minTradeSize)
         )
           {
            return true;
           }
         break;
      case 2:
         if((ArraySize(openSellOrder) == 0))
            return true;
         if(
            (ArraySize(openSellOrder) > 0)
            && (openSellOrder[ArraySize(openSellOrder)-1] - newtrade)
            >= (point * minTradeSize)
         )
           {
            return true;
           }
         break;
     }
   return false;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool searchArray(int size, double target, int seachtype)
  {

   for(int i = 0; i < size; ++i)
     {
      switch(seachtype)
        {
         case 1:
            if(openBuyOrder[i] == target)
              {
               return true;
              }
            break;
         case 2:
            if(openSellOrder[i] == target)
              {
               return true;
              }
            break;
         case 3:
            if(prevFoundLow[i] == target)
              {
               return true;
              }
            break;
         case 4:
            if(prevFoundHigh[i] == target)
              {
               return true;
              }
            break;
        }
     }

   return false;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool tradeIsOpen(double price)
  {

   for(int u=PositionsTotal()-1; u>=0; u--)  // returns the number of current positions
     {
      if(m_position.SelectByIndex(u))      // selects the position by index for further access to its properties
        {
         if(
            m_position.Symbol()==Symbol()
            && m_position.Magic()==order_magic
            && m_position.PriceOpen() == price
         )
           {
           return true;
           }
        }
     }
           return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void modifyBuyTrade(double price, double point, string barType, double foundBar)
  {
   for(int i = 0; i < ArraySize(openBuyOrder); ++i)
     {
      if(
         (price > openBuyOrder[i])
         && (price - openBuyOrder[i])
         > (point * (getSpread()))
      ) // Gaining Trades
        {
         objectAction(price,point,barType,foundBar,1,1,openBuyOrder[i]);
        }
      if(price < openBuyOrder[i]) // Losing Trades
        {
         objectAction(price,point,barType,foundBar,1,2,openBuyOrder[i]);
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void modifySellTrade(double price, double point, string barType, double foundBar)
  {
   for(int i = 0; i < ArraySize(openSellOrder); ++i)
     {
      if(
         (price < openSellOrder[i])
         && (openSellOrder[i] - price)
         > (point * (getSpread())))
        {
         objectAction(price,point,barType,foundBar,2,1,openSellOrder[i]);
        }
      if(price > openSellOrder[i]) // Losing Trades
        {
         objectAction(price,point,barType,foundBar,2,2,openSellOrder[i]);
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void inProfitBuyTrade(int i, string barType,string needle, string trendFindRange, double price, double trendFindInt, double orderPrice)
  {
   if(StringFind(ObjectName(0,i,0,-1),trendFindRange,0) > -1)
     {
      double trendLinePrice = ObjectGetDouble(0,ObjectName(0,i,0,-1),OBJPROP_PRICE);
      ObjectSetInteger(0,ObjectName(0,i,0,-1),OBJPROP_COLOR,clrAzure);
      ObjectSetInteger(0,ObjectName(0,i,0,-1),OBJPROP_WIDTH,5);

      if(
         price < trendLinePrice
         && ((trendLinePrice - price) <= trendFindInt)
      )
        {
         double currentProfit = 0;
         for(int s = 0; s < ArraySize(openBuyOrder); ++s)
           {
            if(
               (trendLinePrice > openBuyOrder[s])
            )
              {
               for(int u=PositionsTotal()-1; u>=0; u--)  // returns the number of current positions
                 {
                  if(m_position.SelectByIndex(u))      // selects the position by index for further access to its properties
                    {
                     if(
                        m_position.Symbol()==Symbol()
                        && m_position.Magic()==order_magic
                        && m_position.PriceOpen() == openBuyOrder[s]
                     )
                       {
                        currentProfit = currentProfit + m_position.Profit();
                        //trade.PositionClose(m_position.Ticket());
                       }
                    }
                 }
              }
           }
         for(int s = 0; s < ArraySize(openBuyOrder); ++s)
           {
            if(
               (trendLinePrice > openBuyOrder[s])
               && (currentProfit >= 0)
            )
              {
               for(int u=PositionsTotal()-1; u>=0; u--)  // returns the number of current positions
                 {
                  if(m_position.SelectByIndex(u))      // selects the position by index for further access to its properties
                    {
                     if(
                        m_position.Symbol()==Symbol()
                        && m_position.Magic()==order_magic
                        && m_position.PriceOpen() == openBuyOrder[s]
                     )
                       {
                        trade.PositionClose(m_position.Ticket());
                       }
                    }
                 }
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void notInProfitBuyTrade(int i, string barType,string needle, string trendFindRange, double price, double trendFindInt, double orderPrice)
  {
//Print("index "+IntegerToString(tradeIndex)+" buy trade not in profit");
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void inProfitSellTrade(int i, string barType,string needle, string trendFindRange, double price, double trendFindInt, double orderPrice)
  {
   if(StringFind(ObjectName(0,i,0,-1),trendFindRange,0) > -1)
     {
      double trendLinePrice = ObjectGetDouble(0,ObjectName(0,i,0,-1),OBJPROP_PRICE);
      ObjectSetInteger(0,ObjectName(0,i,0,-1),OBJPROP_COLOR,clrBeige);
      ObjectSetInteger(0,ObjectName(0,i,0,-1),OBJPROP_WIDTH,5);

      if(
         price > trendLinePrice
         && ((price - trendLinePrice) <= trendFindInt)
      )
        {
         double currentProfit = 0;
         for(int s = 0; s < ArraySize(openSellOrder); ++s)
           {
            if(
               (trendLinePrice < openSellOrder[s])
            )
              {
               for(int u=PositionsTotal()-1; u>=0; u--)  // returns the number of current positions
                 {
                  if(m_position.SelectByIndex(u))      // selects the position by index for further access to its properties
                    {
                     if(
                        m_position.Symbol()==Symbol()
                        && m_position.Magic()==order_magic
                        && m_position.PriceOpen() == openSellOrder[s]
                     )
                       {
                        currentProfit = currentProfit + m_position.Profit();
                        //trade.PositionClose(m_position.Ticket());
                       }
                    }
                 }
              }
           }
         for(int s = 0; s < ArraySize(openSellOrder); ++s)
           {
            if(
               (trendLinePrice < openSellOrder[s])
               && (currentProfit >= 0)
            )
              {
               for(int u=PositionsTotal()-1; u>=0; u--)  // returns the number of current positions
                 {
                  if(m_position.SelectByIndex(u))      // selects the position by index for further access to its properties
                    {
                     if(
                        m_position.Symbol()==Symbol()
                        && m_position.Magic()==order_magic
                        && m_position.PriceOpen() == openSellOrder[s]
                     )
                       {
                        trade.PositionClose(m_position.Ticket());
                       }
                    }
                 }
              }
           }
        }
     }  //ObjectSetInteger(0,ObjectName(0,i,0,-1),OBJPROP_WIDTH,3);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void notInProfitSellTrade(int i, string barType,string needle, string trendFindRange, double price, double trendFindInt, double orderPrice)
  {
//Print("index "+IntegerToString(tradeIndex)+" sell trade not in profit");
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void objectAction(double price, double point, string barType, double foundBar, int tradeType, int tradeStatus, double orderPrice)
  {
   string needle;
   string trendFindRange;
   double trendFindInt = (point * 10);
   if(barType == "High")
     {
      needle = "TrendLineHigh-"+DoubleToString(price);
      trendFindRange = "TrendLineHigh-"+DoubleToString(foundBar);
     }

   if(barType == "Low")
     {
      needle = "TrendLineLow-"+DoubleToString(price);
      trendFindRange = "TrendLineLow-"+DoubleToString(foundBar);
     }

   int TotalObject;
   TotalObject = ObjectsTotal(0,0,-1);

   for(int i=0; i<TotalObject; i++)
     {
      if(tradeType == 1) // Buy
        {
         if(tradeStatus == 1) // In profit
            inProfitBuyTrade(i, barType, needle, trendFindRange, price, trendFindInt,orderPrice);
         if(tradeStatus == 2) // Not In Profit
            notInProfitBuyTrade(i, barType, needle, trendFindRange, price, trendFindInt,orderPrice);
        }
      if(tradeType == 2) // Sell
        {
         if(tradeStatus == 1) // In profit
            inProfitSellTrade(i, barType, needle, trendFindRange, price, trendFindInt,orderPrice);
         if(tradeStatus == 2) // Not In profit
            notInProfitSellTrade(i, barType, needle, trendFindRange, price, trendFindInt,orderPrice);

        }
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void addOpenBuyOrderBar(double bar)
  {
   ArrayResize(openBuyOrder,(ArraySize(openBuyOrder)+1));
   if(ArraySize(openBuyOrder) == 1)
     {
      openBuyOrder[0] = bar;
     }
   else
     {
      openBuyOrder[ArraySize(openBuyOrder) - 1] = bar;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void addOpenSellOrderBar(double bar)
  {
   ArrayResize(openSellOrder,(ArraySize(openSellOrder)+1));
   if(ArraySize(openSellOrder) == 1)
     {
      openSellOrder[0] = bar;
     }
   else
     {
      openSellOrder[ArraySize(openSellOrder) - 1] = bar;
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void addPrevFoundHigh(double bar)
  {
   ArrayResize(prevFoundHigh,(ArraySize(prevFoundHigh)+1));
   if(ArraySize(prevFoundHigh) == 1)
     {
      prevFoundHigh[0] = bar;
     }
   else
     {
      prevFoundHigh[ArraySize(prevFoundHigh) - 1] = bar;
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void addPrevFoundLow(double bar)
  {
   ArrayResize(prevFoundLow,(ArraySize(prevFoundLow)+1));
   if(ArraySize(prevFoundLow) == 1)
     {
      prevFoundLow[0] = bar;
     }
   else
     {
      prevFoundLow[ArraySize(prevFoundLow) - 1] = bar;
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double getSpread()
  {
   bool spreadfloat=SymbolInfoInteger(Symbol(),SYMBOL_SPREAD_FLOAT);
   string comm=StringFormat("Spread %s = %I64d points\r\n",
                            spreadfloat?"floating":"fixed",
                            SymbolInfoInteger(Symbol(),SYMBOL_SPREAD));
   double ask=SymbolInfoDouble(Symbol(),SYMBOL_ASK);
   double bid=SymbolInfoDouble(Symbol(),SYMBOL_BID);
   double spread=ask-bid;
   int spread_points=(int)MathRound(spread/SymbolInfoDouble(Symbol(),SYMBOL_POINT));
   return spread_points;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int FindPeak(int mode, int count, int startBar, string barType)
  {
   double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
   double Equity=AccountInfoDouble(ACCOUNT_EQUITY);
   double Profit=AccountInfoDouble(ACCOUNT_PROFIT);
   double ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   double point=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_POINT),_Digits);

   if(mode!=MODE_HIGH && mode!=MODE_LOW)
      return (-1);

   int currentBar = startBar;
   int foundBar = FindNextPeak(mode, count*2+1,currentBar-count);
   while(foundBar!=currentBar)
     {
      currentBar = FindNextPeak(mode, count, currentBar+1);
      foundBar = FindNextPeak(mode, count*2+1,currentBar-count);

      ObjectDelete(0,"highPointIndicator-"+IntegerToString(foundBar));
      ObjectCreate(0, "highPointIndicator-"+IntegerToString(foundBar),(ENUM_OBJECT)chartArrow(barType),0,iTime(Symbol(),Period(), foundBar),iHigh(Symbol(),Period(), foundBar));
      ObjectSetInteger(0,"highPointIndicator-"+IntegerToString(foundBar),OBJPROP_COLOR,chartArrowColor(barType));
      ObjectSetInteger(0,"highPointIndicator-"+IntegerToString(foundBar),OBJPROP_WIDTH,3);

      CopyRates(_Symbol,_Period,0,MAX_CANDELS/2,candels);
      CopyClose(_Symbol,_Period,0,MAX_CANDELS/2,closes);

      int index_highest = ArrayMaximum(closes,0,MAX_CANDELS/2);
      int index_lowest = ArrayMinimum(closes,0,MAX_CANDELS/2);

      ObjectDelete(0,"TrendLineHigh");
      ObjectCreate(0,"TrendLineHigh",OBJ_HLINE,0,0,candels[index_highest].close);

      ObjectDelete(0,"TrendLineLow");
      ObjectCreate(0,"TrendLineLow",OBJ_HLINE,0,0,candels[index_lowest].close);

      ObjectSetInteger(0,"TrendLineHigh",OBJPROP_COLOR,clrGold);
      ObjectSetInteger(0,"TrendLineLow",OBJPROP_COLOR,clrGold);

      ObjectSetInteger(0,"TrendLineHigh",OBJPROP_WIDTH,2);
      ObjectSetInteger(0,"TrendLineLow",OBJPROP_WIDTH,2);

      ObjectMove(0,"TrendLineHigh",0,0,candels[index_highest].close);
      ObjectMove(0,"TrendLineLow",0,0,candels[index_lowest].close);

      int index_highest2 = ArrayMaximum(prevFoundHigh,(ArraySize(prevFoundHigh)-spBars),MAX_CANDELS);
      int index_lowest2 = ArrayMinimum(prevFoundLow,(ArraySize(prevFoundLow)-spBars),MAX_CANDELS);
      double prevHigh = (index_highest2 != -1) ? prevFoundHigh[index_highest2] : 0.0;
      double prevLow = (index_lowest2 != -1) ? prevFoundLow[index_lowest2] : 0.0;

      //double prevHigh = (ArraySize(prevFoundHigh) > 0) ? prevFoundHigh[ArraySize(prevFoundHigh)-1] : 0.0;
      //double prevLow = (ArraySize(prevFoundLow) > 0) ? prevFoundLow[ArraySize(prevFoundLow)-1] : 0.0;
      double foundBarLowprice = iHigh(Symbol(),Period(), foundBar);
      double foundBarHighprice = iLow(Symbol(),Period(), foundBar);
      if((foundBarHighprice != 0.0) && (prevLow != foundBarLowprice))
        {

         ObjectDelete(0,"TrendLineHigh-"+DoubleToString(ask));
         ObjectCreate(0,"TrendLineHigh-"+DoubleToString(ask),OBJ_HLINE,0,iTime(Symbol(),Period(), foundBar),iHigh(Symbol(),Period(), foundBar));
         ObjectSetInteger(0,"TrendLineHigh-"+DoubleToString(ask),OBJPROP_COLOR,chartFixedTrendingLineColor(barType));
         ObjectSetInteger(0,"TrendLineHigh-"+DoubleToString(ask),OBJPROP_WIDTH,2);

         if(barType == "High")
           {
            modifyBuyTrade(Bid, point,barType, ask);
            addPrevFoundHigh(foundBarHighprice);
            if(
               (prevHigh != 0.0)
               && (candels[index_highest].close > Bid)
               && (candels[index_lowest].close == prevLow)
               && (Bid == candels[index_lowest].close)
            )
              {
               if(
                  !searchArray(ArraySize(openBuyOrder),ask,1)
                  && !searchArray(ArraySize(prevFoundLow),foundBarLowprice,3)
               )
                 {
                  if(
                     ArraySize(prevFoundLow) > (tpBars)
                     && isMintradeSize(
                        ask,1,point
                     )
                  )
                    {
                     MqlTradeRequest request= {};
                     request.action=TRADE_ACTION_DEAL;
                     request.magic=order_magic;
                     request.symbol=_Symbol;
                     request.volume=lot_size;
                     //request.sl=candels[index_lowest].close;
                     request.tp= candels[index_highest]
                                 .close;
                     request.type=ORDER_TYPE_BUY;
                     request.price=ask;
                     MqlTradeResult result= {};
                     int ticket = OrderSend(request,result);
                     if(ticket)
                       {
                        addOpenBuyOrderBar(ask);
                        addPrevFoundLow(foundBarLowprice);
                       }
                    }
                 }
              }
           }
        }
      if((foundBarLowprice != 0.0) && (prevHigh != foundBarHighprice))
        {

         ObjectDelete(0,"TrendLineLow-"+DoubleToString(Bid));
         ObjectCreate(0,"TrendLineLow-"+DoubleToString(Bid),OBJ_HLINE,0,iTime(Symbol(),Period(), foundBar),iHigh(Symbol(),Period(), foundBar));
         ObjectSetInteger(0,"TrendLineLow-"+DoubleToString(Bid),OBJPROP_COLOR,chartFixedTrendingLineColor(barType));
         ObjectSetInteger(0,"TrendLineLow-"+DoubleToString(Bid),OBJPROP_WIDTH,2);

         if(barType == "Low")
           {
            modifySellTrade(ask, point, barType, Bid);
            addPrevFoundLow(foundBarLowprice);
            if(
               (prevLow != 0.0)
               && (candels[index_lowest].close < Bid)
               && (candels[index_highest].close == prevHigh)
               && (Bid == candels[index_highest].close)
            )
              {
               if(
                  !searchArray(ArraySize(openSellOrder),Bid,2)
                  && !searchArray(ArraySize(prevFoundHigh),foundBarHighprice,4)
               )
                 {
                  if(
                     ArraySize(prevFoundHigh) > (tpBars)
                     && isMintradeSize(
                        Bid,2,point
                     )
                  )
                    {
                     MqlTradeRequest request= {};
                     request.action=TRADE_ACTION_DEAL;
                     request.magic=order_magic;
                     request.symbol=_Symbol;
                     request.volume=lot_size;
                     //request.sl=candels[index_highest].close;
                     request.tp=candels[index_lowest].close;
                     request.type=ORDER_TYPE_SELL;
                     request.price=Bid;
                     MqlTradeResult result= {};
                     int ticket = OrderSend(request,result);
                     if(ticket)
                       {
                        addOpenSellOrderBar(Bid);
                        addPrevFoundHigh(foundBarHighprice);
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
int FindNextPeak(int mode, int count, int startBar)
  {
   if(startBar < 0)
     {
      count += startBar;
      startBar = 0;
     }
   return ((mode == MODE_HIGH) ?
           iHighest(Symbol(), Period(),(ENUM_SERIESMODE)mode, count, startBar) :
           iLowest(Symbol(), Period(),(ENUM_SERIESMODE)mode, count, startBar)
          );
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CreateHighLow(int shoulder,string timeframe,int clr)
  {

   int bar1;
   int bar2;

   bar1 = FindPeak(MODE_HIGH, shoulder, 1, "High");
   bar2 = FindPeak(MODE_HIGH, shoulder, bar1+1, "High");

   ObjectDelete(0,"upper"+timeframe);
   ObjectCreate(0, "upper"+timeframe,OBJ_TREND,0,iTime(Symbol(),Period(), bar2),iHigh(Symbol(),Period(), bar2),iTime(Symbol(),Period(), bar1),iHigh(Symbol(),Period(), bar1));
   ObjectSetInteger(0,"upper"+timeframe,OBJPROP_COLOR,clr);
   ObjectSetInteger(0,"upper"+timeframe,OBJPROP_WIDTH,2);
//ObjectSetInteger(0,"upper"+timeframe,OBJPROP_RAY_RIGHT,true);

//--- create point indication

   bar1 = FindPeak(MODE_LOW, shoulder, 1, "Low");
   bar2 = FindPeak(MODE_LOW, shoulder, bar1+1, "Low");

   ObjectDelete(0,"lower"+timeframe);
   ObjectCreate(0,"lower"+timeframe,OBJ_TREND,0,iTime(Symbol(),Period(), bar2),iLow(Symbol(),Period(), bar2),iTime(Symbol(),Period(), bar1),iLow(Symbol(),Period(), bar1));
   ObjectSetInteger(0,"lower"+timeframe,OBJPROP_COLOR,clr);
   ObjectSetInteger(0,"lower"+timeframe,OBJPROP_WIDTH,2);
//ObjectSetInteger(0,"lower"+timeframe,OBJPROP_RAY_RIGHT,true);


  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CreateMovingTrendLines()
  {
   CopyRates(_Symbol,_Period,0,MAX_CANDELS/2,candels);
   CopyClose(_Symbol,_Period,0,MAX_CANDELS/2,closes);

   int index_highest = ArrayMaximum(closes,0,MAX_CANDELS);
   int index_lowest = ArrayMinimum(closes,0,MAX_CANDELS);

   ObjectDelete(0,"TrendLineHigh");
   ObjectCreate(0,"TrendLineHigh",OBJ_HLINE,0,0,candels[index_highest].close);

   ObjectDelete(0,"TrendLineLow");
   ObjectCreate(0,"TrendLineLow",OBJ_HLINE,0,0,candels[index_lowest].close);

   ObjectSetInteger(0,"TrendLineHigh",OBJPROP_COLOR,clrGold);
   ObjectSetInteger(0,"TrendLineLow",OBJPROP_COLOR,clrGold);

   ObjectSetInteger(0,"TrendLineHigh",OBJPROP_WIDTH,2);
   ObjectSetInteger(0,"TrendLineLow",OBJPROP_WIDTH,2);

   ObjectMove(0,"TrendLineHigh",0,0,candels[index_highest].close);
   ObjectMove(0,"TrendLineLow",0,0,candels[index_lowest].close);

  }
//---


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void cleardata()
  {
   if(ArraySize(cls) > ((MAX_CANDELS * 2) + 100))
      ArrayFree(cls);
   if(ArraySize(candels) > ((MAX_CANDELS * 2) + 100))
      ArrayFree(candels);
   if(ArraySize(closes) > ((MAX_CANDELS * 2) + 100))
      ArrayFree(closes);
   if(ArraySize(rte) > ((MAX_CANDELS * 2) + 100))
      ArrayFree(rte);
   if(ArraySize(openBuyOrder) > ((MAX_CANDELS * 2) + 100))
      ArrayFree(openBuyOrder);
   if(ArraySize(openSellOrder) > ((MAX_CANDELS * 2) + 100))
      ArrayFree(openSellOrder);
   if(ArraySize(prevFoundHigh) > ((MAX_CANDELS * 2) + 100))
      ArrayFree(prevFoundHigh);
   if(ArraySize(prevFoundLow) > ((MAX_CANDELS * 2) + 100))
      ArrayFree(prevFoundLow);
   if(ObjectsTotal(0,0,-1) > ((MAX_CANDELS * 2) + 100))
      ObjectsDeleteAll(0,0,-1);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int getArrayIndex(int size, double target,double &arr[])
  {

   for(int i = 0; i < size; ++i)
     {
      if(arr[i] == target)
        {
         return i;
        }
     }

   return -1;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void RemoveIndexFromArray(double &MyArray[],int index)
  {
   string TempArray[];
   ArrayCopy(TempArray,MyArray,0,0,index);
   ArrayCopy(TempArray,MyArray,index,(index+1));
   ArrayFree(MyArray);
   ArrayCopy(MyArray,TempArray,0,0);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void removeClosedTrades()
  {
//--- request trade history

   HistorySelect(0,TimeCurrent());
//--- create objects

   uint     total=HistoryDealsTotal();
   ulong    ticket=0;
   double   price;
   datetime time;
   string   symbol;
   long     type;
   long     entry;
   string _comment;
   string direction;
   string _result;
   double profit;
//--- for all deals
   for(uint i=0; i<total; i++)
     {
      //--- try to get deals ticket
      if((ticket=HistoryDealGetTicket(i))>0)
        {
         //--- get deals properties
         price =HistoryDealGetDouble(ticket,DEAL_PRICE);
         time  =(datetime)HistoryDealGetInteger(ticket,DEAL_TIME);
         symbol=HistoryDealGetString(ticket,DEAL_SYMBOL);
         type  =HistoryDealGetInteger(ticket,DEAL_TYPE);
         entry =HistoryDealGetInteger(ticket,DEAL_ENTRY);
         profit=HistoryDealGetDouble(ticket,DEAL_PROFIT);
         _comment =HistoryDealGetString(ticket,DEAL_COMMENT);

         if(type==0)
           {
            direction = "Buy";
           }
         if(type==1)
           {
            direction = "Sell";
           }
         if(_comment[1]!=NULL && _comment [1]==115)  // it returns ASCI character 115 it means "S"  Comment [SL 1.3746"]
           {
            _result = "SL";
           }
         if(_comment[1]!=NULL && _comment [1]==116)   //it returns ASCI character 115 it means "T"  Comment [TP 1.3799"]
           {
            _result = "TP";
           }
         if(symbol==Symbol())
           {
            if(direction == "Buy" && (ArraySize(openBuyOrder) > 0))
              {
               //Print("buy ",searchArray(ArraySize(openBuyOrder),price,1));
               //Print(price);
              }
            if(
               direction == "Sell"
               && (ArraySize(openSellOrder) > 0)
               && searchArray(ArraySize(openSellOrder),price,2)
               //&& (_result == "TP")
            )
              {
               //RemoveIndexFromArray(openSellOrder,getArrayIndex(ArraySize(openSellOrder),price,openSellOrder)); // delete open trade
               //Print("sell ",getArrayIndex(ArraySize(openSellOrder),price,openSellOrder));
               //Print(_result);
              }
            //totalProfit = totalProfit + profit;
            //Print(price);
            //Print(totalProfit);
            //Alert(Symbol()+ " ___ " +  ticket+ "____"+ direction +"________ " + _result  + " _____" " ______ :" +price);

           }
        }
     }

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
   ArraySetAsSeries(candels,true);
   ArraySetAsSeries(closes,true);
   ArraySetAsSeries(rte,true);
   ArraySetAsSeries(openBuyOrder,true);
   ArraySetAsSeries(openSellOrder,true);
   ArraySetAsSeries(prevFoundHigh,true);
   ArraySetAsSeries(prevFoundLow,true);
   
   return INIT_SUCCEEDED;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   cleardata();
// removeClosedTrades();
//--- scale highest and lowest piont
   CreateHighLow(MAX_CANDELS,"m1",clrGainsboro);
//CreateMovingTrendLines();

  }
//+------------------------------------------------------------------+
