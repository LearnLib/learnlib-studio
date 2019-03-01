package de.learnlib.studio.experiment.codegen.templates.blocks;

import graphmodel.Container
import graphmodel.Edge
import graphmodel.Node

import de.learnlib.studio.experiment.codegen.GeneratorContext;
import de.learnlib.studio.experiment.codegen.templates.AbstractSourceTemplate
import de.learnlib.studio.experiment.codegen.templates.NodeRelatedTemplate
import de.learnlib.studio.experiment.codegen.providers.ExperimentRuntimeInformationProvider
import de.learnlib.studio.experiment.experiment.ControlFlow

import static extension de.learnlib.studio.experiment.utils.ExperimentExtensions.isChildOfAComplexNode


abstract class AbstractBlockTemplate<N extends Node>
			extends AbstractSourceTemplate
			implements NodeRelatedTemplate<N>, ExperimentRuntimeInformationProvider<N> {

	val N   node
	val int i

    new(GeneratorContext context, String subPackage, String name) {
        this(context, null, -1, subPackage, name)
    }

	new(GeneratorContext context, N node, int i, String subPackage, String name) {
		super(context, subPackage, name + "Block")
		this.i = i + 1
		this.node = node
	}

	override getExperimentImports() {
		return #[fullName]
	}
	
    override getConstructorParameters() {
        return #[name]
    }
	
	override getName() {
		return super.getName() + i
	}
	
	override getSuccessors() {
		var successors = getOutgoing(ControlFlow)
		if (!successors.nullOrEmpty) {
            return #["default" -> successors.head.targetElement]		    
		} else {
            return #[]
		}
	}
	
    override getNode() {
        return node
    }
    
    def getI() {
        return i
    }
    
    def <T extends Edge> getOutgoing(Class<T> clazz) {
        if (node.isChildOfAComplexNode) {
            val container = node.container as Container
            return container.getOutgoing(clazz)
        } else {
            return node.getOutgoing(clazz)
        }
    }
	
}
