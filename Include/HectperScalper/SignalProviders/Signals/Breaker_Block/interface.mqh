//+------------------------------------------------------------------+
//|                                                    interface.mqh |
//|                                    Copyright 2023, Ronald hector |
//|                                          https://www.mysite.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Ronald hector"
#property link "https://www.mysite.com/"
#property version "Version = 1.00"
#include <ChartObjects\ChartObject.mqh>
#include <HectperScalper\SignalProviders\Signals\Main\Trader.mqh>;

class MyInterface
{
private:
    _Trader parent;

public:

    void DrawRectangles()
    {
        long chartWidth = ChartGetInteger(parent.index, CHART_WIDTH_IN_PIXELS);
        long chartHeight = ChartGetInteger(parent.index, CHART_HEIGHT_IN_PIXELS);
        // Define the coordinates and dimensions of the rectangles

        long bidY = this.getBidY();
        long onew = chartWidth / 2;
        long twow = (onew / 2) - 35;
        long x1 = onew + twow + 72;
        long y1 = 0;

        long height1 = (chartHeight - bidY);
        long height2 = bidY;
        long x2 = onew + twow + 72;
        long y2 = height1;

        // Draw a red transparent rectangle
        int redRectangle = ObjectCreate(parent.index, "RedRect", OBJ_RECTANGLE_LABEL, 0, 0, 0);
        ObjectSetInteger(parent.index, "RedRect", OBJPROP_COLOR, clrRed);
        ObjectSetInteger(parent.index, "RedRect", OBJPROP_BGCOLOR, clrRed);
        ObjectSetInteger(parent.index, "RedRect", OBJPROP_XDISTANCE, x1);
        ObjectSetInteger(parent.index, "RedRect", OBJPROP_YDISTANCE, y1);
        ObjectSetInteger(parent.index, "RedRect", OBJPROP_XSIZE, twow);
        ObjectSetInteger(parent.index, "RedRect", OBJPROP_YSIZE, height1);
        // ObjectSetInteger(parent.index, "RedRect", OBJPROP_STYLE, STYLE_SOLID);
        ObjectSetInteger(parent.index, "RedRect", OBJPROP_WIDTH, 1);
        ObjectSetInteger(parent.index, "RedRect", OBJPROP_BACK, true);
        ObjectSetInteger(parent.index, "RedRect", OBJPROP_SELECTABLE, false);
        ObjectSetInteger(parent.index, "RedRect", OBJPROP_SELECTED, false);

        // Draw a green transparent rectangle
        int greenRectangle = ObjectCreate(parent.index, "GreenRect", OBJ_RECTANGLE_LABEL, 0, 0, 0);
        ObjectSetInteger(parent.index, "GreenRect", OBJPROP_COLOR, clrGreen);
        ObjectSetInteger(parent.index, "GreenRect", OBJPROP_BGCOLOR, clrGreen);
        ObjectSetInteger(parent.index, "GreenRect", OBJPROP_XDISTANCE, x2);
        ObjectSetInteger(parent.index, "GreenRect", OBJPROP_YDISTANCE, y2);
        ObjectSetInteger(parent.index, "GreenRect", OBJPROP_XSIZE, twow);
        ObjectSetInteger(parent.index, "GreenRect", OBJPROP_YSIZE, height2);
        // ObjectSetInteger(parent.index, "GreenRect", OBJPROP_STYLE, STYLE_SOLID);
        ObjectSetInteger(parent.index, "GreenRect", OBJPROP_WIDTH, 1);
        ObjectSetInteger(parent.index, "GreenRect", OBJPROP_BACK, true);
        ObjectSetInteger(parent.index, "GreenRect", OBJPROP_SELECTABLE, false);
        ObjectSetInteger(parent.index, "GreenRect", OBJPROP_SELECTED, false);
    }

    void createFrom(_Trader &_parent)
    {
        parent = _parent;
        Print("here inter");
        // this.DrawRectangles();
    }

    long getBidY()
    {
        double chartPriceMin = ChartGetDouble(0, CHART_PRICE_MIN);
        double chartPriceMax = ChartGetDouble(0, CHART_PRICE_MAX);
        long chartYDistance = ChartGetInteger(0, CHART_WINDOW_YDISTANCE);
        long chartHeight = ChartGetInteger(0, CHART_HEIGHT_IN_PIXELS);

        return chartYDistance + (long)((parent.PriceBid - chartPriceMin) / (chartPriceMax - chartPriceMin) * chartHeight);
    }
    void clearBase()
    {
        // delete parent;
    }
};
//+------------------------------------------------------------------+