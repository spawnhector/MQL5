//+------------------------------------------------------------------+
//|               Shared Memory Variables                            |
//|         Definitions for reading/writing shared memory            |
//+------------------------------------------------------------------+

// Include guard
// #ifndef SHARED_MEMORY_VARIABLES_MQH
// #define SHARED_MEMORY_VARIABLES_MQH

struct DCIDMEMORY{
    string test;
} dCID;
//+------------------------------------------------------------------+
//|                  Read Shared Double                              |
//+------------------------------------------------------------------+
bool ReadSharedDouble(const string sharedVariableName, double& value)
{

    return false;
}

//+------------------------------------------------------------------+
//|                 Write Shared Double                              |
//+------------------------------------------------------------------+
void WriteSharedDouble()
{
    dCID.test = "great sir";
}

// #endif // SHARED_MEMORY_VARIABLES_MQH