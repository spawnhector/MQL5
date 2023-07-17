#include "terminal.mqh"
//+------------------------------------------------------------------+
class BBBase
{
	public	:
//+------------------------------------------------------------------+
virtual void Create(string szObjectName, ENUM_OBJECT typeObj)
			{
				if(!ObjectCreate(Terminal.Get_ID(), szObjectName, typeObj, Terminal.GetSubWin(), 0, 0)) Print("Failed to create object");
				ObjectSetInteger(Terminal.Get_ID(), szObjectName, OBJPROP_SELECTABLE, false);
				ObjectSetInteger(Terminal.Get_ID(), szObjectName, OBJPROP_SELECTED, false);
				ObjectSetInteger(Terminal.Get_ID(), szObjectName, OBJPROP_BACK, true);
				ObjectSetString(Terminal.Get_ID(), szObjectName, OBJPROP_TOOLTIP, "\n");
				ObjectSetInteger(Terminal.Get_ID(), szObjectName, OBJPROP_BACK, false);
				ObjectSetInteger(Terminal.Get_ID(), szObjectName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
			};
//+------------------------------------------------------------------+
		void PositionAxleX(string szObjectName, int X)
			{
				ObjectSetInteger(Terminal.Get_ID(), szObjectName, OBJPROP_XDISTANCE, X);
			};
//+------------------------------------------------------------------+
		void PositionAxleY(string szObjectName, int Y, int iArrow = 0)
			{
				int desl = (int)ObjectGetInteger(Terminal.Get_ID(), szObjectName, OBJPROP_YSIZE);
				ObjectSetInteger(Terminal.Get_ID(), szObjectName, OBJPROP_YDISTANCE, (iArrow == 0 ? Y - (int)(desl / 2) : (iArrow == 1 ? Y : Y - desl)));
			};
//+------------------------------------------------------------------+
virtual void SetColor(string szObjectName, color cor)
			{
				ObjectSetInteger(Terminal.Get_ID(), szObjectName, OBJPROP_COLOR, cor);
			}
//+------------------------------------------------------------------+
		void Size(string szObjectName, int Width, int Height)
			{
				ObjectSetInteger(Terminal.Get_ID(), szObjectName, OBJPROP_XSIZE, Width);
				ObjectSetInteger(Terminal.Get_ID(), szObjectName, OBJPROP_YSIZE, Height);
			};
//+------------------------------------------------------------------+
};