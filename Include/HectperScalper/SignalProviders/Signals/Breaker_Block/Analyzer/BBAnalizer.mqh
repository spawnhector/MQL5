//+------------------------------------------------------------------+
//|                                          BBAnalizer.mqh |
//|                                    Copyright 2023, Ronald hector |
//|                                          https://www.mysite.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Ronald hector"
#property link "https://www.mysite.com/"
#property version "Version = 1.00"

// #include <HectperScalper\SignalProviders\Signals\Main\Trader.mqh>;
#include <HectperScalper\SignalProviders\Signals\Breaker_Block\BBInterface.mqh>;
#include <HectperScalper\SignalProviders\Signals\Breaker_Block\Analyzer\InterfaceAnalyzer.mqh>;
#include <HectperScalper\SignalProviders\Signals\Breaker_Block\Analyzer\ChartAnalyzer.mqh>;

class BBAnalyzer
{
private:

public:
    BBInterface *__Interface;
    AnalyzerInterface *_analyzeInterface;
    ChartAnalyzer* _chartAnalyzer;

    BBAnalyzer(BBInterface &_Interface)
    {
        __Interface = &_Interface;
        _analyzeInterface = new AnalyzerInterface(_Interface);
    }

    // ChartAnalyzer* GetChartAnalyzer(){
    //     _chartAnalyzer = new ChartAnalyzer();
    //     return _chartAnalyzer;
    // }
    
    ~BBAnalyzer(){
        delete _analyzeInterface;
        delete __Interface;
    }
};
//+------------------------------------------------------------------+