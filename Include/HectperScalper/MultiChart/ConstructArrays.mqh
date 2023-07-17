//+------------------------------------------------------------------+
//|                                              ConstructArrays.mqh |
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
//| Fill arrays                                                      |
//+------------------------------------------------------------------+
void ConstructArrays()//construct the necessary arrays
   {
      int SCount=1;
      for (int i = 0; i < StringLen(SymbolsE); i++)
         {
         if (SymbolsE[i] == ':')
            {
            SCount++;
            }
         }
      ArrayResize(S,SCount);//set the size of the symbol array
      ArrayResize(CN,SCount);//set the size of the array of using bars for each symbol
      int Hc=0;//obtained symbol index
      for (int i = 0; i < StringLen(SymbolsE); i++)//construct the symbol array
         {
         if (i == 0)//if just started
            {
            int LastIndex=-1;
            for (int j = i; j < StringLen(SymbolsE); j++)
               {
               if (StringGetCharacter(SymbolsE,j) == ':')
                  {
                  LastIndex=j;
                  break;
                  }
               }
            if (LastIndex != -1)//if no separating comma is found
               {
               S[Hc]=StringSubstr(SymbolsE,i,LastIndex);
               Hc++;
               }
            else
               {
               S[Hc]=SymbolsE;
               Hc++;
               }
            }          
         if (SymbolsE[i] == ':')
            {
            int LastIndex=-1;
            for (int j = i+1; j < StringLen(SymbolsE); j++)
               {
               if (StringGetCharacter(SymbolsE,j) == ':')
                  {
                  LastIndex=j;
                  break;
                  }
               }
            if (LastIndex != -1)//if no separating comma is found
               {
               S[Hc]=StringSubstr(SymbolsE,i+1,LastIndex-(i+1));
               Hc++;
               }
            else
               {
               S[Hc]=StringSubstr(SymbolsE,i+1,StringLen(SymbolsE)-(i+1));
               Hc++;
               }               
            }
         }
      for (int i = 0; i < ArraySize(S); i++)//set the requested number of bars
         {
         CN[i]=LastBars;
         }
      ConstructLots();
      ConstructTimeframe();         
   }