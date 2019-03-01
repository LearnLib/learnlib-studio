package de.learnlib.studio.wizards.experiments

import org.eclipse.jface.wizard.WizardPage
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Combo
import org.eclipse.swt.layout.GridLayout
import org.eclipse.swt.SWT
import org.eclipse.swt.widgets.Label
import org.eclipse.swt.layout.GridData

import de.learnlib.studio.wizards.experiments.widgets.RandomWordEQOracleOptionsGroup
import de.learnlib.studio.wizards.experiments.widgets.CompleteEQOracleOptionsGroup
import de.learnlib.studio.experiment.experiment.Experiment
import de.learnlib.studio.wizards.experiments.widgets.WMethodEQOracleOptionsGroup
import de.learnlib.studio.wizards.experiments.widgets.WpMethodEQOracleOptionsGroup

class ExperimentWizardEQOraclePage extends WizardPage {
    
    Combo eqOracleCombo
    
    RandomWordEQOracleOptionsGroup randomWordOptionsGroup
    CompleteEQOracleOptionsGroup   completeOptionsGroup
    WMethodEQOracleOptionsGroup    wmethodOptionsGroup
    WpMethodEQOracleOptionsGroup   wpMethodOptionsGroup
    
    
    new() {
        super("eqOraclePage")
        title = "Experiment Setup Wizard"
        description = "Please select the EQ Oracle you want to use."
    }
    
    override createControl(Composite parent) {
        val container = new Composite(parent, SWT::NULL)
        
        var layout = new GridLayout()
        layout.numColumns = 2
        layout.verticalSpacing = 9
        container.setLayout(layout)
        
        val Label label = new Label(container, SWT::NULL)
        label.setText("&EQ Oracle:")
        
        eqOracleCombo = new Combo(container, SWT.READ_ONLY)
        eqOracleCombo.layoutData = new GridData(GridData::FILL_HORIZONTAL)
        
        eqOracleCombo.items = #["Random Word", "Complete" , "W-Method", "Wp-Method"]
        eqOracleCombo.select = 0
        eqOracleCombo.addListener(SWT.Selection, [e | 
            val currentIndex = (e.widget as Combo).selectionIndex
            changeOptionGroup(currentIndex)
            container.pack()
        ])
        
        randomWordOptionsGroup = new RandomWordEQOracleOptionsGroup(container)
        completeOptionsGroup   = new CompleteEQOracleOptionsGroup(container)
        wmethodOptionsGroup    = new WMethodEQOracleOptionsGroup(container)
        wpMethodOptionsGroup   = new WpMethodEQOracleOptionsGroup(container)
        changeOptionGroup(0)
        
        setControl(container)
    }
    
    def changeOptionGroup(int index) {
        randomWordOptionsGroup.visible = false
        completeOptionsGroup  .visible = false
        wmethodOptionsGroup   .visible = false
        wpMethodOptionsGroup  .visible = false
        
        switch (index) {
            case 0: {
                randomWordOptionsGroup.visible = true
            }
            case 1: {
                completeOptionsGroup.visible = true
            }
            case 2: {
                wmethodOptionsGroup.visible = true
            }
            case 3: {
                wpMethodOptionsGroup.visible = true
            }
        }
    }
    
    def createExperimentNode(Experiment experiment) {
        switch eqOracleCombo.selectionIndex {
            case 0: return randomWordOptionsGroup.createNode(experiment)
            case 1: return completeOptionsGroup.createNode(experiment)
            case 2: return wmethodOptionsGroup.createNode(experiment)
            case 3: return wpMethodOptionsGroup.createNode(experiment)
        }
    }
    
}
