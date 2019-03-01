package de.learnlib.studio.tracer.views

import java.util.logging.Logger
import org.eclipse.core.runtime.IPath
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.core.runtime.Status
import org.eclipse.core.runtime.jobs.IJobFunction
import de.jabc.cinco.meta.plugin.generator.runtime.registry.GraphModelGeneratorRegistry
import de.learnlib.studio.experiment.experiment.Experiment
import de.learnlib.studio.tracer.views.TracerView


class GenerateCodeJobFunction implements IJobFunction {
    
    static val LOGGER = Logger.getLogger(TracerView.getName())
    
    val Experiment experiment
    val IPath path

    new(Experiment experiment, IPath path) {
        this.experiment = experiment
        this.path = path
    }

    override run(IProgressMonitor monitor) {
        LOGGER.info("Generating Code")
        val g = GraphModelGeneratorRegistry.INSTANCE.getAllGenerators(Experiment).get(0)
        val generator = g.getGenerator()
        generator.generate(experiment, path, monitor)
        LOGGER.info("\tCode generated")
        return Status.OK_STATUS
    }
}
