
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
    virtual stc01 GetRootData() const = 0;
    virtual ProviderData GetProviderData() const = 0;
    virtual void OnTick(_Trader &_parent){};
    virtual void analyzeChart(_Trader &_parent){};
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
    virtual DCInterface *getChartInterface() { return _INTERFACE; };
    virtual void DispatchMessage(const int id, const long &lparam, const double &dparam, const string &sparam){};
    virtual void addIndex(int index){};
    virtual void clearBase(){};
} *_PROVIDER, *_PROVIDERS[];