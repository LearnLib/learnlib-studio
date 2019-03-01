package de.learnlib.studio.experiment.aps

import style.StyleFactory
import de.jabc.cinco.meta.core.ge.style.generator.runtime.appearance.StyleAppearanceProvider

import de.learnlib.studio.utils.Colors
import de.learnlib.studio.experiment.experiment.SULMembershipOracleSymbol
import de.learnlib.studio.experiment.experiment.SULMebembershipOracleSymbolType


class SymbolAppearance implements StyleAppearanceProvider<SULMembershipOracleSymbol> {
    
    val styleFactory = StyleFactory.eINSTANCE
    
    override getAppearance(SULMembershipOracleSymbol element, String text) {
        val appearance = styleFactory.createAppearance()
        appearance.background = getDesiredColor(element.symbolType)
        return appearance
    }
    
    private def getDesiredColor(SULMebembershipOracleSymbolType type) {
        switch type {
            case GLOBAL_SET_UP:    Colors.GREEN
            case SET_UP:           Colors.LIGHT_GREEN
            case TEAR_DOWN:        Colors.LIGHT_RED
            case GLOBAL_TEAR_DOWN: Colors.RED
            default:               Colors.LIGTH_GRAY
        }
    }
    
}
