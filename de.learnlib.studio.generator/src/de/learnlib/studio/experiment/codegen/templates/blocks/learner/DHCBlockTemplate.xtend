package de.learnlib.studio.experiment.codegen.templates.blocks.learner

import de.learnlib.studio.experiment.codegen.GeneratorContext
import de.learnlib.studio.experiment.experiment.DHCAlgorithm


class DHCBlockTemplate extends AbstractLearnerBlockTemplate<DHCAlgorithm> {
	
	new(GeneratorContext context) {
	    this(context, null, -1)
	}
	
	new(GeneratorContext context, DHCAlgorithm learner, int i) {
		super(context, learner, i , "dhcLearner", "learnlib-dhc", "de.learnlib.algorithms.dhc.mealy", "MealyDHC", "MealyDHCBuilder", "de.learnlib.algorithms.dhc.mealy", "MealyDHCState")
	}
	
}
