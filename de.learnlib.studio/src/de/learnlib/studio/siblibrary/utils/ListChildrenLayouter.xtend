package de.learnlib.studio.siblibrary.utils

import de.learnlib.studio.utils.VerticalStackContainerLayouter

class ListChildrenLayouter extends VerticalStackContainerLayouter {
    
    public static val INSTANCE = new ListChildrenLayouter()
    
    private new() {
        super(30, 5, 5)
    }
    
}