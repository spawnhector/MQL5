enum EventCustom
{
    Ev_RollingTo,
    DataHandshake,
    Rollling_Ev = CHARTEVENT_CUSTOM + Ev_RollingTo,
    Recieve_Ev = CHARTEVENT_CUSTOM + DataHandshake
};

enum EventActions
{
    CHANGECHART
};

class CustomEventHandler
{
protected:
    string szRet[];
    string chartSym;

public:
    void HandleRecievedEvents(const int id, const long &lparam, const double &dparam, const string &sparam)
    {
        if (StringSplit(sparam, '#', szRet) == 2)
        {
            if (szRet[0] == "CHARTCHANGE")
            {
                SymbolSelect(szRet[1], true);
                chartSym = ChartSymbol(lparam);
                if (ChartSetSymbolPeriod(lparam, szRet[1], PERIOD_CURRENT))
                    SymbolSelect(chartSym, false);
                else
                    SymbolSelect(szRet[1], false);
            }
        }
    }
}