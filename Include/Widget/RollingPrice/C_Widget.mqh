//+------------------------------------------------------------------+
//|                                                     C_Widget.mqh |
//|                                                      Daniel Jose |
//+------------------------------------------------------------------+
#property copyright "Daniel Jose"
//+------------------------------------------------------------------+
#include "Elements\C_Object_Edit.mqh"
#include "Elements\C_Object_BackGround.mqh"
#include "Elements\C_Object_BtnBitMap.mqh"
//+------------------------------------------------------------------+
C_Terminal Terminal;
//+------------------------------------------------------------------+
#define def_PrefixName	"WidgetPrice"
#define def_MaxWidth 	160
//+------------------------------------------------------------------+
#define macro_MaxPosition (Terminal.GetWidth() >= (m_Infos.nSymbols * def_MaxWidth) ? Terminal.GetWidth() : m_Infos.nSymbols * def_MaxWidth)
#define macro_ObjectName(A, B) (def_PrefixName + (string)Terminal.GetSubWin() + CharToString(A) + "#" + B)
//+------------------------------------------------------------------+
class C_Widget
{
	protected:
		enum EventCustom {Ev_RollingTo};
	private	:
		enum EnumTypeObject {en_Background = 35, en_Symbol, en_Price, en_Percentual, en_Icon, en_Arrow};
		struct st00
		{
			color CorBackGround,
					CorSymbol;
			int	nSymbols,
					MaxPositionX;
			struct st01
			{
				string szCode;
			}Symbols[];
		}m_Infos;
//+------------------------------------------------------------------+
		void CreateBackGround(void)
			{
				C_Object_BackGround backGround;
				string sz0 = macro_ObjectName(en_Background, "");
				backGround.Create(sz0, m_Infos.CorBackGround);
				backGround.Size(sz0, TerminalInfoInteger(TERMINAL_SCREEN_WIDTH), Terminal.GetHeight());
			}
//+------------------------------------------------------------------+
		void AddSymbolInfo(const string szArg, const bool bRestore = false)
			{
				C_Object_Edit edit;
				C_Object_BtnBitMap bmp;
				string sz0;
				const int x = 9999;

				bmp.Create(sz0 = macro_ObjectName(en_Icon, szArg), szArg);
				bmp.PositionAxleX(sz0, x);
				bmp.PositionAxleY(sz0, 15);
				edit.Create(sz0 = macro_ObjectName(en_Symbol, szArg), m_Infos.CorSymbol, m_Infos.CorBackGround, szArg);
				edit.PositionAxleX(sz0, x);
				edit.PositionAxleY(sz0, 10);
				edit.Size(sz0, 56, 16);
				edit.Create(sz0 = macro_ObjectName(en_Percentual, szArg), m_Infos.CorSymbol, m_Infos.CorBackGround, 0.0, "Lucida Console", 8);
				edit.PositionAxleX(sz0, x);
				edit.PositionAxleY(sz0, 10);
				edit.Size(sz0, 50, 11);
				edit.Create(sz0 = macro_ObjectName(en_Arrow, szArg), m_Infos.CorSymbol, m_Infos.CorBackGround, "", "Wingdings 3", 10);
				edit.PositionAxleX(sz0, x);
				edit.PositionAxleY(sz0, 26);
				edit.Size(sz0, 20, 16);
				edit.Create(sz0 = macro_ObjectName(en_Price, szArg), 0, m_Infos.CorBackGround, 0.0);
				edit.PositionAxleX(sz0, x);
				edit.PositionAxleY(sz0, 26);
				edit.Size(sz0, 60, 16);
				if (!bRestore)
				{
					ArrayResize(m_Infos.Symbols, m_Infos.nSymbols + 1, 10);
					m_Infos.Symbols[m_Infos.nSymbols].szCode = szArg;
					m_Infos.nSymbols++;
				}
			}
//+------------------------------------------------------------------+
inline void UpdateSymbolInfo(int x, const string szArg)
			{
				C_Object_Edit edit;
				C_Object_BtnBitMap bmp;
				string sz0;
				double v0[], v1;
				
				ArraySetAsSeries(v0, true);
				if (CopyClose(szArg, PERIOD_D1, 0, 2, v0) < 2) return;
				v1 = ((v0[0] - v0[1]) / v0[(v0[0] > v0[1] ? 0 : 1)]) * 100.0;
				bmp.PositionAxleX(sz0 = macro_ObjectName(en_Icon, szArg), x);
				x += (int) ObjectGetInteger(Terminal.Get_ID(), sz0, OBJPROP_XSIZE);
				edit.PositionAxleX(macro_ObjectName(en_Symbol, szArg), x + 2);
				edit.PositionAxleX(sz0 = macro_ObjectName(en_Arrow, szArg), x  + 2);
				edit.SetTextValue(sz0, CharToString(v1 >= 0 ? (uchar)230 : (uchar)232), (v1 >= 0 ? def_ColoPositive : def_ColorNegative));
				edit.SetTextValue(sz0 = macro_ObjectName(en_Percentual, szArg), v1 , clrNONE, "%");
				edit.PositionAxleX(sz0, x + 62);
				edit.SetTextValue(sz0 = macro_ObjectName(en_Price, szArg), v0[0] * (v1 >= 0 ? 1 : -1));
				edit.PositionAxleX(sz0, x + 24);
			}
//+------------------------------------------------------------------+
		bool LoadConfig(const string szFileConfig)
			{
				int file;
				string sz0;
				bool ret;
				
				if ((file = FileOpen("Widget\\" + szFileConfig, FILE_CSV | FILE_READ | FILE_ANSI)) == INVALID_HANDLE)
				{
					PrintFormat("Arquivo de configuração %s não encotrado.", szFileConfig);
					return false;
				}
				m_Infos.nSymbols = 0;
				ArrayResize(m_Infos.Symbols, 30, 30);
				for (int c0 = 1; (!FileIsEnding(file)) && (!_StopFlag); c0++)
				{
					if ((sz0 = FileReadString(file)) == "") continue;
					if (SymbolExist(sz0, ret)) AddSymbolInfo(sz0); else
					{
						FileClose(file);
						PrintFormat("Ativo na linha %d não foi reconhecido.", c0);
						return false;
					}
				}
				FileClose(file);
				m_Infos.MaxPositionX = macro_MaxPosition;
				
				return !_StopFlag;
			}
//+------------------------------------------------------------------+
	public	:
//+------------------------------------------------------------------+
		~C_Widget()
			{
				Terminal.Close();
				ObjectsDeleteAll(Terminal.Get_ID(), def_PrefixName);
				ArrayFree(m_Infos.Symbols);
			}
//+------------------------------------------------------------------+
		bool Initilize(const string szFileConfig, const string szNameShort, color corText, color corBack)
			{
				IndicatorSetString(INDICATOR_SHORTNAME, szNameShort);
				Terminal.Init((int)totalSubwindows);
				Terminal.Resize();
				m_Infos.CorBackGround = corBack;
				m_Infos.CorSymbol = corText;
				CreateBackGround();

				return LoadConfig(szFileConfig);
			}
//+------------------------------------------------------------------+
		void DispatchMessage(const int id, const long &lparam, const double &dparam, const string &sparam)
			{
				static int tx = 0;
				string szRet[];
							
				switch (id)
				{
					case (CHARTEVENT_CUSTOM + Ev_RollingTo):
						tx = (int) (tx + lparam);
						tx = (tx < -def_MaxWidth ? m_Infos.MaxPositionX : (tx > m_Infos.MaxPositionX ? -def_MaxWidth : tx));
						for (int c0 = 0, px = tx; (c0 < m_Infos.nSymbols); c0++)
						{
							if (px < Terminal.GetWidth()) UpdateSymbolInfo(px, m_Infos.Symbols[c0].szCode);
							px += def_MaxWidth;
							px = (px > m_Infos.MaxPositionX ? -def_MaxWidth + (px - m_Infos.MaxPositionX) : px);
						}
						ChartRedraw(chartID);
						break;
					case CHARTEVENT_CHART_CHANGE:
						Terminal.Resize();
						m_Infos.MaxPositionX = macro_MaxPosition;
						ChartRedraw(chartID);
						break;
					case CHARTEVENT_OBJECT_DELETE:
						if (StringSubstr(sparam, 0, StringLen(def_PrefixName)) == def_PrefixName) if (StringSplit(sparam, '#', szRet) == 2)
						{
							AddSymbolInfo(szRet[1], true);
							ChartRedraw(chartID);
						}else if (sparam == macro_ObjectName(en_Background, ""))
						{
							ObjectsDeleteAll(Terminal.Get_ID(), def_PrefixName);
							CreateBackGround();
							for (int c0 = 0; c0 < m_Infos.nSymbols; c0++) AddSymbolInfo(m_Infos.Symbols[c0].szCode, true);
							ChartRedraw(chartID);
						}
						break;
					case CHARTEVENT_OBJECT_CLICK:
						if (StringSplit(sparam, '#', szRet) == 2)
						{
							SymbolSelect(szRet[1], true);
							szRet[0] = ChartSymbol(Terminal.Get_ID());
							if (ChartSetSymbolPeriod(Terminal.Get_ID(), szRet[1], PERIOD_CURRENT)) SymbolSelect(szRet[0], false);
							else SymbolSelect(szRet[1], false);
						}
						break;
				}
			}
//+------------------------------------------------------------------+
};
//+------------------------------------------------------------------+
#undef macro_ObjectName
#undef macro_MaxPosition
#undef def_NameObjBackGround
#undef def_PrefixName
//+------------------------------------------------------------------+
