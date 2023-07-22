
#include <HectperScalper\SignalProviders\Struct\interfaceData.mqh>;

interface DCInterface
{
public:
    virtual DCInterfaceData GetInterfaceData() const = 0;
    // virtual void createDuplicateChart(string symb){};
};