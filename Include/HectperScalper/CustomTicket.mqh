/*

   CustomTicket_MQL4.mqh
   Copyright 2022, Orchard Forex
   https://orchardforex.com

   Functions to help with managing magic numbers including a trade number

*/
int rand1 = MathRand() % 101; // generates a random number between 0 and 100
int rand2 = MathRand() % 101;

// Make sure total digits from these do not exceed the system limit
const int MagicNumberLimit = 1000000; // initial magic number must be < this
const int TradeNumberLimit = 1000;    // Trade numbers will wrap at this number

int       BaseNumber;             // saved here as a variable to avoid relying on name used in the app
int       CurrentTradeNumber = rand1+rand2; // For tracking

// Except for IsMagicValid all functions assume the magic number variable above

// and yes, this would be better as a class

//	bool IsMagicValid(
//				int magic - the entered magic to test
//	)
//	returns: true if the magic number is in an allowed range and sets the GV BaseNumber
//
bool      IsMagicValid( int magic ) {

   if ( magic <= 0 || magic >= MagicNumberLimit ) {
      PrintFormat( "Invalid magic, must be from 1 to %i", MagicNumberLimit - 1 );
      return ( false );
   }

   BaseNumber = magic;
   return ( true );
}

//	int GetNextTradeNumber()
//	returns: the next trade number - wrap around if needed
//
int GetNextTradeNumber() {

   // The trade number list is here to check for duplicates
   //		in case the numbers wrap around
   //	It does add some processing although not much
   //	You can remove it if you wish and are confident you will
   //		not have a wrap around conflict
   long tradeNumberList[];
   int  count         = LoadTradeNumberList( tradeNumberList );
   CurrentTradeNumber = ( ++CurrentTradeNumber % TradeNumberLimit );
   while ( count > 0 && tradeNumberList[ArrayBsearch( tradeNumberList, CurrentTradeNumber )] == CurrentTradeNumber ) {
      CurrentTradeNumber = ( ++CurrentTradeNumber % TradeNumberLimit );
   }
   return ( CurrentTradeNumber );
}

//	int GetNextMagicNumber()
//	returns: a full magic number including base number and incremented trade number
//
int GetNextMagicNumber() {

   return ( ( BaseNumber * TradeNumberLimit ) + GetNextTradeNumber() );
}

//	int GetBaseNumber(long magic)
// returns: just the base number part of the magic number
//
int GetBaseNumber( long magic ) {

   return ( int( magic / TradeNumberLimit ) );
}

//	int GetTradeNumber(long magic)
//	returns: just the trade number part of the magic number
int GetTradeNumber( long magic ) {

   return ( ( int )( magic % TradeNumberLimit ) );
}

#ifdef __MQL4__
   #include "CustomTicket_MQL4.mqh"
#endif

#ifdef __MQL5__
   #include "CustomTicket_MQL5.mqh"
#endif
