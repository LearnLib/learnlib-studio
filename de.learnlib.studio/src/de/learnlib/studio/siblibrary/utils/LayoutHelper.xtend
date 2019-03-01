package de.learnlib.studio.siblibrary.utils

import de.learnlib.studio.siblibrary.siblibrary.Activity
import de.learnlib.studio.siblibrary.siblibrary.SibLibrary


class LayoutHelper {
    
    static def layoutActivties(SibLibrary library) {
        var currentX = 25
        for(Activity a: library.activitys) {
            a.moveTo(library, currentX, 25)
            currentX += a.width + 25
        }
        
        
    }
    
}
