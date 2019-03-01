package de.learnlib.studio.experiment.codegen.templates.blocks.learner

import de.learnlib.studio.experiment.codegen.GeneratorContext
import de.learnlib.studio.experiment.experiment.DTAlgorithm


class DTBlockTemplate extends AbstractLearnerBlockTemplate<DTAlgorithm> {
	
	new(GeneratorContext context) {
        this(context, null, -1)
    }
	
	new(GeneratorContext context, DTAlgorithm learner, int i) {
		super(context, learner, i, "ddtLearner", "learnlib-dt", "de.learnlib.algorithms.discriminationtree.mealy", "DTLearnerMealy", "DTLearnerMealyBuilder", "de.learnlib.algorithms.lstar", "AutomatonLStarState")
	}
	
}
