
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
    string name;
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

struct InterfaceHandler
{
    string id;
    void update(stc01 &_RT)
    {
        for (int i = 0; i < ArraySize(_RT.__COBS); i++)
        {
            Print("here");
            if (DCID.symbol == _RT.symbol)
            {
                AddFibonacciRetracement(_RT.__COBS[i].startPrice, _RT.__COBS[i].endPrice,_RT.__COBS[i].time);
            }
        }
    };

    void AddFibonacciRetracement(double startPrice, double endPrice, datetime time)
    {
        string name = "Fibonacci_";
        ObjectCreate(DCID.chartID, name, OBJ_FIBO, 0, time, startPrice, TimeCurrent(), endPrice);
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
    int symbolIndex(string sym){
        for (int i = 0; i < ArraySize(S); i++)
        {
            if(S[i]==sym) return i;
        }
        return -1;
    };
} __chartSymbol;
