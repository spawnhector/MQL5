//+------------------------------------------------------------------+
//|                                                                  |
//|                       CustomButton.mqh                           |
//|                                                                  |
//+------------------------------------------------------------------+

class CustomButton
{
private:
   int           m_x;
   int           m_y;
   int           m_width;
   int           m_height;
   color         m_color;
   string        m_text;

public:
   void Create(int x, int y, int width, int height, string text)
   {
      m_x = x;
      m_y = y;
      m_width = width;
      m_height = height;
    //   m_color = color;
      m_text = text;
   }

   void Draw()
   {
      ObjectCreate(0, "CustomButton", OBJ_BUTTON, 0, 0, 0);
      ObjectSetInteger(0, "CustomButton", OBJPROP_XDISTANCE, m_x);
      ObjectSetInteger(0, "CustomButton", OBJPROP_YDISTANCE, m_y);
      ObjectSetInteger(0, "CustomButton", OBJPROP_XSIZE, m_width);
      ObjectSetInteger(0, "CustomButton", OBJPROP_YSIZE, m_height);
    //   ObjectSetInteger(0, "CustomButton", OBJPROP_COLOR, m_color);
      ObjectSetString(0, "CustomButton", OBJPROP_TEXT, m_text);
   }
};

//+------------------------------------------------------------------+
//|                                                                  |
//|                       Test.mq5                                   |
//|                                                                  |
//+------------------------------------------------------------------+

// #include <CustomButton.mqh>

void OnStart()
{
   CustomButton playButton;
   playButton.Create(100, 100, 50, 50,  "⚙");

   CustomButton pauseButton;
   pauseButton.Create(200, 100, 50, 50,  "⚙");

   playButton.Draw();
   pauseButton.Draw();
}
