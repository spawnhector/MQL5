//+------------------------------------------------------------------+
//|                                                        start.mqh |
//|                                                    ronald Hector |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "ronald Hector"
#property link "https://www.mql5.com"

input string SymbolsE = "BCHUSD.cc:BATUSD.cc";          // Charts
// input string SymbolsE = "BCHUSD.cc:BATUSD.cc:BNBUSD.cc:BTCUSD.cc:DSHUSD.cc:EOSUSD.cc:ETCUSD.cc:ETHUSD.cc:LTCUSD.cc:IOTUSD.cc";          // Charts
input string LotsE = "0.01:0.01";                  // Chart Lots
// input string LotsE = "0.01:0.01:0.01:0.01:0.01:0.01:0.01:0.01:0.01:0.01";                  // Chart Lots
input string TimeframesE = "M1:M1";              // Chart Timeframes
input ENUM_TIMEFRAMES TimeframeE = PERIOD_M1; // Work Timeframe For Unsigned
input bool bInterfaceE = true;                // Interface
input int SpreadPointsE = 50;                 // МахSpread
input int lot_type = 3;
input bool enableServer = false;
input bool isTestAccount = false;             // Test Account
input int LastBars = 10;                      // Last Bars Count
input double RepurchaseLotE = 0.01;           // Fix Lot For Unsigned
input double DepositForRepurchaseLotE = 0.00; // Deposit For Lot (if "0" then fix repurchase)

int SlippageMaxOpen = 100;  // Slippage Open
int SlippageMaxClose = 100; // Slippage Close

///.............necessary values for building virtual robots...........
string S[];          // array with symbols
double L[];          // array with lots
ENUM_TIMEFRAMES T[]; // array with timeframes
int CN[];            // number of candles for trading (loading the last bars)
double cls[];
MqlRates rte[];
int selectedProviders[];
///..............................................................................
double totalProfit;
double percentageAccurate;
int won;
int loss;
int ClosedTades;

datetime algoStartTime = TimeCurrent();
double lot_size = 0.01;
int order_magic = 156;
double minTradeSize;
const int MAX_CANDELS = 100;
int spBars = MAX_CANDELS;
int tpBars = MAX_CANDELS;
double Balance = AccountInfoDouble(ACCOUNT_BALANCE);
string connectionType = "socket"; // socket || websocket
int timer_handle;
double riskPercentage = 0.1;
string interfaceError = " ";
string startButtontext = "Start";
bool strat_trade = false;
bool startButtonClicked = false;

string user00 = "Config.cfg"; // Arquivo de configuração
int user01 = -1;              // Deslocamento
int user02 = 10;              // Pausa em milissegundos
color user03 = clrWhiteSmoke; // Cor do Ativo
color user04 = clrBlack;
