package de.learnlib.studio.symbol.actions

import de.jabc.cinco.meta.runtime.action.CincoCustomAction
import de.learnlib.studio.symbol.symbol.Symbol

class AutofillBranchLabelsAction extends CincoCustomAction<Symbol> {

    override getName() {
        return "Guess Branch Labels"
    }
    
    override execute(Symbol symbol) {
        symbol.sibs.forEach[sib |
            val controlFlows = sib.outgoingControlFlows
            
            val unlabeldEdges = controlFlows.filter[cf | cf.branches.nullOrEmpty]
            if (unlabeldEdges.size == 1) {
                val actityBranchesAsString = sib.branches.map[name]
                
                val missingBranches = newArrayList()      // this and the next line create a copy of the branches,
                missingBranches += actityBranchesAsString // which is not connected to the SIB
                controlFlows.forEach[cf | missingBranches -= cf.branches]
                
                val unlabeldEdge = unlabeldEdges.head
                unlabeldEdge.branches += missingBranches
                unlabeldEdge.label = missingBranches.join(", ")
            }
        ]
    }
    
}