package de.learnlib.studio.wizards.experiments.widgets

import org.eclipse.swt.layout.GridData
import org.eclipse.swt.widgets.Spinner
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.SWT
import org.eclipse.swt.widgets.Label

import de.learnlib.studio.experiment.experiment.Experiment


class RandomWordEQOracleOptionsGroup extends AbstractEQOracleOptionsGroup {
    
    Spinner minLengthSpinner
    Spinner maxLengthSpinner
    Spinner maxAmountSpinner
 
    new(Composite parent) {
        super(parent, "Random Word Options")
        
        var label = new Label(group, SWT.NULL)
        label.setText("Min. &Lenght:")
        
        minLengthSpinner = new Spinner(group, SWT.NULL)
        minLengthSpinner.minimum = 0
        minLengthSpinner.maximum = Integer.MAX_VALUE
        minLengthSpinner.selection = 5
        minLengthSpinner.layoutData = new GridData(GridData.FILL_HORIZONTAL)
        
        label = new Label(group, SWT::NULL)
        label.setText("Max. L&enght:")
        
        maxLengthSpinner = new Spinner(group, SWT.NULL)
        maxLengthSpinner.minimum = 0
        maxLengthSpinner.maximum = Integer.MAX_VALUE
        maxLengthSpinner.selection = 10
        maxLengthSpinner.layoutData = new GridData(GridData.FILL_HORIZONTAL)
        
        label = new Label(group, SWT::NULL)
        label.setText("Max. &Amount:")
        
        maxAmountSpinner = new Spinner(group, SWT.NULL)
        maxAmountSpinner.minimum = 0
        maxAmountSpinner.maximum = Integer.MAX_VALUE
        maxAmountSpinner.selection = 20
        maxAmountSpinner.layoutData = new GridData(GridData.FILL_HORIZONTAL)
    }
    
    override createNode(Experiment experiment) {
        val newNode = experiment.newRandomWordEQOracle(NODE_X, NODE_Y)
        newNode.minLength = minLengthSpinner.selection
        newNode.maxLength = maxLengthSpinner.selection
        newNode.amount    = maxAmountSpinner.selection
        return newNode
    }
    
}
