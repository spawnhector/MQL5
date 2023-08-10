#include "Helpers.mqh";

class HSChartHelpers : public HSDCHelpers
{
public:
    HSChartHelpers(){}
    ~HSChartHelpers(){}
    
    stc01 GetRootData() const override
    {
        return ROOT;
    }

    DCInterfaceData GetInterfaceData() const override
    {
        return DCID;
    }
    
    ProviderData GetProviderData() const override
    {
        return providerData;
    }
}