class SymbolConstructor
{
public:
    string fileName;
    string szFileConfig;
    int symbolLength;
    string Symbols[];

    void SymbolConstructor(string _szFileConfig)
    {
        szFileConfig = _szFileConfig;
        fileName = "Widget\\" + szFileConfig;
    };

    void ~SymbolConstructor(){};

    bool writeFile(int fileHandle)
    {
        int totalSymbols = SymbolsTotal(false);
        for (int i = 0; i < totalSymbols; i++)
        {
            string symbolName = SymbolName(i, false); // Get the symbol name
            FileWrite(fileHandle, symbolName);        // Write the symbol name to the file
            symbolLength = symbolLength + 1;
        }
        FileClose(fileHandle);
        return true;
    };

    bool setSymbols()
    {
        int file;
        string sz0;
        string terminal_data_path = TerminalInfoString(TERMINAL_DATA_PATH);
        if ((file = FileOpen(fileName, FILE_WRITE)) != INVALID_HANDLE)
        {
            return writeFile(file);
        }
        Print("error writing config file");
        return false;
    };

    void AddSymbol(string sym)
    {
        ArrayResize(Symbols, (ArraySize(Symbols) + 1));
        Symbols[ArraySize(Symbols) - 1] = sym;
    };

    bool loadSymbols()
    {
        int file;
        string sz0;
        bool ret;
        string terminal_data_path = TerminalInfoString(TERMINAL_DATA_PATH);

        if (FileIsExist(fileName, 0))
        {
            if ((file = FileOpen(fileName, FILE_CSV | FILE_READ | FILE_ANSI)) == INVALID_HANDLE)
            {
                PrintFormat("%s configuration file not found.", szFileConfig);
                return false;
            }
            m_widget_Infos.nSymbols = 0;
            ArrayResize(m_widget_Infos.Symbols, symbolLength);
            for (int c0 = 1; (!FileIsEnding(file)) && (!_StopFlag); c0++)
            {
                if ((sz0 = FileReadString(file)) == "")
                    continue;
                if (SymbolExist(sz0, ret)){
                    
                    Print(sz0);
                    AddSymbol(sz0);
                }
                else
                {
                    FileClose(file);
                    PrintFormat("Asset on line %d was not recognized.", c0);
                    return false;
                }
            }
            FileClose(file);
            return true;
        }
        return false;
    };
};