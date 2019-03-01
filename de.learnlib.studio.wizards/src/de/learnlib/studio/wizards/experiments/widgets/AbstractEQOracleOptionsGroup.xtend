package de.learnlib.studio.wizards.experiments.widgets

import org.eclipse.swt.layout.GridData
import org.eclipse.swt.widgets.Group
import org.eclipse.swt.layout.GridLayout
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.SWT

import de.learnlib.studio.experiment.experiment.Experiment
import de.learnlib.studio.experiment.experiment.EQOracle


abstract class AbstractEQOracleOptionsGroup {
    
    static public val NODE_X = 100
    static public val NODE_Y = 350
    
    protected Group    group
    protected GridData groupGridData
    
    
    new(Composite parent, String text) {
        group = new Group(parent, SWT.NONE)
        group.text = text
        
        groupGridData = new GridData(GridData.FILL_BOTH)
        groupGridData.horizontalSpan = 2
        group.layoutData = groupGridData
        
        val layout = new GridLayout()
        layout.numColumns = 2
        layout.verticalSpacing = 9
        group.layout = layout
    }
    
    def setVisible(boolean visible) {
        group.setVisible(visible)
        groupGridData.exclude = !visible
    }
    
    def EQOracle createNode(Experiment experiment)
    
}
