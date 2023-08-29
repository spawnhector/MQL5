#include "..\Helpers\BBChartHelpers.mqh";

class BBChartAnalyzer : public BBChartHelpers
{
public:
    TradeOptimizer *Optimizer;
    BBChartAnalyzer(ProviderData &_providerData) : BBChartHelpers() {
        Optimizer = new TradeOptimizer();
        providerData = _providerData;
    };
    ~BBChartAnalyzer() {
        delete Optimizer;
    };

    void analyzeChart(_Trader &_parent) override
    {
        ROOT.analyzing = true;
        ROOT.symbol = _parent.CurrentSymbol;
        IdentifySupportResistanceLevels(_parent);
    };
    
    void OnTick(_Trader &_parent) override{
        CheckPriceBreakOut(_parent);
        if (ROOT.reverseBreakoutFound) _parent._Trade(ROOT);
    };

    void OnTestTick(_Trader &_parent) override{
        _parent._TestTrade(ROOT);
    };

    void UpdateInterface() override{
        DCID.root.update(ROOT);
    };

    void Optimize(_Trader &_parent) override{
        Optimizer.optimize(_parent,ROOT);
    };
};