package de.learnlib.studio.symbol.checks

import de.learnlib.studio.symbol.mcam.modules.checks.SymbolCheck
import de.learnlib.studio.symbol.symbol.Symbol


class ControlFlowBranchesCheck extends SymbolCheck {
    
    override check(Symbol model) {
        model.sibActivitys.forEach[activity |
            val usedBranches = activity.outgoingControlFlows.map[branches].flatten
            
            val activityBranches = activity.activity.branchesLists.head.branchs.map[name]
            
            val branchesThatShouldNotExist = usedBranches.filter[!activityBranches.contains(it)]
            branchesThatShouldNotExist.forEach[branch |
                addError(activity, "The outgoing branch '" + branch + "' is not defined for the activity.")
            ]
            
            val branchesThatShouldExist = activityBranches.filter[!usedBranches.contains(it)]
            branchesThatShouldExist.forEach[branch |
                addError(activity, "The outgoing branch '" + branch + "' is missing for the activity.")
            ]
            
            val duplicatedBranches = usedBranches.groupBy[it].values.filter[size > 1]
            duplicatedBranches.forEach[branch |
                addError(activity, "The outgoing branch '" + branch + "' must only be used once.")
            ]
        ]
    }
    
}
