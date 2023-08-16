#include "..\Helpers\HSChartHelpers.mqh";

class HSChartAnalyzer : public HSChartHelpers
{
public:
    HSChartAnalyzer(ProviderData &_providerData) : HSChartHelpers() {
        providerData = _providerData;
    };
    ~HSChartAnalyzer() {};

    void analyzeChart(_Trader &_parent) override
    {
        parent = _parent;
        // Print("analizing HS trader ",_parent.CurrentSymbol);
    };

    void OnTick(_Trader &_parent) override{
        parent = _parent;
        // if(_parent.CurrentSymbol == root.)CheckPriceBreakOut();
    };
}