package de.learnlib.studio.symbol.hooks

import de.jabc.cinco.meta.runtime.hook.CincoPostCreateHook
import graphmodel.Container

import de.learnlib.studio.symbol.symbol.GeneralPort
import de.learnlib.studio.symbol.utils.SibActivityChildrenLayouter


abstract class GeneralPortPostCreateHook<N extends GeneralPort> extends CincoPostCreateHook<N> {
    
    val layouter = SibActivityChildrenLayouter.INSTANCE
    
    override postCreate(N port) {
        val container = port.container as Container
        layouter.layoutNew(container, port)
    }
    
}
