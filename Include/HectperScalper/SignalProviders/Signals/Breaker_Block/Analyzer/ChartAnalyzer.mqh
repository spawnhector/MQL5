#include "..\Helpers\BBChartHelpers.mqh";

class BBChartAnalyzer : public BBChartHelpers
{
public:
    BBChartAnalyzer(ProviderData &_providerData, DCInterfaceData &_DCID) : BBChartHelpers() {
        DCID = _DCID;
        providerData = _providerData;
    };
    ~BBChartAnalyzer() {};

    void analyzeChart(_Trader &_parent) override
    {
        parent = _parent;
        ROOT.analyzing = true;
        ROOT.symbol = _parent.CurrentSymbol;
        IdentifySupportResistanceLevels();
    };

    void OnTick(_Trader &_parent) override{
        parent = _parent;
        CheckPriceBreakOut();
        if (ROOT.rereverseBreakoutFound) Print();
    };

};