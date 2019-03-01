package de.learnlib.studio.experiment.codegen.providers

import java.util.List

import graphmodel.Node

import de.learnlib.studio.siblibrary.siblibrary.MavenArtifact


interface MavenArtifactProvider<N extends Node> extends NodeRelatedGeneratorInformationProvider<N> {
    
    def List<MavenArtifact> getArtifacts()
    
}
