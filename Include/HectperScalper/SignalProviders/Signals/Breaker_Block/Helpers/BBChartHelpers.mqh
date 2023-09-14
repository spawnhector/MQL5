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
        DrawRSLines.plot((string)_prnt.CurrentSymbol, Period());
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
        if (_prnt.PriceBid < ROOT.SupportLevel)
            this.checkVolume(_prnt, SUPPORTLINE, true);
        if (ROOT.SupportLevelPassed && _prnt.PriceBid > ROOT.SupportLevel)
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
                DCOB.FIBO_RET.AddFibo_Ret(startPrice, endPrice, DCID.rangeTime, _HIDE);
                calculateTPSL(_prnt, tp);
            }
            break;
        case RESISTANCELINE:
            ROOT.reverseBreakoutFound = ROOT.BOBVolume > ROOT.BBOBVolume ? true : false;
            if (ROOT.reverseBreakoutFound)
            {
                startPrice = ROOT.ResistanceLevel;
                endPrice = ROOT.SupportLevel;
                DCOB.FIBO_RET.AddFibo_Ret(startPrice, endPrice, DCID.rangeTime, _HIDE);
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

    bool checkProfit(double _profit, int _tp)
    {
        if (_profit > 0.00)
        {
            ROOT.trade.sl = DCOB.FIBO_RET.GetFiboLevel(_START, _tp - 2);
            ROOT.trade.tp = cl;
            return true;
        }
        return false;
    };

    bool profitInRange(_Trader &_prnt, int _tp)
    {
        cl = DCOB.FIBO_RET.GetFiboLevel(_REVERSE, _tp);
        if (ROOT.trade.type == BUY)
        {
            return checkProfit((cl - _prnt.PriceBid) * SymbolInfoDouble(_prnt.CurrentSymbol, SYMBOL_MARGIN_INITIAL), _tp);
        }
        else if (ROOT.trade.type == SELL)
        {
            return checkProfit((_prnt.PriceBid - cl) * SymbolInfoDouble(_prnt.CurrentSymbol, SYMBOL_MARGIN_INITIAL), _tp);
        }
        return false;
    };

    void calculateTPSL(_Trader &_prnt, int _tp)
    {
        if (_tp < DCOB.FIBO_RET.fiboSize)
            if (profitInRange(_prnt, _tp))
            {
            }
            else
            {
                calculateTPSL(_prnt, _tp + 1);
            }
    };
}