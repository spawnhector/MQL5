//+------------------------------------------------------------------+
//|                                               TradeOptimizer.mqh |
//|                                    Copyright 2023, Ronald hector |
//|                                          https://www.mysite.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Ronald hector"
#property link "https://www.mysite.com/"
#property version "Version = 1.00"

//+------------------------------------------------------------------+
//| TradeOptimizer description: Check for and optimize open trades   |
//+------------------------------------------------------------------+

class TradeOptimizer
{
protected:
    double lowest;
    double highest;
    string barType;
    string prevbarType;
    double point;
    double price;
    string needle;
    string trendFindRange;
    double foundBuyTrendLines[];
    double foundSellTrendLines[];
    int orederPriceIndex;

public:
    TradeOptimizer()
    {
        // ArraySetAsSeries(foundBuyTrendLines, true);
        // ArraySetAsSeries(foundSellTrendLines, true);
        // ArrayResize(foundBuyTrendLines, 0);
        // ArrayResize(foundSellTrendLines, 0);
    }

    void checkCloseTrades(_Trader &parent)
    {
        for (int i = 0; i < ArraySize(parent.openOrders); i++)
        {
            double magic = parent.openOrders[i];
            if (isTradeClosed(parent, magic))
            {
                parent.RemoveIndexFromOpenOrdersArray(i);
            }
        }
    }
    //+------------------------------------------------------------------+

    bool isTradeClosed(_Trader &parent, double custom_magic)
    {
        HistorySelect(algoStartTime, TimeCurrent());
        string comment;
        uint total = HistoryOrdersTotal();
        ulong ticket = 0;
        long order_ticket;
        long magic;
        string symbol;
        double order_price;
        long order_type;
        for (uint i = 0; i < total; i++)
        {
            if ((ticket = HistoryOrderGetTicket(i)) > 0)
            {
                comment = HistoryOrderGetString(ticket, ORDER_COMMENT);
                symbol = HistoryOrderGetString(ticket, ORDER_SYMBOL);
                order_ticket = HistoryOrderGetInteger(ticket, ORDER_TICKET);
                magic = HistoryOrderGetInteger(ticket, ORDER_MAGIC);
                order_price = HistoryOrderGetDouble(order_ticket, ORDER_PRICE_OPEN);
                order_type = HistoryOrderGetInteger(order_ticket, ORDER_TYPE);
                if (magic == custom_magic)
                    if (StringFind(comment, "[tp") != -1 || StringFind(comment, "[sl") != -1 || StringFind(comment, "tp") != -1 || StringFind(comment, "sl") != -1)
                    {
                        StringReplace(comment, "tp ", "");
                        StringReplace(comment, "sl ", "");
                        removeClosedTrades(parent, custom_magic, StringToDouble(comment));
                        sendSignal("'trade_status':'Close','trade_ticket':" + IntegerToString(ticket) + ",'magic':" + IntegerToString(magic));
                        return true;
                    }
            }
        }
        return false;
    }
    //+------------------------------------------------------------------+

    void removeClosedTrades(_Trader &parent, double custom_magic, double closed_order_price)
    {
        HistorySelect(algoStartTime, TimeCurrent());
        uint total = HistoryOrdersTotal();
        ulong ticket = 0;
        long order_ticket;
        long magic;
        double order_price;
        double order_tp;
        double order_sl;
        long order_type;
        for (uint i = 0; i < total; i++)
        {
            if ((ticket = HistoryOrderGetTicket(i)) > 0)
            {
                order_ticket = HistoryOrderGetInteger(ticket, ORDER_TICKET);
                magic = HistoryOrderGetInteger(ticket, ORDER_MAGIC);
                order_price = HistoryOrderGetDouble(order_ticket, ORDER_PRICE_OPEN);
                order_tp = HistoryOrderGetDouble(order_ticket, ORDER_TP);
                order_sl = HistoryOrderGetDouble(order_ticket, ORDER_SL);
                order_type = HistoryOrderGetInteger(order_ticket, ORDER_TYPE);
                if (magic == custom_magic)
                {
                    if (closed_order_price == order_tp)
                    {
                        won = won + 1;
                        ClosedTades = ClosedTades + 1;
                        if (order_type == ORDER_TYPE_BUY && parent.searchArray(order_price, 1))
                        {
                            parent.RemoveIndexFromBuySellArray(parent.openBuyOrder, parent.getArrayIndex(ArraySize(parent.openBuyOrder), order_price, parent.openBuyOrder));
                        }
                        if (order_type == ORDER_TYPE_SELL && parent.searchArray(order_price, 2))
                        {
                            parent.RemoveIndexFromBuySellArray(parent.openSellOrder, parent.getArrayIndex(ArraySize(parent.openSellOrder), order_price, parent.openSellOrder));
                        }
                    }
                    if (closed_order_price == order_sl)
                    {
                        loss = loss + 1;
                        ClosedTades = ClosedTades + 1;
                        if (order_type == ORDER_TYPE_BUY && parent.searchArray(order_price, 1))
                        {
                            parent.RemoveIndexFromBuySellArray(parent.openBuyOrder, parent.getArrayIndex(ArraySize(parent.openBuyOrder), order_price, parent.openBuyOrder));
                        }
                        if (order_type == ORDER_TYPE_SELL && parent.searchArray(order_price, 2))
                        {
                            parent.RemoveIndexFromBuySellArray(parent.openSellOrder, parent.getArrayIndex(ArraySize(parent.openSellOrder), order_price, parent.openSellOrder));
                        }
                    }
                }
            }
        }
    }
    //+------------------------------------------------------------------+

    void modifyBuyTrade(_Trader &parent, double _price, double _point, string _barType, double _lowest)
    {
        lowest = _lowest;
        barType = _barType;
        point = _point;
        price = _price;
        for (int i = 0; i < ArraySize(parent.openBuyOrder); ++i)
        {
            orederPriceIndex = i;
            if (ArraySize(parent.openBuyOrder) > i)
                if (
                    (price > parent.openBuyOrder[i]) && (price - parent.openBuyOrder[i]) > (point * (getSpread(parent)))) // Gaining Trades
                {
                    objectAction(parent, 1, 1, parent.openBuyOrder[i]);
                }
            if (ArraySize(parent.openBuyOrder) > i)
                if (price < parent.openBuyOrder[i]) // Losing Trades
                {
                    objectAction(parent, 1, 2, parent.openBuyOrder[i]);
                }
        }
    }
    //+------------------------------------------------------------------+

    void modifySellTrade(_Trader &parent, double _price, double _point, string _barType, double _highest )
    {
        highest = _highest;
        barType = _barType;
        prevbarType = barType;
        point = _point;
        price = _price;
        for (int i = 0; i < ArraySize(parent.openSellOrder); ++i)
        {
            orederPriceIndex = i;
            if (ArraySize(parent.openSellOrder) > i)
                if (
                    (price < parent.openSellOrder[i]) && (parent.openSellOrder[i] - price) > (point * (getSpread(parent))))
                {
                    objectAction(parent, 2, 1, parent.openSellOrder[i]);
                }
            if (ArraySize(parent.openSellOrder) > i)
                if (price > parent.openSellOrder[i]) // Losing Trades
                {
                    objectAction(parent, 2, 2, parent.openSellOrder[i]);
                }
        }
    }
    //+------------------------------------------------------------------+

    double getSpread(_Trader &parent)
    {
        bool spreadfloat = SymbolInfoInteger(parent.CurrentSymbol, SYMBOL_SPREAD_FLOAT);
        string comm = StringFormat("Spread %s = %I64d points\r\n",
                                   spreadfloat ? "floating" : "fixed",
                                   SymbolInfoInteger(Symbol(), SYMBOL_SPREAD));
        double ask = SymbolInfoDouble(parent.CurrentSymbol, SYMBOL_ASK);
        double bid = SymbolInfoDouble(parent.CurrentSymbol, SYMBOL_BID);
        double spread = ask - bid;
        int spread_points = (int)MathRound(spread / SymbolInfoDouble(parent.CurrentSymbol, SYMBOL_POINT));
        return spread_points;
    }
    //+------------------------------------------------------------------+

    void objectAction(_Trader &parent, int tradeType, int tradeStatus, double orderPrice)
    {
        double trendFindInt = (point * 10);
        if (barType == "High")
        {
            needle = "TrendLineHigh-" + DoubleToString(price);
        }

        if (barType == "Low")
        {
            needle = "TrendLineLow-" + DoubleToString(price);
        }

        int TotalObject;
        TotalObject = ObjectsTotal(0, 0, -1);

        for (int i = 0; i < TotalObject; i++)
        {
            if (tradeType == 1) // Buy
            {
                if (tradeStatus == 1){
                     // In profit
                    inProfitBuyTrade(parent, i, trendFindInt, orderPrice);
                    prevbarType = barType;
                }
                // if (tradeStatus == 2) // Not In Profit
                //     notInProfitBuyTrade(parent, i, trendFindInt, orderPrice);
            }
            if (tradeType == 2) // Sell
            {
                if (tradeStatus == 1)
                {
                    // In profit
                    inProfitSellTrade(parent, i, trendFindInt, orderPrice);
                    prevbarType = barType;
                }
                // if (tradeStatus == 2) // Not In profit
                //     notInProfitSellTrade(parent, i, trendFindInt, orderPrice);
            }
        }
    }
    //+------------------------------------------------------------------+

    void inProfitBuyTrade(_Trader &parent, int i, double trendFindInt, double orderPrice)
    {
        if (lowest > orderPrice
        && price == lowest
        )
        {
            for (int u = PositionsTotal() - 1; u >= 0; u--) // returns the number of current positions
            {
                if (m_position.SelectByIndex(u)) // selects the position by index for further access to its properties
                {
                    if (
                        m_position.Symbol() == parent.CurrentSymbol && parent.searchArray(m_position.Magic(), 5) && m_position.PriceOpen() == orderPrice)
                    {
                        m_trade.PositionClose(m_position.Ticket());
                        parent.RemoveIndexFromBuySellArray(parent.openBuyOrder, orederPriceIndex);
                        parent.RemoveIndexFromOpenOrdersArray(parent.getArrayIndex(ArraySize(parent.openOrders), m_position.Magic(), parent.openOrders));
                        ClosedTades = ClosedTades + 1;
                        won = won + 1;
                    }
                }
            }
        }
        // if (StringFind(ObjectName(0, i, 0, -1), needle, 0) > -1)
        // {
        //     double trendLinePrice = ObjectGetDouble(0, needle, OBJPROP_PRICE);
        //     int newSize = ArraySize(foundBuyTrendLines) + 1;
        //     ArrayResize(foundBuyTrendLines, newSize);
        //     foundBuyTrendLines[newSize - 1] = trendLinePrice;
        //     ObjectSetInteger(0, needle, OBJPROP_COLOR, clrAzure);
        //     ObjectSetInteger(0, needle, OBJPROP_WIDTH, 5);

        //     // for (int f = 0; f < ArraySize(foundBuyTrendLines); f++)
        //     // {
        //     //     if (ArraySize(foundBuyTrendLines) > f)
        //     //         if (
        //     //             price > foundBuyTrendLines[f])
        //     //         {
        //     //             if (ArraySize(foundBuyTrendLines) > f)
        //     //             {

        //     //             }
        //     //         }
        //     // }

        //     ObjectSetInteger(0, needle, OBJPROP_COLOR, clrLime);
        //     ObjectSetInteger(0, needle, OBJPROP_WIDTH, 0);
        // }
    }
    //+------------------------------------------------------------------+

    void notInProfitBuyTrade(_Trader &parent, int i, double trendFindInt, double orderPrice)
    {
        for (int f = 0; f < ArraySize(foundSellTrendLines); f++)
        {
            if (price < orderPrice && foundSellTrendLines[f] == price)
            {
                for (int u = PositionsTotal() - 1; u >= 0; u--) // returns the number of current positions
                {
                    if (m_position.SelectByIndex(u)) // selects the position by index for further access to its properties
                    {
                        if (
                            m_position.Symbol() == parent.CurrentSymbol && parent.searchArray(m_position.Magic(), 5) && m_position.PriceOpen() == orderPrice)
                        {
                            m_trade.PositionClose(m_position.Ticket());
                            parent.RemoveIndexFromBuySellArray(parent.openSellOrder, orederPriceIndex);
                            parent.RemoveIndexFromOpenOrdersArray(parent.getArrayIndex(ArraySize(parent.openOrders), m_position.Magic(), parent.openOrders));
                            ClosedTades = ClosedTades + 1;
                            loss = loss + 1;
                        }
                    }
                }
            }
        }
    }

    void inProfitSellTrade(_Trader &parent, int i, double trendFindInt, double orderPrice)
    {
        // if (StringFind(ObjectName(0, i, 0, -1), needle, 0) > -1)
        // {
        //     double trendLinePrice = ObjectGetDouble(0, needle, OBJPROP_PRICE);
        //     int newSize = ArraySize(foundSellTrendLines) + 1;
        //     ArrayResize(foundSellTrendLines, newSize);
        //     foundSellTrendLines[newSize - 1] = trendLinePrice;
        //     ObjectSetInteger(0, needle, OBJPROP_COLOR, clrBeige);
        //     ObjectSetInteger(0, needle, OBJPROP_WIDTH, 5);

        //     // for (int f = 0; f < ArraySize(foundSellTrendLines); f++)
        //     // {
        //     //     if (ArraySize(foundSellTrendLines) > f)
        //     //     {
        //     //         if (
        //     //             price < foundSellTrendLines[f])
        //     //         {
        //     //             if (ArraySize(foundSellTrendLines) > f)
        //     //             {

        //     //             }
        //     //         }
        //     //     }
        //     // }

        //     ObjectSetInteger(0, needle, OBJPROP_COLOR, clrDeepPink);
        //     ObjectSetInteger(0, needle, OBJPROP_WIDTH, 0);
        // }
        if (
            highest < orderPrice
            && price == highest
            )
        {
            for (int u = PositionsTotal() - 1; u >= 0; u--) // returns the number of current positions
            {
                if (m_position.SelectByIndex(u)) // selects the position by index for further access to its properties
                {
                    if (
                        m_position.Symbol() == parent.CurrentSymbol && parent.searchArray(m_position.Magic(), 5) && m_position.PriceOpen() == orderPrice)
                    {
                        m_trade.PositionClose(m_position.Ticket());
                        parent.RemoveIndexFromBuySellArray(parent.openSellOrder, orederPriceIndex);
                        parent.RemoveIndexFromOpenOrdersArray(parent.getArrayIndex(ArraySize(parent.openOrders), m_position.Magic(), parent.openOrders));
                        ClosedTades = ClosedTades + 1;
                        won = won + 1;
                    }
                }
            }
        }
    }

    void notInProfitSellTrade(_Trader &parent, int i, double trendFindInt, double orderPrice)
    {
        for (int f = 0; f < ArraySize(foundBuyTrendLines); f++)
        {
            if (price > orderPrice && foundBuyTrendLines[f] == price)
            {
                for (int u = PositionsTotal() - 1; u >= 0; u--) // returns the number of current positions
                {
                    if (m_position.SelectByIndex(u)) // selects the position by index for further access to its properties
                    {
                        if (
                            m_position.Symbol() == parent.CurrentSymbol && parent.searchArray(m_position.Magic(), 5) && m_position.PriceOpen() == orderPrice)
                        {
                            m_trade.PositionClose(m_position.Ticket());
                            parent.RemoveIndexFromBuySellArray(parent.openSellOrder, orederPriceIndex);
                            parent.RemoveIndexFromOpenOrdersArray(parent.getArrayIndex(ArraySize(parent.openOrders), m_position.Magic(), parent.openOrders));
                            ClosedTades = ClosedTades + 1;
                            loss = loss + 1;
                        }
                    }
                }
            }
        }
    }
};