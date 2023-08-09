#include "..\Helpers\BBChartHelpers.mqh";

class BBChartAnalyzer : public BBChartHelpers
{
public:
    BBChartAnalyzer(DCInterfaceData &_DCID) : BBChartHelpers() {DCID = _DCID;};
    ~BBChartAnalyzer() {};

    void analyzeChart(_Trader &_parent) override
    {
        parent = _parent;
        Print("analizing BB ",_parent.CurrentSymbol);
        root.analyzing = true;
        root.symbol = _parent.CurrentSymbol;
        IdentifySupportResistanceLevels();
    };

    void OnTick(_Trader &_parent) override{
        parent = _parent;
        Print("ontick BB ",DCID.symbol);
        // if(_parent.CurrentSymbol == root.)CheckPriceBreakOut();
    };

    virtual void setDCIDSymbol(string _sym) override {
        DCID.symbol = _sym;
    };
};