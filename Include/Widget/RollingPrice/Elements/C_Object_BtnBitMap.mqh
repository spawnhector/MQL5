//+------------------------------------------------------------------+
//|                                           C_Object_BtnBitMap.mqh |
//|                                                      Daniel Jose |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Daniel Jose"
//+------------------------------------------------------------------+
#include "C_Object_Base.mqh"
//+------------------------------------------------------------------+
class C_Object_BtnBitMap : public C_Object_Base
{
	public	:
//+------------------------------------------------------------------+
		void Create(string szObjectName, string szResource1)
			{
				C_Object_Base::Create(szObjectName, OBJ_BITMAP_LABEL);
				ObjectSetString(Terminal.Get_ID(), szObjectName, OBJPROP_BMPFILE, 0, "\\Images\\Widget\\Bitmaps\\" + szResource1 + ".bmp");
			   ObjectSetInteger(Terminal.Get_ID(), szObjectName, OBJPROP_STATE, false);
			};
//+------------------------------------------------------------------+
};
//+------------------------------------------------------------------+
