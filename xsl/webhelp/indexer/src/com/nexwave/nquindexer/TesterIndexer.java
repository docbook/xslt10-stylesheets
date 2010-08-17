package com.nexwave.nquindexer;

import java.io.File;

/**
 * For running tests with the indexertask.
 * 
 * @version 2.0 2010-08-14
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
//
//        File file = new File("test");
//        System.out.println(file.getAbsolutePath());
		System.out.println(args[0]);
		if (args.length == 0 ) {
			System.out.println("When using the TestIndexer class, you must give the directory of html files to parse as input");
		}
		
		IT = new IndexerTask();
		IT.setHtmldir(args[0]);
		IT.setIndexerLanguage(args[1]);
		IT.execute();
		
	}
	
}

