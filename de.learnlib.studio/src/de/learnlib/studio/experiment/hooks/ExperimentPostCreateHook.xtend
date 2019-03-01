package de.learnlib.studio.experiment.hooks

import de.jabc.cinco.meta.runtime.hook.CincoPostCreateHook
import de.learnlib.studio.experiment.experiment.Experiment

class ExperimentPostCreateHook extends CincoPostCreateHook<Experiment> {
    
    override postCreate(Experiment experiment) {
        experiment.newStart(50, 50)
    }
    
}