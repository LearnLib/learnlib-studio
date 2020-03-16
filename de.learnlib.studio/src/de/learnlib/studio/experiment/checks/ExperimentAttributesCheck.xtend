package de.learnlib.studio.experiment.checks

import de.learnlib.studio.experiment.experiment.Experiment
import de.learnlib.studio.experiment.mcam.modules.checks.ExperimentCheck

class ExperimentAttributesCheck extends ExperimentCheck {
	
	static val NAME_PATTERN    = "[a-zA-Z0-9][a-zA-Z0-9_]*"
	static val PACKAGE_PATTERN = "[a-zA-Z0-9][a-zA-Z0-9_.]*"
	
	override check(Experiment model) {	
		if (model.name.isNullOrEmpty || !model.name.matches(NAME_PATTERN)) {
			addError(model, '''name has to match «NAME_PATTERN»''')
		}
		
		if (model.package.isNullOrEmpty || !model.package.matches(PACKAGE_PATTERN)) {
			addError(model, '''package has to match «PACKAGE_PATTERN»''')
		}
	}	
}
