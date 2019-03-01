package de.learnlib.studio.wizards.experiments

import org.eclipse.core.resources.IContainer
import org.eclipse.core.resources.IResource
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.core.runtime.Path
import org.eclipse.jface.viewers.ISelection
import org.eclipse.jface.viewers.IStructuredSelection
import org.eclipse.jface.wizard.WizardPage
import org.eclipse.swt.SWT
import org.eclipse.swt.events.ModifyEvent
import org.eclipse.swt.events.ModifyListener
import org.eclipse.swt.events.SelectionAdapter
import org.eclipse.swt.events.SelectionEvent
import org.eclipse.swt.layout.GridData
import org.eclipse.swt.layout.GridLayout
import org.eclipse.swt.widgets.Button
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Label
import org.eclipse.swt.widgets.Text
import org.eclipse.ui.dialogs.ContainerSelectionDialog


/** 
 * The "New" wizard page allows setting the container for the new file as well
 * as the file name. The page will only accept file name without the extension
 * OR with the extension that matches the expected one (mpe).
 */
class ExperimentWizardFilePage extends WizardPage {

    Text containerText
    Text fileText
    ISelection selection

    /** 
     * Constructor for SampleNewWizardPage.
     * @param pageName
     */
    new(ISelection selection) {
        super("filePage")
        title = "Experiment Setup Wizard"
        description = "Please select the location and name of the new Experiment."
        this.selection = selection
    }

    /** 
     * @see IDialogPage#createControl(Composite)
     */
    override void createControl(Composite parent) {
        val container = new Composite(parent, SWT::NULL)
        val layout = new GridLayout()
        container.setLayout(layout)
        layout.numColumns = 3
        layout.verticalSpacing = 9
        
        var Label label = new Label(container, SWT::NULL)
        label.setText("&Container:")
        containerText = new Text(container, SWT::BORDER.bitwiseOr(SWT::SINGLE))
        var GridData gd = new GridData(GridData::FILL_HORIZONTAL)
        containerText.setLayoutData(gd)
        containerText.addModifyListener(([ModifyEvent e|dialogChanged()] as ModifyListener))
        var button = new Button(container, SWT::PUSH)
        button.setText("Browse...")
        button.addSelectionListener(new SelectionAdapter() {

            override void widgetSelected(SelectionEvent e) {
                handleBrowse()
            }

        })
        
        label = new Label(container, SWT::NULL)
        label.setText("&File name:")
        fileText = new Text(container, SWT::BORDER.bitwiseOr(SWT::SINGLE))
        gd = new GridData(GridData::FILL_HORIZONTAL)
        fileText.setLayoutData(gd)
        fileText.addModifyListener(([ModifyEvent e|dialogChanged()] as ModifyListener))
        
        initialize()
        dialogChanged()
        setControl(container)
    }

    /** 
     * Tests if the current workbench selection is a suitable container to use.
     */
    def private void initialize() {
        if(selection !== null && selection.isEmpty() === false && selection instanceof IStructuredSelection) {
            var IStructuredSelection ssel = (selection as IStructuredSelection)
            if(ssel.size() > 1) return;
            var Object obj = ssel.getFirstElement()
            if(obj instanceof IResource) {
                var IContainer container
                if(obj instanceof IContainer) container = obj as IContainer else container = ((obj as IResource)).
                    getParent()
                containerText.setText(container.getFullPath().toString())
            }
        }
        fileText.setText("new_experiment.ll")
    }

    /** 
     * Uses the standard container selection dialog to choose the new value for
     * the container field.
     */
    def private void handleBrowse() {
        var ContainerSelectionDialog dialog = new ContainerSelectionDialog(getShell(),
            ResourcesPlugin::getWorkspace().getRoot(), false, "Select new file container")
        if(dialog.open() === ContainerSelectionDialog::OK) {
            var Object[] result = dialog.getResult()
            if(result.length === 1) {
                containerText.setText(((result.get(0) as Path)).toString())
            }
        }
    }

    /** 
     * Ensures that both text fields are set.
     */
    def private void dialogChanged() {
        var IResource container = ResourcesPlugin::getWorkspace().getRoot().findMember(new Path(getContainerName()))
        var String fileName = getFileName()
        if(getContainerName().length() === 0) {
            updateStatus("File container must be specified")
            return;
        }
        if(container === null ||
            (container.getType().bitwiseAnd((IResource::PROJECT.bitwiseOr(IResource::FOLDER)))) === 0) {
            updateStatus("File container must exist")
            return;
        }
        if(!container.isAccessible()) {
            updateStatus("Project must be writable")
            return;
        }
        if(fileName.length() === 0) {
            updateStatus("File name must be specified")
            return;
        }
        if(fileName.replace(Character.valueOf('\\').charValue, Character.valueOf('/').charValue).indexOf(
            Character.valueOf('/').charValue, 1) > 0) {
            updateStatus("File name must be valid")
            return;
        }
        var int dotLoc = fileName.lastIndexOf(Character.valueOf('.').charValue)
        if(dotLoc !== -1) {
            var String ext = fileName.substring(dotLoc + 1)
            if(ext.equalsIgnoreCase("ll") === false) {
                updateStatus("File extension must be \"ll\"")
                return;
            }
        }
        updateStatus(null)
    }

    def private void updateStatus(String message) {
        setErrorMessage(message)
        setPageComplete(message === null)
    }

    def String getContainerName() {
        return containerText.getText()
    }

    def String getFileName() {
        return fileText.getText()
    }

}
