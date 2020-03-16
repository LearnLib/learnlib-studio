package de.learnlib.studio.experiment.codegen.templates.blocks.eqoracle

import de.learnlib.studio.experiment.experiment.RandomWordEQOracle
import de.learnlib.studio.experiment.codegen.GeneratorContext

class RandomWordEqOracleBlockTemplate extends AbstractEqBlockTemplate<RandomWordEQOracle> {

     new(GeneratorContext context) {
        super(context, "RandomWord", "MealyRandomWordsEQOracle")
    }

    new(GeneratorContext context, RandomWordEQOracle node, int i) {
        super(context, node, i, "RandomWord", "MealyRandomWordsEQOracle")
    }
        
    override protected additionalImportsTemplate() '''
		import de.learnlib.oracle.equivalence.MealyRandomWordsEQOracle;		
	'''
				
	override protected createEqOracleTemplate() '''
		return new MealyRandomWordsEQOracle<>(oracle.getOracle(), «node.minLength.toString», «node.maxLength.toString», «node.amount.toString», new Random(«node.seed.toString»));
	'''	
}
