package de.learnlib.studio.mealy.checks

import de.learnlib.studio.mealy.mcam.modules.checks.MealyCheck
import de.learnlib.studio.mealy.mealy.Mealy
import de.learnlib.studio.mealy.mealy.MealyState
import de.learnlib.studio.mealy.mealy.MealyTransition


class DeterministicCheck extends MealyCheck {

	override check(Mealy model) {
		val alphabet =  model.mealyStates.map[getOutgoing(MealyTransition)]
		                                 .flatten
		                                 .map[input]
		                                 .toSet
		
		model.mealyStates.forEach[s |
			alphabet.forEach[i | 
				val x = countTransitionsWithInput(s, i);
				if (x == 0) {
					addError(s, "The Mealy State misses the input '" + i + "'!")
				} else if (x > 1) {
					addError(s, "The Mealy State has the input '" + i + "' multiple times!")
				}
			]
		]
		
	}

	def private countTransitionsWithInput(MealyState state, String input) {
		state.getOutgoing(MealyTransition).filter[t | t.input == input]
		                                  .size
	}

}
