package de.learnlib.studio.siblibrary.hooks

import de.jabc.cinco.meta.runtime.hook.CincoPostCreateHook

import de.learnlib.studio.siblibrary.siblibrary.OutputParameter
import de.learnlib.studio.siblibrary.utils.ActivityChildrenLayouter
import de.learnlib.studio.siblibrary.utils.ListChildrenLayouter


class OutputParameterPostCreateHook extends CincoPostCreateHook<OutputParameter> {
    
    override postCreate(OutputParameter outputParameter) {
        val list = outputParameter.container
        val activity = list.container
        
        outputParameter.name = "New Output Parameter"
        
        ListChildrenLayouter.INSTANCE.layoutNew(list, outputParameter)
        ActivityChildrenLayouter.INSTANCE.layoutAll(activity)
        
        outputParameter.select()
    }
    
}
