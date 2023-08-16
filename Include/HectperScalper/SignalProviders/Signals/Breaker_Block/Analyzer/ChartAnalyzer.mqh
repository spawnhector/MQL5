#include "..\Helpers\BBChartHelpers.mqh";

class BBChartAnalyzer : public BBChartHelpers
{
public:
    BBChartAnalyzer(ProviderData &_providerData) : BBChartHelpers() {
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
        if (ROOT.reverseBreakoutFound) parent._Trade(ROOT);
    };

};