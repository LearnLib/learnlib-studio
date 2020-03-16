package de.learnlib.studio.experiment.hooks

import de.jabc.cinco.meta.runtime.action.CincoCustomAction

import de.learnlib.studio.experiment.experiment.MealyFileAutomaton

class OpenMealy extends CincoCustomAction<MealyFileAutomaton> {

    override getName() {
        return "Open Mealy"
    }
    
    override execute(MealyFileAutomaton mealySUL) {
        mealySUL.automaton.openEditor
    }
    
    override hasDoneChanges() {
        false
    }
    
}
