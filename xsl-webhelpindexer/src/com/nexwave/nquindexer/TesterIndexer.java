package com.nexwave.nquindexer;

/**
 * For running tests with the indexertask.
 * 
 * @version 2.0 2010-08-14
 * 
 * @author N. Quaine
 * @author Kasun Gajasinghe
 */
    public class TesterIndexer {
	public static IndexerTask IT = null; 
	/**
	 * @param args
	 * @throws InterruptedException 
	 */
	public static void main(String[] args) throws InterruptedException {
        if (args.length != 0) {
            IT = new IndexerTask();
            IT.setHtmldir(args[0]);
            IT.setIndexerLanguage(args[1]);
            IT.execute();
        } else {
            System.out.println("When using the TestIndexer class, you must give the directory of html files to parse as " +
                    "input. Defaulted to '../doc/content' directory and 'English' language.");

            String dir = "../doc/content";
            String lang = "en";
            IT = new IndexerTask();
            IT.setHtmldir(dir);
            IT.setIndexerLanguage(lang);
            IT.execute();
        }

	}
	
}

