//+------------------------------------------------------------------+
//|                                                Rolling Price.mq5 |
//|                                                      Daniel Jose |
//+------------------------------------------------------------------+
// #property strict
#property copyright "Daniel Jose"
#property description "Gadget para cotações em letreiro."
#property description "Este cria uma faixa que mostra o preço dos ativos."
#property description "Para detalhes de como usá-lo visite:\n"
#property description "https://www.mql5.com/pt/articles/10963"
#property link "https://www.mql5.com/pt/articles/10963"

#property indicator_separate_window
#property indicator_plots   0
#property indicator_height 33
//+------------------------------------------------------------------+
// #include <Widget\RollingPrice\C_Widget.mqh>;
// #include "..\..\Include\HectperScalper\Data\sharedData.mqh";

//+------------------------------------------------------------------+
// input BreakerBlock breakerblock;

string 	user00 = "Config.cfg";	//Arquivo de configuração
int		user01 = -1;				//Deslocamento
int		user02 = 10;				//Pausa em milissegundos
color		user03 = clrWhiteSmoke;	//Cor do Ativo
color		user04 = clrBlack;		//Cor de Fundo
//+------------------------------------------------------------------+
// C_Widget Widget;
//+------------------------------------------------------------------+

int OnInit()
{
	// if (!Widget.Initilize(user00, "Widget Price", user03, user04))
	// 	return INIT_FAILED;
	// GlobalVariableSet()
	return INIT_SUCCEEDED;
}
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total, const int prev_calculated, const int begin, const double &price[])
{
	return rates_total;
}
//+------------------------------------------------------------------+
void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
{
	// Widget.DispatchMessage(id, lparam, dparam, sparam);
}
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
	EventKillTimer();
}
//+------------------------------------------------------------------+
