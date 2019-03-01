package de.learnlib.studio.wizards.mealy.importWizards

import java.io.File
import java.io.FileInputStream
import java.io.FileNotFoundException
import java.io.InputStream
import org.eclipse.core.resources.IFile
import org.eclipse.core.runtime.IPath
import org.eclipse.core.runtime.IStatus
import org.eclipse.core.runtime.Path
import org.eclipse.core.runtime.Status
import org.eclipse.jface.preference.FileFieldEditor
import org.eclipse.jface.viewers.IStructuredSelection
import org.eclipse.swt.SWT
import org.eclipse.swt.events.ModifyEvent
import org.eclipse.swt.events.ModifyListener
import org.eclipse.swt.layout.GridData
import org.eclipse.swt.layout.GridLayout
import org.eclipse.swt.widgets.Composite
import org.eclipse.ui.dialogs.WizardNewFileCreationPage
import net.automatalib.serialization.taf.TAFSerializationMealy

import de.learnlib.studio.utils.AutomataLibToGratexUtil


class MealyImportWizardPage extends WizardNewFileCreationPage {
    
	protected FileFieldEditor editor
	 new(String pageName, IStructuredSelection selection) {
		super(pageName, selection)
		setTitle(pageName) 
		//NON-NLS-1
		setDescription("Import a file from the local file system into the workspace") //NON-NLS-1
		
	}
	/* (non-Javadoc)
	 * @see org.eclipse.ui.dialogs.WizardNewFileCreationPage#createAdvancedControls(org.eclipse.swt.widgets.Composite)
	 */override protected void createAdvancedControls(Composite parent) {
		var Composite fileSelectionArea=new Composite(parent,SWT::NONE) 
		var GridData fileSelectionData=new GridData(GridData::GRAB_HORIZONTAL.bitwiseOr(GridData::FILL_HORIZONTAL)) 
		fileSelectionArea.setLayoutData(fileSelectionData) 
		var GridLayout fileSelectionLayout=new GridLayout() 
		fileSelectionLayout.numColumns=3 
		fileSelectionLayout.makeColumnsEqualWidth=false 
		fileSelectionLayout.marginWidth=0 
		fileSelectionLayout.marginHeight=0 
		fileSelectionArea.setLayout(fileSelectionLayout) 
		editor=new FileFieldEditor("fileSelect","Select File: ",fileSelectionArea) 
		//NON-NLS-1 //NON-NLS-2
		editor.getTextControl(fileSelectionArea).addModifyListener(([ModifyEvent e|var IPath path=new Path(MealyImportWizardPage.this.editor.getStringValue()) setFileName(path.lastSegment()) ] as ModifyListener)) 
		var String[] extensions=(#["*.*"] as String[]) 
		//NON-NLS-1
		editor.setFileExtensions(extensions) 
		fileSelectionArea.moveAbove(null) 
	}
	
	/* (non-Javadoc)
	 * @see org.eclipse.ui.dialogs.WizardNewFileCreationPage#createLinkTarget()
	 */
	override protected void createLinkTarget() {
	}
	
	override IFile createNewFile() {
	    val containerPath = getContainerFullPath()
	    val path = containerPath.toFile.absolutePath
	    
	    val inputStream = getInitialContents()
		val inputModelData = TAFSerializationMealy.instance.readModel(inputStream)
		AutomataLibToGratexUtil.createMealy(path, fileName, inputModelData.model, inputModelData.alphabet)
		
		return null
	}
	
	/* (non-Javadoc)
	 * @see org.eclipse.ui.dialogs.WizardNewFileCreationPage#getInitialContents()
	 */
	override protected InputStream getInitialContents() {
		try {
			return new FileInputStream(new File(editor.getStringValue())) 
		} catch (FileNotFoundException e) {
			return null 
		}
		
	}
	/* (non-Javadoc)
	 * @see org.eclipse.ui.dialogs.WizardNewFileCreationPage#getNewFileLabel()
	 */
	override protected String getNewFileLabel() {
		return "New File Name:" //NON-NLS-1
		
	}
	/* (non-Javadoc)
	 * @see org.eclipse.ui.dialogs.WizardNewFileCreationPage#validateLinkedResource()
	 */
	override protected IStatus validateLinkedResource() {
		return new Status(IStatus::OK,"info.scce.cinco.product.learnlibstudio.wizards",IStatus::OK,"",null) //NON-NLS-1 //NON-NLS-2
		
	}
}