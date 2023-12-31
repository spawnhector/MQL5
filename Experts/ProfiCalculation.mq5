//+------------------------------------------------------------------+
//|                                             ProfiCalculation.mq5 |
//|                                Copyright 2022, Centropolis Corp. |
//|                                       https://www.centropolis.tk |
//+------------------------------------------------------------------+

#property copyright "Copyright 2021, Centropolis Corp."
#property link      "https://www.centropolis.tk"
#property version   "1.00"

///////trading parameters
input bool bInitLotControl=false;//Auto lot
input double DEPOSITTOMINLOTE=100;//Deposit $ for the minimum lot
input double LotE=0.01;//Lot
input bool bBuyInit=true;//Buy trades
input bool bSellInit=true;//Sell trades
input int SlippageMaxOpen=15;//Slippage open
input bool bInitSpreadControl=false;//Spread control
input int SpreadE=30;//Spread max open
input int SLE=0;//Stop loss points ( 0 if dont need )
input int TPE=0;//Take profit points ( 0 if dont need )
input int MagicE=15670867;//Magic
input int PointsCloseE=50;//order closing points
input int PointsEmergencyE=3000;//points of order emergency closing
///////

////logic$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
double PriceForClose;//price required to close the last order
bool LastOrderDirection;//last open order direction

int HistoryDaysLoadI=100;
int TradeCounter=0;

void CalculateParameters()
   {
   double MaxDeviationCalculatedMQL;//maximum deviation of calculation using MQL functions when opening an order from real profit 
   double MaxDeviationCalculatedStart;//maximum deviation of calculation using our functions when opening an order from real profit
   double MaxDeviationCalculatedEnd;//maximum deviation of calculation using our functions when closing an order from real profit
   
   double AverageDeviationCalculatedMQL;//average deviation of calculation using MQL functions when opening an order from real profit 
   double AverageDeviationCalculatedStart;//average deviation of calculation using our functions when opening an order from real profit
   double AverageDeviationCalculatedEnd;//average deviation of calculation using our functions when closing an order from real profit
   
   int orders=0;
   double tempsumm=0;
   double tempmax=0;
   for(int i=0;i<ArraySize(RealProfit);i++)
      {
      if (RealProfit[i].bOrder)
         {
         double tempX=MathAbs(BasicCalculatedProfit[i].Profit-RealProfit[i].Profit)/MathAbs(RealProfit[i].Profit);
         tempsumm+=tempX;
         if (tempX > tempmax) tempmax=tempX;
         orders++;
         }
      else break;
      }
   AverageDeviationCalculatedMQL= tempsumm/double(orders);
   MaxDeviationCalculatedMQL = tempmax;
   tempmax=0;
   tempsumm=0;
   orders=0;
   for(int i=0;i<ArraySize(RealProfit);i++)
      {
      if (RealProfit[i].bOrder)
         {
         double tempX=MathAbs(StartCalculatedProfit[i].Profit-RealProfit[i].Profit)/MathAbs(RealProfit[i].Profit);
         tempsumm+=tempX;
         if (tempX > tempmax) tempmax=tempX;
         orders++;
         }
      else break;
      }
   AverageDeviationCalculatedStart= tempsumm/double(orders);
   MaxDeviationCalculatedStart = tempmax;
   tempmax=0;
   tempsumm=0;
   orders=0;   
   for(int i=0;i<ArraySize(RealProfit);i++)
      {
      if (RealProfit[i].bOrder)
         {
         double tempX=MathAbs(EndCalculatedProfit[i].Profit-RealProfit[i].Profit)/MathAbs(RealProfit[i].Profit);
         tempsumm+=tempX;
         if (tempX > tempmax) tempmax=tempX;
         orders++;
         }
      else break;
      }
   AverageDeviationCalculatedEnd= tempsumm/double(orders);
   MaxDeviationCalculatedEnd = tempmax;   
   
   Print("------------------------------------");
   Print("AverageDeviationCalculatedMQL = "+DoubleToString(AverageDeviationCalculatedMQL*100)+" %");
   Print("AverageDeviationCalculatedStart = "+DoubleToString(AverageDeviationCalculatedStart*100)+" %");
   Print("AverageDeviationCalculatedEnd = "+DoubleToString(AverageDeviationCalculatedEnd*100)+" %");
   
   Print("MaxDeviationCalculatedMQL = "+DoubleToString(MaxDeviationCalculatedMQL*100)+" %");
   Print("MaxDeviationCalculatedStart = "+DoubleToString(MaxDeviationCalculatedStart*100)+" %");
   Print("MaxDeviationCalculatedEnd = "+DoubleToString(MaxDeviationCalculatedEnd*100)+" %");   
   Print("------------------------------------");
   }

void AddNewDeal()//processing and adding a new deal to the array
   {
   RealProfit[TradeCounter].Profit=TempReal;
   BasicCalculatedProfit[TradeCounter].Profit=TempBasicCalculated;
   StartCalculatedProfit[TradeCounter].Profit=TempCalculatedStart;
   EndCalculatedProfit[TradeCounter].Profit=TempCalculatedEnd;
   RealProfit[TradeCounter].bOrder=true;
   BasicCalculatedProfit[TradeCounter].bOrder=true;
   StartCalculatedProfit[TradeCounter].bOrder=true;
   EndCalculatedProfit[TradeCounter].bOrder=true;
   Print("------------------------------------");
   Print("TempReal = "+DoubleToString(TempReal));
   Print("TempBasicCalculated = "+DoubleToString(TempBasicCalculated));
   Print("TempCalculatedStart = "+DoubleToString(TempCalculatedStart));
   Print("TempCalculatedEnd = "+DoubleToString(TempCalculatedEnd));
   Print("------------------------------------");   
   TradeCounter++;
   }

struct OrderParams//order parameters
   {
   bool bOrder;//whether this order should be considered
   double Profit;//order profit
   };

string Symbols[];//array of symbols from the Market Watch window
OrderParams RealProfit[];//real order profit
OrderParams BasicCalculatedProfit[];//profit calculated by the basic MQL function
OrderParams StartCalculatedProfit[];//profit calculated by our function, taking into account the fact that we freeze TickValue at the time of opening the order
OrderParams EndCalculatedProfit[];//profit calculated by our function, taking into account the fact that we take TickValue as it should be when closing a position

double TempBasicCalculated;//temporary variable calculated from the MQL5 base function
double TempCalculatedStart;//temporary variable calculated according to our equations based on the fixed values when opening the order
double TempCalculatedEnd;//temporary variable calculated according to our equations based on the fixed values when closing the order
double TempReal;//temporary variable containing real profit from the history of trades


void PrepareArrays()
   {
   int total=SymbolsTotal(false);//how many symbols are in the Market Watch window
   ArrayResize(Symbols,total);
   ArrayResize(RealProfit,1000);//set the maximum size of arrays
   ArrayResize(BasicCalculatedProfit,1000);
   ArrayResize(StartCalculatedProfit,1000);
   ArrayResize(EndCalculatedProfit,1000);
   }

string SymbolBasic()//account currency
   {
   return AccountInfoString(ACCOUNT_CURRENCY);
   }
   
double TickValueCross(string symbol,int prefixcount=0)//determine the tick size in case of a cross rate or a regular rate
   {
   if ( SymbolValue(symbol) == SymbolBasic() )
      {
      return TickValue(symbol);
      }
   else
      {
      MqlTick last_tick;
      int total=SymbolsTotal(false);//how many symbols are in the Market Watch window
      for(int i=0;i<total;i++) Symbols[i]=SymbolName(i,false);
      string crossinstrument=FindCrossInstrument(symbol);
      if ( crossinstrument != "" )
         {
         SymbolInfoTick(crossinstrument,last_tick);//get the current price on the cross symbol
         string firstVAL=StringSubstr(crossinstrument,prefixcount,3);
         string secondVAL=StringSubstr(crossinstrument,prefixcount+3,3);
         if ( secondVAL==SymbolBasic() && firstVAL == SymbolValue(symbol) )
            {
             return TickValue(symbol) * last_tick.bid;
            }
         if ( firstVAL==SymbolBasic() && secondVAL == SymbolValue(symbol) )
            {
            return TickValue(symbol) * 1.0/last_tick.ask;
            }         
         }
      else return TickValue(symbol);  
      }
   return 0.0;   
   }

double TickValue(string symbol)//define a simple tick size
   {
   return SymbolInfoDouble(symbol,SYMBOL_TRADE_CONTRACT_SIZE) * SymbolInfoDouble(symbol,SYMBOL_POINT);
   }
   
string SymbolValue(string symbol,int prefixcount=0)//profit currency of a provided symbol
   {
   return StringSubstr(symbol,prefixcount+3,3);
   }

double CalculateProfitTheoretical(string symbol, double lot,double OpenPrice,double ClosePrice,bool bDirection)//calculate profit in theory (excluding commission and swap)
   {
   //PrBuy = Lot * TickValueCross * [ ( Bid2 - Ask1 )/Point ]
   //PrSell = Lot * TickValueCross * [ ( Bid1 - Ask2 )/Point ]
   if ( bDirection )
      {
      return lot * TickValueCross(symbol) * ( (ClosePrice-OpenPrice)/SymbolInfoDouble(symbol,SYMBOL_POINT) );
      }
   else
      {
      return lot * TickValueCross(symbol) * ( (OpenPrice-ClosePrice)/SymbolInfoDouble(symbol,SYMBOL_POINT) );
      }   
   }

double CalculateRealProfit(string symbol)//calculate real trade profit from history
   {
   bool ord;
   HistorySelect(TimeCurrent()-HistoryDaysLoadI*86400,TimeCurrent());
   for ( int i=HistoryDealsTotal()-1; i>=0; i-- )
      {
      ulong ticket=HistoryDealGetTicket(i);
      ord=HistoryDealSelect(ticket);
      if ( ord && HistoryDealGetString(ticket,DEAL_SYMBOL) == symbol 
      && HistoryDealGetInteger(ticket,DEAL_ENTRY) == DEAL_ENTRY_OUT )
         {
         return HistoryDealGetDouble(ticket,DEAL_PROFIT);
         //return HistoryDealGetDouble(ticket,DEAL_PROFIT)-HistoryDealGetDouble(ticket,DEAL_COMMISSION)-HistoryDealGetDouble(ticket,DEAL_SWAP);
         }
      } 
   return 0.0;
   }

double CalculatedProfit(string symbol, double lot,double OpenPrice,double ClosePrice,bool bDirection)//calculate profit using built-in functions
   {
   bool bc;
   double TP=0.0;
   if ( bDirection ) bc=OrderCalcProfit(ORDER_TYPE_BUY,symbol,lot,OpenPrice,ClosePrice,TP);
   else bc=OrderCalcProfit(ORDER_TYPE_SELL,symbol,lot,OpenPrice,ClosePrice,TP);
   return TP;
   }


string FindCrossInstrument(string symbol,int prefixcount=0)//find the rate for calculating the tick size expressed in the currency of our deposit
   {
   string firstVAL;
   string secondVAL;
   for(int i=0;i<ArraySize(Symbols);i++)
      {
      firstVAL=StringSubstr(Symbols[i],prefixcount,3);
      secondVAL=StringSubstr(Symbols[i],prefixcount+3,3);
      if ( secondVAL==SymbolBasic() && firstVAL == SymbolValue(symbol) )
         {
         return Symbols[i];
         }
      if ( firstVAL==SymbolBasic() && secondVAL == SymbolValue(symbol) )
         {
         return Symbols[i];
         }      
      }
   return "";
   }


////$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$


/////examples of opening and closing market orders
//CloseType(OP_BUY,MagicE);
//CloseType(OP_SELL,MagicE);
//BuyF(SLE,TPE,LotE);
//SellF(SLE,TPE,LotE);
/////

//******************basic functions for trading
void BuyF(double SL0,double TP0,double Lot0)//buy by market (USABLE)
   {
   double DtA;
   double SLTemp0=MathAbs(SL0);
   double TPTemp0=MathAbs(TP0);   
   double Mt=Lot0; 
      
   DtA=double(TimeCurrent())-GlobalVariableGet("TimeStart161");
   if ( PositionsTotal() == 0 && (DtA > 1 || DtA < 0) )
      {
      CheckForOpen(bBuyInit,MagicE,1,Bid,Ask,MathAbs(SlippageMaxOpen),Bid,int(SLTemp0),int(TPTemp0),MathAbs(Mt),Symbol(),0,NULL,bInitLotControl,bInitSpreadControl,SpreadE);
      }
   }
   
void SellF(double SL0,double TP0,double Lot0)//sell by market (USABLE)
   {
   double DtA;
   double SLTemp0=MathAbs(SL0);
   double TPTemp0=MathAbs(TP0);   
   double Mt=Lot0;     

         
   DtA=double(TimeCurrent())-GlobalVariableGet("TimeStart161");
   if ( PositionsTotal() == 0 && (DtA > 1 || DtA < 0) )
      {
      CheckForOpen(bSellInit,MagicE,-1,Bid,Ask,MathAbs(SlippageMaxOpen),Bid,int(SLTemp0),int(TPTemp0),MathAbs(Mt),Symbol(),0,NULL,bInitLotControl,bInitSpreadControl,SpreadE);
      }
   }
   
void CheckForOpen(bool Condition0,int Magic0,int OrdType,double PriceBid,double PriceAsk,int Slippage0,double PriceClose0,int SL0,int TP0,double Lot0,string Symbol0,datetime Expiration0,string Comment0,bool bLotControl0,bool bSpreadControl0,int Spread0)
   {
   bool ord;//opening an order under Condition0
   double LotTemp=Lot0;
   double SpreadLocal=double(SymbolInfoInteger(_Symbol,SYMBOL_SPREAD));
   double LotAntiError=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
                                                       
   if ( Condition0 == true && ( (SpreadLocal <= Spread0 && bSpreadControl0 == true ) || ( bSpreadControl0 == false ) )  )                    
      {   
      if ( bLotControl0 == false )
         {
         LotTemp=Lot0;
         }
      if ( bLotControl0 == true )
         {
         if ( DEPOSITTOMINLOTE > 0.0 ) LotTemp=Lot0*(AccountInfoDouble(ACCOUNT_BALANCE)/DEPOSITTOMINLOTE);
         else LotTemp=Lot0;
         }
       

      LotAntiError=GetLotAntiError(LotTemp);
      if ( LotAntiError <= 0 )
         {
         Print("TOO Low  Free Margin Level !");
         }

      if ( LotAntiError > 0 && OrdType == -1 )
         {
         GlobalVariableSet("TimeStart161",double(TimeCurrent()) );
         MqlTradeResult result={}; 
         MqlTradeRequest request={}; 
         request.action=TRADE_ACTION_DEAL;            // open a position 
         request.magic=MagicE;                            // ORDER_MAGIC 
         request.symbol=_Symbol;                      // symbol 
         request.volume=LotAntiError;                          // lot 
         request.sl=0;                                // Stop Loss not specified 
         request.tp=0;                                // Take Profit not specified    
         //--- form the order type 
         request.type=ORDER_TYPE_SELL;                // order type 
         //--- create a price for a pending order 
         request.price=SymbolInfoDouble(Symbol(),SYMBOL_BID);  // open price
         request.deviation=0;  //slippage
         
         if ( TP0 == 0 ) ord=OrderSend(request,result);
         else ord=OrderSend(request,result);
         if ( ord )
            {
            TempBasicCalculated=CalculatedProfit(_Symbol,LotAntiError,PriceBid,PriceBid-PointsCloseE*_Point,false);
            TempCalculatedStart=CalculateProfitTheoretical(_Symbol,LotAntiError,PriceBid,PriceBid-PointsCloseE*_Point,false);
            PriceForClose=PriceBid-PointsCloseE*_Point;
            LastOrderDirection=false;
            } 
         }
      if ( LotAntiError > 0 &&  OrdType == 1 )
         {
         GlobalVariableSet("TimeStart161",double(TimeCurrent()) );
         MqlTradeResult result={}; 
         MqlTradeRequest request={}; 
         request.action=TRADE_ACTION_DEAL;            // open a position 
         request.magic=MagicE;                            // ORDER_MAGIC 
         request.symbol=_Symbol;                      // symbol 
         request.volume=LotAntiError;                          // lot 
         request.sl=0;                                // Stop Loss not specified 
         request.tp=0;                                // Take Profit not specified    
         //--- form the order type 
         request.type=ORDER_TYPE_BUY;                // order type 
         //--- create a price for a pending order
         request.price=SymbolInfoDouble(Symbol(),SYMBOL_ASK);  // open price
         request.deviation=0;  //slippage
         
         if ( TP0 == 0 ) ord=OrderSend(request,result);
         else ord=OrderSend(request,result);
         if ( ord )
            {
            TempBasicCalculated=CalculatedProfit(_Symbol,LotAntiError,PriceAsk,PriceAsk+PointsCloseE*_Point,true);
            TempCalculatedStart=CalculateProfitTheoretical(_Symbol,LotAntiError,PriceAsk,PriceAsk+PointsCloseE*_Point,true);
            PriceForClose=PriceAsk+PointsCloseE*_Point;            
            LastOrderDirection=true;
            } 
         }                     
      }
      
   }

double GetLotAntiError(double InputLot)//lot correction to adjust values
   {
   double Free = AccountInfoDouble(ACCOUNT_MARGIN_FREE);
   double margin;
   bool ord = OrderCalcMargin(ORDER_TYPE_BUY,_Symbol,1.0,Close[0],margin);
   double minLot = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   double Max_Lot = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX);
   double Step = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP);
   double Lot13;
   int LotCorrection;
   LotCorrection=int(MathFloor(InputLot/Step));
   Lot13=LotCorrection*Step;   
   if(Lot13<=minLot) Lot13 = minLot;
   if(Lot13>=Max_Lot) Lot13 = Max_Lot;
   
   if( Lot13*margin>=Free ) Lot13=-1.0;

   return Lot13;
   }   
   
int CorrectLevels(int level0)//correct the stop level based on the spread and other parameters
   {
   int rez;
   int ZeroLevel0=int(MathAbs(double(SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)))+MathAbs(double(SymbolInfoInteger(_Symbol,SYMBOL_SPREAD)))+MathAbs(SlippageMaxOpen)+1);

   if ( MathAbs(level0) > ZeroLevel0 )
      {
      rez=int(MathAbs(level0));
      }
   else
      {
      rez=ZeroLevel0;
      }   
   return rez;
   }
   
void CloseType(ENUM_POSITION_TYPE OT,int magic0,bool bEmergency)//close all orders of the specified type (USABLE)
   {
   bool order;
   bool ord;
   ulong Tickets[];
   double Lotsx[];
   bool Typex[];      
   string SymbolX[];   
   int TicketsTotal=0;
   int TicketNumCurrent=0;
   MqlTick TickS;
   
   for ( int i=0; i<PositionsTotal(); i++ )
      {
      ord=PositionSelect( PositionGetSymbol(i) );
                         
      if ( ord && PositionGetInteger(POSITION_MAGIC) == magic0 )
         {
         TicketsTotal=TicketsTotal+1;
         }
      }
   ArrayResize(Tickets,TicketsTotal);
   ArrayResize(Lotsx,TicketsTotal);
   ArrayResize(Typex,TicketsTotal);
   ArrayResize(SymbolX,TicketsTotal);
         
   for ( int i=0; i<PositionsTotal(); i++ )
      {
      ord=PositionSelect( PositionGetSymbol(i) );
                         
      if ( ord && PositionGetInteger(POSITION_MAGIC) == magic0 && TicketNumCurrent < TicketsTotal )
         {
         Tickets[TicketNumCurrent]=PositionGetTicket(i);
         if ( PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY )
            {
            Typex[TicketNumCurrent]=true;
            }
         if ( PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL )
            {
            Typex[TicketNumCurrent]=false;
            }                           
         Lotsx[TicketNumCurrent]=PositionGetDouble(POSITION_VOLUME);
         SymbolX[TicketNumCurrent]=PositionGetSymbol(i);            
         TicketNumCurrent=TicketNumCurrent+1;
         }
      }
      
   for ( int i=0; i<TicketsTotal; i++ )
      {
      SymbolInfoTick(SymbolX[i],TickS);
      if ( Typex[i] == true && OT == POSITION_TYPE_BUY )
         {
         
         MqlTradeRequest request={};
         MqlTradeResult  result={};
         request.action   =TRADE_ACTION_DEAL;        // trade operation type
         request.position =Tickets[i];          // position ticket
         request.symbol   =SymbolX[i];          // symbol 
         request.volume   =Lotsx[i];                   // position volume
         request.deviation=0;                        // acceptable price deviation
         request.magic    =MagicE;             // position MagicNumber
         request.price=SymbolInfoDouble(SymbolX[i],SYMBOL_BID);
         request.type =ORDER_TYPE_SELL;         
         
         
         order=OrderSend(request,result);
         if ( order )
            {
            TempReal=CalculateRealProfit(_Symbol);
            TempCalculatedEnd=CalculateProfitTheoretical(_Symbol,Lotsx[i],TickS.bid-PointsCloseE*_Point,TickS.bid,true);
            if (!bEmergency) AddNewDeal();
            } 
         }
      if ( Typex[i] == false && OT == POSITION_TYPE_SELL )
         {
         
         MqlTradeRequest request={};
         MqlTradeResult  result={};
         request.action   =TRADE_ACTION_DEAL;        // trade operation type
         request.position =Tickets[i];          // position ticket
         request.symbol   =SymbolX[i];          // symbol 
         request.volume   =Lotsx[i];                   // position volume
         request.deviation=0;                        // acceptable price deviation
         request.magic    =MagicE;             // position MagicNumber
         request.price=SymbolInfoDouble(SymbolX[i],SYMBOL_ASK);
         request.type =ORDER_TYPE_BUY;            
         
         order=OrderSend(request,result);
         if ( order )
            {
            TempReal=CalculateRealProfit(_Symbol);
            TempCalculatedEnd=CalculateProfitTheoretical(_Symbol,Lotsx[i],TickS.ask+PointsCloseE*_Point,TickS.ask,false);
            if (!bEmergency) AddNewDeal();
            } 
         }       
      }
   }   
//********************

datetime Time0;//auxiliary variable for working by bars
bool bFirst=false;//whether the first false bar has occurred (we should wait till the first normal bar is formed since the initial one appears somewhere in the middle of the tick)
bool bNewBar()//work by bars (USABLE)
   {
   if ( Time0 < Time[1] )
      {
      if (Time0 != 0)
         {
         Time0=Time[1];
         //placefolder
         
         
         if ( bFirst ) return true;
         else//if this is the first tick, then we will not consider this a new bar, because it appeared in the middle
            {
            bFirst=true;
            return false;
            }
         }
      else
         {
         Time0=Time[1];
         return false;
         }
      }
   else return false;
   }


//*******************

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
  DimensionAllMQL5Values();
  PrepareArrays();
  //placefolder
  
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
  CalculateParameters();//display the parameters of this run
  //placefolder
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
  CalcAllMQL5ValuesTick();
  //placefolder
  CalcAllMQL5Values();
  if ( LastOrderDirection )
     {
        if ( TickAlphaPsi.bid == PriceForClose ) CloseType(POSITION_TYPE_BUY,MagicE,false);
     }
  else
     {
        if ( TickAlphaPsi.ask == PriceForClose ) CloseType(POSITION_TYPE_SELL,MagicE,false);
     }
     
  //emergency closing   
  if ( LastOrderDirection )
     {
        if ( MathAbs(TickAlphaPsi.bid - PriceForClose) > PointsEmergencyE*_Point ) CloseType(POSITION_TYPE_BUY,MagicE,true);
     }
  else
     {
        if ( MathAbs(TickAlphaPsi.ask - PriceForClose) > PointsEmergencyE*_Point ) CloseType(POSITION_TYPE_SELL,MagicE,true);
     }     
  //
     
  if ( !LastOrderDirection )
     {
     if (PositionsTotal()==0) BuyF(0,0,1.0);
     }
  else
     {
     if (PositionsTotal()==0) SellF(0,0,1.0);
     }
       
  if ( bNewBar() )//if we need to work by bars
     {

     //placefolder
     }
  //placefolder
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

//move the logic to mql5
double Close[];
double Open[];
double High[];
double Low[];
datetime Time[];
double Bid;
double Ask;
int Bars=1000;//last bars on the chart
MqlTick TickAlphaPsi;//the last tick

///////////////functions for predefined MQL5 arrays

void DimensionAllMQL5Values()////////////////////////////// set the bar array size during the initialization
   {
   ArrayResize(Close,Bars-1,0);
   ArrayResize(Open,Bars-1,0);   
   ArrayResize(Time,Bars-1,0);
   ArrayResize(High,Bars-1,0);
   ArrayResize(Low,Bars-1,0);
   }

void CalcAllMQL5Values()///////////////////////////////////on a bar
   {
   ArraySetAsSeries(Close,false);                        
   ArraySetAsSeries(Open,false);                           
   ArraySetAsSeries(High,false);                        
   ArraySetAsSeries(Low,false);                              
   ArraySetAsSeries(Time,false);                                                            
   CopyClose(_Symbol,_Period,0,Bars-1,Close);
   CopyOpen(_Symbol,_Period,0,Bars-1,Open);   
   CopyHigh(_Symbol,_Period,0,Bars-1,High);
   CopyLow(_Symbol,_Period,0,Bars-1,Low);
   CopyTime(_Symbol,_Period,0,Bars-1,Time);
   ArraySetAsSeries(Close,true);
   ArraySetAsSeries(Open,true);
   ArraySetAsSeries(High,true);                        
   ArraySetAsSeries(Low,true);
   ArraySetAsSeries(Time,true);
   }
   
void CalcAllMQL5ValuesTick()///////////////////////////////////on a tick
   {
   SymbolInfoTick(Symbol(),TickAlphaPsi);
   Bid=TickAlphaPsi.bid;
   Ask=TickAlphaPsi.ask;
   Close[0]=TickAlphaPsi.bid;
   Open[0]=TickAlphaPsi.bid;
   High[0]=TickAlphaPsi.bid;
   Low[0]=TickAlphaPsi.bid;
   Time[0]=iTime(_Symbol,PERIOD_CURRENT,0);
   Time[1]=iTime(_Symbol,PERIOD_CURRENT,1);
   }   
////////////////////////////////////////////////////////////



//