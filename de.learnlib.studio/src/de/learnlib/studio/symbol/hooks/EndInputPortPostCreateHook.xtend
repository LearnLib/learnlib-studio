package de.learnlib.studio.symbol.hooks

import de.learnlib.studio.symbol.symbol.EndInputPort


class EndInputPortPostCreateHook extends GeneralPortPostCreateHook<EndInputPort> {
    
    override postCreate(EndInputPort port) {
        super.postCreate(port)
        port.name = "New Input"
    }
    
}
