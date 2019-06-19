package de.learnlib.studio.symbol.aps

import style.StyleFactory

import de.jabc.cinco.meta.core.ge.style.generator.runtime.appearance.StyleAppearanceProvider

import de.learnlib.studio.symbol.symbol.DataFlow
import de.learnlib.studio.symbol.symbol.Symbol


class DataFlowAppearanceProvider implements StyleAppearanceProvider<DataFlow> {
	
	val styleFactory = StyleFactory.eINSTANCE
	
	override getAppearance(DataFlow edge, String text) {
		val appearance = styleFactory.createAppearance()
		
		val symbol = edge.container as Symbol
		
		if (symbol.showDataFlow) {
			appearance.transparency = 0.0
		} else {
			appearance.transparency = 1.0
		}
		 	
		return appearance
	}

	
}
