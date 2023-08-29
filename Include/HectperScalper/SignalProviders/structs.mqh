
string S[]; // array with symbols
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
} __COB;

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
} __root;

struct ChartObjects
{
    struct Fibo_Ret
    {
        string _name;
        string levelObjName;

        struct Fibo_Levels_Type
        {
            struct Levels
            {
                double price;
            } LEVELS[];
        } FIBO_LEVELS_TYPE[2];

        void Draw(DCOBJ_PROP nameCat, double startPrice, double endPrice, datetime time, DCOBJ_PROP display)
        {
            _name = "BB-Plot-" + DCID.symbol +"_Fibonacci_" + EnumToString(nameCat);
            levelObjName = _name + "_Level_";
            double FibonacciLevels[] = {0.0, 0.236, 0.382, 0.5, 0.618, 1.0, 1.618, 2.618};
            int fiboSize = ArraySize(FibonacciLevels);
            ArrayResize(FIBO_LEVELS_TYPE[nameCat].LEVELS, fiboSize);
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
                FIBO_LEVELS_TYPE[nameCat].LEVELS[i].price = fiboPrice;
            }
            ChartRedraw(DCID.chartID);
        };

        void AddFibo_Ret(double startPrice, double endPrice, datetime time, DCOBJ_PROP display)
        {
            Draw(_START, startPrice, endPrice, time, display);
            Draw(_REVERSE, endPrice, startPrice, time, display);
        };

        double GetFiboLevel(DCOBJ_PROP _ty, int level)
        {
            return FIBO_LEVELS_TYPE[_ty].LEVELS[level].price;
        };
    } FIBO_RET;

    struct BreakOut_Levels
    {
        string _name;
        void Draw(AppValues lineType, datetime time, double level)
        {
            _name = "BB-Plot-" + DCID.symbol + "-" + EnumToString(lineType);
            ;
            ObjectCreate(DCID.chartID, _name, OBJ_HLINE, 0, time, level);
            ObjectSetInteger(DCID.chartID, _name, OBJPROP_COLOR, clrBlue);
        };

        void AddBreakOut_Levels(double support, double resistance, datetime time)
        {
            Draw(SUPPORTLINE, time, support);
            Draw(RESISTANCELINE, time, resistance);
        };
    } BREAKOUT_LEVELS;
} DCOB;

struct InterfaceHandler
{
    bool toUpdate;
    void update(stc01 &_RT)
    {
        if (toUpdate)        
            if (DCID.symbol == _RT.symbol)
            {
                for (int i = 0; i < ArraySize(_RT.__COBS); i++)
                {
                    switch (_RT.__COBS[i].name)
                    {
                    case FIBO_RET:
                        DCOB.FIBO_RET.AddFibo_Ret(_RT.__COBS[i].startPrice, _RT.__COBS[i].endPrice, _RT.__COBS[i].time, _SHOW);
                        break;
                    case BREAKOUT_LEVELS:
                        DCOB.BREAKOUT_LEVELS.AddBreakOut_Levels(_RT.__COBS[i].support, _RT.__COBS[i].resistance, _RT.__COBS[i].time);
                        break;
                    }
                }
                toUpdate = false;
            }
    };

    void removeObject(stc01 &root){
        ArrayFree(root.__COBS);
        ObjectsDeleteAll(DCID.chartID, "BB-Plot-" + root.symbol);
    };
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
    int symbolIndex(string sym)
    {
        for (int i = 0; i < ArraySize(S); i++)
        {
            if (S[i] == sym)
                return i;
        }
        return -1;
    };
} __chartSymbol;
