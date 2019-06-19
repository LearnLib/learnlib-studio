package de.learnlib.studio.symbol.actions

import de.jabc.cinco.meta.runtime.action.CincoCustomAction
import de.learnlib.studio.symbol.symbol.Symbol


class ToggleDataFlowAction extends CincoCustomAction<Symbol> {

    override getName() {
        return "Show / Hide Data Flow"
    }
    
    override execute(Symbol symbol) {
        symbol.showDataFlow = !symbol.showDataFlow
        symbol.updateModelElements
    }
    
}
