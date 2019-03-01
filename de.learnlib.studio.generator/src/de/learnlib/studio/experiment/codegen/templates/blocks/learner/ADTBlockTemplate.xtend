package de.learnlib.studio.experiment.codegen.templates.blocks.learner

import de.learnlib.studio.experiment.codegen.GeneratorContext
import de.learnlib.studio.experiment.experiment.ADTAlgorithm


class ADTBlockTemplate extends AbstractLearnerBlockTemplate<ADTAlgorithm> {
	
	new(GeneratorContext context) {
        this(context, null, -1)
    }
	
	new(GeneratorContext context, ADTAlgorithm learner, int i) {
		super(context, learner, i , "adtLearner", "learnlib-adt", "de.learnlib.algorithms.adt.learner", "ADTLearner", "ADTLearnerBuilder", " de.learnlib.algorithms.adt.learner", "ADTLearnerState")
	}
	
}
