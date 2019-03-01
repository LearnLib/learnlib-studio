package de.learnlib.studio.tracer.views

import java.util.Observable
import java.util.Observer
import java.util.logging.Logger
import java.util.regex.Pattern
import java.util.Arrays

import org.eclipse.core.resources.IProject
import org.eclipse.core.runtime.FileLocator
import org.eclipse.core.runtime.OperationCanceledException
import org.eclipse.core.runtime.Path
import org.eclipse.core.runtime.jobs.Job
import org.eclipse.core.runtime.jobs.JobGroup;
import org.eclipse.jface.action.Action
import org.eclipse.jface.action.IAction
import org.eclipse.jface.action.IMenuManager
import org.eclipse.jface.action.IToolBarManager
import org.eclipse.jface.action.Separator
import org.eclipse.jface.preference.BooleanPropertyAction
import org.eclipse.jface.preference.PreferenceStore
import org.eclipse.jface.resource.ImageDescriptor
import org.eclipse.swt.SWT
import org.eclipse.swt.layout.GridData
import org.eclipse.swt.layout.GridLayout
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Display
import org.eclipse.swt.widgets.Label
import org.eclipse.swt.widgets.List
import org.eclipse.ui.part.ViewPart
import org.osgi.framework.FrameworkUtil
import de.jabc.cinco.meta.runtime.xapi.WorkbenchExtension
import org.eclipse.graphiti.util.IColorConstant
import graphmodel.Node
import de.jabc.cinco.meta.core.ge.style.generator.runtime.highlight.Highlight

import de.learnlib.studio.experiment.experiment.WordEdge
import de.learnlib.studio.experiment.experiment.ModelEdge
import de.learnlib.studio.tracer.outputparser.OutputParser
import de.learnlib.studio.tracer.outputparser.StepFinishedOutputParser
import de.learnlib.studio.tracer.outputparser.HypothesisOutputParser
import de.learnlib.studio.tracer.outputparser.InternalDataOutputParser
import de.learnlib.studio.tracer.utils.TracerUtils
import de.learnlib.studio.experiment.experiment.Experiment
import org.eclipse.core.runtime.IPath

class TracerView extends ViewPart implements Observer {

    /**
     * The ID of the view as specified by the extension.
     */
    public static val ID = "de.learnlib.studio.tracer.view.views.TracerView"
    
    public static val LOGGER = Logger.getLogger(TracerView.getName())

    static val WORKBENCH_EXTENSION = new WorkbenchExtension()
    
    static val PATH_PATTERN         = Pattern.compile("^ --> (.*)$")
    static val END_PATTERN          = Pattern.compile("^Experiment finished.$")
    static val MODEL_EXPORT_PATTERN = Pattern.compile("^Exporting Model$")
    static val DATA_EXPORT_PATTERN  = Pattern.compile("^Exporting internal data$")

    static enum TracerStatus {
        STOPPED,
        RUNNING,
        STEPPING,
        PAUSED
    }

    static enum TracerEvent {
        EXPERIMENT_STARTED,
        EXPERIMENT_OUTPUT,
        JOB_FAILED
    }

    val bundle = FrameworkUtil.getBundle(this.getClass())
    
    val PreferenceStore preferences
    
    var Action actionRun
    var Action actionStep
    var Action actionStop
    
    val Highlight highlight
    var Node      currentNode
    
    var IAction actionRunWithHighlights
    
    var Label labelStatus
    var List log
    
    var IProject project
    var JobGroup jobGroup
    var TracerStatus status
    var String resumeFileName
    
    var OutputParser outputParser

    var Experiment experiment

    new() {
        this.preferences = new PreferenceStore()
        this.preferences.setDefault("withDelay", true)
        
        highlight = new Highlight();
        highlight.setBackgroundColor(IColorConstant.ORANGE);
        highlight.setForegroundColor(IColorConstant.BLACK);
    }
    
    override createPartControl(Composite parent) {
		parent.setLayout(new GridLayout(1, false))
	   
		labelStatus = new Label(parent, SWT.LEFT);
		labelStatus.setLayoutData(new GridData(SWT.FILL, SWT.TOP, true, false))
		labelStatus.setText("Not running")
		
		log = new List(parent, SWT.BORDER.bitwiseOr(SWT.MULTI).bitwiseOr(SWT.V_SCROLL))
        log.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, true))
        
        makeActions()
        contributeToActionBars()
        
        setStatus(TracerStatus.STOPPED)
	}

    def setStatusText(String text) {
        Display.getDefault().asyncExec(new Runnable() {
            override run() {
                labelStatus.setText(text)
            }
		})
    }

    def runWithHighlights() {
        return actionRunWithHighlights.isChecked()
    }

    private def contributeToActionBars() {
        val bars = getViewSite().getActionBars()
        fillLocalPullDown(bars.getMenuManager())
        fillLocalToolBar(bars.getToolBarManager())
    }

    private def makeActions() {
        makeRunAction()
        makeStepAction()
        makeStopAction()
    }
    
    private def fillLocalToolBar(IToolBarManager manager) {
        manager.add(actionRun)
        manager.add(actionStep)
        manager.add(actionStop)
    }
    
    private def fillLocalPullDown(IMenuManager manager) {
        manager.add(actionRun)
        manager.add(actionStep)
        manager.add(actionStop)
        manager.add(new Separator())
    
        actionRunWithHighlights = new BooleanPropertyAction("Run With Highlighting", preferences, "withHighlights")
        manager.add(actionRunWithHighlights)
    }
	
	private def executeExperiment(boolean singleStep) {
	    experiment = TracerUtils.getCurrentExperiment();
        if (experiment === null) {
            // TODO: Error handling
            return;
        }
        
	    project = TracerUtils.getProject(experiment)
        val srcgenPath = project.location.append("src-gen")
	    
	    val runnable = if (status == TracerStatus.STOPPED) {
                            createAndBuildNewExperimentThread(experiment, srcgenPath, singleStep)
                	   } else {
                            createResumeExperimentThread(experiment, srcgenPath, singleStep)
                	   }
	    
        try {
            runnable.start()
        } catch (OperationCanceledException e) {
            // TODO Auto-generated catch block
            e.printStackTrace()
        } catch (InterruptedException e) {
            // TODO Auto-generated catch block
            e.printStackTrace()
        }
    }
	
	private def createAndBuildNewExperimentThread(Experiment experiment, IPath srcgenPath, boolean singleStep) {
	    currentNode = experiment.starts.get(0)
            
        jobGroup = new JobGroup("Experiment Setup", 1, 3);
        
        val generateCodeJobFunction = new GenerateCodeJobFunction(experiment, srcgenPath)
        val generateCodeJob = Job.create("Generating code", generateCodeJobFunction)
        generateCodeJob.setJobGroup(jobGroup)
        
        val runMavenJobFunction = new RunMavenJobFunction(srcgenPath)
        runMavenJobFunction.addObserver(TracerView.this)
        val runMavenJob = Job.create("Running Maven build", runMavenJobFunction)
        runMavenJob.setJobGroup(jobGroup)
        
        val runExperimentJobFunction = new RunExperimentJobFunction(srcgenPath, experiment.name, singleStep)
        runExperimentJobFunction.addObserver(TracerView.this)
        val runExperimentJob = Job.create("Running the Experiment", runExperimentJobFunction)
        runExperimentJob.setJobGroup(jobGroup)
        
        return new Thread() {
            
            override run() {
                generateCodeJob.schedule()
                runMavenJob.schedule()
                runExperimentJob.schedule()
                jobGroup.join(0, null)
            }

        }
	}
	
	private def createResumeExperimentThread(Experiment experiment, IPath srcgenPath, boolean singleStep) {
	    jobGroup = new JobGroup("Experiment Setup", 1, 1);
            
        val runExperimentJobFunction = new RunExperimentJobFunction(srcgenPath, experiment.name, singleStep, resumeFileName)
        runExperimentJobFunction.addObserver(TracerView.this)
        val runExperimentJob = Job.create("Run the experiment", runExperimentJobFunction)
        runExperimentJob.setJobGroup(jobGroup)
        
        return new Thread() {
            
            override run() {
                runExperimentJob.schedule()
                jobGroup.join(0, null)
            }

        }
	}

    private def makeRunAction() {
		actionRun = new Action() {
            override run() {
				executeExperiment(false)
			}
		}
		actionRun.setText("Run")
		actionRun.setToolTipText("Execute the Learn Experiment")
		
		val iconURL = FileLocator.find(bundle, new Path("icons/run_obj.gif"), null)
		actionRun.setImageDescriptor(ImageDescriptor.createFromURL(iconURL))
	}

    private def makeStepAction() {
		actionStep = new Action() {
            override run() {
				executeExperiment(true)
			}
		}
		actionStep.setText("Step");
		actionStep.setToolTipText("Make one Step in the Learn Experiment");
		
		val iconURL = FileLocator.find(bundle, new Path("icons/stepinto_co.gif"), null);
		actionStep.setImageDescriptor(ImageDescriptor.createFromURL(iconURL));
	}

    private def makeStopAction() {
		actionStop = new Action() {
            override run() {
				jobGroup.cancel()
				setStatus(TracerStatus.STOPPED)
			}
		}
		actionStop.setText("Stop");
		actionStop.setToolTipText("Abort the execution of the Learn Experiment");
		
		val iconURL = FileLocator.find(bundle, new Path("icons/terminatedlaunch_obj.gif"), null);
		actionStop.setImageDescriptor(ImageDescriptor.createFromURL(iconURL));
		
		actionStop.setEnabled(false);
	}

	override setFocus() {
	}

	override update(Observable o, Object arg) {
		var TracerEvent event
		var Object[]    args
		if (arg.getClass().isArray()) {
        	args  = arg as Object[]
			event = args.get(0) as TracerEvent
            System.out.println("Received update " + Arrays.toString(args))
        } else {
			args  = #[]
			event = arg as TracerEvent
			System.out.println("Received update " + arg)
		}
		
		switch event {
    	    case EXPERIMENT_STARTED: processExperimentStarted(Boolean.parseBoolean(args.get(1).toString))
    		case EXPERIMENT_OUTPUT:  processExperimentOutput(args.get(1).toString())
    		case JOB_FAILED:         processJobFailed()
		}
	}
	
	private def processExperimentStarted(boolean singleStep) {
	    if (status == TracerStatus.STOPPED) {
            Display.getDefault().syncExec(new Runnable() {
                override run() {
                    log.setItems(#[])
                }
            })
            highlight.add(currentNode);
            highlight.on();
        }
        
        if (singleStep) {
            setStatus(TracerStatus.STEPPING)
        } else {
            setStatus(TracerStatus.RUNNING)
        }
	}
	
	private def processExperimentOutput(String output) {
        addLogEntry(output)
        if (outputParser !== null && !output.isNullOrEmpty) {
            outputParser.read(output)
        }
        
        var m = PATH_PATTERN.matcher(output);
        if (m.matches()) {
            outputParser = new StepFinishedOutputParser(m.group(1))
        }
        
        m = MODEL_EXPORT_PATTERN.matcher(output)
        if (m.matches()) {
            val modelName = experiment.name + "_model"
            outputParser = new HypothesisOutputParser("/" + project.name + "/results", modelName);
        }
        
        m = DATA_EXPORT_PATTERN.matcher(output)
        if (m.matches()) {
            outputParser = new InternalDataOutputParser(project);
        }
        
        if (output.isEmpty) {
            switch outputParser {
                HypothesisOutputParser:   outputParser.parse()
                InternalDataOutputParser: outputParser.parse()
                
                StepFinishedOutputParser: {
                    outputParser.parse()
                    hightlighNextBlock(outputParser.pathToFollow)
                    resumeFileName = outputParser.resumeFileName
            
                    System.out.println(outputParser.pathToFollow)
                    System.out.println(outputParser.resumeFileName)
            
                    if (this.status == TracerStatus.STEPPING) {
                        setStatus(TracerStatus.PAUSED)
                    }
                }
            }
            outputParser = null
        }
        
        m = END_PATTERN.matcher(output);
        if (m.matches()) {
            setStatus(TracerStatus.STOPPED)
            highlight.off()
            highlight.remove(currentNode);
        }
	}
	
	private def processJobFailed() {
	    jobGroup.cancel()
        setStatus(TracerStatus.STOPPED)
        WORKBENCH_EXTENSION.showErrorDialog("Job Failed", "The execution failed and was stopped.")
	}

    private def setStatus(TracerStatus status) {
        System.out.println("Setting status to " + status);
		this.status = status;
		
		switch status {
    		case STOPPED: {
    			actionRun.setEnabled(true)
    			actionStep.setEnabled(true)
    			actionStop.setEnabled(false)
    			setStatusText("Stopped")
    		}
    
    		case RUNNING: {
    			actionRun.setEnabled(false)
    			actionStep.setEnabled(false)
    			actionStop.setEnabled(true)
    			setStatusText("Running...")
    		}
    
    		case STEPPING: {
    			actionRun.setEnabled(false)
    			actionStep.setEnabled(false)
    			actionStop.setEnabled(true)
    			setStatusText("Doing one step")
    		}
    			
    		case PAUSED: {
    			actionRun.setEnabled(true)
    			actionStep.setEnabled(true)
    			actionStop.setEnabled(false)
    			setStatusText("Paused")
    		}
		}
	}

    private def addLogEntry(String text) {
		Display.getDefault().syncExec(new Runnable() {
            override run() {
		    	log.add(text)
		    	log.setSelection(log.getItemCount() - 1)
		    }
		})
	}
	
	private def hightlighNextBlock(String pathToFollow) {
        if (runWithHighlights) {
            Thread.sleep(500)
        
            highlight.off();
            highlight.remove(currentNode);
            
            if (currentNode.successors.size > 0) {
                if (currentNode.successors.size == 1) {
                    currentNode = currentNode.successors.get(0)
                } else {
                    if (pathToFollow == "word") {
                        currentNode = currentNode.getOutgoing(WordEdge).get(0).targetElement
                    } else {
                        currentNode = currentNode.getOutgoing(ModelEdge).get(0).targetElement
                    }
                }
            
                highlight.add(currentNode);
                highlight.on();    
            }
        }
	}
	
}
