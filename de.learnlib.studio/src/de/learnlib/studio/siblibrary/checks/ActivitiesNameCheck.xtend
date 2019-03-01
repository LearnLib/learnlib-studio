package de.learnlib.studio.siblibrary.checks

import de.learnlib.studio.utils.Checker
import de.learnlib.studio.siblibrary.siblibrary.Activity
import de.learnlib.studio.siblibrary.siblibrary.SibLibrary
import de.learnlib.studio.siblibrary.mcam.modules.checks.SibLibraryCheck


class ActivitiesNameCheck extends SibLibraryCheck {
    
    static val NAME_PATTERN = "[a-zA-Z0-9]([a-zA-Z0-9_]*[a-zA-Z0-9]+)*"
    
    override check(SibLibrary model) {
        val checker = new Checker<Activity>(this, model.activitys)

        checker.addStringChecksFor([name])
                            .notNullOrEmpty()
                            .shouldFollowRegexPattern(NAME_PATTERN)
                            .shouldBeUnique()
                    
        checker.check()
    }
    
}
