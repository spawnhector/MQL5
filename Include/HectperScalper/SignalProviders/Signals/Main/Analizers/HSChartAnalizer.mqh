#include "..\Helpers\HSChartHelpers.mqh";

class HSChartAnalyzer : public HSChartHelpers
{
public:
    HSChartAnalyzer(DCInterfaceData &_DCID) : HSChartHelpers() {DCID=_DCID;};
    ~HSChartAnalyzer() {};

    void analyzeChart(_Trader &_parent) override
    {
        parent = _parent;
        Print("analizing HS ",_parent.CurrentSymbol);
        // Print("analizing HS trader ",_parent.CurrentSymbol);
    }

    void OnTick(_Trader &_parent) override{
        parent = _parent;
        Print("ontick HS ",DCID.symbol);
        // if(_parent.CurrentSymbol == root.)CheckPriceBreakOut();
    }
    virtual void setDCIDSymbol(string _sym) override {
        DCID.symbol = _sym;
    };
}