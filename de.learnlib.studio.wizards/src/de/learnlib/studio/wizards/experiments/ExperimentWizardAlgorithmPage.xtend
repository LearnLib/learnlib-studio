package de.learnlib.studio.wizards.experiments

import org.eclipse.jface.wizard.WizardPage
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Label
import org.eclipse.swt.layout.GridData
import org.eclipse.swt.layout.GridLayout
import org.eclipse.swt.widgets.Combo
import org.eclipse.swt.SWT

import de.learnlib.studio.experiment.experiment.Experiment


class ExperimentWizardAlgorithmPage extends WizardPage {
    
    static val NODE_X = 100
    static val NODE_Y = 200
    
    Combo algorithmCombo
    
    
    new() {
        super("algorithm")
        title = "Experiment Setup Wizard"
        description = "Please select the Learn Algorithm you want to use."
    }
    
    override createControl(Composite parent) {
        val container = new Composite(parent, SWT::NULL)
        val layout = new GridLayout()
        container.setLayout(layout)
        layout.numColumns = 2
        layout.verticalSpacing = 9
        
        val Label label = new Label(container, SWT::NULL)
        label.setText("&Algorithm:")
        algorithmCombo = new Combo(container, SWT.READ_ONLY)
        algorithmCombo.items = #["L*", "DHC", "Discrimination Tree", "TTT"]
        algorithmCombo.select = 0
        val gd = new GridData(GridData::FILL_HORIZONTAL)
        algorithmCombo.layoutData = gd
        
        setControl(container)
    }
    
    def createExperimentNode(Experiment experiment) {
        switch algorithmCombo.selectionIndex {
            case 0: return experiment.newLStarAlgorithm(NODE_X, NODE_Y)
            case 1: return experiment.newDHCAlgorithm(NODE_X, NODE_Y)
            case 2: return experiment.newDTAlgorithm(NODE_X, NODE_Y)
            case 3: return experiment.newTTTAlgorithm(NODE_X, NODE_Y)
        }
    }
    
}
