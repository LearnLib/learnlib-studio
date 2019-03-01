package de.learnlib.studio.siblibrary.hooks

import de.jabc.cinco.meta.runtime.hook.CincoPostResizeHook

import de.learnlib.studio.siblibrary.siblibrary.Activity
import de.learnlib.studio.siblibrary.utils.LayoutHelper
import de.learnlib.studio.siblibrary.utils.ActivityChildrenLayouter
import de.learnlib.studio.siblibrary.utils.ListChildrenLayouter

class ActivityPostResizeHook extends CincoPostResizeHook<Activity> {
    
    override postResize(Activity activity, int direction, int width, int height) {
        ActivityChildrenLayouter.INSTANCE.layoutAll(activity)
        activity.nodes.forEach[ListChildrenLayouter.INSTANCE.layoutAll(it)]
        
        val library = activity.container
        LayoutHelper.layoutActivties(library)
    }
    
}
