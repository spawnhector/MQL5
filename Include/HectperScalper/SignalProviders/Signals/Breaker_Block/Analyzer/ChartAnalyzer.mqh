#include "..\Helpers\BBChartHelpers.mqh";

class ChartAnalyzer : public BBChartHelpers
{
public:
    ChartAnalyzer(_Trader &_parent) : BBChartHelpers() {parent = _parent;}
    ~ChartAnalyzer() {}

    void analyzeChart()
    {
        root.analyzing = true;
        IdentifySupportResistanceLevels();
    }
    
    void analyzeOnTick(_Trader &_parent){
        parent = _parent;
        CheckPriceBreakOut();
    }
}