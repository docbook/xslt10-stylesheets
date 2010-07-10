package com.nexwave.stemmer;

/**
 * Abstract class for all the language specific stemmers.
 * @author Kasun Gajasinghe
 * Date: Jul 11, 2010
 * Time: 12:59:47 AM
 */
public abstract class Stemmer {

    public abstract void stem();

    public abstract void add(char[] w, int wLen);

    public abstract void add(char ch);

    public abstract String doStem(String word);

    public abstract String[] doStem(String[] word);

    public abstract String toString();

}
