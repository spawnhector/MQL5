
    struct ChartObjects
    {
      struct Fibo_Ret
      {
        string _name;
        string levelObjName;
        int fiboSize;

        struct Fibo_Levels_Type
        {
          struct Types
          {
            struct Levels
            {
              double price;
            } LEVELS[];
          } TYPE[2];
        } FIBO_LEVELS[__chartSymbol.symbolLength]; // size of _chartSymbol.Symbol
        void Draw(int symIndex, DCOBJ_PROP nameCat, double startPrice, double endPrice, datetime time, DCOBJ_PROP display)
        {
          _name = "BB-Plot-" + DCID.symbol + "_Fibonacci_" + EnumToString(nameCat);
          levelObjName = _name + "_Level_";
          double FibonacciLevels[] = {0.0, 0.236, 0.382, 0.5, 0.618, 1.0, 1.618, 2.618, 3.618, 4.618, 5.618, 6.618, 7.618, 8.618, 9.618, 10.618};
          fiboSize = ArraySize(FibonacciLevels);
          ArrayResize(FIBO_LEVELS[symIndex].TYPE[nameCat].LEVELS, fiboSize);
          ObjectDelete(DCID.chartID, _name);
          for (int i = 1; i < fiboSize; i++)
          {
            double fiboPrice = startPrice + (endPrice - startPrice) * FibonacciLevels[i];
            if ((display == _SHOW) && ((nameCat == _START) || ((nameCat == _REVERSE) && (i >= 6))))
            {
              string _levelObjName = levelObjName + IntegerToString(i);
              ObjectDelete(DCID.chartID, _levelObjName);
              ObjectCreate(DCID.chartID, _levelObjName, OBJ_TREND, 0, time, fiboPrice, TimeCurrent(), fiboPrice);
              ObjectSetInteger(DCID.chartID, _levelObjName, OBJPROP_RAY_LEFT, false);
              ObjectSetInteger(DCID.chartID, _levelObjName, OBJPROP_RAY_RIGHT, true);
              ObjectSetInteger(DCID.chartID, _levelObjName, OBJPROP_STYLE, STYLE_DASH);
              ObjectSetInteger(DCID.chartID, _levelObjName, OBJPROP_WIDTH, 2);
              ObjectSetInteger(DCID.chartID, _levelObjName, OBJPROP_COLOR, clrDimGray);
            }
            FIBO_LEVELS[symIndex].TYPE[nameCat].LEVELS[i].price = fiboPrice;
          }
          ChartRedraw(DCID.chartID);
        };

        void AddFibo_Ret(int symIndex, double startPrice, double endPrice, datetime time, DCOBJ_PROP display)
        {
          Draw(symIndex, _START, startPrice, endPrice, time, display);
          Draw(symIndex, _REVERSE, endPrice, startPrice, time, display);
        };

        double GetFiboLevel(int symIndex, DCOBJ_PROP _ty, int level)
        {
          return FIBO_LEVELS[symIndex].TYPE[_ty].LEVELS[level].price;
        };
      } FIBO_RET;

      struct BreakOut_Levels
      {
        string _name;
        void Draw(AppValues lineType, datetime time, double level)
        {
          _name = "BB-Plot-" + DCID.symbol + "-" + EnumToString(lineType);
          ObjectCreate(DCID.chartID, _name, OBJ_HLINE, 0, time, level);
          ObjectSetInteger(DCID.chartID, _name, OBJPROP_COLOR, clrBlue);
        };

        void AddBreakOut_Levels(double support, double resistance, datetime time)
        {
          Draw(SUPPORTLINE, time, support);
          Draw(RESISTANCELINE, time, resistance);
        };
      } BREAKOUT_LEVELS;

      struct Ask_Line
      {
        string _name;
        void AddAskLine(double ask_price)
        {
          _name = "BB-Ask-Line-" + DCID.symbol;
          if (ObjectCreate(DCID.chartID, _name, OBJ_HLINE, 0, TimeCurrent(), ask_price))
          {
            ObjectSetInteger(DCID.chartID, _name, OBJPROP_COLOR, clrRed);
          }
        };
      } ASK_LINE;
    } DCOB;

    