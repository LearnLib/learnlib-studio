package de.learnlib.studio.tracer.views

import java.io.BufferedReader
import java.io.IOException
import java.io.InputStreamReader
import java.util.Observable
import java.util.logging.Level
import java.util.logging.Logger
import org.eclipse.core.runtime.IPath
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.core.runtime.Status
import org.eclipse.core.runtime.jobs.IJobFunction
import de.learnlib.studio.tracer.views.TracerView
import de.learnlib.studio.tracer.views.TracerView.TracerEvent


class RunExperimentJobFunction extends Observable implements IJobFunction {
    
    static val LOGGER = Logger.getLogger(TracerView.getName())
    
    val IPath path
    val String experimentName
    val boolean singleStep
    val String resumeFile

    new(IPath path, String experimentName) {
        this(path, experimentName, false, "")
    }

    new(IPath path, String experimentName, boolean singleStep) {
        this(path, experimentName, singleStep, "")
    }

    new(IPath path, String experimentName, boolean singleStep, String resumeFile) {
        this.path = path
        this.experimentName = experimentName
        this.singleStep = singleStep
        this.resumeFile = resumeFile
    }

    override run(IProgressMonitor monitor) {
        LOGGER.info("Starting the Experiment process")
        var Object[] updateArgs = #[TracerEvent.EXPERIMENT_STARTED, singleStep]
        setChanged()
        notifyObservers(updateArgs)
        
        try {
            val jarProcessBuilder = new ProcessBuilder("java", "-jar", '''target/«experimentName»-1.0.0-SNAPSHOT-jar-with-dependencies.jar''')
            val commands = jarProcessBuilder.command()
            if (singleStep) {
                commands.add("-s")
            }
            if (!resumeFile.isEmpty()) {
                commands.add("-i")
                commands.add(resumeFile)
            }
            println(jarProcessBuilder.command())
            jarProcessBuilder.directory(path.toFile())
            val process = jarProcessBuilder.start()
            val stdout = process.getInputStream()
            val reader = new BufferedReader(new InputStreamReader(stdout))
            
            var String line
            while ((line = reader.readLine()) !== null) {
                LOGGER.fine(line)
                updateArgs = #[TracerEvent.EXPERIMENT_OUTPUT, line]
                setChanged()
                notifyObservers(updateArgs)
            }
            
            val jarProcessExitStatus = process.waitFor()
            if (jarProcessExitStatus !== 0) {
                System.err.println("Jar Failed!")
                setChanged()
                notifyObservers(TracerEvent.JOB_FAILED)
                return Status.CANCEL_STATUS
            }
        } catch (IOException | InterruptedException e) {
            setChanged()
            notifyObservers(TracerEvent.JOB_FAILED)
            LOGGER.log(Level.SEVERE, "Experiment failed", e)
            return Status.CANCEL_STATUS
        }

        LOGGER.info("\tProcess ended normal")
        return Status.OK_STATUS
    }
}
