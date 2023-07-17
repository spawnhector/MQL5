/*

   CustomTicket_MQL5.mqh
   Copyright 2022, Orchard Forex
   https://orchardforex.com

   Functions to help with managing magic numbers including a trade number

*/

//	long FindTicketFromMagic(
//				long magic	-	The actual magic number being searched including trade #
//	)	-	Returns the ticket number of the trade found
//
// Find the ticket number given a unique magic
//	Only for live trades/orders
//		2 versions
//		This version only if there is only one trade
ulong FindPositionTicketFromMagic( long magic ) {

   ulong ticket;
   for ( int i = PositionsTotal() - 1; i >= 0; i-- ) {
      ticket = PositionGetTicket( i );
      if ( ticket == 0 ) continue;
      if ( PositionGetString( POSITION_SYMBOL ) == Symbol() && PositionGetInteger( POSITION_MAGIC ) == magic ) {
         return ( ticket );
      }
   }

   return ( 0 );
}

ulong FindOrderTicketFromMagic( long magic ) {

   ulong ticket;
   for ( int i = OrdersTotal() - 1; i >= 0; i-- ) {
      ticket = OrderGetTicket( i );
      if ( ticket == 0 ) continue;
      if ( OrderGetString( ORDER_SYMBOL ) == Symbol() && OrderGetInteger( ORDER_MAGIC ) == magic ) {
         return ( ticket );
      }
   }

   return ( 0 );
}

//	long FindTicketFromMagic(
//				long magic,	-	The actual magic number being searched including trade #
//				long &tickets[] - array of found ticket numebrs to return
//	)	-	Returns the number of tickets found
//
//		This version finds all current trades
long FindPositionTicketFromMagic( long magic, ulong &tickets[] ) {

   int   count = 0;
   ulong ticket;
   for ( int i = PositionsTotal() - 1; i >= 0; i-- ) {
      ticket = PositionGetTicket( i );
      if ( ticket == 0 ) continue;
      if ( PositionGetString( POSITION_SYMBOL ) == Symbol() && PositionGetInteger( POSITION_MAGIC ) == magic ) {
         ArrayResize( tickets, count + 1, 10 );
         tickets[count++] = ticket;
      }
   }
   return ( count );
}

long FindOrderTicketFromMagic( long magic, ulong &tickets[] ) {

   int   count = 0;
   ulong ticket;
   for ( int i = OrdersTotal() - 1; i >= 0; i-- ) {
      ticket = OrderGetTicket( i );
      if ( ticket == 0 ) continue;
      if ( OrderGetString( ORDER_SYMBOL ) == Symbol() && OrderGetInteger( ORDER_MAGIC ) == magic ) {
         ArrayResize( tickets, count + 1, 10 );
         tickets[count++] = ticket;
      }
   }
   return ( count );
}

//	int LoadTradeNumberList(
//				long &list[] - sorted array of trade numbers found
//	)
//	returns: number of trades found
// Load an array of all currently open trade numbers
//
int LoadTradeNumberList( long &list[] ) {

   int   count = 0;
   ulong ticket;
   for ( int i = PositionsTotal() - 1; i >= 0; i-- ) {
      ticket = PositionGetTicket( i );
      if ( ticket == 0 ) continue;
      if ( PositionGetString( POSITION_SYMBOL ) == Symbol() && GetBaseNumber( PositionGetInteger( POSITION_MAGIC ) ) == BaseNumber ) {
         ArrayResize( list, count + 1, 10 );
         list[count++] = GetTradeNumber( PositionGetInteger( POSITION_MAGIC ) );
      }
   }
   for ( int i = OrdersTotal() - 1; i >= 0; i-- ) {
      ticket = OrderGetTicket( i );
      if ( ticket == 0 ) continue;
      if ( OrderGetString( ORDER_SYMBOL ) == Symbol() && GetBaseNumber( OrderGetInteger( ORDER_MAGIC ) ) == BaseNumber ) {
         ArrayResize( list, count + 1, 10 );
         list[count++] = GetTradeNumber( OrderGetInteger( ORDER_MAGIC ) );
      }
   }
   ArraySort( list );
   return ( count );
}

//	void FindCurrentTradeNumber()
//
// Just find the highest currently used trade number
//
void FindCurrentTradeNumber() {

   CurrentTradeNumber  = 0;
   datetime latestDate = FindCurrentTradeNumberFromPositions();
   latestDate          = FindCurrentTradeNumberFromOrders( latestDate );
}

//	datetime FindCurrentTradeNumberFrom( - Sets the CurrentTradeNumber variable
//				int pool		-	MODE_TRADES or MODE_HISTORY to search current or history
//				datetime &latestDate	-	Helps to find in case of searching 2 pools
//	)
//
// Load trade number from a specific pool
// Finds most recent used based on trade open time
// This can be wrong for things like partially closed trades
// or where 2 trades are opened at the same time
// Live with it and handle in the next number fn
datetime FindCurrentTradeNumberFromPositions( datetime latestDate = 0 ) {

   ulong ticket;
   for ( int i = PositionsTotal() - 1; i >= 0; i-- ) {
      ticket = PositionGetTicket( i );
      if ( ticket == 0 ) continue;
      if ( PositionGetString( POSITION_SYMBOL ) == Symbol() && GetBaseNumber( PositionGetInteger( POSITION_MAGIC ) ) == BaseNumber ) {
         latestDate         = ( datetime )PositionGetInteger( POSITION_TIME );
         CurrentTradeNumber = GetTradeNumber( PositionGetInteger( POSITION_MAGIC ) );
      }
   }
   return ( latestDate );
}

datetime FindCurrentTradeNumberFromOrders( datetime latestDate = 0 ) {

   ulong ticket;
   for ( int i = OrdersTotal() - 1; i >= 0; i-- ) {
      ticket = OrderGetTicket( i );
      if ( ticket == 0 ) continue;
      if ( OrderGetString( ORDER_SYMBOL ) == Symbol() && GetBaseNumber( OrderGetInteger( ORDER_MAGIC ) ) == BaseNumber ) {
         latestDate         = ( datetime )OrderGetInteger( ORDER_TIME_SETUP );
         CurrentTradeNumber = GetBaseNumber( OrderGetInteger( ORDER_MAGIC ) );
      }
   }
   return ( latestDate );
}
