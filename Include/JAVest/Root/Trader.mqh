Interface tester{
    public:
        virtual void test(){}
};

class _Trader: public tester
{
public:
    int MagicF;
    int index;
    double PriceBid;
    double PriceAsk;
    string CurrentSymbol;
    int shoulder;
    string timeframe;
    int clr;
    int size;
    double openOrders[];
    double cls[];
    double openBuyOrder[];
    double openSellOrder[];
    double prevFoundHigh[];
    double prevFoundLow[];
    MqlRates candels[];
    double closes[];
    MqlRates rte[];

    _Trader()
    {
        // ArraySetAsSeries(candels, true);
        // ArraySetAsSeries(closes, true);
        // ArraySetAsSeries(rte, true);
        // ArraySetAsSeries(openBuyOrder, true);
        // ArraySetAsSeries(openSellOrder, true);
        // ArraySetAsSeries(prevFoundHigh, true);
        // ArraySetAsSeries(prevFoundLow, true);
    }

    virtual void _SetState(
        int _MagicF,
        int _index,
        double _PriceBid,
        double _PriceAsk,
        string _CurrentSymbol,
        int _shoulder,
        string _timeframe,
        int _clr)
    {
        if (ArraySize(prevFoundHigh) > MAX_CANDELS)
        {
            ArrayFree(prevFoundHigh);
        }
        if (ArraySize(prevFoundLow) > MAX_CANDELS)
        {
            ArrayFree(prevFoundLow);
        }
        ArrayFree(candels);
        ArrayFree(closes);
        if (ObjectsTotal(0, 0, -1) > MAX_CANDELS)
        {
            ObjectsDeleteAll(0, 0, -1);
        }
        this.MagicF = _MagicF;
        this.index = _index;
        this.PriceBid = _PriceBid;
        this.PriceAsk = _PriceAsk;
        this.CurrentSymbol = _CurrentSymbol;
        this.shoulder = _shoulder;
        this.timeframe = _timeframe;
        this.clr = _clr;
    }

    virtual int GetMagicF()
    {
        return MagicF;
    }
    virtual int GetIndex()
    {
        return index;
    }
    virtual double GetPriceBid()
    {
        return PriceBid;
    }
    virtual double GetPriceAsk()
    {
        return PriceAsk;
    }
    virtual string GetCurrentSymbol()
    {
        return CurrentSymbol;
    }
    virtual int GetShoulder()
    {
        return shoulder;
    }
    virtual string GetTimeframe()
    {
        return timeframe;
    }
    virtual int GetClr()
    {
        return clr;
    }
    virtual int GetIndex_highest()
    {
        return ArrayMaximum(prevFoundHigh, (ArraySize(prevFoundHigh) - 1), MAX_CANDELS);
    }
    virtual int GetIndex_lowest()
    {
        return ArrayMinimum(prevFoundLow, (ArraySize(prevFoundLow) - 1), MAX_CANDELS);
    }
    virtual int GetBuyIndex()
    {
        return ArrayMaximum(openBuyOrder, (ArraySize(openBuyOrder) - 1), ArraySize(openBuyOrder));
    }
    virtual int GetSellIndex()
    {
        return ArrayMaximum(openSellOrder, (ArraySize(openSellOrder) - 1), ArraySize(openSellOrder));
    }
    virtual double GetPrevHigh(int index_highest)
    {
        return (index_highest != -1) ? prevFoundHigh[index_highest] : 0.0;
    }
    virtual double GetPrevLow(int index_lowest)
    {
        return (index_lowest != -1) ? prevFoundLow[index_lowest] : 0.0;
    }
    virtual double GetPrevSellPrice(int prev_index)
    {
        return (prev_index != -1) ? openSellOrder[prev_index] : 0.0;
    }
    virtual double GetPrevBuyPrice(int prev_index)
    {
        return (prev_index != -1) ? openBuyOrder[prev_index] : 0.0;
    }
    virtual double GetOpenOrders(int _index)
    {
        return openOrders[_index];
    }
    void addOpenOrder(double trade_price)
    {
        ArrayResize(openOrders, (ArraySize(openOrders) + 1));
        if (ArraySize(openOrders) == 1)
        {
            openOrders[0] = trade_price;
        }
        else
        {
            openOrders[ArraySize(openOrders) - 1] = trade_price;
        }
    }
    void addOpenBuyOrderBar(double bar)
    {
        ArrayResize(openBuyOrder, (ArraySize(openBuyOrder) + 1));
        openBuyOrder[ArraySize(openBuyOrder) - 1] = bar;
        if (ArraySize(openBuyOrder) == 1)
        {
            openBuyOrder[0] = bar;
        }
        else
        {
            openBuyOrder[ArraySize(openBuyOrder) - 1] = bar;
        }
    }
    void addOpenSellOrderBar(double bar)
    {
        ArrayResize(openSellOrder, (ArraySize(openSellOrder) + 1));
        if (ArraySize(openSellOrder) == 1)
        {
            openSellOrder[0] = bar;
        }
        else
        {
            openSellOrder[ArraySize(openSellOrder) - 1] = bar;
        }
    }
    void addPrevFoundHigh(double bar)
    {
        ArrayResize(prevFoundHigh, (ArraySize(prevFoundHigh) + 1));
        if (ArraySize(prevFoundHigh) == 1)
        {
            prevFoundHigh[0] = bar;
        }
        else
        {
            prevFoundHigh[ArraySize(prevFoundHigh) - 1] = bar;
        }
    }
    void addPrevFoundLow(double bar)
    {
        ArrayResize(prevFoundLow, (ArraySize(prevFoundLow) + 1));
        if (ArraySize(prevFoundLow) == 1)
        {
            prevFoundLow[0] = bar;
        }
        else
        {
            prevFoundLow[ArraySize(prevFoundLow) - 1] = bar;
        }
    }
    int getArrayIndex(int _size, double target, double &arr[])
    {

        for (int i = 0; i < _size; ++i)
        {
            if (arr[i] == target)
            {
                return i;
            }
        }

        return -1;
    }
    void RemoveIndexFromBuySellArray(double &MyArray[], int _index)
    {
        int length = ArraySize(MyArray);
        if (_index >= 0 && _index < length)
        {
            for (int i = _index; i < length - 1; i++)
            {
                MyArray[i] = MyArray[i + 1];
            }
            ArrayResize(MyArray, length - 1);
        }
    }
    void RemoveIndexFromOpenOrdersArray(int _index)
    {
        int length = ArraySize(openOrders);
        if (_index >= 0 && _index < length)
        {
            for (int i = _index; i < length - 1; i++)
            {
                openOrders[i] = openOrders[i + 1];
            }
            ArrayResize(openOrders, length - 1);
        }
    }
    bool searchArray(double target, int seachtype)
    {
        switch (seachtype)
        {
        case 1:
            size = ArraySize(openBuyOrder);
            break;
        case 2:
            size = ArraySize(openSellOrder);
            break;
        case 3:
            size = ArraySize(prevFoundLow);
            break;
        case 4:
            size = ArraySize(prevFoundHigh);
            break;
        case 5:
            size = ArraySize(openOrders);
            break;
        }

        for (int i = 0; i < size; ++i)
        {
            switch (seachtype)
            {
            case 1:
                if (openBuyOrder[i] == target)
                {
                    return true;
                }
                break;
            case 2:
                if (openSellOrder[i] == target)
                {
                    return true;
                }
                break;
            case 3:
                if (prevFoundLow[i] == target)
                {
                    return true;
                }
                break;
            case 4:
                if (prevFoundHigh[i] == target)
                {
                    return true;
                }
                break;
            case 5:
                if (openOrders[i] == target)
                {
                    return true;
                }
                break;
            }
        }

        return false;
    }
    bool isMintradeSize(double newtrade, int tradeType, double point)
    {
        //   double tickValue = SymbolInfoDouble(CurrentSymbol, SYMBOL_VOLUME);
        switch (tradeType)
        {
        case 1:
            if ((ArraySize(openBuyOrder) == 0))
                return true;
            // Print("diff ",openBuyOrder[ArraySize(openBuyOrder) - 1] - newtrade);
            // Print("point ",point * minTradeSize);
            if (
                (ArraySize(openBuyOrder) > 0) && (newtrade < openBuyOrder[ArraySize(openBuyOrder) - 1]) && (openBuyOrder[ArraySize(openBuyOrder) - 1] - newtrade) >= (point * minTradeSize))
            {
                return true;
            }
            if (
                (ArraySize(openBuyOrder) > 0) && (newtrade > openBuyOrder[ArraySize(openBuyOrder) - 1]) && (newtrade - openBuyOrder[ArraySize(openBuyOrder) - 1]) >= (point * minTradeSize))
            {
                return true;
            }
            break;
        case 2:
            if ((ArraySize(openSellOrder) == 0))
                return true;
            if (
                (ArraySize(openSellOrder) > 0) && (newtrade > openSellOrder[ArraySize(openSellOrder) - 1]) && (newtrade - openSellOrder[ArraySize(openSellOrder) - 1]) >= (point * minTradeSize))
            {
                return true;
            }
            if (
                (ArraySize(openSellOrder) > 0) && (newtrade < openSellOrder[ArraySize(openSellOrder) - 1]) && (openSellOrder[ArraySize(openSellOrder) - 1] - newtrade) >= (point * minTradeSize))
            {
                return true;
            }
            break;
        }
        return false;
    }
    double getTrendLinePrice(string lineName)
    {
        int TotalObject;
        double TrendLinePrice = 0.0;
        TotalObject = ObjectsTotal(0, 0, -1);
        for (int i = 0; i < TotalObject; i++)
        {
            if (StringFind(ObjectName(0, i, 0, -1), lineName, 0) > -1)
            {
                TrendLinePrice = ObjectGetDouble(0, lineName, OBJPROP_PRICE);
            }
        }
        return TrendLinePrice;
    }
};