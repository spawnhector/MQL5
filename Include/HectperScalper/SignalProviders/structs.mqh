
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
        struct Fibo_Levels_Type{
            struct Levels{
                double price;
            } LEVELS[];
        } FIBO_LEVELS_TYPE[2];
        void AddFibonacciRetracement(DCOBJ_PROP nameCat, double startPrice, double endPrice, datetime time)
        {
            _name = "Fibonacci_"+EnumToString(nameCat);
            levelObjName = _name + "_Level_";
            double FibonacciLevels[] = {0.0, 0.236, 0.382, 0.5, 0.618, 1.0, 1.618, 2.618};
            int fiboSize = ArraySize(FibonacciLevels);
            ArrayResize(FIBO_LEVELS_TYPE[nameCat].LEVELS,fiboSize);
            ObjectDelete(DCID.chartID, _name);
            for (int i = 1; i < fiboSize; i++)
            {
                double fiboPrice = startPrice + (endPrice - startPrice) * FibonacciLevels[i];
                string _levelObjName = levelObjName + IntegerToString(i);
                if ((nameCat == _START) || (nameCat == _REVERSE && i >= 6))
                {
                    ObjectDelete(DCID.chartID, _levelObjName);
                    ObjectCreate(DCID.chartID,_levelObjName, OBJ_TREND, 0, time, fiboPrice, TimeCurrent(), fiboPrice);
                    ObjectSetInteger(DCID.chartID,_levelObjName, OBJPROP_RAY_LEFT, false);
                    ObjectSetInteger(DCID.chartID,_levelObjName, OBJPROP_RAY_RIGHT, true);
                    ObjectSetInteger(DCID.chartID,_levelObjName, OBJPROP_STYLE, STYLE_DASH);
                    ObjectSetInteger(DCID.chartID,_levelObjName, OBJPROP_WIDTH, 2);
                    ObjectSetInteger(DCID.chartID,_levelObjName, OBJPROP_COLOR, clrDimGray);
                }
                FIBO_LEVELS_TYPE[nameCat].LEVELS[i].price = fiboPrice;
            }
            // ObjectCreate(DCID.chartID, _name, OBJ_FIBO, 0, time, startPrice, TimeCurrent(), endPrice);
            ChartRedraw(DCID.chartID);
        };

        double GetFiboLevel(DCOBJ_PROP _ty,int level)
        {
            return FIBO_LEVELS_TYPE[_ty].LEVELS[level].price;
        };
    } FIBO_RET;
} DCOB;

struct InterfaceHandler
{
    string id;
    void update(stc01 &_RT)
    {
        for (int i = 0; i < ArraySize(_RT.__COBS); i++)
        {
            if (DCID.symbol == _RT.symbol)
            {
                switch (_RT.__COBS[i].name)
                {
                case FIBO_RET:
                    DCOB.FIBO_RET.AddFibonacciRetracement(_START,_RT.__COBS[i].startPrice, _RT.__COBS[i].endPrice, _RT.__COBS[i].time);
                    break;
                }
            }
        }
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
