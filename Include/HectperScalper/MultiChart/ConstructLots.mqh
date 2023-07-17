//+------------------------------------------------------------------+
//|                                                ConstructLots.mqh |
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
   
void ConstructLots()//construct the lot array
   {
   int SCount=1;
   int LCount=1;//number of lot arrays
   for (int i = 0; i < StringLen(SymbolsE); i++)
      {
      if (SymbolsE[i] == ':')
         {
         SCount++;
         }
      }
   for (int i = 0; i < StringLen(LotsE); i++)
      {
      if (LotsE[i] == ':')
         {
         LCount++;
         }
      }
      
   ArrayResize(L,SCount);//set the size of the timeframe array
   int Hc=0;//obtained symbol index
   for (int i = 0; i < StringLen(LotsE); i++)//construct the symbol array
      {
      if (Hc < LCount)
         {
         if (i == 0)//if just started
            {
            int LastIndex=-1;
            for (int j = i; j < StringLen(LotsE); j++)
               {
               if (StringGetCharacter(LotsE,j) == ':')
                  {
                  LastIndex=j;
                  break;
                  }
               }
            if (LastIndex != -1)//if no separating comma is found
               {
               L[Hc]=StringToDoubleP(StringSubstr(LotsE,i,LastIndex));
               Hc++;
               }
            else
               {
               L[Hc]=StringToDoubleP(LotsE);
               Hc++;
               }
            }          
         if (LotsE[i] == ':')
            {
            int LastIndex=-1;
            for (int j = i+1; j < StringLen(LotsE); j++)
               {
               if (StringGetCharacter(LotsE,j) == ':')
                  {
                  LastIndex=j;
                  break;
                  }
               }
            if (LastIndex != -1)//if no separating comma is found
               {
               L[Hc]=StringToDoubleP(StringSubstr(LotsE,i+1,LastIndex-(i+1)));
               Hc++;
               }
            else
               {
               L[Hc]=StringToDoubleP(StringSubstr(LotsE,i+1,StringLen(LotsE)-(i+1)));
               Hc++;
               }               
            }            
         }
      }
   if (Hc < SCount)
      {
      for (int i = Hc; i < SCount; i++)
         {
         L[i]=RepurchaseLotE;
         }
      }
   if (LotsE=="" || LotsE == " ")
      {
      for (int i = 0; i < SCount; i++)
         {
         L[i]=RepurchaseLotE;
         }
      }   
   }