
class __Trader
{
public:
    virtual ProviderData GetProviderData() const = 0;
    virtual void _Trade(_Trader &parent){};
    virtual void clearBase(){};
    virtual void DispatchMessage(const int id, const long &lparam, const double &dparam, const string &sparam){};
} *_TRADER, *_TRADERS[];

class D_c
{
public:
    virtual DCInterfaceData GetInterfaceData() const = 0;
    virtual void OnTick(_Trader &_parent){};
    virtual void analyzeChart(_Trader &_parent){};
    virtual void setDCIDSymbol(string _sym){};
} *_DC,*_DCS[];

class DCInterface
{
public:
    virtual DCInterfaceData GetInterfaceData() const = 0;
    virtual D_c *getChartAnalizer() { return _DC; };
    virtual void createInterFace(string _symb){};
} *_INTERFACE, *_INTERFACES[];

class Provider
{
public:
    virtual ProviderData GetProviderData() const = 0;
    virtual __Trader *GetTrader() { return _TRADER; };
    virtual DCInterface *getChartInterface() { return _INTERFACE; };
    void DispatchMessage(const int id, const long &lparam, const double &dparam, const string &sparam){};
    virtual void addIndex(int index){};
    virtual void clearBase(){};
} *_PROVIDER, *_PROVIDERS[];