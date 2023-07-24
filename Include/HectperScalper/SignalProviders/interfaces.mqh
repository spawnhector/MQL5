
interface __Trader
{
public:
    virtual ProviderData GetProviderData() const = 0;
    // virtual DCInterface* GetDCInterface() { return __Interface;};
    virtual void _Trade(_Trader &parent){};
    virtual void clearBase(){};
    virtual void DispatchMessage(const int id, const long &lparam, const double &dparam, const string &sparam){};
};

interface DCInterface
{
public:
    virtual DCInterfaceData GetInterfaceData() const = 0;
    // virtual void createDuplicateChart(string symb){};
};


interface D_C
{
public:
    virtual void analyzeChart(_Trader &_parent){};
    // virtual void createDuplicateChart(string symb){};
};

__Trader* trader;
D_C *_Inface;
interface Provider
{
public:
    virtual ProviderData GetProviderData() const = 0;
    virtual __Trader* GetTrader() { return trader;};
    // virtual void startAnalizer(_Trader &_parent){};
    virtual D_C* getChartInterface(){return _Inface;};
    void DispatchMessage(const int id, const long &lparam, const double &dparam, const string &sparam){};
    virtual void addIndex(int index){};
    virtual void clearBase(){};
    
};