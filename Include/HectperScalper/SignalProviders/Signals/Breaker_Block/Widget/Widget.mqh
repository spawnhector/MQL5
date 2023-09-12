//+------------------------------------------------------------------+
#include "edit.mqh";
#include "background.mqh";
#include "bthbit.mqh";
//+------------------------------------------------------------------+
BBWidgetTerminal Terminal;
//+------------------------------------------------------------------+
#define def_PrefixName "WidgetPrice"
#define def_MaxWidth 160
//+------------------------------------------------------------------+
#define macro_MaxPosition (Terminal.GetWidth() >= (m_widget_Infos.nSymbols * def_MaxWidth) ? Terminal.GetWidth() : m_widget_Infos.nSymbols * def_MaxWidth)
#define macro_ObjectName(A, B) (def_PrefixName + (string)Terminal.GetSubWin() + CharToString(A) + "$" + B)

class BBWidget
{

private:
    enum EnumTypeObject
    {
        en_Background = 35,
        en_Symbol,
        en_Price,
        en_Percentual,
        en_Icon,
        en_Arrow
    };
    //+------------------------------------------------------------------+
    void CreateBackGround(void)
    {
        BBBackGround backGround;
        string sz0 = macro_ObjectName(en_Background, "");
        backGround.Create(sz0, m_widget_Infos.CorBackGround);
        backGround.Size(sz0, TerminalInfoInteger(TERMINAL_SCREEN_WIDTH), Terminal.GetHeight());
    }
    //+------------------------------------------------------------------+
    void AddSymbolInfo(const string szArg, const bool bRestore = false)
    {
        BBEdit edit;
        BBBtnBitMap bmp;
        string sz0;
        const int x = 9999;

        bmp.Create(sz0 = macro_ObjectName(en_Icon, szArg), szArg);
        bmp.PositionAxleX(sz0, x);
        bmp.PositionAxleY(sz0, 15);
        edit.Create(sz0 = macro_ObjectName(en_Symbol, szArg), m_widget_Infos.CorSymbol, m_widget_Infos.CorBackGround, szArg);
        edit.PositionAxleX(sz0, x);
        edit.PositionAxleY(sz0, 10);
        edit.Size(sz0, 110, 16);
        // edit.Create(sz0 = macro_ObjectName(en_Percentual, szArg), m_widget_Infos.CorSymbol, m_widget_Infos.CorBackGround, 0.0, "Lucida Console", 8);
        // edit.PositionAxleX(sz0, x);
        // edit.PositionAxleY(sz0, 10);
        // edit.Size(sz0, 100, 11);
        edit.Create(sz0 = macro_ObjectName(en_Arrow, szArg), m_widget_Infos.CorSymbol, m_widget_Infos.CorBackGround, "", "Wingdings 3", 10);
        edit.PositionAxleX(sz0, x);
        edit.PositionAxleY(sz0, 26);
        edit.Size(sz0, 20, 16);
        edit.Create(sz0 = macro_ObjectName(en_Price, szArg), 0, m_widget_Infos.CorBackGround, 0.0);
        edit.PositionAxleX(sz0, x);
        edit.PositionAxleY(sz0, 26);
        edit.Size(sz0, 110, 16);
        if (!bRestore)
        {
            ArrayResize(m_widget_Infos.Symbols, m_widget_Infos.nSymbols + 1, 10);
            m_widget_Infos.Symbols[m_widget_Infos.nSymbols].szCode = szArg;
            m_widget_Infos.nSymbols++;
        }
    }
    //+------------------------------------------------------------------+
    inline void UpdateSymbolInfo(int x, const string szArg)
    {
        BBEdit edit;
        BBBtnBitMap bmp;
        string sz0;
        double v0[], v1;

        ArraySetAsSeries(v0, true);
        if (CopyClose(szArg, PERIOD_D1, 0, 2, v0) < 2)
            return;
        v1 = ((v0[0] - v0[1]) / v0[(v0[0] > v0[1] ? 0 : 1)]) * 100.0;
        bmp.PositionAxleX(sz0 = macro_ObjectName(en_Icon, szArg), x);
        x += (int)ObjectGetInteger(Terminal.Get_ID(), sz0, OBJPROP_XSIZE);
        edit.PositionAxleX(macro_ObjectName(en_Symbol, szArg), x + 2);
        edit.PositionAxleX(sz0 = macro_ObjectName(en_Arrow, szArg), x + 2);
        edit.SetTextValue(sz0, CharToString(v1 >= 0 ? (uchar)230 : (uchar)232), (v1 >= 0 ? def_ColoPositive : def_ColorNegative));
        // edit.SetTextValue(sz0 = macro_ObjectName(en_Percentual, szArg), v1, clrNONE, "%");
        // edit.PositionAxleX(sz0, x + 62);
        edit.SetTextValue(sz0 = macro_ObjectName(en_Price, szArg), v0[0] * (v1 >= 0 ? 1 : -1));
        edit.PositionAxleX(sz0, x + 24);
    }
    //+------------------------------------------------------------------+
    bool LoadConfig()
    {
        bool ret;
        for (int i = 0; i < __chartSymbol.symbolLength; i++)
        {
            if (SymbolExist(__chartSymbol.Symbols[i], ret))
                AddSymbolInfo(__chartSymbol.Symbols[i]);
            else
            {
                PrintFormat("Asset at index %d was not recognized.", i);
                return false;
            }
        };
        return true;
    }
    //+------------------------------------------------------------------+
public:
    //+------------------------------------------------------------------+
    ~BBWidget()
    {
        Terminal.Close();
        ObjectsDeleteAll(Terminal.Get_ID(), def_PrefixName);
        ArrayFree(m_widget_Infos.Symbols);
    }
    //+------------------------------------------------------------------+
    bool Initilize(long chartID, int subWin, const string szFileConfig, const string szNameShort, color corText, color corBack)
    {
        IndicatorSetString(INDICATOR_SHORTNAME, szNameShort);
        Terminal.Init(chartID, subWin);
        Terminal.Resize();
        m_widget_Infos.CorBackGround = corBack;
        m_widget_Infos.CorSymbol = corText;
        CreateBackGround();

        return LoadConfig();
    }
    //+------------------------------------------------------------------+
    void DispatchMessage(const int id, const long &lparam, const double &dparam, const string &sparam)
    {
        static int tx = 0;
        string szRet[];

        switch (id)
        {
        case Rollling_Ev:
            tx = (int)(tx + lparam);
            tx = (tx < -def_MaxWidth ? m_widget_Infos.MaxPositionX : (tx > m_widget_Infos.MaxPositionX ? -def_MaxWidth : tx));
            for (int c0 = 0, px = tx; (c0 < m_widget_Infos.nSymbols); c0++)
            {
                if (px < Terminal.GetWidth())
                    UpdateSymbolInfo(px, m_widget_Infos.Symbols[c0].szCode);
                px += def_MaxWidth;
                px = (px > m_widget_Infos.MaxPositionX ? -def_MaxWidth + (px - m_widget_Infos.MaxPositionX) : px);
            }
            ChartRedraw(Terminal.Get_ID());
            break;

        case Recieve_Ev:
            if (StringSplit(sparam, '#', szRet) == 3)
            {
                // if (szRet[2] == "TID")
                //     EventChartCustom(Terminal.Get_ID(), DataHandshake, Terminal.Get_ID(), 0.0, (string)(szRet[0]+"#"+szRet[1]));
            }
            break;

        case CHARTEVENT_CHART_CHANGE:
            Terminal.Resize();
            m_widget_Infos.MaxPositionX = macro_MaxPosition;
            ChartRedraw(Terminal.Get_ID());
            break;

        case CHARTEVENT_OBJECT_DELETE:
            if (StringSubstr(sparam, 0, StringLen(def_PrefixName)) == def_PrefixName)
                if (StringSplit(sparam, '$', szRet) == 2)
                {
                    AddSymbolInfo(szRet[1], true);
                    ChartRedraw(Terminal.Get_ID());
                }
                else if (sparam == macro_ObjectName(en_Background, ""))
                {
                    ObjectsDeleteAll(Terminal.Get_ID(), def_PrefixName);
                    CreateBackGround();
                    for (int c0 = 0; c0 < m_widget_Infos.nSymbols; c0++)
                        AddSymbolInfo(m_widget_Infos.Symbols[c0].szCode, true);
                    ChartRedraw(Terminal.Get_ID());
                }
            break;

        case CHARTEVENT_OBJECT_CLICK:
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
