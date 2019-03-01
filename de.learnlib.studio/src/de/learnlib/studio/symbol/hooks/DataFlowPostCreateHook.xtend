package de.learnlib.studio.symbol.hooks

import de.jabc.cinco.meta.runtime.hook.CincoPostCreateHook
import de.jabc.cinco.meta.core.ge.style.generator.runtime.layout.EdgeLayouter
import de.jabc.cinco.meta.core.ge.style.generator.runtime.layout.Layouter_C_LEFT

import de.learnlib.studio.symbol.symbol.DataFlow


class DataFlowPostCreateHook extends CincoPostCreateHook<DataFlow> {
	
	val EdgeLayouter layouter = new Layouter_C_LEFT()
	
	override postCreate(DataFlow dataFlow) {
		layouter.apply(dataFlow)
	}
	
}
