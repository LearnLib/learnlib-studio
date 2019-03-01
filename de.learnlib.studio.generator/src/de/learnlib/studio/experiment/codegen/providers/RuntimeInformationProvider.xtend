package de.learnlib.studio.experiment.codegen.providers

import graphmodel.Node


interface RuntimeInformationProvider<N extends Node> extends NodeRelatedGeneratorInformationProvider<N> {
    
    def N getNode()
    
    def String getName()
    
    def String getClassName()
    
    def String[] getExperimentImports()
    
    def Object[] getConstructorParameters()
    
}
