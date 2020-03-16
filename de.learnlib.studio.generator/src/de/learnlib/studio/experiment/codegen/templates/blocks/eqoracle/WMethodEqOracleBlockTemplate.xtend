package de.learnlib.studio.experiment.codegen.templates.blocks.eqoracle

import de.learnlib.studio.experiment.experiment.WMethodEQOracle
import de.learnlib.studio.experiment.codegen.GeneratorContext

class WMethodEqOracleBlockTemplate extends AbstractEqBlockTemplate<WMethodEQOracle> {

     new(GeneratorContext context) {
        super(context, "WMethod", "MealyWMethodEQOracle")
    }

    new(GeneratorContext context, WMethodEQOracle node, int i) {
        super(context, node, i, "WMethod", "MealyWMethodEQOracle")
    }
        
    override additionalImportsTemplate() '''
    	import de.learnlib.oracle.equivalence.MealyWMethodEQOracle;
    '''
				
	override protected createEqOracleTemplate() '''
		return new MealyWMethodEQOracle<>(oracle.getOracle(), «node.maxDepth»);
	'''
}
