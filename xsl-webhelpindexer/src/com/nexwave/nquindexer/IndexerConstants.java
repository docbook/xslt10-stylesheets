package com.nexwave.nquindexer;
/**
 * Constants used for the indexer.
 * 
 * @version 2.0 2008-02-26
 * 
 * @author N. Quaine
 */
public abstract class IndexerConstants {
    // European punctuation
	public static final String EUPUNCTUATION1 = "[$|%,;.':()\\/*\"{}=!&+<>#\\?]|\\[|\\]|[-][-]+";
	public static final String EUPUNCTUATION2 = "[$,;.':()\\/*\"{}=!&+<>\\\\]";	
	// Japanese punctuation
	public static final String JPPUNCTUATION1 = "\\u3000|\\u3001|\\u3002|\\u3003|\\u3008|\\u3009|\\u300C|\\u300D";
	public static final String JPPUNCTUATION2 = "\\u3013|\\u3014|\\u3015|\\u301C|\\u301D|\\u301E|\\u301F";
	public static final String JPPUNCTUATION3 = "\\u3013|\\u300C|\\u300D";
}
