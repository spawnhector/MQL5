//+------------------------------------------------------------------+
//|                                           ConstructTimeframe.mqh |
//|                                                    ronald Hector |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "ronald Hector"
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

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ConstructTimeframe()//construct the timeframe array
  {
   int SCount=1;
   int TCount=1;//number of lot arrays
   for(int i = 0; i < StringLen(SymbolsE); i++)
     {
      if(SymbolsE[i] == ':')
        {
         SCount++;
        }
     }
   for(int i = 0; i < StringLen(TimeframesE); i++)
     {
      if(TimeframesE[i] == ':')
        {
         TCount++;
        }
     }
   ArrayResize(T,SCount);//set the size of the timeframe array
   int Hc=0;//obtained symbol index
   for(int i = 0; i < StringLen(TimeframesE); i++) //construct the symbol array
     {
      if(Hc < TCount)
        {
         if(i == 0) //if just started
           {
            int LastIndex=-1;
            for(int j = i; j < StringLen(TimeframesE); j++)
              {
               if(StringGetCharacter(TimeframesE,j) == ':')
                 {
                  LastIndex=j;
                  break;
                 }
              }
            if(LastIndex != -1) //if no separating comma is found
              {
               T[Hc]=StringToPeriod(StringSubstr(TimeframesE,i,LastIndex));
               Hc++;
              }
            else
              {
               T[Hc]=StringToPeriod(TimeframesE);
               Hc++;
              }
           }
         if(TimeframesE[i] == ':')
           {
            int LastIndex=-1;
            for(int j = i+1; j < StringLen(TimeframesE); j++)
              {
               if(StringGetCharacter(TimeframesE,j) == ':')
                 {
                  LastIndex=j;
                  break;
                 }
              }
            if(LastIndex != -1) //if no separating comma is found
              {
               T[Hc]=StringToPeriod(StringSubstr(TimeframesE,i+1,LastIndex-(i+1)));
               Hc++;
              }
            else
              {
               T[Hc]=StringToPeriod(StringSubstr(TimeframesE,i+1,StringLen(TimeframesE)-(i+1)));
               Hc++;
              }
           }
        }
     }
   if(Hc < SCount)
     {
      for(int i = Hc; i < SCount; i++)
        {
         T[i]=TimeframeE;
        }
     }
   if(TimeframesE=="" || TimeframesE == " ")
     {
      for(int i = Hc; i < SCount; i++)
        {
         T[i]=TimeframeE;
        }
     }
  }
