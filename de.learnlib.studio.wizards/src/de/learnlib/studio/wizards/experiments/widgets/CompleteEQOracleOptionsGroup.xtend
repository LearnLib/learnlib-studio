package de.learnlib.studio.wizards.experiments.widgets

import org.eclipse.swt.layout.GridData
import org.eclipse.swt.widgets.Spinner
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.SWT
import org.eclipse.swt.widgets.Label

import de.learnlib.studio.experiment.experiment.Experiment


class CompleteEQOracleOptionsGroup extends AbstractEQOracleOptionsGroup {
    
    Spinner minDepthSpinner
    Spinner maxDepthSpinner
 
 
    new (Composite parent) {
        super(parent, "Complete Options Group")
        
        var minLabel = new Label(group, SWT.NULL)
        minLabel.setText("Min. Depth:")
        
        minDepthSpinner = new Spinner(group, SWT.NULL)
        minDepthSpinner.minimum = 0
        minDepthSpinner.maximum = Integer.MAX_VALUE
        minDepthSpinner.selection = 1
        minDepthSpinner.layoutData = new GridData(GridData.FILL_HORIZONTAL)
        
        var maxLabel = new Label(group, SWT.NULL)
        maxLabel.setText("Max. Depth:")
        
        maxDepthSpinner = new Spinner(group, SWT.NULL)
        maxDepthSpinner.minimum = 0
        maxDepthSpinner.maximum = Integer.MAX_VALUE
        maxDepthSpinner.selection = 5
        maxDepthSpinner.layoutData = new GridData(GridData.FILL_HORIZONTAL)
    }
    
    override createNode(Experiment experiment) {
        val newNode = experiment.newCompleteEQOracle(NODE_X, NODE_Y)
        newNode.minDepth = minDepthSpinner.selection
        newNode.maxDepth = maxDepthSpinner.selection
        return newNode
    }
    
}
