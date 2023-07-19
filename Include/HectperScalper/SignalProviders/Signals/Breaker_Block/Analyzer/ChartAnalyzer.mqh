#include "..\Helpers\BBChartHelpers.mqh";

class ChartAnalyzer : public BBChartHelpers
{
protected:
public:
    ChartAnalyzer() : BBChartHelpers() {}
    ~ChartAnalyzer() {}
    void analyzeChart(_Trader &parent)
    {
        root.analyzing = true;
        IdentifySupportResistanceLevels(parent);
    }
}