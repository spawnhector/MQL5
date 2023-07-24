#include "..\Helpers\BBChartHelpers.mqh";

class BBChartAnalyzer : public BBChartHelpers
{
public:
    BBChartAnalyzer() : BBChartHelpers() {}
    ~BBChartAnalyzer() {}

    void analyzeChart(_Trader &_parent)
    {
        parent = _parent;
        Print("analizing ",_parent.CurrentSymbol);
        root.analyzing = true;
        root.symbol = _parent.CurrentSymbol;
        IdentifySupportResistanceLevels();
    }

    void analyzeOnTick(_Trader &_parent){
        parent = _parent;
        Print(root.symbol);
        // if(_parent.CurrentSymbol == root.)CheckPriceBreakOut();
    }
}