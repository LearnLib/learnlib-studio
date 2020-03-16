package de.learnlib.studio.experiment.codegen.templates.blocks.eqoracle

import de.learnlib.studio.experiment.codegen.GeneratorContext
import de.learnlib.studio.experiment.experiment.CompleteEQOracle


class CompleteEqOracleBlockTemplate extends AbstractEqBlockTemplate<CompleteEQOracle> {

    new(GeneratorContext context) {
        super(context, "Complete", "MealyCompleteExplorationEQOracle")
    }

    new(GeneratorContext context, CompleteEQOracle node, int i) {
        super(context, node, i, "Complete", "MealyCompleteExplorationEQOracle")
    }
    
    override protected additionalImportsTemplate() '''
		import de.learnlib.oracle.equivalence.MealyCompleteExplorationEQOracle;		
	'''
				
	override protected createEqOracleTemplate() '''
		return new MealyCompleteExplorationEQOracle<>(oracle.getOracle(), «node.minDepth.toString», «node.maxDepth.toString»);
	'''
}
