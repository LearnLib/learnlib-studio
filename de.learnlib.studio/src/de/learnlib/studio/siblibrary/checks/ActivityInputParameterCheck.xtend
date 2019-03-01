package de.learnlib.studio.siblibrary.checks

import de.learnlib.studio.siblibrary.mcam.modules.checks.SibLibraryCheck
import de.learnlib.studio.siblibrary.siblibrary.SibLibrary
import de.learnlib.studio.siblibrary.siblibrary.Parameter
import de.learnlib.studio.utils.Checker
import de.learnlib.studio.siblibrary.utils.ParameterNameAgainsBranchNameChecker

class ActivityInputParameterCheck extends SibLibraryCheck {
    
    static val NAME_PATTERN = "[a-zA-Z0-9]([a-zA-Z0-9_]*[a-zA-Z0-9]+)*"
    
    override check(SibLibrary model) {
        model.activitys.forEach[activity |
            val parameterNameAgainsBranchNameChecker = new ParameterNameAgainsBranchNameChecker(activity)
    
            val inputParameters = activity.inputParametersLists.head.inputParameters
            
            val checker = new Checker<Parameter>(this, inputParameters)
            checker.addStringChecksFor([name])
                                .notNullOrEmpty()
                                .shouldFollowRegexPattern(NAME_PATTERN)
                                .shouldBeUnique()
                                .addCustomCheck(parameterNameAgainsBranchNameChecker)
            
            checker.check()
        ]
    }
    
}
