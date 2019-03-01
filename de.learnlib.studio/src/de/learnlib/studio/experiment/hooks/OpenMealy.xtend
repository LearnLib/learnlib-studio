package de.learnlib.studio.experiment.hooks

import de.jabc.cinco.meta.runtime.action.CincoCustomAction

import de.learnlib.studio.experiment.experiment.MealyMembershipOracle


class OpenMealy extends CincoCustomAction<MealyMembershipOracle> {

    override getName() {
        return "Open Mealy"
    }
    
    override execute(MealyMembershipOracle mealyOracle) {
        val mealy = mealyOracle.mealyReference
        mealy.openEditor()
    }
    
    override hasDoneChanges() {
        false
    }
    
}
