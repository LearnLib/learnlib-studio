package de.learnlib.studio.siblibrary.hooks

import de.jabc.cinco.meta.runtime.hook.CincoPostCreateHook

import de.learnlib.studio.siblibrary.siblibrary.Branch
import de.learnlib.studio.siblibrary.utils.ActivityChildrenLayouter
import de.learnlib.studio.siblibrary.utils.ListChildrenLayouter


class BranchPostCreateHook extends CincoPostCreateHook<Branch> {
    
    override postCreate(Branch branch) {
        val list = branch.container
        val activity = list.container
        
        branch.name = "New Branch"
        
        ListChildrenLayouter.INSTANCE.layoutNew(list, branch)
        ActivityChildrenLayouter.INSTANCE.layoutAll(activity)
        
        branch.select()
    }
    
}
