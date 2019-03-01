package de.learnlib.studio.tracer.outputparser

import java.io.ByteArrayInputStream
import java.nio.charset.StandardCharsets

import net.automatalib.serialization.taf.TAFSerializationMealy

import de.learnlib.studio.utils.AutomataLibToGratexUtil


class HypothesisOutputParser extends OutputParser {
    
    val String path
    val String name
    
    new(String path, String name) {
        this.path = path
        this.name = name
    }
    
    override parse() {
        val stream = new ByteArrayInputStream(buffer.toString().getBytes(StandardCharsets.UTF_8))
        
        val inputModelData = TAFSerializationMealy.instance.readModel(stream)
        AutomataLibToGratexUtil.createMealy(path, name, inputModelData.model, inputModelData.alphabet)
    }
    
}
