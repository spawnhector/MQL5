
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
    int tradeType;
    bool tradeOpen;
    chartObjects __COBS[];
} __root;

struct ChartObjects
{
    struct Fibo_Ret
    {
        string _name;
        void AddFibonacciRetracement(double startPrice, double endPrice, datetime time)
        {
            _name= "Fibonacci_";
            bool result = true;
            int found = ObjectFind(DCID.chartID, _name);
            if (found < 0)
            {
                result = ObjectCreate(DCID.chartID, _name, OBJ_FIBO, 0, time, startPrice, TimeCurrent(), endPrice);
            }
            else
            {
                result &= ObjectSetInteger(DCID.chartID, _name, OBJPROP_TIME, 0, time);
                result &= ObjectSetInteger(DCID.chartID, _name, OBJPROP_TIME, 1, TimeCurrent());
                result &= ObjectSetDouble(DCID.chartID, _name, OBJPROP_PRICE, 0, startPrice);
                result &= ObjectSetDouble(DCID.chartID, _name, OBJPROP_PRICE, 1, endPrice);
            }
            ChartRedraw(DCID.chartID);
            PrintFormat("Level 2=%f, level 6=%f", GetFiboLevel(DCID.chartID, 2), GetFiboLevel(DCID.chartID, 6));
        };

        bool GetFiboStart(long chartId, datetime &time, double &price){
             return (GetFiboPoint(chartId, 0, time, price));
        };

        bool GetFiboEnd(long chartId, datetime &time, double &price){
             return (GetFiboPoint(chartId, 1, time, price));
        };

        bool GetFiboPoint(long chartId, int pointNumber, datetime &time, double &price)
        {
            int found = ObjectFind(chartId, _name);
            if (found < 0)
                return (false);
            time = (datetime)ObjectGetInteger(chartId, _name, OBJPROP_TIME, pointNumber);
            price = ObjectGetDouble(chartId, _name, OBJPROP_PRICE, pointNumber);
            return (true);
        };

        double GetFiboLevelByRatio(long chartId, double ratio)
        {
            datetime time;
            double value1;
            double value2;
            if (!GetFiboStart(chartId, time, value1))
                return (0);
            if (!GetFiboEnd(chartId, time, value2))
                return (0);
            return (GetFiboLevelByRatio(value1, value2, ratio));
        };

        double GetFiboLevelByRatio(double value1, double value2, double ratio){
             return (value2 + ((value1 - value2) * ratio));
        };

        double GetFiboLevel(long chartId, int level)
        {
            int found = ObjectFind(chartId, _name);
            if (found < 0)
            {
                PrintFormat("%s not found", _name);
                return (0);
            }

            if (level >= ObjectGetInteger(chartId, _name, OBJPROP_LEVELS))
            {
                PrintFormat("Invalid level %i", level);
                return (0);
            }
            double ratio = ObjectGetDouble(chartId, _name, OBJPROP_LEVELVALUE, level);
            return (GetFiboLevelByRatio(chartId, ratio));
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
                    DCOB.FIBO_RET.AddFibonacciRetracement(_RT.__COBS[i].startPrice, _RT.__COBS[i].endPrice, _RT.__COBS[i].time);
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
