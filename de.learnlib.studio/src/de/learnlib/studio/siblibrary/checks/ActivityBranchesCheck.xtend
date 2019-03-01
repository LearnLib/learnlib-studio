package de.learnlib.studio.siblibrary.checks

import de.learnlib.studio.siblibrary.mcam.modules.checks.SibLibraryCheck
import de.learnlib.studio.siblibrary.siblibrary.SibLibrary
import de.learnlib.studio.siblibrary.siblibrary.Branch
import de.learnlib.studio.utils.Checker


class ActivityBranchesCheck extends SibLibraryCheck {
    
    static val NAME_PATTERN = "[a-zA-Z0-9]([a-zA-Z0-9_]*[a-zA-Z0-9]+)*"
    
    override check(SibLibrary model) {
        model.activitys.forEach[activity |
            val branches = activity.branchesLists.head.branchs
            
            val checker = new Checker<Branch>(this, branches)
            
            checker.addStringChecksFor([name])
                                .notNullOrEmpty()
                                .shouldFollowRegexPattern(NAME_PATTERN)
                                .shouldBeUnique()
            
            checker.check()
        ]
    }
    
}
