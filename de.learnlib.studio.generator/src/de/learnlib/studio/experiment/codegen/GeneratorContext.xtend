package de.learnlib.studio.experiment.codegen

import java.util.List
import java.util.Map
import java.util.Set

import graphmodel.Node

import de.learnlib.studio.experiment.experiment.Experiment
import de.learnlib.studio.experiment.codegen.templates.AbstractSourceTemplate
import de.learnlib.studio.experiment.codegen.providers.NodeRelatedGeneratorInformationProvider
import de.learnlib.studio.experiment.codegen.providers.GeneratorInformationProvider


class GeneratorContext {
	
	val Experiment model;
	
	val String modelName
	val String modelPackage
	val String modelPackageAsPath
	
	val Set<AbstractSourceTemplate> sourceTemplates
	
	val Map<Class<? extends GeneratorInformationProvider>, List<GeneratorInformationProvider>>                                                                  generalProviders
    val Map<Node, Map<Class<? extends NodeRelatedGeneratorInformationProvider<? extends Node>>, List<NodeRelatedGeneratorInformationProvider<? extends Node>>>> nodeRelatedProviders
	
	
	new(Experiment experiment) {
		this.model              = experiment
		this.modelName          = experiment.name
		this.modelPackage       = experiment.package
		this.modelPackageAsPath = experiment.package.replace('.', '/')
		
		this.sourceTemplates = newHashSet()
		
		this.generalProviders     = newHashMap()
		this.nodeRelatedProviders = newHashMap()
	}
	
	def getModel() {
		model
	}
	
	def getModelName() {
		modelName
	}
	
	def getModelPackage() {
		modelPackage
	}
	
	def getModelPackageAsPath() {
		modelPackageAsPath
	}
	
	def getNodes(Class<? extends Node> nodeType) {
	    val List<Node> result = newLinkedList()
	    result += model.getNodes(nodeType)
	    model.allContainers.forEach[c | result += c.getNodes(nodeType)]
	    return result
	}
	
	def isNodeTypeUsed(Class<? extends Node> usedNodeType) {
        return !model.getNodes(usedNodeType).nullOrEmpty || model.allContainers.exists[!getNodes(usedNodeType).nullOrEmpty]
	}
	
	def addSourceTemplate(AbstractSourceTemplate sourceTemplate) {
	    sourceTemplates += sourceTemplate
	}
	
	def getSourceTemplates() {
	    return sourceTemplates
	}
	
	def <P extends GeneratorInformationProvider> List<P> getProviders(Class<P> providerClass) {
        return generalProviders.get(providerClass) as List<P>
    }
    
    def <P extends GeneratorInformationProvider> P getProvider(Class<P> providerClass) {
        return getProviders(providerClass)?.get(0)
    }
    
    def addProvider(Class<? extends GeneratorInformationProvider> clazz, GeneratorInformationProvider provider) {
        generalProviders.computeIfAbsent(clazz, [newLinkedList()]).add(provider)
    }
    
    def <N extends Node, P extends NodeRelatedGeneratorInformationProvider<N>> List<P> getProviders(N node, Class<P> providerClass) {
        val map = nodeRelatedProviders.get(node)
        if (map !== null) {
            return map.get(providerClass) as List<P>    
        } else {
            return null;
        }
    }
    
    def <N extends Node, P extends NodeRelatedGeneratorInformationProvider<N>> P getProvider(N node, Class<P> providerClass) {
        return getProviders(node, providerClass)?.get(0)
    }

    def addProvider(Node node, Class<? extends NodeRelatedGeneratorInformationProvider<? extends Node>> clazz, NodeRelatedGeneratorInformationProvider<? extends Node> provider) {
        generalProviders.computeIfAbsent(clazz, [newLinkedList()]).add(provider)
        
        val mapForNode = nodeRelatedProviders.computeIfAbsent(node, [n | newHashMap()])
        mapForNode.computeIfAbsent(clazz as Class<? extends NodeRelatedGeneratorInformationProvider<? extends Node>>, [newLinkedList()]).add(provider)
    }

}
