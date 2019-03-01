package de.learnlib.studio.siblibrary.utils

import de.learnlib.studio.utils.VerticalStackContainerLayouter

class ActivityChildrenLayouter extends VerticalStackContainerLayouter {
    
    public static val INSTANCE = new ActivityChildrenLayouter()
    
    private new() {
        super(45, 0, 5)
    }
    
}