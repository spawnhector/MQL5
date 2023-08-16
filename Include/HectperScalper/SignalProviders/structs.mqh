
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
    void update()
    {
        for (int i = 0; i < ArraySize(__root.__COBS); i++)
        {
            // Print(ArraySize(__root.__COBS));
            if (DCID.symbol == __root.symbol)
            {
                AddFibonacciRetracement(__root.__COBS[i].startPrice, __root.__COBS[i].endPrice);
            }
        }
    };

    void AddFibonacciRetracement(double startPrice, double endPrice)
    {
        string name = "Fibonacci_";
        ObjectCreate(DCID.chartID, name, OBJ_FIBO, 0, TimeCurrent(), startPrice, TimeCurrent(), endPrice);
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
