package de.learnlib.studio.siblibrary.hooks

import de.jabc.cinco.meta.runtime.hook.CincoPostDeleteHook

import de.learnlib.studio.siblibrary.siblibrary.Activity
import de.learnlib.studio.siblibrary.utils.LayoutHelper

class ActivityPostDeleteHook extends CincoPostDeleteHook<Activity> {
    
    override getPostDeleteFunction(Activity activity) {
        val library = activity.container
        
        return new Runnable() {
            
            override run() {
                LayoutHelper.layoutActivties(library)
            }
            
        }
    }
    
}
