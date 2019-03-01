package de.learnlib.studio.wizards.experiments.widgets

import org.eclipse.swt.layout.GridData
import org.eclipse.swt.widgets.Spinner
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.SWT
import org.eclipse.swt.widgets.Label

import de.learnlib.studio.experiment.experiment.Experiment


class WMethodEQOracleOptionsGroup extends AbstractEQOracleOptionsGroup {
    
    Spinner depthSpinner
 
 
    new (Composite parent) {
        super(parent, "WMethod Options Group")
        
        var label = new Label(group, SWT.NULL)
        label.setText("Max &Depth:")
        
        depthSpinner = new Spinner(group, SWT.NULL)
        depthSpinner.minimum = 0
        depthSpinner.maximum = Integer.MAX_VALUE
        depthSpinner.selection = 1
        depthSpinner.layoutData = new GridData(GridData.FILL_HORIZONTAL)
    }
    
    override createNode(Experiment experiment) {
        val newNode = experiment.newWMethodEQOracle(NODE_X, NODE_Y)
        newNode.maxDepth = depthSpinner.selection
        return newNode
    }
    
}
