package de.learnlib.studio.siblibrary.hooks

import de.jabc.cinco.meta.runtime.hook.CincoPostDeleteHook

import de.learnlib.studio.siblibrary.siblibrary.InputParameter
import de.learnlib.studio.siblibrary.utils.ActivityChildrenLayouter
import de.learnlib.studio.siblibrary.utils.ListChildrenLayouter


class InputParameterPostDeleteHook extends CincoPostDeleteHook<InputParameter> {
    
    override getPostDeleteFunction(InputParameter inputParameter) {
        val container = inputParameter.container
        
        return new Runnable() {
            override run() {
                ListChildrenLayouter.INSTANCE.layoutAll(container)
                ActivityChildrenLayouter.INSTANCE.layoutAll(container.container)
            }
        }
    }
    
}
