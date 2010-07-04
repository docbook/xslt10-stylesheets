package com.nexwave.nquindexer;

/**
 * For running tests with the indexertask.
 * 
 * @version 1.0 2008-0226
 * 
 * @author N. Quaine
 */
public class TesterIndexer {
	public static IndexerTask IT = null; 
	/**
	 * @param args
	 * @throws InterruptedException 
	 */
	public static void main(String[] args) throws InterruptedException {
		
		System.out.println(args[0]);
		if (args.length == 0 ) {
			System.out.println("When using the TestIndexer class, you must give the directory of html files to parse as input");
		}
		
		IT = new IndexerTask();
		IT.setHtmldir(args[0]);
		IT.execute();
		
	}
	
}

