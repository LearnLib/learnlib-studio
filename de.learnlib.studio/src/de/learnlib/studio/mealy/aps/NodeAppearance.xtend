package de.learnlib.studio.mealy.aps

import style.StyleFactory
import de.jabc.cinco.meta.core.ge.style.generator.runtime.appearance.StyleAppearanceProvider

import de.learnlib.studio.utils.Colors
import de.learnlib.studio.mealy.mealy.MealyState


class NodeAppearance implements StyleAppearanceProvider<MealyState> {
    
    val styleFactory = StyleFactory.eINSTANCE
    
    override getAppearance(MealyState element, String text) {
        val appearance = styleFactory.createAppearance()
        appearance.background = getDesiredColor(element.init)
        return appearance
    }
    
    private def getDesiredColor(boolean initState) {
        if (initState) {
            Colors.LIGHT_GREEN
        } else {
            Colors.LIGTH_GRAY
        }
    }
    
}
