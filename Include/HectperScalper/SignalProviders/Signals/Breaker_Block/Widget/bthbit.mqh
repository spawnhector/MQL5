#include "base.mqh";
class BBBtnBitMap : public BBBase
{
	public	:
//+------------------------------------------------------------------+
		void Create(string szObjectName, string szResource1)
			{
                string DefaultBMP = "default";
				BBBase::Create(szObjectName, OBJ_BITMAP_LABEL);
				// ObjectSetString(Terminal.Get_ID(), szObjectName, OBJPROP_BMPFILE, 0, "\\Images\\Widget\\Bitmaps\\" + szResource1 + ".bmp");
				ObjectSetString(Terminal.Get_ID(), szObjectName, OBJPROP_BMPFILE, 0, "\\Images\\Widget\\Bitmaps\\" + DefaultBMP + ".bmp");
			   ObjectSetInteger(Terminal.Get_ID(), szObjectName, OBJPROP_STATE, false);
			};
//+------------------------------------------------------------------+
};