/*

   CustomTicket_MQL4.mqh
   Copyright 2022, Orchard Forex
   https://orchardforex.com

   Functions to help with managing magic numbers including a trade number

*/

//	long FindTicketFromMagic(
//				long magic	-	The actual magic number being searched including trade #
//	)
//	returns: the ticket number of the trade found
//
// Find the ticket number given a unique magic
//	Only for live trades/orders not history
//		2 versions
//		This version only if there is only one trade
long FindTicketFromMagic( long magic ) {

   for ( int i = OrdersTotal() - 1; i >= 0; i-- ) {
      if ( !OrderSelect( i, SELECT_BY_POS, MODE_TRADES ) ) continue;
      if ( OrderSymbol() == Symbol() && OrderMagicNumber() == magic ) {
         return ( OrderTicket() );
      }
   }
   return ( 0 );
}

//	long FindTicketFromMagic(
//				long magic,	-	The actual magic number being searched including trade #
//				long &tickets[] - array of found ticket numebrs to return
//	)
//	returns: the number of tickets found
//
//		This version finds all current trades
long FindTicketFromMagic( long magic, long &tickets[] ) {

   int count = 0;
   for ( int i = OrdersTotal() - 1; i >= 0; i-- ) {
      if ( !OrderSelect( i, SELECT_BY_POS, MODE_TRADES ) ) continue;
      if ( OrderSymbol() == Symbol() && OrderMagicNumber() == magic ) {
         ArrayResize( tickets, count + 1, 10 );
         tickets[count++] = OrderTicket();
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

   int count = 0;
   for ( int i = OrdersTotal() - 1; i >= 0; i-- ) {
      if ( !OrderSelect( i, SELECT_BY_POS, MODE_TRADES ) ) continue;
      if ( OrderSymbol() == Symbol() && GetBaseNumber( OrderMagicNumber() ) == BaseNumber ) {
         ArrayResize( list, count + 1, 10 );
         list[count++] = GetTradeNumber( OrderMagicNumber() );
      }
   }
   ArraySort( list );
   return ( count );
}

//	void FindCurrentTradeNumber(
//				bool	includeHistory = false - indicates if searhc of closed trades is required
//	)
//
// Just find the most recently used trade number
// Also looks in history just in case you need to
//
void FindCurrentTradeNumber( bool includeHistory = false ) {

   CurrentTradeNumber  = 0;
   datetime latestDate = FindCurrentTradeNumberFrom( MODE_TRADES );
   if ( includeHistory ) {
      FindCurrentTradeNumberFrom( MODE_HISTORY, latestDate );
   }
}

//	datetime FindCurrentTradeNumberFrom(
//				int pool		-	MODE_TRADES or MODE_HISTORY to search current or history
//				datetime latestDate	-	Helps to find in case of searching 2 pools
//	)
//	returns: open time of most recent matching order
//
// Load trade number from a specific pool
// Finds most recent used based on trade open time
// This can be wrong for things like partially closed trades
// or where 2 trades are opened at the same time
// Live with it and handle in the next number fn
datetime FindCurrentTradeNumberFrom( int pool, datetime latestDate = 0 ) {

   int count = ( pool == MODE_TRADES ) ? OrdersTotal() : OrdersHistoryTotal();
   for ( int i = count - 1; i >= 0; i-- ) {
      if ( !OrderSelect( i, SELECT_BY_POS, pool ) ) continue;
      if ( OrderSymbol() == Symbol() && GetBaseNumber( OrderMagicNumber() ) == BaseNumber ) {
         if ( OrderOpenTime() > latestDate ) {
            latestDate         = OrderOpenTime();
            CurrentTradeNumber = GetTradeNumber( OrderMagicNumber() );
         }
      }
   }
   return ( latestDate );
}
