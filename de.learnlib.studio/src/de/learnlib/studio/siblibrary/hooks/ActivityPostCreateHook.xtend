package de.learnlib.studio.siblibrary.hooks

import de.jabc.cinco.meta.runtime.hook.CincoPostCreateHook

import de.learnlib.studio.siblibrary.siblibrary.Activity
import de.learnlib.studio.siblibrary.utils.LayoutHelper
import de.learnlib.studio.siblibrary.utils.ActivityChildrenLayouter

class ActivityPostCreateHook extends CincoPostCreateHook<Activity> {
	
	val layouter = ActivityChildrenLayouter.INSTANCE
	
	override postCreate(Activity activity) {
		activity.name = "New Activity"
		
		activity.newBranchesList(0, 0)
        activity.newInputParametersList(0, 0)
        activity.newOutputParametersList(0, 0)
        
        layouter.layoutAll(activity)
        
        val library = activity.container
        LayoutHelper.layoutActivties(library)
	}
	
}
