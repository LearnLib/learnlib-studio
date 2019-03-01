package de.learnlib.studio.experiment.codegen.providers

import graphmodel.Node


interface AutomataLibArtifactProvider<N extends Node> extends NodeRelatedGeneratorInformationProvider<N> {
    
    def String[] automataLibArtifacts()
    
}
