package de.learnlib.studio.siblibrary.hooks

import de.jabc.cinco.meta.runtime.hook.CincoPostResizeHook

import de.learnlib.studio.siblibrary.siblibrary.List
import de.learnlib.studio.siblibrary.utils.ActivityChildrenLayouter
import de.learnlib.studio.siblibrary.utils.ListChildrenLayouter


class ListPostResizeHook extends CincoPostResizeHook<List> {
    
    override postResize(List list, int direction, int widht, int hight) {
        ListChildrenLayouter.INSTANCE.layoutAll(list)
        ActivityChildrenLayouter.INSTANCE.layoutAll(list.container)
    }
    
}
