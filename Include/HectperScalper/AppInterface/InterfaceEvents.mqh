//+------------------------------------------------------------------+
//|                                              InterfaceEvents.mqh |
//|                                                    ronald Hector |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "ronald Hector"
#property link "https://www.mql5.com"
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool bOurMagic(long magic1) // whether the magic number of the current deal matches one of the possible magic numbers of our robot
{
  // for (int i = 0; i < ArraySize(openOrders); i++)
  // {
  //   if ((int)magic1 == openOrders[i])
  //     return true;
  // }
  return true;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CalculateBuyLots() // calculate buy lots
{
  double Lots = 0;
  bool ord;
  ulong ticket;
  for (int i = 0; i < PositionsTotal(); i++)
  {
    ticket = PositionGetTicket(i);
    ord = PositionSelectByTicket(ticket);
    if (ord && bOurMagic(PositionGetInteger(POSITION_MAGIC)) && PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
    {
      Lots += PositionGetDouble(POSITION_VOLUME);
    }
  }
  return Lots;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CalculateSellLots() // calculate sell lots
{
  double Lots = 0;
  bool ord;
  ulong ticket;
  for (int i = 0; i < PositionsTotal(); i++)
  {
    ticket = PositionGetTicket(i);
    ord = PositionSelectByTicket(ticket);
    if (ord && bOurMagic(PositionGetInteger(POSITION_MAGIC)) && PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
    {
      Lots += PositionGetDouble(POSITION_VOLUME);
    }
  }
  return Lots;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CalculateBuyQuantity() // count buy entries
{
  double Positions = 0;
  bool ord;
  ulong ticket;
  for (int i = 0; i < PositionsTotal(); i++)
  {
    ticket = PositionGetTicket(i);
    ord = PositionSelectByTicket(ticket);
    if (ord && bOurMagic(PositionGetInteger(POSITION_MAGIC)) && PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
    {
      Positions++;
    }
  }
  return Positions;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CalculateSellQuantity() // count sell entries
{
  double Positions = 0;
  bool ord;
  ulong ticket;
  for (int i = 0; i < PositionsTotal(); i++)
  {
    ticket = PositionGetTicket(i);
    ord = PositionSelectByTicket(ticket);
    if (ord && bOurMagic(PositionGetInteger(POSITION_MAGIC)) && PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
    {
      Positions++;
    }
  }
  return Positions;
}

double drawdown;
double CalculateDrawDown()
{
  double profit;
  profit = NormalizeDouble(AccountInfoDouble(ACCOUNT_EQUITY) - AccountInfoDouble(ACCOUNT_BALANCE), 2);
  if (profit < 0 && profit < drawdown)
  {
    drawdown = profit;
  }
  return drawdown;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CloseAllI(int magic0) // close all
{
  bool ord;
  ulong Tickets[];
  int TicketsTotal = 0;
  int TicketNumCurrent = 0;
  ulong ticket;

  for (int i = 0; i < PositionsTotal(); i++)
  {
    ticket = PositionGetTicket(i);
    ord = PositionSelectByTicket(ticket);

    if (ord && (bOurMagic(PositionGetInteger(POSITION_MAGIC)) || magic0 == -1))
    {
      TicketsTotal = TicketsTotal + 1;
    }
  }
  ArrayResize(Tickets, TicketsTotal);

  for (int i = 0; i < PositionsTotal(); i++)
  {
    ticket = PositionGetTicket(i);
    ord = PositionSelectByTicket(ticket);

    if (ord && (bOurMagic(PositionGetInteger(POSITION_MAGIC)) || magic0 == -1) && TicketNumCurrent < TicketsTotal)
    {
      Tickets[TicketNumCurrent] = ticket;
      TicketNumCurrent = TicketNumCurrent + 1;
    }
  }

  for (int i = 0; i < TicketsTotal; i++)
  {
    m_trade.PositionClose(Tickets[i]);
  }
}

double OptimalLot(string CurrentSymbol, double takeProfitDiff) // function for calculating the lot included in the trading function
{
  double result = 0.01;
  double accountEquity = AccountInfoDouble(ACCOUNT_EQUITY);
  double currentBalance = AccountInfoDouble(ACCOUNT_BALANCE);
  double riskAmount;
  double point;
  double tickValue;
  double pointDiff;
  double lotSize;
  double checklot;

  if (lot_size == 1)
  {

    riskAmount = accountEquity * (riskPercentage / 100.0);
    point = NormalizeDouble(SymbolInfoDouble(CurrentSymbol, SYMBOL_POINT), _Digits);point = NormalizeDouble(SymbolInfoDouble(CurrentSymbol, SYMBOL_POINT), _Digits);
    tickValue = SymbolInfoDouble(CurrentSymbol, SYMBOL_TRADE_TICK_VALUE);
    pointDiff = takeProfitDiff / point;
    lotSize = riskAmount / pointDiff;
    checklot = (lotSize * tickValue * pointDiff);
    if (checklot < riskAmount)
    {
      double correctlot = riskAmount - checklot;
      double fixlot = correctlot / pointDiff;
      double newlot = lotSize + fixlot;
      result = NormalizeDouble(newlot, 2);
    }
    else
    {
      result = NormalizeDouble(lotSize, 2);
    }
  }
  if (lot_type == 2)
  {

    if (Balance < 100)
    {
      result = 0.01;
    }
    else
    {
      result = NormalizeDouble((currentBalance / 10000), 2);
    }
  }
  if (lot_type == 3)
  {
    result = 0.01;
  }

  if (result > 0.01)
  {
    return result;
  }
  else
  {
    return 0.01;
  }
}

void addToArray(int &Arr[], int val)
{
  ArrayResize(Arr, (ArraySize(Arr) + 1));
  if (ArraySize(Arr) == 1)
  {
    Arr[0] = val;
  }
  else
  {
    Arr[ArraySize(Arr) - 1] = val;
  }
}

void RemoveFromArray(int &MyArray[], int _index)
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

int IsInArray(int &Arr[], int val)
{
  for (int i = 0; i < ArraySize(Arr); ++i)
  {
    if (Arr[i] == val) return i;
  }
  return -1;
}