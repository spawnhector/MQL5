//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2020, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#import
//+------------------------------------------------------------------+
//|                                                   connection.mqh |
//|                                   Copyright 2022, Ronald Hector. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, Ronald Hector."
#property link      "https://www.mql5.com"
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
// Include header file for sockets

#include <HectperScalper\wsc\WebSocketClient.mqh>

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int socket1;
int socket2;
//string Address = "api.onlinecash.gq";
string Address = "localhost";
int socket_count = 2;
int sockets[];
input string ServerAddress = "localhost";
input int SignalPort=8082;
input bool enableCurrencyDataPort = false;
input int CurrencyDataPort=8081;
bool signalChannelOpen = false;


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool createSocket()
  {

   if(enableCurrencyDataPort)
     {
      socket1 = SocketCreate();
      if(socket1 == INVALID_HANDLE)
        {
         Print("Failed to create socket ", 1);
         return false;
        }
     }

   socket2 = SocketCreate();
   if(socket2 == INVALID_HANDLE)
     {
      Print("Failed to create socket ", 2);
      return false;
     }
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void createInSocket()
  {
   if(SocketConnect(socket1,ServerAddress,CurrencyDataPort,10000))
     {
      Print("[INFO]\tConnection Established In in-socket");
     }
   else
     {
      Print("Error in in-socket connection, EA is offline.");
      SocketClose(socket1);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool createOutSocket()
  {

   if(SocketConnect(socket2,ServerAddress,SignalPort,10000))
     {
      Print("[INFO]\tConnection Established In out-socket");
      sendSignalSetting();
      // set up a timer to trigger the OnTimer event every 100 milliseconds
      timer_handle = EventSetMillisecondTimer(100);
      return true;
     }
   else
     {
      Print("Error in out-socket connection, EA is offline.");
      SocketClose(socket2);
      return false;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool ConnectServer()
  {
   if(createSocket())
     {
      if(enableCurrencyDataPort)
        {
         createInSocket();
        }
      if(createOutSocket())
        {
         return true;
        }
     }
   return false;
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void sendSignalSetting()
  {
   string msg = "{'type':'init','currency':'"+ _Symbol+"'}";
   char req[];
   int len = StringToCharArray(msg,req) -1;
   SocketSend(socket2,req,len);
   Print("settings sent: "+msg);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void sendSignal(string signal)
  {
   string msg = "{'type':'signal','currency':'"+ _Symbol+"',"+signal+"}";

   if(enableServer)
     {
      if(connectionType == "socket")
        {
         char req[];
         int len = StringToCharArray(msg,req) -1;
         SocketSend(socket2,req,len);
         Print("signal sent: "+msg);
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string socketreceive(int sock,int timeout)
  {
   char rsp[];
   string result="";
   uint len;
   uint timeout_check=GetTickCount()+timeout;
   do
     {
      len=SocketIsReadable(sock);
      if(len)
        {
         int rsp_len;
         rsp_len=SocketRead(sock,rsp,len,timeout);
         if(rsp_len>0)
           {
            result+=CharArrayToString(rsp,0,rsp_len);
           }
        }
     }
   while((GetTickCount()<timeout_check) && !IsStopped());
   return result;
  }
//+------------------------------------------------------------------+
void sendCurrencyData(string data)
  {

   string msg = data;

   if(enableServer)
     {
      if(connectionType == "socket")
        {
         char req[];
         int len = StringToCharArray(msg,req) -1;
         SocketSend(socket1,req,len);
         Print("currency data sent"+IntegerToString(CurrencyDataPort));
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void closeSocket()
  {
   char endConnection[];
   int endConnectionLen = StringToCharArray("END CONNECTION\0",endConnection) -1;
   if(enableCurrencyDataPort)
     {
      SocketSend(socket1,endConnection,endConnectionLen);
      SocketClose(socket1);
     }
   SocketSend(socket2,endConnection,endConnectionLen);
   SocketClose(socket2);
  }
//+------------------------------------------------------------------+

#import
//+------------------------------------------------------------------+
