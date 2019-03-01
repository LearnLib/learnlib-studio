package de.learnlib.studio.experiment.codegen.templates.blocks.learner

import de.learnlib.studio.experiment.codegen.GeneratorContext
import de.learnlib.studio.experiment.experiment.LStarAlgorithm

class LStarBlockTemplate extends AbstractLearnerBlockTemplate<LStarAlgorithm> {
	
	new(GeneratorContext context) {
        this(context, null, -1)
    }
	
	new(GeneratorContext context, LStarAlgorithm learner, int i) {
		super(context, learner, i , "lStarLearner", "learnlib-lstar", "de.learnlib.algorithms.lstar.mealy", "ExtensibleLStarMealy", "ExtensibleLStarMealyBuilder", "de.learnlib.algorithms.lstar", "AutomatonLStarState")
	}
	
}
