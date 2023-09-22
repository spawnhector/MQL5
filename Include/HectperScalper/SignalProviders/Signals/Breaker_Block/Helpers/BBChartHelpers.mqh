#include "Helpers.mqh";

class BBChartHelpers : public BBDCHelpers
{
public:
    double startPrice;
    double endPrice;
    int tp;
    double cl;

    BBChartHelpers()
    {
        tp = 3;
    };
    ~BBChartHelpers(){};

    stc01 GetRootData() const override
    {
        return ROOT;
    };

    DCInterfaceData GetInterfaceData() const override
    {
        return DCID;
    };

    ProviderData GetProviderData() const override
    {
        return providerData;
    };

    void IdentifySupportResistanceLevels(_Trader &_prnt)
    {
        DrawRSLines.plot((string)_prnt.CurrentSymbol, PERIOD_M1);
        ROOT.SupportLevel = DrawRSLines.rangeLow;
        ROOT.ResistanceLevel = DrawRSLines.rangeHigh;
        ROOT.rangeTime = DrawRSLines.rangeTime;
        __COB.name = BREAKOUT_LEVELS;
        __COB.support = ROOT.SupportLevel;
        __COB.resistance = ROOT.ResistanceLevel;
        __COB.time = ROOT.rangeTime;
        this.addRootObject(__COB);
    };

    void CheckPriceBreakOut(_Trader &_prnt)
    {
        if (_prnt.PriceAsk < ROOT.SupportLevel)
            this.checkVolume(_prnt, SUPPORTLINE, true);
        if (ROOT.SupportLevelPassed && _prnt.PriceAsk > ROOT.SupportLevel)
            this.unCheckVolume(_prnt, SUPPORTLINE, false);
        if (_prnt.PriceBid > ROOT.ResistanceLevel)
            this.checkVolume(_prnt, RESISTANCELINE, true);
        if (ROOT.ResistanceLevelPassed && _prnt.PriceBid < ROOT.ResistanceLevel)
            this.unCheckVolume(_prnt, RESISTANCELINE, false);
    };

    void switchLevelType(int levelType, bool typeVal) // level type: SUPPORTLINE support(low), RESISTANCELINE resistance(high)
    {
        switch (levelType)
        {
        case SUPPORTLINE:
            ROOT.SupportLevelPassed = typeVal;
            break;
        case RESISTANCELINE:
            ROOT.ResistanceLevelPassed = typeVal;
            break;
        }
    };

    void switchTradeType(int levelType)
    {
        switch (levelType)
        {
        case SUPPORTLINE:
            ROOT.trade.type = SELL;
            break;
        case RESISTANCELINE:
            ROOT.trade.type = BUY;
            break;
        }
    };

    void isBOFound(int levelType)
    {
        switch (levelType)
        {
        case SUPPORTLINE:
            ROOT.breakoutFound = ROOT.BOBVolume > ROOT.BBOBVolume ? true : false;
            break;
        case RESISTANCELINE:
            ROOT.breakoutFound = ROOT.BOBVolume < ROOT.BBOBVolume ? true : false;
            break;
        }
    };

    void isRBOFound(_Trader &_prnt, int levelType)
    {
        switch (levelType)
        {
        case SUPPORTLINE:
            ROOT.reverseBreakoutFound = ROOT.BOBVolume < ROOT.BBOBVolume ? true : false;
            if (ROOT.reverseBreakoutFound)
            {
                startPrice = ROOT.SupportLevel;
                endPrice = ROOT.ResistanceLevel;
                DCOB.FIBO_RET.AddFibo_Ret(__chartSymbol.symbolIndex(_prnt.CurrentSymbol), startPrice, endPrice, DCID.rangeTime, _HIDE);
                calculateTPSL(_prnt, tp);
            }
            break;
        case RESISTANCELINE:
            ROOT.reverseBreakoutFound = ROOT.BOBVolume > ROOT.BBOBVolume ? true : false;
            if (ROOT.reverseBreakoutFound)
            {
                startPrice = ROOT.ResistanceLevel;
                endPrice = ROOT.SupportLevel;
                DCOB.FIBO_RET.AddFibo_Ret(__chartSymbol.symbolIndex(_prnt.CurrentSymbol), startPrice, endPrice, DCID.rangeTime, _HIDE);
                calculateTPSL(_prnt, tp);
            }
            break;
        }
        if (ROOT.reverseBreakoutFound)
        {
            __COB.name = FIBO_RET;
            __COB.startPrice = startPrice;
            __COB.endPrice = endPrice;
            __COB.time = ROOT.rangeTime;
            this.addRootObject(__COB);
            this.switchTradeType(levelType);
        }
    };

    void checkVolume(_Trader &_prnt, int levelType, bool typeVal)
    {
        this.switchLevelType(levelType, typeVal);
        if (!ROOT.volumeChecked)
        {
            ROOT.volumeChecked = true;
            ROOT.BOBVolume = iVolume(_prnt.CurrentSymbol, PERIOD_M1, _prnt.previousBar);
            ROOT.BBOBVolume = iVolume(_prnt.CurrentSymbol, PERIOD_M1, _prnt.previousBar + 1);
            if (!ROOT.breakoutFound)
                this.isBOFound(levelType);
            if (ROOT.breakoutFound)
                this.isRBOFound(_prnt, levelType);
        }
    };

    void unCheckVolume(_Trader &_prnt, int levelType, bool typeVal)
    {
        this.switchLevelType(levelType, typeVal);
        ROOT.volumeChecked = false;
    };

    bool checkProfit(_Trader &_prnt, double _profit, int _tp, DCOBJ_PROP _ty)
    {
        if (_profit > 0.01)
        {
            ROOT.trade.sl = DCOB.FIBO_RET.GetFiboLevel(__chartSymbol.symbolIndex(_prnt.CurrentSymbol), _ty, _tp - 2);
            ROOT.trade.tp = cl;
            return true;
        }
        return false;
    };

    bool profitInRange(_Trader &_prnt, int _tp)
    {
        double TickValue = SymbolInfoDouble(_prnt.CurrentSymbol, SYMBOL_TRADE_TICK_VALUE);
        double TickSize = SymbolInfoDouble(_prnt.CurrentSymbol, SYMBOL_TRADE_TICK_SIZE);
        double lots = 0.05;
        cl = DCOB.FIBO_RET.GetFiboLevel(__chartSymbol.symbolIndex(_prnt.CurrentSymbol), (ROOT.trade.type == BUY ? _REVERSE : _START), _tp);
        switch (ROOT.trade.type)
        {
        case BUY:
            if (cl > _prnt.PriceAsk)
            {
                double pl = (cl - _prnt.PriceAsk);
                double prof = pl * (TickValue / TickSize) * lots;
                return checkProfit(_prnt, prof, _tp, (ROOT.trade.type == BUY ? _START : _REVERSE));
            }
            break;
        case SELL:
            if (_prnt.PriceBid > cl)
            {
                double pl = (_prnt.PriceBid - cl);
                double prof = pl * (TickValue / TickSize) * lots;
                return checkProfit(_prnt, prof, _tp, (ROOT.trade.type == BUY ? _START : _REVERSE));
            }
            break;
        }
        return false;
    };

    void calculateTPSL(_Trader &_prnt, int _tp)
    {
        if (_tp < (DCOB.FIBO_RET.fiboSize - 1))
        {
            if (!profitInRange(_prnt, _tp))
                calculateTPSL(_prnt, _tp + 1);
            else
                ROOT.reverseBreakoutFound = true;
        }
        else
            ROOT.reverseBreakoutFound = false;
    };
}