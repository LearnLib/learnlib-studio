package de.learnlib.studio.utils

import java.util.HashMap

//import de.jabc.cinco.meta.runtime.xapi.WorkbenchExtension

import de.learnlib.studio.mealy.factory.MealyFactory
import de.learnlib.studio.mealy.mealy.Mealy
import de.learnlib.studio.mealy.mealy.MealyState
import net.automatalib.automata.transducers.MealyMachine
import net.automatalib.words.Alphabet


class AutomataLibToGratexUtil {
    
    static def createMealy(String path, String name, MealyMachine<?, String, ?, String> automaton, Alphabet<String> alphabet) {
        val f = MealyFactory.eINSTANCE
        
        val newMealy = f.createMealy(path, name)
        
        createMealyDiagram(automaton, alphabet, newMealy);
        
        new GraphLayouter().layout(newMealy.allNodes)
        newMealy.save()
    }
    
    static private def createMealyDiagram(MealyMachine hypothesis, Alphabet<String> alphabet, Mealy newMealy) {
        val stateAmount         = hypothesis.states.size
        val hypothesesInitState = hypothesis.initialState
        
        // States
        val stateMap = new HashMap<Object, MealyState>(stateAmount);
        hypothesis.forEach[state, i |
            val newMealyState = newMealy.newMealyState(0, 0)
            
            newMealyState.setLabel("q" + i )
            
            if (state == hypothesesInitState) {
                newMealyState.setInit(true)
            }
            
            stateMap.put(state, newMealyState)
        ]
        
        // Transitions
        hypothesis.forEach[state |
            for (String input : alphabet) {
                val newCurrent          = stateMap.get(state)
                val hypothesesSuccessor = hypothesis.getSuccessor(state, input)
                val newSuccessor        = stateMap.get(hypothesesSuccessor)
                val output              = hypothesis.getOutput(state, input).toString()
                
                val newMealyTransition = newCurrent.newMealyTransition(newSuccessor)
                newMealyTransition.setInput (input)
                newMealyTransition.setOutput(output)
            }
        ]
    }
    
}
