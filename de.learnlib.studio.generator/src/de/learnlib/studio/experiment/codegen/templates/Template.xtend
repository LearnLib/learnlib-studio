package de.learnlib.studio.experiment.codegen.templates

import de.learnlib.studio.experiment.experiment.Experiment
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.core.runtime.IPath


interface Template {

	def void generate(Experiment model, IPath targetDir, IProgressMonitor progressMonitor)
	
}
