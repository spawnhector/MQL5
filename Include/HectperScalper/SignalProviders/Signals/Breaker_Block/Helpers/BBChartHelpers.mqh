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
            this.checkVolume(1, true);
        if (ROOT.SupportLevelPassed && parent.PriceBid > ROOT.SupportLevel)
            this.unCheckVolume(1, false);
        if (parent.PriceBid > ROOT.ResistanceLevel)
            this.checkVolume(2, true);
        if (ROOT.ResistanceLevelPassed && parent.PriceBid < ROOT.ResistanceLevel)
            this.unCheckVolume(2, false);
    };

    void switchLevelType(int levelType, bool typeVal) // level type: 1 support(low), 2 resistance(high)
    {
        switch (levelType)
        {
        case 1:
            ROOT.SupportLevelPassed = typeVal;
            break;
        case 2:
            ROOT.ResistanceLevelPassed = typeVal;
            break;
        }
    };

    void isBOFound(int levelType){
        switch (levelType)
        {
        case 1:
            ROOT.breakoutFound = ROOT.BOBVolume > ROOT.BBOBVolume ? true : false;
            break;
        case 2:
            break;
        }
    };
    
    void isRBOFound(int levelType){
        switch (levelType)
        {
        case 1:
            ROOT.reverseBreakoutFound = ROOT.BOBVolume < ROOT.BBOBVolume ? true : false;
            break;
        case 2:
            break;
        }
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