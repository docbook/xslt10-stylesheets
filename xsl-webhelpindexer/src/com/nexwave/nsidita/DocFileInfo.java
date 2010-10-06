package com.nexwave.nsidita;

import java.io.File;
/**
 * Object for describing a dita or html file.
 * 
 * @version 2.0 2010-08-14
 * 
 * @author N. Quaine
 */
public class DocFileInfo {
	File fullpath = null;
	String title = null;
	String shortdesc = null;
	String relpathToDocRep = null; //relative path to doc repository (ex: tasks/nexbuilder)
	String deltaPathToDocRep = null; // distance from the doc repository (ex: ../..)

	// default constructor
	public DocFileInfo() {
	}
	
	public DocFileInfo(File file) {
		fullpath = file;
	}
	
	public DocFileInfo(DocFileInfo info) {
		this.fullpath = info.fullpath;
		this.title = info.title;
		this.shortdesc = info.shortdesc;
	}
	
	public void setTitle (String title){
		this.title = title;
	}

	public void setShortdesc (String shortDesc){
		this.shortdesc = shortDesc;
	}

	/**
	 * @return the shortdesc
	 */
	public String getShortdesc() {
		return shortdesc;
	}

	/**
	 * @return the title
	 */
	public String getTitle() {
		return title;
	}

	public File getFullpath() {
		return fullpath;
	}

	public void setFullpath(File fullpath) {
		this.fullpath = fullpath;
	}

}
