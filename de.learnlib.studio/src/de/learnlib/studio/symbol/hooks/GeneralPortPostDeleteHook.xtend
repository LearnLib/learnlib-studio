package de.learnlib.studio.symbol.hooks

import graphmodel.Container
import de.jabc.cinco.meta.runtime.hook.CincoPostDeleteHook

import de.learnlib.studio.symbol.symbol.GeneralPort
import de.learnlib.studio.utils.VerticalStackContainerLayouter


class GeneralPortPostDeleteHook extends CincoPostDeleteHook<GeneralPort> {
    
    val layouter = new VerticalStackContainerLayouter(65, 5, 5)
    
    override getPostDeleteFunction(GeneralPort port) {
        val container = port.container as Container
        
        return [
            layouter.layoutAll(container)
        ]
    }
    
}
