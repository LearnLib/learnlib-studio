package de.learnlib.studio.symbol.actions

import de.jabc.cinco.meta.runtime.action.CincoCustomAction

import de.learnlib.studio.symbol.symbol.Sib
import de.learnlib.studio.symbol.symbol.SibStaticInputPort


class SibStaticInputPortMakeDynamicCustomAction extends CincoCustomAction<SibStaticInputPort> {
    
    override getName() {
        "Make Parameter Dynamic"
    }
    
    override execute(SibStaticInputPort inputPort) {
        val Sib sib = inputPort.container
        
        val newPort = sib.newSibDynamicInputPort(inputPort.x, inputPort.y, inputPort.width, inputPort.height)
        newPort.name     = inputPort.name
        newPort.dataType = inputPort.dataType
        
        inputPort.delete
    }
    
}
