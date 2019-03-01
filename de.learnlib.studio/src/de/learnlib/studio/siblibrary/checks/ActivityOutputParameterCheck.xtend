package de.learnlib.studio.siblibrary.checks

import de.learnlib.studio.siblibrary.mcam.modules.checks.SibLibraryCheck
import de.learnlib.studio.siblibrary.siblibrary.SibLibrary
import de.learnlib.studio.siblibrary.siblibrary.Parameter
import de.learnlib.studio.utils.Checker
import de.learnlib.studio.siblibrary.utils.ParameterNameAgainsBranchNameChecker

class ActivityOutputParameterCheck extends SibLibraryCheck {
    
    static val NAME_PATTERN = "[a-zA-Z0-9]([a-zA-Z0-9_]*[a-zA-Z0-9]+)*"
    
    override check(SibLibrary model) {
        model.activitys.forEach[activity |
            val parameterNameAgainsBranchNameChecker = new ParameterNameAgainsBranchNameChecker(activity)
            
            val outputParameters = activity.outputParametersLists.head.outputParameters
            
            val checker = new Checker<Parameter>(this, outputParameters)
            checker.addStringChecksFor([name])
                                .notNullOrEmpty()
                                .shouldFollowRegexPattern(NAME_PATTERN)
                                .shouldBeUnique()
                                .addCustomCheck(parameterNameAgainsBranchNameChecker)
            
            checker.check()
        ]
    }
    
}
