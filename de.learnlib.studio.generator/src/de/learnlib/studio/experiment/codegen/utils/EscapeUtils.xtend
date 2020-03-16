package de.learnlib.studio.experiment.codegen.utils

import java.util.regex.Matcher

class EscapeUtils {
		
	def escapeId(String id) {
        return id.replaceAll("-", "HypenMinus");
    }
    
    def toMultiLine(String text) {
    	return text.replaceAll("\"", Matcher.quoteReplacement("\\\""))
    		.split("\n")
    		.join("\" + \n\"")
    }
}