package de.learnlib.studio.experiment.codegen.utils

import com.google.common.reflect.TypeToken
import java.lang.reflect.ParameterizedType
import graphmodel.Node


final class ReflectionUtils {
    
    private new() {}
    
    static def getAllInterfaces(Class<?> clazz) {
        val result = <Class<?>>newHashSet()
        for (TypeToken<?> t : TypeToken.of(clazz).types.interfaces()) {
            result += t.rawType
        }
        return result
    }
    
    static def getGenericTypeParameter(Class<?> clazz, Class<?> superType) {
        for (TypeToken<?> t : TypeToken.of(clazz).types.interfaces()){
            if (t.rawType == TypeToken.of(superType).rawType && t.type instanceof ParameterizedType) {
                val parameterizedType = t.type as ParameterizedType
                return parameterizedType.actualTypeArguments.get(0) as Class<? extends Node>
            }
        }
        
        return null
    }
    
}