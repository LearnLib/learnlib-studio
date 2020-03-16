package de.learnlib.studio.experiment.codegen.templates.blocks.eqoracle

import de.learnlib.studio.experiment.codegen.GeneratorContext
import de.learnlib.studio.experiment.experiment.WPMethodEQOracle

class WpMethodEqOracleBlockTemplate extends AbstractEqBlockTemplate<WPMethodEQOracle> {

     new(GeneratorContext context) {
        super(context, "WpMethod", "MealyWpMethodEQOracle")
    }

    new(GeneratorContext context, WPMethodEQOracle node, int i) {
        super(context, node, i,  "WpMethod", "MealyWpMethodEQOracle")
    }
    
    override additionalImportsTemplate() '''
    	import de.learnlib.oracle.equivalence.MealyWpMethodEQOracle;
    '''

	override protected createEqOracleTemplate() '''
		return new MealyWpMethodEQOracle<>(oracle.getOracle(), «node.minDepth», «node.maxDepth»);
	'''	
}
