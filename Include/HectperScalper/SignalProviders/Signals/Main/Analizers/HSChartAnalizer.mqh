#include "..\Helpers\HSChartHelpers.mqh";

class HSChartAnalyzer : public HSChartHelpers
{
public:
    HSChartAnalyzer() : HSChartHelpers() {}
    ~HSChartAnalyzer() {}

    void analyzeChart(_Trader &_parent)
    {
        // Print("analizing HS trader ",_parent.CurrentSymbol);
    }

    void analyzeOnTick(_Trader &_parent){
        parent = _parent;
        // if(_parent.CurrentSymbol == root.)CheckPriceBreakOut();
    }
}