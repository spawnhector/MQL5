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
        _parent.___trade = false;
        _parent.newBarCount = 0;
        ROOT.trade.open = false;
        ROOT.reverseBreakoutFound = false;
        ROOT.volumeChecked = false;
        ROOT.breakoutFound = false;
        ROOT.analyzing = true;
        DCID.root.removeObject(ROOT);
        this.foundTempCl = 0;
        this.tempCl = 0;
        IdentifySupportResistanceLevels(_parent);
        DCID.root.toUpdate = true;
    };

    void OnTick(_Trader &_parent) override
    {
        if (!_parent.___trade)
        {
            InterfaceRoot.startTickCount = GetTickCount();
            CheckPriceBreakOut(_parent);
            InterfaceRoot.LogExecutionTime("Check price break out for " + _parent.CurrentSymbol, InterfaceRoot.startTickCount);
            if (ROOT.reverseBreakoutFound)
            {
                if (_parent._Trade(ROOT))
                {
                    __COB.name = FIBO_RET;
                    __COB.startPrice = startPrice;
                    __COB.endPrice = endPrice;
                    __COB.time = ROOT.rangeTime;
                };
            }
            else
            {
                if (plotStart == _parent.newBarCount)
                    this.reAnalyzeChart(_parent);
            };
        }else{
            this.trailProfit(_parent, this.tp);
        };
    };

    void UpdateInterface(_Trader &_parent) override
    {
        if (DCID.symbol == ROOT.symbol)
        {
            // __COB.name = ASK_LINE;
            // __COB.line_price = _parent.PriceAsk;
            // this.addRootObject(__COB);
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