package de.learnlib.studio.experiment.codegen.templates

import org.eclipse.core.resources.IFolder
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.core.runtime.IPath
import org.eclipse.core.runtime.IProgressMonitor

import de.jabc.cinco.meta.core.utils.EclipseFileUtils

import de.learnlib.studio.experiment.experiment.Experiment
import de.learnlib.studio.experiment.codegen.GeneratorContext


abstract class AbstractTemplateImpl implements Template {
	
	protected var String path
	protected var String fileName
	
	protected var GeneratorContext context
	
	new(GeneratorContext context) {
		this.path = "/"
		this.context  = context
	}
	
	new(GeneratorContext context, String path, String fileName) {
		this.path     = path
		this.fileName = fileName
		this.context  = context
	}
	
	override generate(Experiment model, IPath targetDir, IProgressMonitor progressMonitor) {
		// look for the targetDir and make sure it exists
		val actualTargetDir = ResourcesPlugin.workspace.root.getContainerForLocation(targetDir.append(path)) as IFolder
		if (!actualTargetDir.exists) {
			EclipseFileUtils.mkdirs(actualTargetDir, progressMonitor)
		}
		
		// generate code and write it out
		val targetFile = ResourcesPlugin.workspace.root.getFileForLocation(targetDir.append(path).append(fileName))
		val code = template()
		EclipseFileUtils.writeToFile(targetFile, code)
	}
	
	def String template()
	
}
