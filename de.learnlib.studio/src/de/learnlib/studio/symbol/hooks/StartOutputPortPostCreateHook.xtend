package de.learnlib.studio.symbol.hooks

import de.learnlib.studio.symbol.symbol.StartOutputPort


class StartOutputPortPostCreateHook extends GeneralPortPostCreateHook<StartOutputPort> {
    
    override postCreate(StartOutputPort port) {
        super.postCreate(port)
        port.name = "New Output"
        
    }
    
}
