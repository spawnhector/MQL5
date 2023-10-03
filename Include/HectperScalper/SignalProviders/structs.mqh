struct StartBar
{
    int barIndex;
    datetime time;
    double open;
    double high;
    double low;
    double close;
};

struct ProviderData
{
    int ProviderIndex;
    string ProviderName;
} __providerData;

struct chartObjects
{
    DCObjects name;
    double startPrice;
    double endPrice;
    datetime time;
    double support;
    double resistance;
    double line_price;
} __COB;

struct stA0
{
    long ID;
    int Width,
        Height,
        SubWin;
} m_terminal_Infos;

struct stA1
{
    color CorBackGround,
        CorSymbol;
    int nSymbols,
        MaxPositionX;
    struct st01
    {
        string szCode;
    } Symbols[];
} m_widget_Infos;

struct stc01
{
    bool analyzing;
    bool redRectangle;
    bool greenRectangle;
    long chartWidth;
    long chartHeight;
    long bidY;
    long onew;
    long twow;
    long x1;
    long y1;
    double SupportLevel;
    double ResistanceLevel;
    datetime rangeTime;
    string symbol;
    bool volumeChecked;
    bool SupportLevelPassed;
    bool ResistanceLevelPassed;
    long BOBVolume;
    long BBOBVolume;
    bool breakoutFound;
    bool reverseBreakoutFound;
    struct trader
    {
        int type;
        bool open;
        double tp;
        double sl;
    } trade;
    chartObjects __COBS[];
    void removeCOBS(double target)
    {
        int length = ArraySize(__COBS);
        for (int _index = 0; _index < length; ++_index)
        {
            if (_index == target)
            {
                if (_index >= 0 && _index < length)
                {
                    for (int i = _index; i < length - 1; i++)
                    {
                        __COBS[i] = __COBS[i + 1];
                    }
                    ArrayResize(__COBS, length - 1);
                }
            }
        }
    };
} __root;

struct ChartObjects
{
    struct Fibo_Ret
    {
        string _name;
        string levelObjName;
        int fiboSize;

        struct Fibo_Levels_Type
        {
            struct Types
            {
                struct Levels
                {
                    double price;
                } LEVELS[];
            } TYPE[2];
        } FIBO_LEVELS[100000]; // size of _chartSymbol.Symbol

        void Draw(int symIndex, DCOBJ_PROP nameCat, double startPrice, double endPrice, datetime time, DCOBJ_PROP display)
        {
            _name = "BB-Plot-" + DCID.symbol + "_Fibonacci_" + EnumToString(nameCat);
            levelObjName = _name + "_Level_";
            double FibonacciLevels[] = {0.0, 0.236, 0.382, 0.5, 0.618, 1.0, 1.618, 2.618, 3.618, 4.618, 5.618, 6.618, 7.618, 8.618, 9.618, 10.618};
            fiboSize = ArraySize(FibonacciLevels);
            ArrayResize(FIBO_LEVELS[symIndex].TYPE[nameCat].LEVELS, fiboSize);
            ObjectDelete(DCID.chartID, _name);
            for (int i = 1; i < fiboSize; i++)
            {
                double fiboPrice = startPrice + (endPrice - startPrice) * FibonacciLevels[i];
                if ((display == _SHOW) && ((nameCat == _START) || ((nameCat == _REVERSE) && (i >= 6))))
                {
                    string _levelObjName = levelObjName + IntegerToString(i);
                    ObjectDelete(DCID.chartID, _levelObjName);
                    ObjectCreate(DCID.chartID, _levelObjName, OBJ_TREND, 0, time, fiboPrice, TimeCurrent(), fiboPrice);
                    ObjectSetInteger(DCID.chartID, _levelObjName, OBJPROP_RAY_LEFT, false);
                    ObjectSetInteger(DCID.chartID, _levelObjName, OBJPROP_RAY_RIGHT, true);
                    ObjectSetInteger(DCID.chartID, _levelObjName, OBJPROP_STYLE, STYLE_DASH);
                    ObjectSetInteger(DCID.chartID, _levelObjName, OBJPROP_WIDTH, 2);
                    ObjectSetInteger(DCID.chartID, _levelObjName, OBJPROP_COLOR, clrDimGray);
                }
                FIBO_LEVELS[symIndex].TYPE[nameCat].LEVELS[i].price = fiboPrice;
            }
            ChartRedraw(DCID.chartID);
        };

        void AddFibo_Ret(int symIndex, double startPrice, double endPrice, datetime time, DCOBJ_PROP display)
        {
            Draw(symIndex, _START, startPrice, endPrice, time, display);
            Draw(symIndex, _REVERSE, endPrice, startPrice, time, display);
        };

        double GetFiboLevel(int symIndex, DCOBJ_PROP _ty, int level)
        {
            return FIBO_LEVELS[symIndex].TYPE[_ty].LEVELS[level].price;
        };
    } FIBO_RET;

    struct BreakOut_Levels
    {
        string _name;
        void Draw(AppValues lineType, datetime time, double level)
        {
            _name = "BB-Plot-" + DCID.symbol + "-" + EnumToString(lineType);
            ObjectCreate(DCID.chartID, _name, OBJ_HLINE, 0, time, level);
            ObjectSetInteger(DCID.chartID, _name, OBJPROP_COLOR, clrBlue);
        };

        void AddBreakOut_Levels(double support, double resistance, datetime time)
        {
            Draw(SUPPORTLINE, time, support);
            Draw(RESISTANCELINE, time, resistance);
        };
    } BREAKOUT_LEVELS;

    struct Ask_Line
    {
        string _name;
        void AddAskLine(double ask_price)
        {
            _name = "BB-Ask-Line-" + DCID.symbol;
            if (ObjectCreate(DCID.chartID, _name, OBJ_HLINE, 0, TimeCurrent(), ask_price))
            {
                ObjectSetInteger(DCID.chartID, _name, OBJPROP_COLOR, clrRed);
            }
        };
    } ASK_LINE;
} DCOB;

struct InterfaceHandler
{
    bool toUpdate;
    uint startTickCount;
    void update(stc01 &_RT)
    {
        InterfaceRoot.startTickCount = GetTickCount();
        for (int i = 0; i < ArraySize(_RT.__COBS); i++)
        {
            if (toUpdate)
            {
                switch (_RT.__COBS[i].name)
                {
                case FIBO_RET:
                    DCOB.FIBO_RET.AddFibo_Ret(__chartSymbol.symbolIndex(_RT.symbol), _RT.__COBS[i].startPrice, _RT.__COBS[i].endPrice, _RT.__COBS[i].time, _SHOW);
                    _RT.removeCOBS(i);
                    break;
                case BREAKOUT_LEVELS:
                    DCOB.BREAKOUT_LEVELS.AddBreakOut_Levels(_RT.__COBS[i].support, _RT.__COBS[i].resistance, _RT.__COBS[i].time);
                    _RT.removeCOBS(i);
                    break;
                }
                toUpdate = false;
            };
            switch (_RT.__COBS[i].name)
            {
            case ASK_LINE:
                DCOB.ASK_LINE.AddAskLine(_RT.__COBS[i].line_price);
                _RT.removeCOBS(i);
                break;
            }
        }
        InterfaceRoot.LogExecutionTime("Updating the interface " + _RT.symbol, InterfaceRoot.startTickCount);
    };

    void removeObject(stc01 &root)
    {
        ArrayFree(root.__COBS);
        ObjectsDeleteAll(DCID.chartID, "BB-Plot-" + root.symbol);
    };

    void LogExecutionTime(const string processName, uint _startTickCount)
    {
        uint elapsedMilliseconds = GetTickCount() - _startTickCount;
        double elapsedSeconds = elapsedMilliseconds / 1000.0;
        // if (elapsedMilliseconds > 0)
        //     Print("Process '", processName, "' took ", elapsedMilliseconds, " ms (", elapsedSeconds, " seconds)");
    }
} InterfaceRoot;

struct DCInterfaceData
{
    long chartID;
    bool redRectangle;
    bool greenRectangle;
    long chartWidth;
    long chartHeight;
    long bidY;
    long onew;
    long twow;
    long x1;
    long y1;
    double SupportLevel;
    double ResistanceLevel;
    int volumesIndicatorHandle;
    datetime rangeTime;
    StartBar startBar;
    string symbol;
    InterfaceHandler root;
} DCID;

struct ChartSymbol
{
    string isSet;
    string fileName;
    string szFileConfig;
    int symbolLength;
    string Symbols[];
    MqlBookInfo marketInfo[];

    bool IsTradeAllowed(string symbol)
    {
        m_symbolinfo.Name(symbol);
        ENUM_SYMBOL_TRADE_MODE trade_disabled = m_symbolinfo.TradeMode();
        if (trade_disabled == 4)
        {
            return true;
        }
        return false;
    };

    bool writeFile(int fileHandle)
    {
        if (isTestAccount)
        {
            if (IsTradeAllowed(_Symbol) == true)
            {
                FileWrite(fileHandle, _Symbol); // Write the symbol name to the file
                symbolLength = symbolLength + 1;
            }
        }
        else
        {
            int totalSymbols = SymbolsTotal(false);
            for (int i = 0; i < totalSymbols; i++)
            {
                string symbolName = SymbolName(i, false); // Get the symbol name
                if (IsTradeAllowed(symbolName) == true)
                {
                    FileWrite(fileHandle, symbolName); // Write the symbol name to the file
                    symbolLength = symbolLength + 1;
                }
            }
        }

        FileClose(fileHandle);
        return true;
    };

    bool setSymbols(string _szFileConfig)
    {
        int file;
        string sz0;
        szFileConfig = _szFileConfig;
        fileName = "Widget\\" + szFileConfig;
        string terminal_data_path = TerminalInfoString(TERMINAL_DATA_PATH);
        if ((file = FileOpen(fileName, FILE_WRITE)) != INVALID_HANDLE)
        {
            return writeFile(file);
        }
        Print("error writing config file");
        return false;
    };

    void AddSymbol(string sym)
    {
        ArrayResize(Symbols, (ArraySize(Symbols) + 1));
        Symbols[ArraySize(Symbols) - 1] = sym;
    };

    bool loadSymbols()
    {
        int file;
        string sz0;
        bool ret;
        string terminal_data_path = TerminalInfoString(TERMINAL_DATA_PATH);

        if (FileIsExist(fileName, 0))
        {
            if ((file = FileOpen(fileName, FILE_CSV | FILE_READ | FILE_ANSI)) == INVALID_HANDLE)
            {
                PrintFormat("%s configuration file not found.", szFileConfig);
                return false;
            }
            m_widget_Infos.nSymbols = 0;
            ArrayResize(m_widget_Infos.Symbols, symbolLength);
            for (int c0 = 1; (!FileIsEnding(file)) && (!_StopFlag); c0++)
            {
                if ((sz0 = FileReadString(file)) == "")
                    continue;
                if (SymbolExist(sz0, ret))
                {
                    AddSymbol(sz0);
                }
                else
                {
                    FileClose(file);
                    PrintFormat("Asset on line %d was not recognized.", c0);
                    return false;
                }
            }
            FileClose(file);
            return true;
        }
        return false;
    };

    int symbolIndex(string sym)
    {
        for (int i = 0; i < ArraySize(Symbols); i++)
        {
            if (Symbols[i] == sym)
                return i;
        }
        return -1;
    };

    double CalculateMarginRequired(double lotSize, double leverage, string symbol)
    {
        double marginRequired = lotSize * SymbolInfoDouble(symbol, SYMBOL_MARGIN_INITIAL) / leverage;
        return marginRequired;
    };

    bool hasEnoughMargin(AppValues type, string sym, long vol, double pri)
    {
        double margin;
        bool res;
        res = OrderCalcMargin((type == BUY ? ORDER_TYPE_BUY : ORDER_TYPE_SELL), sym, vol, pri, margin);
        if (res)
            if (AccountInfoDouble(ACCOUNT_BALANCE) >= (margin / AccountInfoInteger(ACCOUNT_LEVERAGE)))
                return true;
        return true;
    };
} __chartSymbol;
