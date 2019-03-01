package de.learnlib.studio.experiment.codegen.providers

import java.util.List

import graphmodel.Node


interface LearnLibArtifactProvider<N extends Node> extends NodeRelatedGeneratorInformationProvider<N> {
    
    def List<String> learnLibArtifacts()
    
}
