package de.learnlib.studio.symbol.hooks

import de.jabc.cinco.meta.runtime.hook.CincoPostCreateHook

import de.learnlib.studio.symbol.symbol.Symbol


class SymbolPostCreateHook extends CincoPostCreateHook<Symbol> {
    
    // thanks to https://stackoverflow.com/a/7594052
    static val CAMEL_CASE_SPLITTER = "(?<!(^|[A-Z]))(?=[A-Z])|(?<!^)(?=[A-Z][a-z])"
    
    static val DEFAULT_X_POSITION = 100
    
    override postCreate(Symbol symbol) {
        val modelName = getModelName(symbol)
        symbol.name = convertModelNameToSymbolName(modelName)
            
        symbol.newStart(DEFAULT_X_POSITION, 50)
        
        val successEnd = symbol.newEnd(DEFAULT_X_POSITION, 200)
        successEnd.name = "Success"
    }
    
    private def getModelName(Symbol symbol) {
        val uri = symbol.eResource().getURI()
        val fileName = uri.lastSegment()
        val fileExtension = uri.fileExtension()
        
        var modelName = fileName.replace("." + fileExtension, "")
        modelName = modelName.replace("%20", " ")
        modelName = modelName.replace("_", " ")
        
        return modelName
    }
    
    private def convertModelNameToSymbolName(String fileName) {
        println("File Name: " + fileName)
        
        val fileNameParts = fileName.split(" ")
        val camelCaseSplittedParts = fileNameParts.map[part | part.split(CAMEL_CASE_SPLITTER)]
        
        val antiCamelizedParts = camelCaseSplittedParts.map[join(" ")]
        val symbolName = antiCamelizedParts.join(" ")
        
        return symbolName
    }
    
}
