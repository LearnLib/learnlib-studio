package de.learnlib.studio.experiment.hooks

import de.jabc.cinco.meta.runtime.action.CincoCustomAction

import de.learnlib.studio.experiment.experiment.SULMembershipOracleSymbol


class OpenSymbol extends CincoCustomAction<SULMembershipOracleSymbol> {
    
    override getName() {
        return "Open Symbol"
    }
    
    override execute(SULMembershipOracleSymbol symbol) {
        symbol.symbolReference.openEditor()
    }
    
    override hasDoneChanges() {
        return false
    }
    
}
