class BBWidgetTerminal
{
public:
    //+------------------------------------------------------------------+
    void Init(long chartID, const int WhatSub)
    {
        ChartSetInteger(m_terminal_Infos.ID = chartID, CHART_EVENT_OBJECT_DELETE, m_terminal_Infos.SubWin = WhatSub, true);
        Resize();
    }
    void Resize(void)
    {
        m_terminal_Infos.Width = (int)ChartGetInteger(m_terminal_Infos.ID, CHART_WIDTH_IN_PIXELS);
        m_terminal_Infos.Height = (int)ChartGetInteger(m_terminal_Infos.ID, CHART_HEIGHT_IN_PIXELS);
    }

    void Close(void)
    {
        ChartSetInteger(m_terminal_Infos.ID, CHART_EVENT_OBJECT_DELETE, m_terminal_Infos.SubWin, false);
    }

    //+------------------------------------------------------------------+
    inline long Get_ID(void) const { return m_terminal_Infos.ID; }
    inline int GetSubWin(void) const { return m_terminal_Infos.SubWin; }
    inline int GetWidth(void) const { return m_terminal_Infos.Width; }
    inline int GetHeight(void) const { return m_terminal_Infos.Height; }
    inline string ViewDouble(double Value)
    {
        Value = NormalizeDouble(Value, 8);
        return DoubleToString(Value, ((Value - MathFloor(Value)) * 100) > 0 ? 2 : 0);
    }
    //+------------------------------------------------------------------+
};