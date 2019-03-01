package de.learnlib.studio.symbol.hooks

import graphmodel.Container
import de.jabc.cinco.meta.runtime.hook.CincoPostResizeHook

import de.learnlib.studio.symbol.utils.SibActivityChildrenLayouter


class VerticalContainerPostResizeHook extends CincoPostResizeHook<Container> {
    
    val layouter = SibActivityChildrenLayouter.INSTANCE
    
    override postResize(Container container, int direction, int newWidth, int newHeight) {
        layouter.resizeChildren(container)
    }
    
}
