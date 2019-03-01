package de.learnlib.studio.tracer.outputparser

import java.util.regex.Pattern


class StepFinishedOutputParser extends OutputParser {
    
    static val STATE_FILE_PATTERN = Pattern.compile("^     Wrote state to (.*)$")
    
    val String pathToFollow
    
    var String resumeFileName
    
    
    new (String pathToFollow) {
        this.pathToFollow = pathToFollow
    }
    
    override parse() {
        val line = if (buffer.length > 0) { buffer.substring(0, buffer.length - 1) }
                   else                   { buffer.toString() }
        val matcher = STATE_FILE_PATTERN.matcher(line)
        
        if (matcher.matches()) {
            resumeFileName = matcher.group(1)
        } else {
            System.err.println("Could not find the resume file name in '" + line + "'.");
        }
    }
    
    def getResumeFileName() {
        resumeFileName
    }
    
    def getPathToFollow() {
        pathToFollow
    }
    
}
