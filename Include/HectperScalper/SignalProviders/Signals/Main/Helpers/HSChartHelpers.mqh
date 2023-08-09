#include "Helpers.mqh";

class HSChartHelpers : public HSDCHelpers
{
public:
    HSChartHelpers(){}
    ~HSChartHelpers(){}
    
    DCInterfaceData GetInterfaceData() const override
    {
        return DCID;
    }
}