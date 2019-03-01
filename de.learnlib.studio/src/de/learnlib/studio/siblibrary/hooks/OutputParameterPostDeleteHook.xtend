package de.learnlib.studio.siblibrary.hooks

import de.jabc.cinco.meta.runtime.hook.CincoPostDeleteHook

import de.learnlib.studio.siblibrary.siblibrary.OutputParameter
import de.learnlib.studio.siblibrary.utils.ActivityChildrenLayouter
import de.learnlib.studio.siblibrary.utils.ListChildrenLayouter


class OutputParameterPostDeleteHook extends CincoPostDeleteHook<OutputParameter> {
    
    override getPostDeleteFunction(OutputParameter outputParameter) {
        val container = outputParameter.container
        
        return new Runnable() {
            override run() {
                ListChildrenLayouter.INSTANCE.layoutAll(container)
                ActivityChildrenLayouter.INSTANCE.layoutAll(container.container)
            }
        }
    }
    
}
