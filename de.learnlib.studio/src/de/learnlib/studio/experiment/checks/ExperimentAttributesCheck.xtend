package de.learnlib.studio.experiment.checks

import de.learnlib.studio.utils.Checker
import de.learnlib.studio.experiment.experiment.Experiment
import de.learnlib.studio.experiment.mcam.modules.checks.ExperimentCheck


class ExperimentAttributesCheck extends ExperimentCheck {
	
	static val NAME_PATTERN    = "[a-zA-Z0-9][a-zA-Z0-9_]*"
	static val PACKAGE_PATTERN = "[a-zA-Z0-9][a-zA-Z0-9_.]*"
	
	
	override check(Experiment model) {
		val checker = new Checker<Experiment>(this, model)
                            
        checker.addStringChecksFor([name])
                            .notNullOrEmpty()
                            .shouldFollowRegexPattern(NAME_PATTERN)
                            
        checker.addStringChecksFor([package])
                            .notNullOrEmpty()
                            .shouldFollowRegexPattern(PACKAGE_PATTERN)            
                            
        checker.check()
	}
	
}
