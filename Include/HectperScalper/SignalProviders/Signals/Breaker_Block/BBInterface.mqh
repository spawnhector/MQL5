//+------------------------------------------------------------------+
//|                                                  BBInterface.mqh |
//|                                    Copyright 2023, Ronald hector |
//|                                          https://www.mysite.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Ronald hector"
#property link "https://www.mysite.com/"
#property version "Version = 1.00"
#include "Widget\Widget.mqh";
#include <ChartObjects\ChartObject.mqh>
#include <HectperScalper\SignalProviders\Signals\Breaker_Block\Helpers\BBInterfaceHelper.mqh>;

BBWidget Widget;

class BBInterface : public BBInterfaceHelper
{
public:
    BBInterface(ProviderData &_providerData) : BBInterfaceHelper()
    {
        providerData = _providerData;
    }

    ~BBInterface()
    {
        ChartClose(DCID.chartID);
    }

    D_c *getChartAnalizer()
    {
        return new BBChartAnalyzer(providerData);
    }

    void createInterFace(string _symb) override
    {
        this.createDuplicateChart(_symb);
    }

    void createDuplicateChart(string symb)
    {
        DCID.symbol = symb;
        ENUM_TIMEFRAMES timeframe = PERIOD_M1;
        DCID.chartID = ChartOpen(DCID.symbol, timeframe);
        if (DCID.chartID < 0)
            Print("Failed to open the chart! Error code:", GetLastError());
        else
        {
            ChartSetInteger(DCID.chartID, CHART_SHOW_GRID, false);
            ChartSetInteger(DCID.chartID, CHART_SHIFT, true);
            ChartSetInteger(DCID.chartID, CHART_SCALE, 2);
            // DrawRectangles();
            AddVolumeIndicator();
            addCustomIndicator();
        }
    }

    void AddVolumeIndicator()
    {
        long totalSubwindows = ChartGetInteger(DCID.chartID, CHART_WINDOWS_TOTAL);
        DCID.volumesIndicatorHandle = iVolumes(DCID.symbol, PERIOD_M1, VOLUME_TICK);
        if (DCID.volumesIndicatorHandle != INVALID_HANDLE)
        {
            ChartIndicatorAdd(DCID.chartID, (int)(totalSubwindows), DCID.volumesIndicatorHandle);
        }
        else
        {
            Print("Failed to attach custom indicator.");
        }
    }

    void addCustomIndicator()
    {
        long totalSubwindows = ChartGetInteger(DCID.chartID, CHART_WINDOWS_TOTAL);
        int customIndicator = iCustom(DCID.symbol, PERIOD_M1, "Examples\\InterfacePriceButton");
        if (customIndicator != INVALID_HANDLE)
        {
            if (!ChartIndicatorAdd(DCID.chartID, (int)(totalSubwindows), customIndicator))
                Print("Failed to attach custom indicator.");
            else
            {
                Widget.Initilize(DCID.chartID, (int)(totalSubwindows), user00, "Widget Price", user03, user04);
                EventSetMillisecondTimer(10);
            }
        }
        else
        {
            Print("Failed to attach custom indicator.");
        }
    }

    void DrawRectangles()
    {
        DCID.chartWidth = ChartGetInteger(DCID.chartID, CHART_WIDTH_IN_PIXELS);
        DCID.chartHeight = ChartGetInteger(DCID.chartID, CHART_HEIGHT_IN_PIXELS);
        DCID.bidY = this.getBidY();
        DCID.onew = DCID.chartWidth / 2;
        DCID.twow = (DCID.onew / 2);
        DCID.x1 = DCID.onew;
        DCID.y1 = 0;
        long height1 = (DCID.chartHeight - DCID.bidY);
        long height2 = DCID.bidY;
        long x2 = DCID.onew;
        long y2 = height1;

        string objectName = DCID.symbol + "RedRect";
        DCID.redRectangle = ObjectCreate(DCID.chartID, objectName, OBJ_RECTANGLE_LABEL, 0, 0, 0);
        ObjectSetInteger(DCID.chartID, objectName, OBJPROP_COLOR, clrRed);
        ObjectSetInteger(DCID.chartID, objectName, OBJPROP_BGCOLOR, clrRed);
        ObjectSetInteger(DCID.chartID, objectName, OBJPROP_XDISTANCE, DCID.x1);
        ObjectSetInteger(DCID.chartID, objectName, OBJPROP_YDISTANCE, DCID.y1);
        ObjectSetInteger(DCID.chartID, objectName, OBJPROP_XSIZE, DCID.chartWidth);
        ObjectSetInteger(DCID.chartID, objectName, OBJPROP_YSIZE, height1);
        // ObjectSetInteger(DCID.chartID, objectName, OBJPROP_STYLE, STYLE_SOLID);
        ObjectSetInteger(DCID.chartID, objectName, OBJPROP_WIDTH, 1);
        ObjectSetInteger(DCID.chartID, objectName, OBJPROP_BACK, true);
        ObjectSetInteger(DCID.chartID, objectName, OBJPROP_SELECTABLE, false);
        ObjectSetInteger(DCID.chartID, objectName, OBJPROP_SELECTED, false);

        objectName = DCID.symbol + "GreenRect";
        DCID.greenRectangle = ObjectCreate(DCID.chartID, objectName, OBJ_RECTANGLE_LABEL, 0, 0, 0);
        ObjectSetInteger(DCID.chartID, objectName, OBJPROP_COLOR, clrGreen);
        ObjectSetInteger(DCID.chartID, objectName, OBJPROP_BGCOLOR, clrGreen);
        ObjectSetInteger(DCID.chartID, objectName, OBJPROP_XDISTANCE, x2);
        ObjectSetInteger(DCID.chartID, objectName, OBJPROP_YDISTANCE, y2);
        ObjectSetInteger(DCID.chartID, objectName, OBJPROP_XSIZE, DCID.chartWidth);
        ObjectSetInteger(DCID.chartID, objectName, OBJPROP_YSIZE, height2);
        // ObjectSetInteger(DCID.chartID, objectName, OBJPROP_STYLE, STYLE_SOLID);
        ObjectSetInteger(DCID.chartID, objectName, OBJPROP_WIDTH, 1);
        ObjectSetInteger(DCID.chartID, objectName, OBJPROP_BACK, true);
        ObjectSetInteger(DCID.chartID, objectName, OBJPROP_SELECTABLE, false);
        ObjectSetInteger(DCID.chartID, objectName, OBJPROP_SELECTED, false);
    }

    void resizeRect()
    {
        DCID.bidY = this.getBidY();
        long height1 = (DCID.chartHeight - DCID.bidY);
        long height2 = DCID.bidY;
        long y2 = height1;
        string objectName = DCID.symbol + "RedRect";
        int objectID = ObjectFind(DCID.chartID, objectName); // Retrieve the ID of the chart object
        if (objectID != -1)                                  // Check if the object was found
        {
            ObjectSetInteger(DCID.chartID, objectName, OBJPROP_XSIZE, DCID.chartWidth); // Resize the width of the object
            ObjectSetInteger(DCID.chartID, objectName, OBJPROP_YSIZE, height1);         // Resize the height of the object
        }
        objectName = DCID.symbol + "GreenRect";
        objectID = ObjectFind(DCID.chartID, objectName); // Retrieve the ID of the chart object
        if (objectID != -1)                              // Check if the object was found
        {
            ObjectSetInteger(DCID.chartID, objectName, OBJPROP_XSIZE, DCID.chartWidth); // Resize the width of the object
            ObjectSetInteger(DCID.chartID, objectName, OBJPROP_YSIZE, height2);         // Resize the height of the object
            ObjectSetInteger(DCID.chartID, objectName, OBJPROP_YDISTANCE, y2);
        }
    }

    void GetObjectStartBar()
    {
        GetCandleByXY(
            (int)ObjectGetInteger(DCID.chartID, DCID.symbol + "RedRect", OBJPROP_XDISTANCE),
            (int)ObjectGetInteger(DCID.chartID, DCID.symbol + "RedRect", OBJPROP_YDISTANCE));
    }

    void GetCandleByXY(int x, int y)
    {
        int sub_window = 0;
        double price;
        datetime time;
        if (ChartXYToTimePrice(DCID.chartID, x, y, sub_window, time, price))
        {
            int barIndex = GetBarIndexByTime(time);
            if (barIndex != -1)
            {
                MqlRates rates[1];
                int copied = CopyRates(DCID.symbol, PERIOD_CURRENT, barIndex, 1, rates);
                if (copied > 0)
                {
                    DCID.startBar.barIndex = barIndex;
                    DCID.startBar.time = time;
                    DCID.startBar.open = rates[0].open;
                    DCID.startBar.high = rates[0].high;
                    DCID.startBar.low = rates[0].low;
                    DCID.startBar.close = rates[0].close;
                }
            }
        }
    }

    long getBidY()
    {
        double bid = SymbolInfoDouble(DCID.symbol, SYMBOL_BID);
        double chartPriceMin = ChartGetDouble(DCID.chartID, CHART_PRICE_MIN);
        double chartPriceMax = ChartGetDouble(DCID.chartID, CHART_PRICE_MAX);
        long chartYDistance = ChartGetInteger(DCID.chartID, CHART_WINDOW_YDISTANCE);
        long _chartHeight = ChartGetInteger(DCID.chartID, CHART_HEIGHT_IN_PIXELS);

        return chartYDistance + (long)((bid - chartPriceMin) / (chartPriceMax - chartPriceMin) * _chartHeight);
    }

    void PlaceHorizontalLine(double price, const string &objectName, const color lineColor = clrRed)
    {
        ObjectCreate(DCID.chartID, objectName, OBJ_HLINE, 0, 0, price);
        ObjectSetInteger(DCID.chartID, objectName, OBJPROP_COLOR, lineColor);
    }

    void PlaceVerticalLine(const datetime time, const string &objectName, const color lineColor = clrRed)
    {
        ObjectCreate(DCID.chartID, objectName, OBJ_VLINE, 0, time, 0);
        ObjectSetInteger(DCID.chartID, objectName, OBJPROP_COLOR, lineColor);
    }

    void PlotBB()
    {
        IdentifySupportResistanceLevels();
    }

    void clearBase()
    {
    }
};
//+------------------------------------------------------------------+