package de.learnlib.studio.tracer.views

import java.io.BufferedReader
import java.io.IOException
import java.io.InputStreamReader
import java.util.Observable
import java.util.logging.Level
import java.util.logging.Logger
import java.util.regex.Pattern
import org.eclipse.core.runtime.IPath
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.core.runtime.Status
import org.eclipse.core.runtime.jobs.IJobFunction
import de.learnlib.studio.tracer.views.TracerView
import de.learnlib.studio.tracer.views.TracerView.TracerEvent


class RunMavenJobFunction extends Observable implements IJobFunction {
    
    static val LOGGER = Logger.getLogger(TracerView.getName())
    
    static val PATTERN = Pattern.compile("^.*--- (.*) @ (.*) ---$")
    
    val IPath path


    new(IPath path) {
        this.path = path
    }

    override run(IProgressMonitor monitor) {
        LOGGER.info("Starting Maven")
        
        val os = System.getProperty("os.name")
        val mvnCmd = if (os.toLowerCase.contains("windows")) { "mvnw.cmd"  }
                     else                                    { "./mvnw" }
        
        val fullCmd = path.append(mvnCmd).toFile()
        val mavenProcessBuilder = new ProcessBuilder(fullCmd.absolutePath, "clean", "package")
        mavenProcessBuilder.directory(path.toFile())
        
        try {
            val mavenProcess = mavenProcessBuilder.start()
            val stdout = mavenProcess.getInputStream()
            val reader = new BufferedReader(new InputStreamReader(stdout))
            
            var String line
            while ((line = reader.readLine()) !== null) {
                LOGGER.info(line)
                val m = PATTERN.matcher(line)
                if (m.matches()) {
                    monitor.beginTask('''«m.group(2)» -> «m.group(1)»''', -1)
                }
            }
            
            val mavenExitStatus = mavenProcess.waitFor()
            if (mavenExitStatus !== 0) {
                LOGGER.severe('''Maven failed. Exit status «mavenExitStatus»''')
                setChanged()
                notifyObservers(TracerEvent.JOB_FAILED)
                return Status.CANCEL_STATUS
            }
        } catch (IOException | InterruptedException e) {
            LOGGER.log(Level.SEVERE, "Maven failed", e)
            setChanged()
            notifyObservers(TracerEvent.JOB_FAILED)
            return Status.CANCEL_STATUS
        }

        LOGGER.info("\tMaven finished")
        return Status.OK_STATUS
    }
}
