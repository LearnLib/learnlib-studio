package de.learnlib.studio.tracer.utils

import java.util.logging.Logger

import org.eclipse.core.resources.IProject
import de.learnlib.studio.experiment.experiment.Experiment
import de.jabc.cinco.meta.runtime.xapi.WorkspaceExtension
import de.jabc.cinco.meta.runtime.xapi.WorkbenchExtension
import de.learnlib.studio.tracer.views.TracerView


class TracerUtils {
    
    static val WORKBENCH_EXTENSION = new WorkbenchExtension()
    static val WORKSPACE_EXTENSION = new WorkspaceExtension()
    
    public static val LOGGER = Logger.getLogger(TracerView.getName())
    
    def static getCurrentExperiment() {
        val model = WORKBENCH_EXTENSION.getActiveGraphModel()
    
        LOGGER.fine("Found graph model: " + model + " of type " + model.getClass())
        if(model instanceof Experiment) {
            LOGGER.fine("Found experiment: " + model)
            
            var container = TracerUtils.getExperimentFile(model).parent
            while (!(container instanceof IProject)) {
                container = container.parent
            }
            return model as Experiment;
        }
    
        return null
    }
    
    def static getProject(Experiment experiment) {
        var container = TracerUtils.getExperimentFile(experiment).parent
            while (!(container instanceof IProject)) {
                container = container.parent
            }
            return container as IProject
    }
    
    def static getExperimentFile(Experiment experiment){
        return WORKSPACE_EXTENSION.getFile(experiment)
    }
    
}
