//+------------------------------------------------------------------+
//|                                            hectperScalperSCS.mq5 |
//|                                   Copyright 2022, Ronald Hector. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, Ronald Hector."
#property link      "https://"
#property version   "1.00"

#include<Trade\Trade.mqh>
#include <Trade\PositionInfo.mqh>

CTrade trade;

CPositionInfo  m_position;

#include <HectperScalper\connection.mqh>;
#include <HectperScalper\customChatObjects.mqh>;
#include <HectperScalper\searchArray.mqh>;
#include <HectperScalper\tadeModifierAction.mqh>;
#include <HectperScalper\tradeModifer.mqh>;
#include <HectperScalper\arrayModifier.mqh>;
#include <HectperScalper\getSpread.mqh>;
#include <HectperScalper\peakFindAndTrade.mqh>;
#include <HectperScalper\clearData.mqh>;
#include <HectperScalper\removeCloseTrade.mqh>;
#include <HectperScalper\createHighLow.mqh>;
#include <HectperScalper\createMovingTrendLine.mqh>;
#include <HectperScalper\inMinTradeSize.mqh>;
#include <HectperScalper\CustomTicket.mqh>;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
datetime algoStartTime = TimeCurrent();
double cls[];
MqlRates candels[];
double closes[];
MqlRates rte[];
double openBuyOrder[];
double openSellOrder[];


double prevFoundHigh[];
double prevFoundLow[];
ulong openOrders[];
double totalProfit;
double lot_size = 0.01;
int order_magic=55555;
int minTradeSize = 100;
const int MAX_CANDELS = 100;
int spBars = MAX_CANDELS; // must be greater than tpBars
int tpBars = MAX_CANDELS;
double Balance=AccountInfoDouble(ACCOUNT_BALANCE);
input bool enableServer = false;
string connectionType = "socket"; // socket || websocket
int timer_handle;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
   if(TerminalInfoInteger(TERMINAL_TRADE_ALLOWED) == 0)
     {
      Print("Automated trading is currently disabled. Please enable automated trading to use this Expert Advisor.");
      return INIT_FAILED;
     }
   ArraySetAsSeries(candels,true);
   ArraySetAsSeries(closes,true);
   ArraySetAsSeries(rte,true);
   ArraySetAsSeries(openBuyOrder,true);
   ArraySetAsSeries(openSellOrder,true);
   ArraySetAsSeries(prevFoundHigh,true);
   ArraySetAsSeries(prevFoundLow,true);
   if(enableServer)
     {
      if(ConnectServer())
        {
         return INIT_SUCCEEDED;
        }
      return INIT_FAILED;
     }
   return INIT_SUCCEEDED;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTimer()
  {
   if(TerminalInfoInteger(TERMINAL_TRADE_ALLOWED) == 0)
     {
      Print("Automated trading is currently disabled. Please enable automated trading to use this Expert Advisor.");
      EventKillTimer();
      return;
     }
   Print("waiting on curreny settings");
// check if data is available to read
   if(SocketIsReadable(socket2))
     {
      // data is available to read
      string settings = socketreceive(socket2,10);
      if(settings != "")
        {
         Print(settings);
         signalChannelOpen = true;
         EventKillTimer();
         return;
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {

   cleardata();
// removeClosedTrades();
   checkCloseTrades();

   CreateHighLow(MAX_CANDELS,"m1",clrGainsboro);
   if(signalChannelOpen)
     {
      //CreateMovingTrendLines();
      if(enableCurrencyDataPort)
        {
         int total=SymbolsTotal(true)-1;
         string currencyData;

         for(int i=total-1; i>=0; i--)
           {
            string Sembol=SymbolName(i,true);
            currencyData = currencyData +","+ Sembol+":"+iClose(Sembol,0,0);
           }
         sendCurrencyData(currencyData);
        }
     }
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   EventKillTimer();
   Print("Deinit call");
   closeSocket();

  }
//+------------------------------------------------------------------+
