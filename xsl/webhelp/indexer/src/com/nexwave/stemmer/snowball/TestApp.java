

package com.nexwave.stemmer.snowball;
import com.nexwave.stemmer.snowball.ext.FrenchStemmer;

public class TestApp {
    private static void usage()
    {
        System.err.println("Usage: TestApp <algorithm> <input file> [-o <output file>]");
    }

    public static void main(String [] args) throws Throwable {
/*	if (args.length < 2) {
            usage();
            return;
        }

	Class stemClass = Class.forName("com.nexwave.stemmer.snowball.ext." +
					args[0] + "Stemmer");*/
    //    SnowballStemmer stemmer = (SnowballStemmer) stemClass.newInstance();
        SnowballStemmer stemmer = new FrenchStemmer();//new EnglishStemmer();//= new GermanStemmer();

        StringBuffer input = new StringBuffer();
	/*Reader reader;
	reader = new InputStreamReader(new FileInputStream(args[1]));
	reader = new BufferedReader(reader);

	StringBuffer input = new StringBuffer();

        OutputStream outstream;

	if (args.length > 2) {
            if (args.length >= 4 && args[2].equals("-o")) {
                outstream = new FileOutputStream(args[3]);
            } else {
                usage();
                return;
            }
	} else {
	    outstream = System.out;
	}
	Writer output = new OutputStreamWriter(outstream);
	output = new BufferedWriter(output);

	int repeat = 1;
	if (args.length > 4) {
	    repeat = Integer.parseInt(args[4]);
	}*/

	Object [] emptyArgs = new Object[0];
    //char[] charArr = "testing runnable dogs ".toCharArray();
    char[] charArr = "complément ,é compliment, compliments , condiments ,".toCharArray();
//char[] charArr = "complément , c: compl s:complé compliment, c: compl s:compli compliments, c: compl s:compli condiments, c: cond s:condi".toCharArray();
//	int character;
	for (char ch : charArr) {
        //    char ch = (char) character;
        if (Character.isWhitespace((char) ch)) {
            if (input.length() > 0) {
                stemmer.setCurrent(input.toString());

                stemmer.stem();

                System.out.print(stemmer.getCurrent()+".");
              /*  output.write(stemmer.getCurrent());
                output.write('\n');*/
                input.delete(0, input.length());
            }
        } else {
            input.append(Character.toLowerCase(ch));
        }
	}
//	output.flush();
    }
}
