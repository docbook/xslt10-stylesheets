package com.nexwave.nsidita;

import java.io.File;
import java.io.FilenameFilter;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.regex.*;

public class DirList {

    ArrayList<File> listFiles = null;
    ArrayList<String> listFilesRelTo = null;
    String[] topicFiles = null;
    String[] regexp = null;
    
    public static final int MAX_DEPTH = 10;

    public DirList(File inputDir, String[] regexpr, int depth) {
        try {

            listFiles = new ArrayList<File>();
            this.regexp = regexpr;
            
            // not yet implemented
            if (regexp == null) {
                for (File f : inputDir.listFiles()) {
                    if (!f.isDirectory()) {
                        listFiles.add(f);
                    } else {
                        if (depth < MAX_DEPTH) {
                            DirList nsiDoc = new DirList(f, regexp, depth + 1);
                            listFiles.addAll(new ArrayList<File>(nsiDoc.getListFiles()));
                        }
                    }
                }
            } else {
                for (File f : inputDir.listFiles(new DirFilter(regexp, regexp[regexp.length-1]))) {
                    listFiles.add(f);
                }
// Patch from Oxygen to address problem where directories
// containing . were not traversed.
                for (File f : inputDir.listFiles(new DirFilter(regexp,".*"))) {
                    if (f.isDirectory()) {
                        if (depth < MAX_DEPTH) {
                            DirList nsiDoc = new DirList(f, regexp, depth + 1);
                            listFiles.addAll(new ArrayList<File>(nsiDoc.getListFiles()));
                        }
                    }
                }
            }
        }
        catch (Exception e) {
            // TODO gerer exception
            e.printStackTrace();
        }
    }

    public ArrayList<File> getListFiles() {
        return this.listFiles;
    }

    /**
     * Calculate the path of the files already listed relative to projectDir
     *
     * @param projectDir Root from where to calculate the relative path
     * @return The list of files with their relative path
     */
    public ArrayList<String> getListFilesRelTo(String projectDir) {
        Iterator it;

        if (this.listFiles == null) return null;

        listFilesRelTo = new ArrayList<String>();
        it = this.listFiles.iterator();
        while (it.hasNext()) {
            File ftemp = (File) it.next();
            String stemp = ftemp.getPath();
            int i = stemp.indexOf(projectDir);
            if (i != 0) {
                System.out.println("the documentation root does not match with the documentation input!");
                return null;
            }
            int ad = 1;
            if (stemp.equals(projectDir)) ad = 0;
            stemp = stemp.substring(i + projectDir.length() + ad);
            listFilesRelTo.add(stemp);
        }
        return this.listFilesRelTo;
    }

}

class DirFilter implements FilenameFilter {
    private Pattern pattern;
    private String[] regexp = null;
    private ArrayList<Pattern> patternlist;
    
    public DirFilter(String regex) {
        pattern = Pattern.compile(regex);
    }
    public DirFilter(String[] regexx, String regex) {
    	patternlist = new ArrayList<Pattern>();
    	this.regexp = regexx;
    	
    	for(int i = 0; i < regexp.length-1; i++){
    		Pattern pattern;
    		pattern = Pattern.compile(regexp[i]);
    		patternlist.add(pattern);
    	}
    	pattern = Pattern.compile(regexp[regexp.length-1]);
    }

    public boolean accept(File dir, String name) {
        String thisname = new File(name).getName();
        boolean result = false;
//        System.out.println("all files : "+ name);
        for(int i = 0; i < patternlist.size(); i++){
        	if(patternlist.get(i).matcher(new File(name).getName()).matches()){
            	result = false;
            	break;
            }else{
            	result = pattern.matcher(new File(name).getName()).matches();
            }
    	}
        return result;
    }
} 
