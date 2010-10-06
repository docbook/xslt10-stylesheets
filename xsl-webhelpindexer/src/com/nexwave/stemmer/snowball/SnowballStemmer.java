
package com.nexwave.stemmer.snowball;
import java.lang.reflect.InvocationTargetException;

public abstract class SnowballStemmer extends SnowballProgram {
    public abstract boolean stem();
    
    /**
     * Do stemming of a given String array and returns the stemmed set of words as an array.
     * @param words Word set to be stemmed
     * @return stemmed word array
     */
    public String[] doStem(String[] words){
        String[] stemmedWords = new String[words.length];
        for (int i = 0; i < words.length; i++) {
            String word = words[i];
            word = word.trim().toLowerCase();

            //Do the stemming of the given word.
            setCurrent(word);   //set the word to be stemmed
            stem();             //tell stemmer to stem

            stemmedWords[i] = getCurrent(); //Get the stemmed word and add it to the stemmedWords array
         }
        return stemmedWords;
    }
}
