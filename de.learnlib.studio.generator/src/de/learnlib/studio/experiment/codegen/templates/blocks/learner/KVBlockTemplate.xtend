package de.learnlib.studio.experiment.codegen.templates.blocks.learner

import de.learnlib.studio.experiment.codegen.GeneratorContext
import de.learnlib.studio.experiment.experiment.KVAlgorithm


class KVBlockTemplate extends AbstractLearnerBlockTemplate<KVAlgorithm> {
	
	new(GeneratorContext context) {
        this(context, null, -1)
    }
	
	new(GeneratorContext context, KVAlgorithm learner, int i) {
		super(context, learner, i , "lStarLearner", "learnlib-lstar", "de.learnlib.algorithms.kv.mealy", "KearnsVaziraniMealy", "KearnsVaziraniMealyBuilder", "de.learnlib.algorithms.kv.mealy", "KearnsVaziraniMealyState")
	}
	
}
