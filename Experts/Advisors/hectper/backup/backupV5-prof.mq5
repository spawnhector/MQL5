//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2020, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#include<Trade\Trade.mqh>
CTrade trade;

double cls[];
MqlRates candels[];
double closes[];
MqlRates rte[];
double openOrder[];
double prevFoundHigh[];
double prevFoundLow[];
double lot_size = 0.01;
long order_magic=55555;
const int MAX_CANDELS = 200;
int spBars = 200; // must be greater than tpBars
int tpBars = 200;
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
bool searchArray(int size, double target)
  {
   for(int i = 0; i < size; ++i)
     {
      if(openOrder[i] == target)
        {
         return true;
        }
     }

   return false;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void addOpenOrderBar(double bar)
  {
   ArrayResize(openOrder,(ArraySize(openOrder)+1));
   if(ArraySize(openOrder) == 1)
     {
      openOrder[0] = bar;
     }
   else
     {
      openOrder[ArraySize(openOrder) - 1] = bar;
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

      ObjectDelete(0,"highPointIndicator"+IntegerToString(foundBar));
      ObjectCreate(0, "highPointIndicator"+IntegerToString(foundBar),(ENUM_OBJECT)chartArrow(barType),0,iTime(Symbol(),Period(), foundBar),iHigh(Symbol(),Period(), foundBar));
      ObjectSetInteger(0,"highPointIndicator"+IntegerToString(foundBar),OBJPROP_COLOR,chartArrowColor(barType));
      ObjectSetInteger(0,"highPointIndicator"+IntegerToString(foundBar),OBJPROP_WIDTH,3);

      ObjectDelete(0,"TrendLineHigh"+IntegerToString(foundBar));
      ObjectDelete(0,"TrendLineLow"+IntegerToString(foundBar));
      ObjectCreate(0,"TrendLineHigh"+IntegerToString(foundBar),OBJ_HLINE,0,iTime(Symbol(),Period(), foundBar),iHigh(Symbol(),Period(), foundBar));
      ObjectCreate(0,"TrendLineLow"+IntegerToString(foundBar),OBJ_HLINE,0,iTime(Symbol(),Period(), foundBar),iHigh(Symbol(),Period(), foundBar));

      ObjectSetInteger(0,"TrendLineHigh"+IntegerToString(foundBar),OBJPROP_COLOR,chartFixedTrendingLineColor(barType));
      ObjectSetInteger(0,"TrendLineLow"+IntegerToString(foundBar),OBJPROP_COLOR,chartFixedTrendingLineColor(barType));

      ObjectSetInteger(0,"TrendLineHigh"+IntegerToString(foundBar),OBJPROP_WIDTH,2);
      ObjectSetInteger(0,"TrendLineLow"+IntegerToString(foundBar),OBJPROP_WIDTH,2);

      
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
      double foundBarLowprice = (barType == "Low") ? iLow(Symbol(),Period(), foundBar) : 0.00;
      double foundBarHighprice = (barType == "High") ? iHigh(Symbol(),Period(), foundBar) : 0.00;
      if((foundBarHighprice != 0.0) && (prevHigh != foundBarHighprice))
        {
         if(barType == "High")
           {
            if((prevHigh != 0.0) && (candels[index_highest].close > Bid) && (Bid == candels[index_lowest].close))
              {
               if(!searchArray(ArraySize(openOrder),candels[index_highest].close))
                 {
                  if(ArraySize(prevFoundLow) > (tpBars))
                    {
                     MqlTradeRequest request= {};
                     request.action=TRADE_ACTION_PENDING;
                     request.magic=order_magic;
                     request.symbol=_Symbol;
                     request.volume=lot_size;
                     request.sl=prevHigh;
                     request.tp= candels[index_lowest].close;
                     request.type=ORDER_TYPE_SELL_LIMIT;
                     request.price=candels[index_highest].close;
                     MqlTradeResult result= {};
                     int ticket = OrderSend(request,result);
                     if(ticket)
                       {
                        addOpenOrderBar(candels[index_highest].close);
                       }
                    }
                 }
              }
            addPrevFoundHigh(foundBarHighprice);
           }
        }
      if((foundBarLowprice != 0.0) && (prevLow != foundBarLowprice))
        {
         if(barType == "Low")
           {
            addPrevFoundLow(foundBarLowprice);
            if((prevLow != 0.0) && (candels[index_lowest].close < Bid) && (Bid == candels[index_highest].close))
              {
               if(!searchArray(ArraySize(openOrder),candels[index_lowest].close))
                 {
                  if(ArraySize(prevFoundHigh) > (tpBars))
                    {
                     MqlTradeRequest request= {};
                     request.action=TRADE_ACTION_PENDING;
                     request.magic=order_magic;
                     request.symbol=_Symbol;
                     request.volume=lot_size;
                     request.sl=prevLow;
                     request.tp=candels[index_highest].close;
                     request.type=ORDER_TYPE_BUY_LIMIT;
                     request.price=candels[index_lowest].close;
                     MqlTradeResult result= {};
                     int ticket = OrderSend(request,result);
                     if(ticket)
                       {
                        addOpenOrderBar(candels[index_lowest].close);
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
int OnInit()
  {
   ArraySetAsSeries(candels,true);
   ArraySetAsSeries(closes,true);

   return INIT_SUCCEEDED;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
//--- scale highest and lowest piont
   CreateHighLow(MAX_CANDELS,"m1",clrGainsboro);
   //CreateMovingTrendLines();

  }
//+------------------------------------------------------------------+
