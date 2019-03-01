package de.learnlib.studio.experiment.codegen.templates

import java.util.List

import graphmodel.Node
import graphmodel.Container
import org.eclipse.core.runtime.IPath
import org.eclipse.core.runtime.IProgressMonitor

import de.learnlib.studio.experiment.experiment.Experiment
import de.learnlib.studio.experiment.experiment.Filter
import de.learnlib.studio.experiment.experiment.Oracle
import de.learnlib.studio.experiment.codegen.GeneratorContext
import de.learnlib.studio.experiment.codegen.templates.oracles.ExperimentOracleInterfaceTemplate
import de.learnlib.studio.experiment.codegen.templates.blocks.BlockInterfaceTemplate
import de.learnlib.studio.experiment.codegen.providers.ExperimentRuntimeInformationProvider
import de.learnlib.studio.experiment.codegen.providers.OracleInformationProvider
import de.learnlib.studio.experiment.codegen.utils.ExperimentConfigurationsHelper.ExperimentConfiguration
import de.learnlib.studio.experiment.codegen.providers.RuntimeInformationProvider
import de.learnlib.studio.experiment.codegen.providers.ExperimentConfigurationsProvider

import de.learnlib.studio.experiment.experiment.SULMembershipOracle
import de.learnlib.studio.experiment.experiment.QueryCounterFilter

import static extension de.learnlib.studio.experiment.utils.ExperimentExtensions.isComplexNode


class ExperimentTemplate extends AbstractSourceTemplate {

    var ExperimentConfiguration currentConfiguration
    var int i

    new(GeneratorContext context) {
        super(context, context.model.name)
        this.context = context
    }
    
    private def getOracleInformationProviders() {
        val oracles = currentConfiguration.nodes.filter[n | n instanceof Oracle && !(n instanceof Filter)]
        
        val result = <OracleInformationProvider<? extends Node>> newLinkedList()
        val queue = <Node> newLinkedList(oracles)
        val done  = <Node> newHashSet()
        while(!queue.empty) {
            val currentNode = queue.poll
            
            queue  += currentNode.predecessors.filter[n | !done.contains(n) && n instanceof Filter]
            done   += currentNode
            
            if (currentNode.isComplexNode) {	            
	            val realCurrentNode = currentConfiguration.getNode(currentNode as Container)
	            
	            val nodeChain = newLinkedList(realCurrentNode)
	            while (!nodeChain.last.successors.nullOrEmpty) {
	            	nodeChain += nodeChain.last.successors
	            }
	            
	            nodeChain.reverse.forEach[n |
	            	addNodeToResult(result, n)
            	]
            } else {
            	addNodeToResult(result, currentNode)
            }
        }
        
        return result
    }
    
    private def addNodeToResult(List<OracleInformationProvider<? extends Node>> result, Node node) {
    	val provider = context.getProvider(node, OracleInformationProvider)
        if (provider === null) {
            println("No OracleInformationProvider for " + node)
        } else {
            result += context.getProvider(node, OracleInformationProvider)
        }
    }
    
    override generate(Experiment model, IPath targetDir, IProgressMonitor progressMonitor) {
        val configurations = context.getProvider(ExperimentConfigurationsProvider).configurations
        if (configurations.size > 1) {
            configurations.forEach[config, counter |
                currentConfiguration = config
                i = counter + 1
                fileName = className + ".java"
                super.generate(model, targetDir, progressMonitor)
            ]
        } else {
            currentConfiguration = configurations.head
            i = -1
            super.generate(model, targetDir, progressMonitor)
        }
    }
    
    override getClassName() {
        if (i == -1) {
            return super.className
        } else {
            return super.className + i
        }
    }

    override template() '''
        « val oiProviders = getOracleInformationProviders() »
        « val eiProviders = getCurrentExperimentRuntimeInformationProvider() »
        package « package »;
        
        « importsTemplate(oiProviders) »
        
        
        public class « className » extends AbstractExperiment {
            
            « oracleDefinitionTemplate(oiProviders) »
            
            « blockDefinitionTemplate() »
            
            
            public « className »() {
                super();
                
                « oracleInitializationTemplate(oiProviders) »
                
                « blockInitializationTemplate() »
                
                « callTableTeamplate() »
                
                // Preparing for the run
                this.current = start;
            }
            
            @Override
            public String getConfigurationAsString() {
            	return "« FOR o : oiProviders SEPARATOR ", "»« o.className »« ENDFOR», « FOR e : eiProviders SEPARATOR ", "»« e.className »(« getConstructorParameterList(e).replace('"', '\'') »)« ENDFOR»";
            }
            
            @Override
            public void setUp() {
                « IF i != -1 »
                    System.setProperty("« context.modelName ».currentConfiguration", "« i »");
                « ENDIF »
                
                « FOR o : oiProviders.filter[o | o.node instanceof SULMembershipOracle] »
                    ((«o.className») « o.name  »).setUp();
                « ENDFOR »
            }
            
            @Override
            public void dispose() {
                « FOR o : oiProviders.filter[o | o.node instanceof QueryCounterFilter] »
                    ((«o.className») « o.name  »).dispose();
                « ENDFOR »
                « FOR o : oiProviders.filter[o | o.node instanceof SULMembershipOracle] »
                    ((«o.className») « o.name  »).dispose();
                « ENDFOR »
            }
            
        }
        
    '''

    def importsTemplate(List<OracleInformationProvider<? extends Node>> oiProviders) '''
        import « reference(ExperimentOracleInterfaceTemplate) »;
        « FOR p : oiProviders »
            « FOR i : p.experimentImports »
                import « i »;
            « ENDFOR »
        « ENDFOR »
        
        import « reference(BlockInterfaceTemplate) »;
        « FOR p : getCurrentExperimentRuntimeInformationProvider() »
            « FOR i : p.experimentImports »
            	import « i »;
            « ENDFOR »
        « ENDFOR »
    '''

    def oracleDefinitionTemplate(List<OracleInformationProvider<? extends Node>> oiProviders) '''
        // Define the Oracles & Filters
        « FOR p : oiProviders »
            private ExperimentOracle « p.name »;
        « ENDFOR »
    '''

    def blockDefinitionTemplate() '''
        // Define the Blocks
        « FOR p : getCurrentExperimentRuntimeInformationProvider() »
            private Block « p.name »;
        « ENDFOR »
    '''
    
    def oracleInitializationTemplate(List<OracleInformationProvider<? extends Node>> oiProviders) '''
        // Init. the Oracles & Filters
        « FOR p : oiProviders »
            this.« p.name » = new « p.className »(« getConstructorParameterList(p) »);
        « ENDFOR »
    '''
    
    private def String getConstructorParameterList(RuntimeInformationProvider<? extends Node> provider) '''
        « FOR p : provider.getConstructorParameters() SEPARATOR ", " »« formatParameter(p) »« ENDFOR »'''
    
    private def formatParameter(Object parameter) {
        switch (parameter) {
            Node:    getNodeName(parameter)
            String:  '"' + parameter + '"'
            default: parameter.toString()
        }
    }
    
    def blockInitializationTemplate() '''
        // Init. the Blocks
        « FOR p : getCurrentExperimentRuntimeInformationProvider() »
            this.« p.name » = new « p.className »(« getConstructorParameterList(p) »);
        « ENDFOR »
    '''
    
    def callTableTeamplate() '''
        // Define the 'calltable'
        « FOR p : getCurrentExperimentRuntimeInformationProvider() »
            « FOR s : p.successors as List<Pair<String, Node>> »
                « val successorName = getNodeName(s.value) »
                ((« p.className ») « p.name »).set« s.key.toFirstUpper »Successor(« successorName »);
            « ENDFOR »
        « ENDFOR »
    '''

    def getCurrentExperimentRuntimeInformationProvider() {
        val currentRuntimeInforamtionProviders = newHashSet()
        
        currentConfiguration.nodes.forEach[node | 
            val provider = context.getProviders(node, ExperimentRuntimeInformationProvider)
            if (provider !== null) {
                currentRuntimeInforamtionProviders += provider
            }
        ]
        
        return currentRuntimeInforamtionProviders
    }
    
    def getNodeName(Node node) {
        val realNode = if (node.isComplexNode) { currentConfiguration.getNode(node as Container) }
                       else                    { node }
                            
        val nodeInformationProvider = context.getProvider(realNode, RuntimeInformationProvider)                
        
        if (nodeInformationProvider === null) {
            println("No Runtime Information for " + realNode + " (" + node + ")")
            return ""
        } else {
            return nodeInformationProvider.name
        }
    }

}
