package de.learnlib.studio.utils

import style.StyleFactory


class Colors {
    
    static public val BLACK       = color(  0,   0,   0)
    static public val LIGTH_GRAY  = color(229, 229, 229)

    static public val RED         = color(255,   0,   0)
    static public val LIGHT_RED   = color(255, 102, 102)

	static public val GREEN       = color(  0, 255,   0)
    static public val DARK_GREEN  = color(182, 211, 207)
    static public val LIGHT_GREEN = color(144, 238, 144)
    
    static public val BLUE        = color(  0,   0, 255)
    
    static public val ORANGE      = color(255, 158,   0)
 	
    
    static def color(int r, int g, int b) {
        val color = StyleFactory.eINSTANCE.createColor()
        color.r = r
        color.g = g
        color.b = b 
        return color
    }

}
