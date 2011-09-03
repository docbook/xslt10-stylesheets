package com.nexwave.nquindexer;

// OXYGEN PATCH, Create object 
public class WordAndScoring {
	
	/**
	 * The original word
	 */
	private String word;
	/**
	 * Scoring for given word
	 */
	private int scoring;
	/**
	 * Stemmed word
	 */
	private String stem;
	
	/**
	 * Constructor
	 * @param word Original word
	 * @param stem Stemmed word
	 * @param scoring Scoring of word 
	 */
	public WordAndScoring(String word, String stem, int scoring) {
		this.word = word;
		this.stem = stem;
		this.scoring = scoring;
	}
	/**
	 * @return the word
	 */
	public String getWord() {
		return word;
	}
	
	/**
	 * @return the scoring
	 */
	public int getScoring() {
		return scoring;
	}
	/**
	 * @param scoring the scoring to set
	 */
	public void setScoring(int scoring) {
		this.scoring = scoring;
	}

	@Override
	public String toString() {
		StringBuilder sb = new StringBuilder();
		sb.append("Word: ").append(word).append(" Score: ").append(scoring).append(" Stem: ").append(stem);
		return sb.toString();
	}
	
	/**
	 * 
	 * @return stemmed word
	 */
	public String getStem() {
		return stem;
	}
}
