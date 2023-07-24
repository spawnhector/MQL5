
class TraderFindPeak
{
protected:
    double Bid;
    double Equity;
    double Profit;
    double ask;
    double point;
    int currentBar;
    int foundBar;
    int index_highest;
    int index_lowest;
    double prevHigh;
    double prevLow;
    double foundBarLowprice;
    double foundBarHighprice;
    double currentBarLowprice;
    double currentBarHighprice;
    double prevBuyPrice;
    double prevSellPrice;
    int index_highest1;
    int index_lowest1;
    int index_highest1_2;
    int index_lowest1_2;
    string barType;
    int sl_extend;
    double tickSize;
    double contract;
    double dtp;

public:
    //+------------------------------------------------------------------+
    //|                Getters                                                  |
    //+------------------------------------------------------------------+
    virtual double GetBid()
    {
        return Bid;
    }
    virtual double GetEquity()
    {
        return Equity;
    }
    virtual double GetProfit()
    {
        return Profit;
    }
    virtual double GetAsk()
    {
        return ask;
    }
    virtual double GetPoint()
    {
        return point;
    }
    virtual int GetCurrentBar()
    {
        return currentBar;
    }
    virtual int GetFoundBar()
    {
        return foundBar;
    }
    virtual double GetFoundBarLowprice()
    {
        return foundBarLowprice;
    }
    virtual double GetFoundBarHighprice()
    {
        return foundBarHighprice;
    }
    virtual double GetCurrentBarLowprice()
    {
        return currentBarLowprice;
    }
    virtual double GetCurrentBarHighprice()
    {
        return currentBarHighprice;
    }

    //+------------------------------------------------------------------+
    //|                                                                  |
    //+------------------------------------------------------------------+
    int FindPeak(_Trader &parent, int mode, int count, int startBar, string _barType)
    {
        sl_extend = 20;
        barType = _barType;
        Bid = parent.GetPriceBid();
        Equity = AccountInfoDouble(ACCOUNT_EQUITY);
        Profit = AccountInfoDouble(ACCOUNT_PROFIT);
        ask = parent.GetPriceAsk();

        tickSize = SymbolInfoDouble(parent.GetCurrentSymbol(), SYMBOL_TRADE_TICK_SIZE);
        contract = SymbolInfoDouble(parent.GetCurrentSymbol(), SYMBOL_TRADE_CONTRACT_SIZE);
        point = NormalizeDouble(SymbolInfoDouble(parent.GetCurrentSymbol(), SYMBOL_POINT), _Digits);

        if (mode != MODE_HIGH && mode != MODE_LOW)
            return (-1);

        currentBar = startBar;
        foundBar = FindNextPeak(parent, mode, count * 2 + 1, currentBar - count);
        while (foundBar != currentBar)
        {
            currentBar = FindNextPeak(parent, mode, count, currentBar + 1);
            foundBar = FindNextPeak(parent, mode, count * 2 + 1, currentBar - count);

            foundBarLowprice = iHigh(parent.GetCurrentSymbol(), T[parent.GetIndex()], foundBar);
            foundBarHighprice = iHigh(parent.GetCurrentSymbol(), T[parent.GetIndex()], foundBar);

            CopyRates(parent.GetCurrentSymbol(), T[parent.GetIndex()], 0, MAX_CANDELS, parent.candels);
            CopyClose(parent.GetCurrentSymbol(), T[parent.GetIndex()], 0, MAX_CANDELS, parent.closes);

            //////////////////////////////////////////////////////////////////////////
            //
            //////////////////////////////////////////////////////////////////////////
            index_highest1 = ArrayMaximum(parent.closes, 0, MAX_CANDELS);
            index_lowest1 = ArrayMinimum(parent.closes, 0, MAX_CANDELS);
            ObjectDelete(0, "TrendLineHigh" + parent.GetCurrentSymbol());
            ObjectCreate(0, "TrendLineHigh" + parent.GetCurrentSymbol(), OBJ_HLINE, 0, 0, parent.candels[index_highest1].close);

            ObjectDelete(0, "TrendLineLow" + parent.GetCurrentSymbol());
            ObjectCreate(0, "TrendLineLow" + parent.GetCurrentSymbol(), OBJ_HLINE, 0, 0, parent.candels[index_lowest1].close);

            ObjectSetInteger(0, "TrendLineHigh" + parent.GetCurrentSymbol(), OBJPROP_COLOR, clrGold);
            ObjectSetInteger(0, "TrendLineLow" + parent.GetCurrentSymbol(), OBJPROP_COLOR, clrGold);

            ObjectSetInteger(0, "TrendLineHigh" + parent.GetCurrentSymbol(), OBJPROP_WIDTH, 2);
            ObjectSetInteger(0, "TrendLineLow" + parent.GetCurrentSymbol(), OBJPROP_WIDTH, 2);

            ObjectMove(0, "TrendLineHigh" + parent.GetCurrentSymbol(), 0, 0, parent.candels[index_highest1].close);
            ObjectMove(0, "TrendLineLow" + parent.GetCurrentSymbol(), 0, 0, parent.candels[index_lowest1].close);
            //////////////////////////////////////////////////////////////////////////
            //
            /////////////////////////////////////////////////////////////////////////
            index_highest1_2 = ArrayMaximum(parent.closes, 0, MAX_CANDELS);
            index_lowest1_2 = ArrayMinimum(parent.closes, 0, MAX_CANDELS);
            ObjectDelete(0, "TrendLineHigh_2" + parent.GetCurrentSymbol());
            ObjectCreate(0, "TrendLineHigh_2" + parent.GetCurrentSymbol(), OBJ_HLINE, 0, 0, parent.candels[index_highest1_2].close);

            ObjectDelete(0, "TrendLineLow_2" + parent.GetCurrentSymbol());
            ObjectCreate(0, "TrendLineLow_2" + parent.GetCurrentSymbol(), OBJ_HLINE, 0, 0, parent.candels[index_lowest1_2].close);

            ObjectSetInteger(0, "TrendLineHigh_2" + parent.GetCurrentSymbol(), OBJPROP_COLOR, clrGreen);
            ObjectSetInteger(0, "TrendLineLow_2" + parent.GetCurrentSymbol(), OBJPROP_COLOR, clrGreen);

            ObjectSetInteger(0, "TrendLineHigh_2" + parent.GetCurrentSymbol(), OBJPROP_WIDTH, 2);
            ObjectSetInteger(0, "TrendLineLow_2" + parent.GetCurrentSymbol(), OBJPROP_WIDTH, 2);

            ObjectMove(0, "TrendLineHigh_2" + parent.GetCurrentSymbol(), 0, 0, parent.candels[index_highest1_2].close);
            ObjectMove(0, "TrendLineLow_2" + parent.GetCurrentSymbol(), 0, 0, parent.candels[index_lowest1_2].close);
            //////////////////////////////////////////////////////////////////////////
            //
            //////////////////////////////////////////////////////////////////////////

            index_highest = parent.GetIndex_highest();
            index_lowest = parent.GetIndex_lowest();

            prevHigh = parent.GetPrevHigh(index_highest);
            prevLow = parent.GetPrevLow(index_lowest);
            prevBuyPrice = parent.GetPrevBuyPrice(parent.GetBuyIndex());
            prevBuyPrice = parent.GetPrevSellPrice(parent.GetSellIndex());

            currentBarLowprice = iHigh(parent.GetCurrentSymbol(), T[parent.GetIndex()], currentBar);
            currentBarHighprice = iHigh(parent.GetCurrentSymbol(), T[parent.GetIndex()], currentBar);

            double minTradeSizeCal = (parent.candels[index_highest1].close - parent.candels[index_lowest1].close) * (contract * tickSize);
            minTradeSize = minTradeSizeCal * contract;
            dtp = point * (MAX_CANDELS*2);

            if ((foundBarHighprice != 0.0))
            {
                if (barType == "High")
                {
                    // _Sell(parent);
                    _Buy(parent);
                    // optimizer.modifySellTrade(
                    //     parent,
                    //     Bid,
                    //     point,
                    //     barType,
                    //     parent.candels[index_highest1_2].close
                    //     );
                }
            }
            if ((foundBarLowprice != 0.0))
            {
                if (barType == "Low")
                {
                    _Sell(parent);
                    // _Buy(parent);
                    // optimizer.modifyBuyTrade(
                    //     parent, 
                    //     Bid, 
                    //     point, 
                    //     barType, 
                    //     parent.candels[index_lowest1_2].close
                    //     );
                }
            }
        }
        return (currentBar);
    }

    //+------------------------------------------------------------------+
    //|                                                                  |
    //+------------------------------------------------------------------+
    int FindNextPeak(_Trader &parent, int mode, int count, int startBar)
    {
        if (startBar < 0)
        {
            count += startBar;
            startBar = 0;
        }
        return ((mode == MODE_HIGH) ? iHighest(parent.GetCurrentSymbol(), T[parent.GetIndex()], (ENUM_SERIESMODE)mode, count, startBar) : iLowest(parent.GetCurrentSymbol(), T[parent.GetIndex()], (ENUM_SERIESMODE)mode, count, startBar));
    }

    void toBuyRev(_Trader &parent, double sellprice)
    {
        // double tp = (parent.candels[index_lowest1].close - ((point*getSpread()) + (point*2)));
        // int MagicNumber = GetNextMagicNumber();
        double tp = sellprice - dtp;

        ///////// sell config /////////////
        m_trade.SetExpertMagicNumber(parent.GetMagicF());
        double takeProfitPips = sellprice - tp;
        double sl = sellprice + (takeProfitPips/2);
        // double sl = foundBarHighprice;
        /////////// sell config /////////////
        double CorrectedLot = OptimalLot(parent.GetCurrentSymbol(), takeProfitPips);
        if (m_trade.Sell(CorrectedLot, parent.GetCurrentSymbol(), sellprice, sl, tp, NULL))
        {
            ulong Ticket = m_trade.ResultOrder();
            parent.addOpenBuyOrderBar(sellprice);
            parent.addPrevFoundHigh(foundBarHighprice);
            parent.addOpenOrder(parent.GetMagicF());
            order_magic = order_magic + 1;
            sendSignal("'trade_status':'Open','trade_ticket':" + IntegerToString(Ticket) + ",'trade_type':'Buy','trade_price':" + DoubleToString(sellprice) + ",'take_profit':" + DoubleToString(tp) + ",'magic':" + IntegerToString(parent.GetMagicF()));
        }
    }

    void toSellRev(_Trader &parent, double buyprice)
    {

       // double tp = (parent.candels[index_highest1].close - ((point*getSpread()) + (point*2)));
        double tp = buyprice + dtp;
        // int MagicNumber = GetNextMagicNumber();

        /////////// buy config /////////////
        m_trade.SetExpertMagicNumber(parent.GetMagicF());
        double takeProfitPips = tp - buyprice;
        double sl = buyprice - (takeProfitPips/2);
        // double sl = foundBarLowprice;
        /////////// buy config /////////////
        double CorrectedLot = OptimalLot(parent.GetCurrentSymbol(), takeProfitPips);
        if (m_trade.Buy(CorrectedLot, parent.GetCurrentSymbol(), buyprice, sl, tp, NULL))
        {
            ulong Ticket = m_trade.ResultOrder();
            parent.addOpenSellOrderBar(buyprice);
            parent.addPrevFoundLow(foundBarLowprice);
            parent.addOpenOrder(parent.GetMagicF());
            order_magic = order_magic + 1;
            sendSignal("'trade_status':'Open','trade_ticket':" + IntegerToString(Ticket) + ",'trade_type':'Sell','trade_price':" + DoubleToString(Bid) + ",'take_profit':" + DoubleToString(tp) + ",'magic':" + IntegerToString(parent.GetMagicF()));
        }
    }

    void _Buy(_Trader &parent)
    {
        parent.addPrevFoundLow(foundBarLowprice);
        // ObjectDelete(0, "TrendLineLow-" + DoubleToString(prevLow));
        // ObjectCreate(0, "TrendLineLow-" + DoubleToString(prevLow), OBJ_HLINE, 0, iTime(parent.GetCurrentSymbol(), T[parent.GetIndex()], foundBar), iLow(parent.GetCurrentSymbol(), T[parent.GetIndex()], foundBar));
        // ObjectSetInteger(0, "TrendLineLow-" + DoubleToString(prevLow), OBJPROP_COLOR, chartFixedTrendingLineColor(barType));
        // ObjectSetInteger(0, "TrendLineLow-" + DoubleToString(prevLow), OBJPROP_WIDTH, 0);
        
          if (
            (prevHigh != 0.0) 
            && (prevBuyPrice == 0.0 ? true : (Bid < prevBuyPrice)) 
            && (Bid < prevLow) 
            // && (parent.getTrendLinePrice("TrendLineLow-" + DoubleToString(0.00000000)) < foundBarLowprice) 
            // && (Bid == foundBarLowprice) 
            && !parent.searchArray(Bid, 1) 
            && parent.isMintradeSize(Bid, 1, point)
            // && (parent.candels[index_highest1_2].close == parent.candels[index_highest1].close)
            && (parent.candels[index_highest1].close == Bid)
        )
        {
            toBuyRev(parent, Bid);
        }
        
    }

    void _Sell(_Trader &parent)
    {
        parent.addPrevFoundHigh(foundBarHighprice);
        // ObjectDelete(0, "TrendLineHigh-" + DoubleToString(prevHigh));
        // ObjectCreate(0, "TrendLineHigh-" + DoubleToString(prevHigh), OBJ_HLINE, 0, iTime(parent.GetCurrentSymbol(), T[parent.GetIndex()], foundBar), iHigh(parent.GetCurrentSymbol(), T[parent.GetIndex()], foundBar));
        // ObjectSetInteger(0, "TrendLineHigh-" + DoubleToString(prevHigh), OBJPROP_COLOR, chartFixedTrendingLineColor(barType));
        // ObjectSetInteger(0, "TrendLineHigh-" + DoubleToString(prevHigh), OBJPROP_WIDTH, 0);
        if (
            (prevLow != 0.0) 
            && (prevSellPrice == 0.0 ? true : (Bid > prevSellPrice)) 
            // && (parent.getTrendLinePrice("TrendLineHigh-" + DoubleToString(0.00000000)) > foundBarHighprice) 
            && (Bid > prevHigh) 
            && !parent.searchArray(ask, 2) 
            && parent.isMintradeSize(ask, 2, point)
            // && (parent.candels[index_highest1_2].close == parent.candels[index_highest1].close)
            && (parent.candels[index_lowest1].close == Bid)
        )
        {
            toSellRev(parent, ask);
        }
    }
}