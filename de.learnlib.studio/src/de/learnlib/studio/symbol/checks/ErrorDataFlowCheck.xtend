package de.learnlib.studio.symbol.checks

import java.util.List

import graphmodel.Node

import de.jabc.cinco.meta.plugin.mcam.runtime.core.CincoCheckModule
import de.learnlib.studio.symbol.symbol.Symbol
import de.learnlib.studio.symbol.mcam.adapter.SymbolId
import de.learnlib.studio.symbol.mcam.adapter.SymbolAdapter
import de.learnlib.studio.symbol.symbol.DataFlow
import de.learnlib.studio.symbol.symbol.ControlFlow
import de.learnlib.studio.symbol.symbol.Sib
import de.learnlib.studio.symbol.symbol.Port
import de.learnlib.studio.symbol.symbol.GeneralPort
import de.learnlib.studio.symbol.symbol.SibPort


class ErrorDataFlowCheck extends CincoCheckModule<SymbolId, Symbol, SymbolAdapter> {
	
	override check(Symbol symbol) {
		val dataFlows = symbol.getEdges(DataFlow)
		
		dataFlows.forEach[df | 
			checkDataFlow(df)
		]
	}
	
	private def checkDataFlow(DataFlow dataFlow) {
		val dfSource = dataFlow.sourceElement
		val dfTarget = dataFlow.targetElement
		
		if (dfSource.dataType != dfTarget.dataType) {
			addError(dataFlow, "Data Types are not matching.")
		}
		
		val startSib = dfSource.container as Node
		val endSib   = dfTarget.container as Node
		
		val paths = startSib.findPathsTo(endSib)
		paths.forEach[path| path.add(0, startSib)]

		if (paths.empty) {
			addWarning(dataFlow, "Data Flow between unreachable blocks.")
		} else if (pathWithErrorExists(paths)) {
			addWarning(dataFlow, "Data Flow along possible error connection.")
		}	
	}
	
	private def getDataType(Port port) {
		switch (port) {
			GeneralPort: port.dataType
			SibPort:     port.dataType
		}
	}
	
	private def pathWithErrorExists(List<List<Node>> paths) {
		for (List<Node> path : paths) {
			var i = 0
			do {
				val currentNode = path.get(i)
				val nextNode    = path.get(i + 1)	
				
				if(currentNode instanceof Sib) {
					val allSibErrorBranches = currentNode.branches.filter[error].map[name]
				
					val controlFlows = currentNode.getOutgoing(ControlFlow).filter[c | c.targetElement == nextNode]
					for (ControlFlow cf : controlFlows) {
						
						val controlFlowBranches = cf.branches
        
       					if (allSibErrorBranches.exists[controlFlowBranches.contains(it)]) {
       						return true
       					}
					}
				}
				
				i++
			} while (i < path.length - 1)
		}
		
		return false
	}
	
}
