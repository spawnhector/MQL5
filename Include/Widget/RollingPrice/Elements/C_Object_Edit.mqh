//+------------------------------------------------------------------+
//|                                                C_Object_Edit.mqh |
//|                                                      Daniel Jose |
//+------------------------------------------------------------------+
#property copyright "Daniel Jose"
//+------------------------------------------------------------------+
#include "C_Object_Base.mqh"
//+------------------------------------------------------------------+
#define def_ColorNegative		clrCoral
#define def_ColoPositive		clrPaleGreen
//+------------------------------------------------------------------+
class C_Object_Edit : public C_Object_Base
{
	public	:
//+------------------------------------------------------------------+
		template < typename T >
		void Create(string szObjectName, color corTxt, color corBack, T InfoValue, string szFont = "Lucida Console", int iSize = 10)
			{
				C_Object_Base::Create(szObjectName, OBJ_EDIT);
				ObjectSetString(Terminal.Get_ID(), szObjectName, OBJPROP_FONT, szFont);
				ObjectSetInteger(Terminal.Get_ID(), szObjectName, OBJPROP_FONTSIZE, iSize);
				ObjectSetInteger(Terminal.Get_ID(), szObjectName, OBJPROP_ALIGN, ALIGN_LEFT);
				ObjectSetInteger(Terminal.Get_ID(), szObjectName, OBJPROP_BGCOLOR, corBack);
				ObjectSetInteger(Terminal.Get_ID(), szObjectName, OBJPROP_BORDER_COLOR, corBack);
				ObjectSetInteger(Terminal.Get_ID(), szObjectName, OBJPROP_READONLY, true);
				SetTextValue(szObjectName, InfoValue, corTxt);
			};
//+------------------------------------------------------------------+
		template < typename T >
		void SetTextValue(string szObjectName, T InfoValue, color cor = clrNONE, const string szSufix = "")
			{
				color clr = (cor != clrNONE ? cor : (color)ObjectGetInteger(Terminal.Get_ID(), szObjectName, OBJPROP_COLOR));
				string sz0;
				
				if (typename(T) == "string") sz0 = (string)InfoValue; else
				if (typename(T) == "double")
				{
					clr = (cor != clrNONE ? cor : ((double)InfoValue < 0.0 ? def_ColorNegative : def_ColoPositive));
					sz0 = Terminal.ViewDouble((double)InfoValue < 0.0 ? -((double)InfoValue) : (double)InfoValue) + szSufix;
				}else	sz0 = "?#?";
				ObjectSetString(Terminal.Get_ID(), szObjectName, OBJPROP_TEXT, sz0);
				ObjectSetInteger(Terminal.Get_ID(), szObjectName, OBJPROP_COLOR, clr);
			};
//+------------------------------------------------------------------+
};
//+------------------------------------------------------------------+
