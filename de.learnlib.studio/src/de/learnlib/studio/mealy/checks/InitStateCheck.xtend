package de.learnlib.studio.mealy.checks

import de.learnlib.studio.mealy.mcam.modules.checks.MealyCheck
import de.learnlib.studio.mealy.mealy.Mealy


class InitStateCheck extends MealyCheck {

	override check(Mealy model) {
		val initStates = model.mealyStates.filter[s | s.isInit]
		val amountOfInitStates = initStates.size
		
		if (amountOfInitStates == 0) {
			addError(model, "Every Mealy Machine needs one initial state (found none)!")
		} else if (amountOfInitStates > 1) {
			initStates.forEach[s | 
				addError(s, "Every Mealy Machine has just one initial state (found " + amountOfInitStates + ")!")
			]
		}
	}

}
