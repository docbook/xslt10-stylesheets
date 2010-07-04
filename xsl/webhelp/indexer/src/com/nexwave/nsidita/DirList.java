package com.nexwave.nsidita;

import java.io.File;
import java.io.FilenameFilter;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.regex.*;

public class DirList {
	
	ArrayList<File> listFiles = null;
	ArrayList<String> listFilesRelTo = null;
	String [] topicFiles = null;
   	public static final int MAX_DEPTH = 10;
    
  public DirList(File inputdir, String regex, int depth) {
    try {
      
      listFiles = new ArrayList<File> ();
    	
    // not yet implemented	
      if(regex == null) {
          for (File f: inputdir.listFiles()) {
        	  if (!f.isDirectory()){
        		  listFiles.add(f);
        	  }else {
        		  if (depth < MAX_DEPTH ) {
           			DirList nsiDoc = new DirList(f,regex,depth+1);
         			listFiles.addAll(new ArrayList<File>(nsiDoc.getListFiles()));
        		  }
        	  }
          }
      }
      else {
          for (File f: inputdir.listFiles(new DirFilter(regex))) {
        	  listFiles.add(f);
          }
          for (File f: inputdir.listFiles(new DirFilter("^[^\\.]*$"))) {
        	  if (f.isDirectory()){
        		  if (depth < MAX_DEPTH ) {
        			DirList nsiDoc = new DirList(f,regex, depth+1);
         			listFiles.addAll(new ArrayList<File>(nsiDoc.getListFiles()));
        		  }
        	  }
          }
      }
    } 
    catch(Exception e) {
    	// TODO gerer exception
     e.printStackTrace();
    }
  }
  
  public ArrayList<File> getListFiles() {
	  return this.listFiles;
  }
 /**
  * Calculate the path of the files already listed relative to projectDir
  * @param projectDir Root from where to calculate the relative path
  * @return The list of files with their relative path
  */ 
  public ArrayList<String> getListFilesRelTo(String projectDir) {
	Iterator it;
	
	if (this.listFiles == null) return null;
	
	listFilesRelTo =  new ArrayList<String>();
	it = this.listFiles.iterator ( ) ;
	while ( it.hasNext ( ) ) {
		File ftemp = (File) it.next();
		String stemp = ftemp.getPath();
		int i = stemp.indexOf(projectDir);
		if ( i != 0 ) {
			System.out.println("the documentation root does not match with the documentation input!");
			return null;
		}
		int ad = 1;
		if (stemp.equals(projectDir)) ad = 0; 
		stemp = stemp.substring(i+projectDir.length()+ad);
		listFilesRelTo.add(stemp);
	}
	return this.listFilesRelTo;
  }

}

class DirFilter implements FilenameFilter {
	private Pattern pattern;
	public DirFilter(String regex) {
	    pattern = Pattern.compile(regex);
	  }
	  public boolean accept(File dir, String name) {
		  String thisname = new File(name).getName();
		  //System.out.println("Testing: "+ thisname);
		  if(thisname.equals("index.html") || thisname.equals("ix01.html")){
			  return false;
		  }else{
			  // Strip path information, search for regex:
			  return pattern.matcher(new File(name).getName()).matches();
		  }
	  }
} 
