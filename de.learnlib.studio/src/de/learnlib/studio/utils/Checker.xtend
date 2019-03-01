package de.learnlib.studio.utils

import java.util.List
import java.util.Set
import java.util.function.Function
import java.util.function.BiConsumer
import java.util.function.Consumer

import de.jabc.cinco.meta.plugin.mcam.runtime.core.CincoCheckModule
import graphmodel.IdentifiableElement


class Checker<N> {
    
    val Iterable<N> nodes    
    
    val Set<CheckPipeline<N, ?>> checks
    
    val BiConsumer<N, String> warnFunction
    val BiConsumer<N, String> errorFunction
    
    new(N... nodes) {
        this(nodes, newHashSet(), null, null)
    }

    new(CincoCheckModule<?, ?, ?> checkModule, N... nodes) {
        this.nodes = nodes
        this.checks = newHashSet()
        
        this.warnFunction  = createCincoCheckModuleCallFunction(checkModule, "addWarning")
        this.errorFunction = createCincoCheckModuleCallFunction(checkModule, "addError")
    }
    
    private def BiConsumer<N, String> createCincoCheckModuleCallFunction(CincoCheckModule<?, ?, ?> checkModule, String methodName) {
        return [N node, String message |
            val method = checkModule.class.getMethod(methodName, IdentifiableElement, String)
            method.invoke(checkModule, node, message)
        ]
    }
    
    private new(Iterable<N> nodes, Set<CheckPipeline<N, ?>> checks, BiConsumer<N, String> warnFunction, BiConsumer<N, String> errorFunction) {
        this.nodes = nodes
        this.checks = checks
        this.warnFunction  = warnFunction
        this.errorFunction = errorFunction
    }
    
    def setWarnFunction(BiConsumer<N, String> warnFunction) {
        return new Checker(this.nodes, this.checks, warnFunction, this.errorFunction)
    }
    
    def setErrorFunction(BiConsumer<N, String> errorFunction) {
        return new Checker(this.nodes, this.checks, this.warnFunction, errorFunction)
    }
    
    def <T> addChecksFor(Function<N, T> mapToUniqueAttributeFunction) {
        if (errorFunction === null) {
            throw new IllegalStateException("No Error Function defined!")
        }
        if (warnFunction === null) {
            throw new IllegalStateException("No Error Function defined!")
        }

        val newPipeline = new CheckPipeline<N, T>(mapToUniqueAttributeFunction, warnFunction, errorFunction)
        checks += newPipeline
        return newPipeline
    }
    
    def addStringChecksFor(Function<N, String> mapToUniqueAttributeFunction) {
        if (errorFunction === null) {
            throw new IllegalStateException("No Error Function defined!")
        }
        if (warnFunction === null) {
            throw new IllegalStateException("No Error Function defined!")
        }

        val newPipeline = new StringCheckPipeline<N>(mapToUniqueAttributeFunction, warnFunction, errorFunction)
        checks += newPipeline
        return newPipeline
    }
    
    def check() {
        if (checks === null) {
            throw new IllegalStateException("No Check Pipeline defined!")
        }
        if (errorFunction === null) {
            throw new IllegalStateException("No Error Function defined!")
        }
        if (warnFunction === null) {
            throw new IllegalStateException("No Error Function defined!")
        }
        
        nodes.forEach[n | checks.forEach[c | c.check(n)]]
    }
    
    static class CheckPipeline<N, T> {
        
        val BiConsumer<N, String> warnFunction
        val BiConsumer<N, String> errorFunction
        
        val Function<N, T> mapToAttributeFunction
        val List<Checker.Check<N, T>> pipeline
        
        new(Function<N, T> mapToAttributeFunction, BiConsumer<N, String> warnFunction, BiConsumer<N, String> errorFunction) {
            this.mapToAttributeFunction = mapToAttributeFunction
            this.pipeline = newLinkedList()
            
            this.errorFunction = errorFunction
            this.warnFunction  = warnFunction
        }
        
        def check(N data) {
            val value = mapToAttributeFunction.apply(data)
            
            val singleWarnFunction  = [String warnMessage  | warnFunction.accept(data, warnMessage)]
            val singleErrorFunction = [String errorMessage | errorFunction.accept(data, errorMessage)]
            
            val iterator = pipeline.iterator()
            var lastResult = true
            while (iterator.hasNext() && lastResult) {
                val func = iterator.next()
                
                lastResult = func.check(value, singleWarnFunction, singleErrorFunction)
            }
        }
        
        def addCustomCheck(Checker.Check<N, T> cutstomChecker) {
            pipeline += cutstomChecker
            return this
        }
        
        def operator_add(Checker.Check<N, T> cutstomChecker) {
            pipeline += cutstomChecker
            return this
        }
        
    }
    
    static class StringCheckPipeline<N> extends CheckPipeline<N, String> {
        
        new(Function<N, String> mapToAttributeFunction, BiConsumer<N, String> warnFunction, BiConsumer<N, String> errorFunction) {
            super(mapToAttributeFunction, warnFunction, errorFunction)
        }
    
        def notNullOrEmpty() {
            addCustomCheck([String data, Consumer<String> warnFunction, Consumer<String> errorFunction |
                    if (data.isNullOrEmpty) {
                        errorFunction.accept("is missing")
                        return false
                    }
                    return true
            ])
            
            return this
        }
        
        def shouldFollowRegexPattern(String pattern) {
            addCustomCheck([String data, Consumer<String> warnFunction, Consumer<String> errorFunction |
                if (!data.matches(pattern)) {
                    errorFunction.accept("is not matching '" + pattern + "'")
                    return false
                }
                return true
            ])
            
            return this
        }
        
        def shouldBeUnique() {
            val usedNamesMap = <String> newHashSet()
            addCustomCheck([String data, Consumer<String> warnFunction, Consumer<String> errorFunction |
                if (usedNamesMap.contains(data)) {
                    errorFunction.accept("is not unique")
                    return false
                }
                
                usedNamesMap.add(data)
                return true
            ])
            
            return this
        }
    }
    
    @FunctionalInterface
    static interface Check<N, T> {
        
        def boolean check(T data, Consumer<String> warnFunction, Consumer<String> errorFunction)
        
    }
    
}
