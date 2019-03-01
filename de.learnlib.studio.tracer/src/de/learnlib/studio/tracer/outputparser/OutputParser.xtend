package de.learnlib.studio.tracer.outputparser


abstract class OutputParser {
    
    protected val StringBuilder buffer
    
    new () {
        this.buffer = new StringBuilder;
    }
    
    def read(String in) {
        buffer.append(in + "\n")
    }
    
    def void parse()
    
}
