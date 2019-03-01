package de.learnlib.studio.siblibrary.hooks

import de.jabc.cinco.meta.runtime.hook.CincoPostDeleteHook

import de.learnlib.studio.siblibrary.siblibrary.Branch
import de.learnlib.studio.siblibrary.utils.ActivityChildrenLayouter
import de.learnlib.studio.siblibrary.utils.ListChildrenLayouter


class BranchPostDeleteHook extends CincoPostDeleteHook<Branch> {
    
    override getPostDeleteFunction(Branch branch) {
        val container = branch.container
        
        return new Runnable() {
            override run() {
                ListChildrenLayouter.INSTANCE.layoutAll(container)
                ActivityChildrenLayouter.INSTANCE.layoutAll(container.container)
            }
        }
    }
    
}
