package de.learnlib.studio.symbol.aps

import style.LineStyle
import style.StyleFactory

import de.jabc.cinco.meta.core.ge.style.generator.runtime.appearance.StyleAppearanceProvider

import de.learnlib.studio.symbol.symbol.ControlFlow
import de.learnlib.studio.symbol.symbol.Sib
import de.learnlib.studio.utils.Colors

class ControlFlowAppearanceProvider implements StyleAppearanceProvider<ControlFlow> {
	
	val styleFactory = StyleFactory.eINSTANCE
	
	override getAppearance(ControlFlow edge, String text) {
		val appearance = styleFactory.createAppearance()
		   
        if (edgeContainsErrorBranch(edge)) {
            appearance.lineStyle = LineStyle.DASHDOT
            appearance.foreground = Colors.LIGHT_RED
        } else {
            appearance.lineStyle = LineStyle.SOLID
            appearance.foreground = Colors.BLACK
        }
		
		return appearance
	}
	
	private def edgeContainsErrorBranch(ControlFlow edge) {
	    val source = edge.sourceElement
	    
	    if (source instanceof Sib) {
	        val controlFlowBranches = edge.branches
	        val sibErrorBranches = getAllErrorBranches(source)
	        
	        return sibErrorBranches.exists[controlFlowBranches.contains(it)]
	    } else {
	        return false
	    }
	}
	
	private def getAllErrorBranches(Sib sib) {
	    return sib.branches.filter[error].map[b | b.name]
	}
	
}
