package de.learnlib.studio.symbol.hooks

import org.eclipse.emf.ecore.EStructuralFeature

import de.jabc.cinco.meta.runtime.action.CincoPostAttributeChangeHook

import de.learnlib.studio.symbol.symbol.ControlFlow


class ControlFlowPostAttributeChangeHook extends CincoPostAttributeChangeHook<ControlFlow> {
    
    override canHandleChange(ControlFlow controllFlow, EStructuralFeature feature) {
        return true
    }
    
    override handleChange(ControlFlow controllFlow, EStructuralFeature feature) {
        if (feature.name == "label") {
            val branchNames = getAllBranchOutputNames(controllFlow)
            
            controllFlow.branches.clear
            
            branchNames.forEach[b | controllFlow.addBranches(b)]
        }
    }
    
    private def getAllBranchOutputNames(ControlFlow edge) {
        val label = edge.label
        return label.split(",").map[trim]
    }
    
}
