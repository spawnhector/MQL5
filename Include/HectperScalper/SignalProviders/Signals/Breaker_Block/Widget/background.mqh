#include "Base.mqh";

class BBBackGround : public BBBase
{
	public:
//+------------------------------------------------------------------+
		void Create(string szObjectName, color cor)
			{
				BBBase::Create(szObjectName, OBJ_RECTANGLE_LABEL);
				ObjectSetInteger(Terminal.Get_ID(), szObjectName, OBJPROP_BORDER_TYPE, BORDER_FLAT);
				ObjectSetInteger(Terminal.Get_ID(), szObjectName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
				this.SetColor(szObjectName, cor);
			}
//+------------------------------------------------------------------+
virtual void SetColor(string szObjectName, color cor)
			{
				ObjectSetInteger(Terminal.Get_ID(), szObjectName, OBJPROP_COLOR, cor);
				ObjectSetInteger(Terminal.Get_ID(), szObjectName, OBJPROP_BGCOLOR, cor);
			}
//+------------------------------------------------------------------+
};