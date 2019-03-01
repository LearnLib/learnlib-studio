package de.learnlib.studio.siblibrary.hooks

import de.jabc.cinco.meta.runtime.hook.CincoPostCreateHook

import de.learnlib.studio.siblibrary.siblibrary.InputParameter
import de.learnlib.studio.siblibrary.utils.ActivityChildrenLayouter
import de.learnlib.studio.siblibrary.utils.ListChildrenLayouter


class InputParameterPostCreateHook extends CincoPostCreateHook<InputParameter> {
    
    override postCreate(InputParameter inputParameter) {
        val list = inputParameter.container
        val activity = list.container
        
        inputParameter.name = "New Input Parameter"
        
        ListChildrenLayouter.INSTANCE.layoutNew(list, inputParameter)
        ActivityChildrenLayouter.INSTANCE.layoutAll(activity)
        
        inputParameter.select()
    }
    
}
