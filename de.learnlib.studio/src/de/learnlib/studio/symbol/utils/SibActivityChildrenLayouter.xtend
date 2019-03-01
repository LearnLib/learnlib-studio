package de.learnlib.studio.symbol.utils

import de.learnlib.studio.utils.VerticalStackContainerLayouter

class SibActivityChildrenLayouter extends VerticalStackContainerLayouter {
    
    public static val INSTANCE = new SibActivityChildrenLayouter()
    
    private new() {
        super(65, 5, 5)
    }
    
}
