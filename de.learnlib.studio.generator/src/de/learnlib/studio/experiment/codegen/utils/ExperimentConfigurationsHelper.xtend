package de.learnlib.studio.experiment.codegen.utils

import java.util.Map
import java.util.Set

import graphmodel.Container
import graphmodel.Node

import de.learnlib.studio.experiment.experiment.Experiment
import de.learnlib.studio.experiment.experiment.SULMembershipOracle


class ExperimentConfigurationsHelper {

    static class ExperimentConfiguration {
        
        val Set<Node> allNodes
        
        val Map<Container, Node> containerNodeMap
        
        new() {
            this.allNodes = newHashSet()
            this.containerNodeMap = newHashMap()
        }
        
        private new(Set<Node> allNodes, Map<Container, Node> containerNodeMap) {
            this.allNodes = allNodes
            this.containerNodeMap = containerNodeMap
        }
        
        def add(Container container, Node node) {
            allNodes += node
            containerNodeMap.put(container, node)
        }
        
        def add(Node node) {
            allNodes += node
        }
        
        def contains(Node node) {
            return allNodes.contains(node)
        }
        
        def getNodes() {
            return allNodes
        }
        
        def getNode(Container container) {
            return containerNodeMap.get(container)
        }
        
        def copy() {
            val copyOfAllNodes = <Node> newHashSet(allNodes)
            
            val copyOfContainerNodeMap = <Container, Node> newHashMap()
            copyOfContainerNodeMap.putAll(containerNodeMap)
            
            return new ExperimentConfiguration(copyOfAllNodes, copyOfContainerNodeMap)
        }
        
        def copyAndAdd(Container container, Node node) {
            val newConfiguration = copy()
            newConfiguration.add(container, node)
            return newConfiguration
        }
        
        def copyAndAdd(Node node) {
            val newConfiguration = copy()
            newConfiguration.add(node)
            return newConfiguration
        }
        
    }

    def Set<ExperimentConfiguration> findConfigurations(Experiment model) {
        var configurations = <ExperimentConfiguration> newHashSet()
        configurations += new ExperimentConfiguration()
        
        for (node : model.nodes) {
            val newConfigurations = <ExperimentConfiguration> newHashSet()
            for (config : configurations) {
                newConfigurations += createUpdatedConfigurations(config, node)
            }
            configurations = newConfigurations
        }
        
        println("Combinations: " + configurations.size)
        return configurations
    }
    
    private def createUpdatedConfigurations(ExperimentConfiguration config, Node node) {
        val newConfigurations = <ExperimentConfiguration> newHashSet()
        
        if (node.isComplexElement) {
            val container = node as Container
            val sourceNodesInContainer = getSourceNodesWithin(container)
            for (sourceNode : sourceNodesInContainer) {
                newConfigurations += config.copyAndAdd(container, sourceNode)
            }
        } else {
            newConfigurations += config.copyAndAdd(node)
        }
        
        return newConfigurations
    }
    
    private def isComplexElement(Node node) {
        return (node instanceof Container) && !(node instanceof SULMembershipOracle)
    }
    
    private def getSourceNodesWithin(Container container) {
        return container.nodes.filter[incoming.size == 0]
    }

}
