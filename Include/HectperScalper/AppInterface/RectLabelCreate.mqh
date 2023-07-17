//+------------------------------------------------------------------+
//|                                              RectLabelCreate.mqh |
//|                                                    ronald Hector |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "ronald Hector"
#property link      "https://www.mql5.com"
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+
////of the function creating a rectangle, text, button***********************
//create a rectangle border
bool RectLabelCreate(
   const long chart_ID=0, // chart ID
   const string name="RectLabel", // label name
   const int sub_window=0, // subwindow number
   const int x=0, // X coordinate
   const int y=0, // Y coordinate
   const int width=50, // width
   const int height=18, // height
   const color back_clr=C'236,233,216', // background color
   const ENUM_BORDER_TYPE border=BORDER_SUNKEN, // const border type
   ENUM_BASE_CORNER corner=CORNER_LEFT_UPPER, // chart corner for anchoring
   const color clr=clrRed, // flat border color (Flat)
   const ENUM_LINE_STYLE style=STYLE_SOLID, // flat border style
   const int line_width=1, // flat border width
   const bool back=false, // const in the background
   bool selection=false, // select to move
   const bool hidden=true, // hidden in the list of objects
   const long z_order=0) // priority for mouse click
  {
//--- reset the error value
   ResetLastError();
//--- create a rectangle label
   if(!ObjectCreate(chart_ID,name,OBJ_RECTANGLE_LABEL,sub_window,0,0))
     {
      Print(__FUNCTION__, ": failed to create a rectangle label! Error code = ",GetLastError());
      return(false);
     }
//--- set label coordinates
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
//--- set label size
   ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width);
   ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height);
//--- set the background color
   ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr);
//--- set border type
   ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_TYPE,border);
//--- set the chart's corner, relative to which point coordinates are defined
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
//--- set flat border color (in Flat mode)
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- set flat border line style
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
//--- set flat border width
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,line_width);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- enable (true) or disable (false) the mode of moving the label by mouse
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- set the priority for receiving the event of a mouse click on the chart
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- successful execution
   return(true);
  }

  bool RectLabelCreateResizable(
   const long chart_ID=0, // chart ID
   const string name="RectLabel", // label name
   const int sub_window=0, // subwindow number
   const long x=0, // X coordinate
   const long y=0, // Y coordinate
   const long width=50, // width
   const long height=18, // height
   const color back_clr=C'236,233,216', // background color
   const ENUM_BORDER_TYPE border=BORDER_SUNKEN, // border type
   ENUM_BASE_CORNER corner=CORNER_LEFT_UPPER, // chart corner for anchoring
   const color clr=clrRed, // flat border color (Flat)
   const ENUM_LINE_STYLE style=STYLE_SOLID, // flat border style
   const int line_width=1, // flat border width
   const bool back=false, // in the background
   bool selection=false, // select to move
   const bool hidden=true, // hidden in the list of objects
   const long z_order=0) // priority for mouse click
{
    // Reset the error value
    ResetLastError();

    // Create a rectangle label
    if (!ObjectCreate(chart_ID, name, OBJ_RECTANGLE_LABEL, sub_window, 0, 0))
    {
        Print(__FUNCTION__, ": failed to create a rectangle label! Error code = ", GetLastError());
        return (false);
    }

    // Set label coordinates
    ObjectSetInteger(chart_ID, name, OBJPROP_XDISTANCE, x);
    ObjectSetInteger(chart_ID, name, OBJPROP_YDISTANCE, y);

    // Set label size
    ObjectSetInteger(chart_ID, name, OBJPROP_XSIZE, width);
    ObjectSetInteger(chart_ID, name, OBJPROP_YSIZE, height);

    // Set the background color
    ObjectSetInteger(chart_ID, name, OBJPROP_BGCOLOR, back_clr);

    // Set border type
    ObjectSetInteger(chart_ID, name, OBJPROP_BORDER_TYPE, border);

    // Set the chart's corner, relative to which point coordinates are defined
    ObjectSetInteger(chart_ID, name, OBJPROP_CORNER, corner);

    // Set flat border color (in Flat mode)
    ObjectSetInteger(chart_ID, name, OBJPROP_COLOR, clr);

    // Set flat border line style
    ObjectSetInteger(chart_ID, name, OBJPROP_STYLE, style);

    // Set flat border width
    ObjectSetInteger(chart_ID, name, OBJPROP_WIDTH, line_width);

    // Display in the foreground (false) or background (true)
    ObjectSetInteger(chart_ID, name, OBJPROP_BACK, back);

    // Enable (true) or disable (false) the mode of moving the label by mouse
    ObjectSetInteger(chart_ID, name, OBJPROP_SELECTABLE, selection);
    ObjectSetInteger(chart_ID, name, OBJPROP_SELECTED, selection);

    // Hide (true) or display (false) graphical object name in the object list
    ObjectSetInteger(chart_ID, name, OBJPROP_HIDDEN, hidden);

    // Set the priority for receiving the event of a mouse click on the chart
    ObjectSetInteger(chart_ID, name, OBJPROP_ZORDER, z_order);

    // Successful execution
    return (true);
}