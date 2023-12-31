#include "Helpers.mqh";

class BBChartHelpers : public BBDCHelpers
{
public:
    double startPrice;
    double endPrice;
    int tp;
    double cl;
    double tempCl;
    double foundTempCl;

    BBChartHelpers()
    {
        tp = 2;
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
        if (ROOT.SupportLevelPassed && _prnt.PriceBid > ROOT.SupportLevel)
            this.unCheckVolume(_prnt, SUPPORTLINE, false);
        if (_prnt.PriceBid > ROOT.ResistanceLevel)
            this.checkVolume(_prnt, RESISTANCELINE, true);
        if (ROOT.ResistanceLevelPassed && _prnt.PriceAsk < ROOT.ResistanceLevel)
            this.unCheckVolume(_prnt, RESISTANCELINE, false);
    };

    void checkVolume(_Trader &_prnt, int levelType, bool typeVal)
    {
        _prnt.newBarCount++;
        this.switchLevelType(levelType, typeVal);
        this.switchTradeType(levelType);
        if (!ROOT.volumeChecked)
        {
            ROOT.volumeChecked = true;
            ROOT.BOBVolume = iVolume(_prnt.CurrentSymbol, PERIOD_M1, _prnt.previousBar);
            ROOT.BBOBVolume = iVolume(_prnt.CurrentSymbol, PERIOD_M1, _prnt.previousBar + 1);
            if (!ROOT.breakoutFound)
                this.isBOFound(_prnt, levelType);
            if (ROOT.breakoutFound)
                this.isRBOFound(_prnt, levelType);
        };
    };

    void unCheckVolume(_Trader &_prnt, int levelType, bool typeVal)
    {
        this.switchLevelType(levelType, typeVal);
        ROOT.volumeChecked = false;
        _prnt.newBarCount = 0;
    };

    void isBOFound(_Trader &_prnt, int levelType)
    {
        switch (levelType)
        {
        case SUPPORTLINE:
            ROOT.breakoutFound = ROOT.BOBVolume < ROOT.BBOBVolume ? true : false;
            break;
        case RESISTANCELINE:
            ROOT.breakoutFound = ROOT.BOBVolume > ROOT.BBOBVolume ? true : false;
            break;
        }
        if (!ROOT.breakoutFound)
            ROOT.volumeChecked = false;
    };

    void isRBOFound(_Trader &_prnt, int levelType)
    {
        switch (levelType)
        {
        case SUPPORTLINE:
            ROOT.reverseBreakoutFound = ROOT.BOBVolume > ROOT.BBOBVolume ? true : false;
            if (ROOT.reverseBreakoutFound)
            {
                startPrice = ROOT.ResistanceLevel;
                endPrice = ROOT.SupportLevel;
                DCOB.FIBO_RET.AddFibo_Ret(__chartSymbol.symbolIndex(_prnt.CurrentSymbol), startPrice, endPrice, DCID.rangeTime, _HIDE);
                calculateTPSL(_prnt, tp);
            }
            break;
        case RESISTANCELINE:
            ROOT.reverseBreakoutFound = ROOT.BOBVolume < ROOT.BBOBVolume ? true : false;
            if (ROOT.reverseBreakoutFound)
            {
                startPrice = ROOT.SupportLevel;
                endPrice = ROOT.ResistanceLevel;
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
        }
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
            ROOT.trade.type = BUY ;
            break;
        }
    };

    bool calculateSL(double greater, double lesser, AppValues _type)
    {
        double diff = (greater - lesser) / 2;
        if (_type == BUY)
            ROOT.trade.sl = lesser - diff;
        if (_type == SELL)
            ROOT.trade.sl = greater + diff;
        return true;
    };

    bool checkProfit(_Trader &_prnt, double _profit, int _tp, DCOBJ_PROP _ty)
    {
        if (_profit > 2.00)
        {
            ROOT.trade.tp = cl;
            return true;
        }
        return false;
    };

    bool profitInRange(_Trader &_prnt, int _tp)
    {
        double TickValue = SymbolInfoDouble(_prnt.CurrentSymbol, SYMBOL_TRADE_TICK_VALUE);
        double TickSize = SymbolInfoDouble(_prnt.CurrentSymbol, SYMBOL_TRADE_TICK_SIZE);
        cl = DCOB.FIBO_RET.GetFiboLevel(__chartSymbol.symbolIndex(_prnt.CurrentSymbol), _START, _tp);
        switch (ROOT.trade.type)
        {
        case BUY:
            if (cl > _prnt.PriceAsk)
            {
                double pl = (cl - _prnt.PriceAsk);
                double prof = pl * (TickValue / TickSize) * lot_size;
                return checkProfit(_prnt, prof, _tp, _START) ? calculateSL(cl, _prnt.PriceAsk, BUY) : false;
            }
            break;
        case SELL:
            if (_prnt.PriceBid > cl)
            {
                double pl = (_prnt.PriceBid - cl);
                double prof = pl * (TickValue / TickSize) * lot_size;
                return checkProfit(_prnt, prof, _tp, _START) ? calculateSL(_prnt.PriceBid, cl, SELL) : false;
            }
            break;
        }
        return false;
    };

    void trailProfit(_Trader &_prnt, int _tp)
    {
        if (_tp < (DCOB.FIBO_RET.fiboSize - 1))
        {
            if (!profitInReverse(_prnt, _tp))
            {
                trailProfit(_prnt, _tp + 1);
            }
            else
            {
                for (int i = PositionsTotal() - 1; i >= 0; i--)
                {
                    ulong tempTicket = PositionGetTicket(i);
                    if (tempTicket == _prnt.__Ticket)
                    {
                        // PositionSelect(tempTicket);
                        // if (PositionModify(tempTicket, PositionGetDouble(POSITION_VOLUME), PositionGetDouble(POSITION_PRICE_OPEN), tempCl, PositionGetDouble(POSITION_TP), newComment) == POS_ERR_NO_ERROR)
                        // {
                        //     Print("Position ", position_ticket, " comment modified to: ", newComment);
                        // }
                        // else
                        // {
                        //     Print("Failed to modify the position comment.");
                        // }
                        m_trade.PositionModify(_prnt.__Ticket, tempCl, PositionGetDouble(POSITION_TP));
                        // Posi
                    }
                }
            };
        };
    };

    bool profitInReverse(_Trader &_prnt, int _tp)
    {
        bool result = false;
        tempCl = DCOB.FIBO_RET.GetFiboLevel(__chartSymbol.symbolIndex(_prnt.CurrentSymbol), _START, _tp);
        long currentVol = iVolume(_prnt.CurrentSymbol, PERIOD_M1, _prnt.previousBar);
        switch (ROOT.trade.type)
        {
        case BUY:
            if ((_prnt.PriceBid > ROOT.ResistanceLevel) 
            && (tempCl > ROOT.ResistanceLevel) 
            && (_prnt.PriceBid > tempCl) 
            && (foundTempCl == 0 || tempCl > foundTempCl))
            {
                foundTempCl = tempCl;
                result = true;
            };
            break;
        case SELL:
            if ((_prnt.PriceAsk < ROOT.SupportLevel ) 
            && (tempCl < ROOT.SupportLevel) 
            && (_prnt.PriceAsk < tempCl) 
            && (foundTempCl == 0 || tempCl < foundTempCl))
            {
                foundTempCl = tempCl;
                result = true;
            };
            break;
        };
        return result;
    };
}