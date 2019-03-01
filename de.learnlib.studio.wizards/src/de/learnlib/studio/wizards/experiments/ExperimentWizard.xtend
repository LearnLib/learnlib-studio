package de.learnlib.studio.wizards.experiments

import java.lang.reflect.InvocationTargetException

import org.eclipse.jface.viewers.IStructuredSelection
import org.eclipse.jface.wizard.Wizard
import org.eclipse.ui.INewWizard
import org.eclipse.ui.IWorkbench
import org.eclipse.jface.dialogs.MessageDialog
import org.eclipse.jface.viewers.ISelection
import org.eclipse.core.runtime.CoreException
import org.eclipse.jface.operation.IRunnableWithProgress
import org.eclipse.core.runtime.IProgressMonitor

import de.jabc.cinco.meta.runtime.xapi.WorkbenchExtension
import de.jabc.cinco.meta.core.ge.style.generator.runtime.layout.Layouter_C_LEFT

import de.learnlib.studio.experiment.factory.ExperimentFactory


class ExperimentWizard extends Wizard implements INewWizard {

	static val WorkbenchExtension workbenchExtension = new WorkbenchExtension()
	static val experimentFactory = ExperimentFactory.eINSTANCE
    	


    ExperimentWizardFilePage      filePage
    ExperimentWizardAlgorithmPage algorithmPage
    ExperimentWizardEQOraclePage  eqOraclePage
    ExperimentWizardMQOraclePage  mqOraclePage
    
    ISelection selection


    /** 
     * Constructor for SampleNewWizard.
     */
    new() {
        super()
        setNeedsProgressMonitor(true)
        helpAvailable = false
        windowTitle = "Create a new Experiment with guidance"
    }

    /** 
     * Adding the page to the wizard.
     */
    override void addPages() {
        filePage = new ExperimentWizardFilePage(selection)
        addPage(filePage)
        
        algorithmPage = new ExperimentWizardAlgorithmPage()
        addPage(algorithmPage)
        
        eqOraclePage = new ExperimentWizardEQOraclePage()
        addPage(eqOraclePage)
        
        mqOraclePage = new ExperimentWizardMQOraclePage()
        addPage(mqOraclePage)
    }

    /** 
     * This method is called when 'Finish' button is pressed in
     * the wizard. We will create an operation and run it
     * using wizard as execution context.
     */
    override boolean performFinish() {
        val String containerName = filePage.getContainerName()
        val String fileName = filePage.getFileName()
        var IRunnableWithProgress op = ([IProgressMonitor monitor|
            try {
                doFinish(containerName, fileName, monitor)
            } catch(CoreException e) {
                throw new InvocationTargetException(e)
            } finally {
                monitor.done()
            }
        ] as IRunnableWithProgress)
        try {
            getContainer().run(false, false, op)
        } catch(InterruptedException e) {
            return false
        } catch(InvocationTargetException e) {
            var Throwable realException = e.getTargetException()
            MessageDialog::openError(getShell(), "Error", realException.getMessage())
            return false
        }

        return true
    }

    /** 
     * The worker method. It will find the container, create the
     * file if missing or just replace its contents, and open
     * the editor on the newly created file.
     */
    def private void doFinish(String containerName, String fileName, IProgressMonitor monitor) throws CoreException {
    	monitor.beginTask("Creating Experiment", 2)
    	
    	val newExperiment = experimentFactory.createExperiment(containerName, sanitizeFileName(fileName))
    	newExperiment.name    = "NewExperiment"
    	newExperiment.package = "com.example.experiment"
    	
    	val startNode     = newExperiment.starts.get(0)
    	val cacheNode     = newExperiment.newCacheFilter(450, 200)
		val mqNode        = mqOraclePage.createExperimentNode(newExperiment)
    	val algorithmNode = algorithmPage.createExperimentNode(newExperiment)
    	val eqNode        = eqOraclePage.createExperimentNode(newExperiment)
		val showNode      = newExperiment.newShowModel(100, 500)
		newExperiment.save()
		
		startNode.moveTo(newExperiment, 109, 50)
		startNode.newStartEdge(algorithmNode)
		
		algorithmNode.newModelEdge(eqNode)
		algorithmNode.newQueryEdge(cacheNode)
		
		cacheNode.newQueryEdge(mqNode)
		
		eqNode.newModelEdge(showNode)
		val wordEdge = eqNode.newWordEdge(algorithmNode)		
		eqNode.newQueryEdge(cacheNode)
		newExperiment.save()

        // FIXME: Calling the Layout leads to some crazy thread race conditions...
        //new Layouter_C_LEFT().apply(wordEdge)
		
    	monitor.worked(1)
        monitor.setTaskName("Opening file for editing...")
        
        workbenchExtension.openEditor(newExperiment)
		
		monitor.worked(1) 
	}
	
	private def sanitizeFileName(String fileName) {
        if (fileName.endsWith(".ll")) {
            return fileName.substring(0, fileName.length - 3)
        } else {
            return fileName
        }
	}

    /** 
     * We will initialize file contents with a sample text.
     */
//    def private InputStream openContentStream() {
//        var String contents = "This is the initial file contents for *.mpe file that should be word-sorted in the Preview page of the multi-page editor"
//        return new ByteArrayInputStream(contents.getBytes())
//    }

//    def private void throwCoreException(String message) throws CoreException {
//        var IStatus status = new Status(IStatus::ERROR, "info.scce.cinco.product.learnlibstudio.wizards",
//            IStatus::OK, message, null)
//        throw new CoreException(status)
//    }

    /** 
     * We will accept the selection in the workbench to see if
     * we can initialize from it.
     * @see IWorkbenchWizard#init(IWorkbench, IStructuredSelection)
     */
    override void init(IWorkbench workbench, IStructuredSelection selection) {
        this.selection = selection
    }

}
        