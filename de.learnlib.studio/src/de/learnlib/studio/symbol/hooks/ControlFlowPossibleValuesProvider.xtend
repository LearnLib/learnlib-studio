package de.learnlib.studio.symbol.hooks

import java.util.List

import de.jabc.cinco.meta.runtime.provider.CincoValuesProvider

import de.learnlib.studio.symbol.symbol.ControlFlow
import de.learnlib.studio.symbol.symbol.Sib
import de.learnlib.studio.symbol.symbol.SibBranch


class ControlFlowPossibleValuesProvider extends CincoValuesProvider<ControlFlow, String> {
    
    override getPossibleValues(ControlFlow edge) {
        val sourceElement = edge.sourceElement
        val result = <String, String> newTreeMap([s1, s2 | s1.compareTo(s2)])
        
        if (sourceElement instanceof Sib) {
            val outputs = sourceElement.branches
           
            val allCombinations = powerSet(outputs)
            allCombinations.removeIf[size == 0]
            
            allCombinations.forEach[c |
            	val branchesNames = c.map[name]
            	val text = branchesNames.join(", ")
                result.put(text, text)
            ]
        } else {
            result.put("Success", "Success")
        }
        
        return result
    }
    
    private def powerSet(List<SibBranch> outputs) {
        val result = <List<SibBranch>> newLinkedList()
        
        result += <SibBranch> newLinkedList()
        
        outputs.forEach[o |
            val newEntries = <List<SibBranch>> newLinkedList()
            result.forEach[r |
                val newEntry = <SibBranch> newLinkedList(r)
                newEntry += o           
                newEntries += newEntry
            ]
            result += newEntries
        ]
        
        return result
    }
    
}
