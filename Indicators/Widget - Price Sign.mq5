//+------------------------------------------------------------------+
//|                                                Rolling Price.mq5 |
//|                                                      Daniel Jose |
//+------------------------------------------------------------------+
#property copyright "Daniel Jose"
#property description "Gadget para cotações em letreiro."
#property description "Este cria uma faixa que mostra o preço dos ativos."
#property description "Para detalhes de como usá-lo visite:\n"
#property description "https://www.mql5.com/pt/articles/10963"
#property link "https://www.mql5.com/pt/articles/10963"
#property indicator_separate_window
#property indicator_plots 0
#property indicator_height 32
//+------------------------------------------------------------------+
#include <Widget\Rolling Price\C_Widget.mqh>
//+------------------------------------------------------------------+
input string 	user00 = "Config.cfg";	//Arquivo de configuração
input int		user01 = -1;				//Deslocamento
input int		user02 = 10;				//Pausa em milissegundos
input	color		user03 = clrWhiteSmoke;	//Cor do Ativo
input color		user04 = clrBlack;		//Cor de Fundo
//+------------------------------------------------------------------+
C_Widget Widget;
//+------------------------------------------------------------------+
int OnInit()
{
	if (!Widget.Initilize(user00, "Widget Price", user03, user04))
		return INIT_FAILED;
	EventSetMillisecondTimer(user02);
	
	return INIT_SUCCEEDED;
}
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total, const int prev_calculated, const int begin, const double &price[])
{
	return rates_total;
}
//+------------------------------------------------------------------+
void OnTimer()
{
	EventChartCustom(Terminal.Get_ID(), C_Widget::Ev_RollingTo, user01, 0.0, "");
}
//+------------------------------------------------------------------+
void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
{
	Widget.DispatchMessage(id, lparam, dparam, sparam);
}
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
	EventKillTimer();
}
//+------------------------------------------------------------------+
