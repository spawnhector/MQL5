#include "..\Helpers\BBChartHelpers.mqh";

class BBChartAnalyzer : public BBChartHelpers
{
public:
    TradeOptimizer *Optimizer;
    BBChartAnalyzer(ProviderData &_providerData) : BBChartHelpers()
    {
        Optimizer = new TradeOptimizer();
        providerData = _providerData;
    };
    ~BBChartAnalyzer()
    {
        delete Optimizer;
    };

    void analyzeChart(_Trader &_parent) override
    {
        ROOT.analyzing = true;
        ROOT.symbol = _parent.CurrentSymbol;
        IdentifySupportResistanceLevels(_parent);
    };

    void reAnalyzeChart(_Trader &_parent) override
    {
        ROOT.analyzing = true;
        DCID.root.removeObject(ROOT);
        IdentifySupportResistanceLevels(_parent);
        DCID.root.toUpdate = true;
        ROOT.trade.open = false;
    };

    void OnTick(_Trader &_parent) override
    {
        InterfaceRoot.startTickCount = GetTickCount();
        CheckPriceBreakOut(_parent);
        InterfaceRoot.LogExecutionTime("Check price break out for " + _parent.CurrentSymbol, InterfaceRoot.startTickCount);
        if (ROOT.reverseBreakoutFound)
        {
            InterfaceRoot.startTickCount = GetTickCount();
            _parent._Trade(ROOT);
            InterfaceRoot.LogExecutionTime("Placing trade for " + _parent.CurrentSymbol, InterfaceRoot.startTickCount);
        };
    };

    void UpdateInterface(_Trader &_parent) override
    {
        if (DCID.symbol == ROOT.symbol)
        {
            __COB.name = ASK_LINE;
            __COB.line_price = _parent.PriceAsk;
            this.addRootObject(__COB);
            DCID.root.update(ROOT);
        };
    };

    void Optimize(_Trader &_parent) override
    {
        InterfaceRoot.startTickCount = GetTickCount();
        Optimizer.optimize(_parent, ROOT, this);
        InterfaceRoot.LogExecutionTime("Optimizer for " + _parent.CurrentSymbol, InterfaceRoot.startTickCount);
    };
};