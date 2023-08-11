#include "Helpers.mqh";

class BBChartHelpers : public BBDCHelpers
{
public:
    BBChartHelpers(){};
    ~BBChartHelpers(){};

    stc01 GetRootData() const override
    {
        return ROOT;
    };

    DCInterfaceData GetInterfaceData() const override
    {
        return DCID;
    };

    ProviderData GetProviderData() const override
    {
        return providerData;
    };

    void IdentifySupportResistanceLevels()
    {
        DrawRSLines.plot((string)parent.CurrentSymbol, Period());
        ROOT.SupportLevel = DrawRSLines.rangeLow;
        ROOT.ResistanceLevel = DrawRSLines.rangeHigh;
    };

    void CheckPriceBreakOut()
    {
        if (parent.PriceBid < ROOT.SupportLevel)
            this.checkVolume(SUPPORTLINE, true);
        if (ROOT.SupportLevelPassed && parent.PriceBid > ROOT.SupportLevel)
            this.unCheckVolume(SUPPORTLINE, false);
        if (parent.PriceBid > ROOT.ResistanceLevel)
            this.checkVolume(RESISTANCELINE, true);
        if (ROOT.ResistanceLevelPassed && parent.PriceBid < ROOT.ResistanceLevel)
            this.unCheckVolume(RESISTANCELINE, false);
    };

    void switchLevelType(int levelType, bool typeVal) // level type: SUPPORTLINE support(low), RESISTANCELINE resistance(high)
    {
        switch (levelType)
        {
        case SUPPORTLINE:
            ROOT.SupportLevelPassed = typeVal;
            break;
        case RESISTANCELINE:
            ROOT.ResistanceLevelPassed = typeVal;
            break;
        }
    };

    void switchTradeType(int levelType){
        switch (levelType)
            {
            case SUPPORTLINE:
                ROOT.tradeType = SELL;
                break;
            case RESISTANCELINE:
                ROOT.tradeType = BUY;
                break;
            }
    };

    void isBOFound(int levelType){
        switch (levelType)
        {
        case SUPPORTLINE:
            ROOT.breakoutFound = ROOT.BOBVolume > ROOT.BBOBVolume ? true : false;
            break;
        case RESISTANCELINE:
            ROOT.breakoutFound = ROOT.BOBVolume < ROOT.BBOBVolume ? true : false;
            break;
        }
    };

    void isRBOFound(int levelType){
        switch (levelType)
        {
        case SUPPORTLINE:
            ROOT.reverseBreakoutFound = ROOT.BOBVolume < ROOT.BBOBVolume ? true : false;
            break;
        case RESISTANCELINE:
            ROOT.reverseBreakoutFound = ROOT.BOBVolume > ROOT.BBOBVolume ? true : false;
            break;
        }
        if(ROOT.reverseBreakoutFound) this.switchTradeType(levelType);
    };

    void checkVolume(int levelType, bool typeVal)
    {
        this.switchLevelType(levelType,typeVal);
        if (!ROOT.volumeChecked)
        {
            ROOT.volumeChecked = true;
            ROOT.BOBVolume = iVolume(parent.CurrentSymbol, PERIOD_M1, parent.previousBar);
            ROOT.BBOBVolume = iVolume(parent.CurrentSymbol, PERIOD_M1, parent.previousBar + 1);
            if(!ROOT.breakoutFound) this.isBOFound(levelType);
            if(ROOT.breakoutFound) this.isRBOFound(levelType);
        }
    };

    void unCheckVolume(int levelType, bool typeVal)
    {
        this.switchLevelType(levelType,typeVal);
        ROOT.volumeChecked = false;
    };
}