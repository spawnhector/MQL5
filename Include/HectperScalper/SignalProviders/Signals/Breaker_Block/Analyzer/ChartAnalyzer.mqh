class ChartAnalyzer
{
public:
    struct stc01
    {
        bool analyzing;
    } root;
    ChartAnalyzer() {}
    ~ChartAnalyzer() {}
    void analyzeChart(){
        root.analyzing = true;
    }
}