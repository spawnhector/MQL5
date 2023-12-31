
class _Trader
{
public:
    int index;
    double PriceBid;
    double PriceAsk;
    string CurrentSymbol;
    int shoulder;
    string timeframe;
    int clr;
    int size;
    int currentBar;
    int previousBar;
    double openOrders[];
    double cls[];
    double openBuyOrder[];
    double openSellOrder[];
    double prevFoundHigh[];
    double prevFoundLow[];
    MqlRates candels[];
    double closes[];
    MqlRates rte[];
    int ProviderIndex;
    double _point;
    bool ___trade;
    ulong __Ticket;
    int newBarCount;

    _Trader()
    {
        ArraySetAsSeries(candels, true);
        ArraySetAsSeries(closes, true);
        ArraySetAsSeries(rte, true);
        ArraySetAsSeries(openBuyOrder, true);
        ArraySetAsSeries(openSellOrder, true);
        ArraySetAsSeries(prevFoundHigh, true);
        ArraySetAsSeries(prevFoundLow, true);
    }

    virtual void _SetState()
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
    }

    bool _Trade(stc01 &chartData)
    {
        ___trade = false;
        if (!chartData.trade.open)
        {
            InterfaceRoot.startTickCount = GetTickCount();
            bool hasMargin;
            int mag = GetMagicF();
            m_trade.SetExpertMagicNumber(mag);
            switch (chartData.trade.type)
            {
            case BUY:
                hasMargin = __chartSymbol.hasEnoughMargin(BUY, chartData.symbol, chartData.BOBVolume, PriceAsk);
                if (hasMargin && (PriceAsk < chartData.trade.tp))
                    ___trade = m_trade.Buy(lot_size, chartData.symbol, PriceAsk, chartData.trade.sl, chartData.trade.tp, NULL);
                    if(___trade)TBPositions++;
                break;
            case SELL:
                hasMargin = __chartSymbol.hasEnoughMargin(SELL, chartData.symbol, chartData.BOBVolume, PriceBid);
                if (hasMargin && (PriceBid > chartData.trade.tp))
                    ___trade = m_trade.Sell(lot_size, chartData.symbol, PriceBid, chartData.trade.sl, chartData.trade.tp, NULL);
                    if(___trade)TSPositions++;
                break;
            }
            if (___trade)
            {
                DCID.root.toUpdate = true;
                chartData.trade.open = true;
                __Ticket = m_trade.ResultOrder();
                addOpenOrder(mag);
                InterfaceRoot.LogExecutionTime("Placing trade for " + chartData.symbol, InterfaceRoot.startTickCount);
            }
        }
        return ___trade;
    };

    void _TestTrade(stc01 &chartData)
    {
        if (chartData.trade.open != true)
        {
            int mag = GetMagicF();
            m_trade.SetExpertMagicNumber(mag);
            ___trade = m_trade.Sell(0.10, CurrentSymbol, PriceAsk, PriceAsk + (_point * 200), PriceBid - (_point * 200), NULL);
            if (___trade)
            {
                chartData.trade.open = true;
                __Ticket = m_trade.ResultOrder();
                addOpenOrder(mag);
            }
        }
    };

    virtual int GetMagicF()
    {
        order_magic = order_magic + 1;
        return order_magic;
    };

    void addOpenOrder(double ordermagic)
    {
        ArrayResize(openOrders, (ArraySize(openOrders) + 1));
        openOrders[ArraySize(openOrders) - 1] = ordermagic;
    };

    void removeFromArray(double &arr[], double target)
    {
        int length = ArraySize(arr);
        for (int _index = 0; _index < length; ++_index)
        {
            if (arr[_index] == target)
            {
                if (_index >= 0 && _index < length)
                {
                    for (int i = _index; i < length - 1; i++)
                    {
                        arr[i] = arr[i + 1];
                    }
                    ArrayResize(arr, length - 1);
                }
            }
        }
    };
};