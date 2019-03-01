package de.learnlib.studio.experiment.codegen.utils

import de.learnlib.studio.experiment.codegen.GeneratorContext
import graphmodel.Node
import java.util.Map

class ObjectFactory {
    
    val Map<Class<?>, Object>            generalCache
    val Map<Node, Map<Class<?>, Object>> nodeRelatedCache
    
    var int misses
    var int requests
    
    new() {
        this.generalCache     = newHashMap()
        this.nodeRelatedCache = newHashMap()
    }
    
    def getInstance(Class<?> clazz, GeneratorContext context) {
        requests++
        return generalCache.computeIfAbsent(clazz, [misses++; createInstance(clazz, context)])
    }
        
    private def createInstance(Class<?> clazz, GeneratorContext context) {    
        try {
            val constructor = clazz.getConstructor(GeneratorContext)
            return constructor.newInstance(context)
        } catch (NoSuchMethodException e) {
            val constructor = clazz.getConstructor()
            return constructor.newInstance()
        }
    }
    
    def getInstance(Class<?> clazz, Class<? extends Node> nodeType, GeneratorContext context, Node node, Integer i) {
        requests++
        return nodeRelatedCache.computeIfAbsent(node,  [newHashMap()])
                               .computeIfAbsent(clazz, [misses++; createInstance(clazz, nodeType, context, node, i)])
    }
    
    private def createInstance(Class<?> clazz, Class<? extends Node> nodeType, GeneratorContext context, Node node, Integer i) {
        try {
            val constructor = clazz.getConstructor(GeneratorContext, nodeType, int)
            return constructor.newInstance(context, node, i)
        } catch (NoSuchMethodException e) {
            return getInstance(clazz, context)
        }
    }

    def printStatistics() {
        println("Object Requests:" + requests)
        println("\tNewly Created: " + misses)
        println("\tChached:" + (requests - misses))
    }
    
    def clear() {
        requests = 0
        misses = 0
        generalCache.clear()
        nodeRelatedCache.clear()   
    }
    
}
