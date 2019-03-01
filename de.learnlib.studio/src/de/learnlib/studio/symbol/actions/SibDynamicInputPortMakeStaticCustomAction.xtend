package de.learnlib.studio.symbol.actions

import de.jabc.cinco.meta.runtime.action.CincoCustomAction

import de.learnlib.studio.symbol.symbol.Sib
import de.learnlib.studio.symbol.symbol.SibDynamicInputPort


class SibDynamicInputPortMakeStaticCustomAction extends CincoCustomAction<SibDynamicInputPort> {
    
    override getName() {
        "Make Parameter Static"
    }
    
    override execute(SibDynamicInputPort inputPort) {
        val Sib sib = inputPort.container
        
        val newPort = sib.newSibStaticInputPort(inputPort.x, inputPort.y, inputPort.width, inputPort.height)
        newPort.name     = inputPort.name
        newPort.dataType = inputPort.dataType
        
        inputPort.delete
    }
    
}
