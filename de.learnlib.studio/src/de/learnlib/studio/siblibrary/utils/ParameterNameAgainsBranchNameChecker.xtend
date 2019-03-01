package de.learnlib.studio.siblibrary.utils

import java.util.function.Consumer

import de.learnlib.studio.siblibrary.siblibrary.Activity
import de.learnlib.studio.siblibrary.siblibrary.Parameter
import de.learnlib.studio.utils.Checker.Check


class ParameterNameAgainsBranchNameChecker implements Check<Parameter, String> {
    
    val Activity activity
    
    new(Activity activity) {
        this.activity = activity
    }
    
    override check(String name, Consumer<String> warnFunction, Consumer<String> errorFunction) {
        val nameUsedForABranch = activity.branchesLists.head.branchs.exists[b | b.name == name]
        
        if (nameUsedForABranch) {
            errorFunction.accept("The Input can not have the same name as the Activity")
            return false
        }
            
        return true
    }
    
}
