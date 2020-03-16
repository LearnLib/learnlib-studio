package de.learnlib.studio.experiment.codegen.templates.blocks.eqoracle

import de.learnlib.studio.experiment.experiment.MealySimulatorEQOracle
import de.learnlib.studio.experiment.codegen.GeneratorContext
import de.learnlib.studio.experiment.codegen.utils.EscapeUtils

class SimulatorEqOracleBlockTemplate extends AbstractEqBlockTemplate<MealySimulatorEQOracle> {
	
	protected extension EscapeUtils = new EscapeUtils
	
	new(GeneratorContext context) {
        super(context, "MealySimulator", "MealySimulatorEQOracle")
    }

    new(GeneratorContext context, MealySimulatorEQOracle node, int i) {
        super(context, node, i, "MealySimulator", "MealySimulatorEQOracle")
    }
					
	override protected createEqOracleTemplate() '''
		final MealyAutomaton«getIncomingAutomatonId» automaton = new MealyAutomaton«getIncomingAutomatonId»();	
		return new MealySimulatorEQOracle<>(automaton.getAutomaton());
	'''
	
	override protected additionalImportsTemplate() '''
		import de.learnlib.oracle.equivalence.MealySimulatorEQOracle;		
		import «context.modelPackage».automata.MealyAutomaton«getIncomingAutomatonId»;
	'''
	
	private def getIncomingAutomatonId() {
		return node.incomingModelEdges.head.sourceElement.id.escapeId
	}
}