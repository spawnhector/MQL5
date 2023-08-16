//------- Sell retracements -----------------------------------

double GetSell88Point6FibRetracement(double high, double low)
{
   return (GetSellRetracementFor(88.6, high, low));
}

double GetSell78Point6FibRetracement(double high, double low)
{
   return (GetSellRetracementFor(78.6, high, low));
}

double GetSell61Point8FibRetracement(double high, double low)
{
  return (GetSellRetracementFor(61.8, high, low));
}

double GetSell50FibRetracement(double high, double low)
{
   return (GetSellRetracementFor(50.0, high, low));
}

double GetSellRetracementFor(double retracementAmount, double high, double low)
{
   double amountToAddToLow = ((high - low) / 100) * retracementAmount;
   double level = low + amountToAddToLow;
   return (level);
}


//------- Buy retracements -----------------------------------

double GetBuy88Point6FibRetracement(double high, double low)
{
   return (GetBuyRetracementFor(88.6, high, low));
}

double GetBuy78Point6FibRetracement(double high, double low)
{
   return (GetBuyRetracementFor(78.6, high, low));
}

double GetBuy61Point8FibRetracement(double high, double low)
{
   return (GetBuyRetracementFor(61.8, high, low));
}

double GetBuy50FibRetracement(double high, double low)
{
   return (GetBuyRetracementFor(50.0, high, low));
}

double GetBuyRetracementFor(double retracementAmount, double high, double low)
{
   double amountToTakeFromHigh = ((high - low) / 100) * retracementAmount;
   double level = high - amountToTakeFromHigh;
   return (level);
}


