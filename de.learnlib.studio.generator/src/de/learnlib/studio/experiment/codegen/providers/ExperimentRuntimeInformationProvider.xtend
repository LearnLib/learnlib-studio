package de.learnlib.studio.experiment.codegen.providers

import java.util.List

import graphmodel.Node


interface ExperimentRuntimeInformationProvider<N extends Node> extends RuntimeInformationProvider<N> {
	
	def List<Pair<String, Node>> getSuccessors()
	
}
