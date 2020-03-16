package de.learnlib.studio.experiment.codegen.templates.automata

import de.learnlib.studio.experiment.codegen.GeneratorContext
import de.learnlib.studio.experiment.experiment.MealyAutomaton
import de.learnlib.studio.experiment.experiment.MealyFileAutomaton
import de.learnlib.studio.experiment.experiment.MealyTextAutomaton
import de.learnlib.studio.experiment.codegen.utils.EscapeUtils
import de.learnlib.studio.mealy.mealy.MealyTransition

class MealyAutomatonGenerator {
	
	val String packageName;
	
	protected extension EscapeUtils = new EscapeUtils
	
	new(GeneratorContext context, String packageName) {
		this.packageName = packageName
	}
		
	def generate(MealyAutomaton node) '''
		package «packageName»;
		
		import java.io.IOException;
		
		import net.automatalib.automata.transducers.MealyMachine;
		import net.automatalib.automata.transducers.impl.compact.CompactMealy;
		import net.automatalib.words.Alphabet;
		import net.automatalib.words.impl.GrowingMapAlphabet;
		
		«automatonImports(node)»
			
		public class MealyAutomaton«node.id.escapeId» {
			
			private MealyMachine<?, String, ?, String> automaton;
			private Alphabet<String> alphabet;
			
			public MealyAutomaton«node.id.escapeId»() {
				createAutomaton();
			}
			
			public MealyMachine<?, String, ?, String> getAutomaton() {
				return automaton;
			}
			
			public Alphabet<String> getAlphabet() {
				return alphabet;
			}
			
			private void createAutomaton() {
				«automatonTemplate(node)»
			}
		}
	'''
	
	def dispatch automatonImports(MealyFileAutomaton node) '''
	'''
	
	def dispatch automatonImports(MealyTextAutomaton node) '''
		« switch node.format {
		    case DOT: '''
		    	import net.automatalib.serialization.InputModelData;
		    	import net.automatalib.serialization.dot.DOTParsers;
		    '''
		    case TAF: '''
		    	import net.automatalib.serialization.taf.parser.TAFParseDiagnosticListener;
		    	import net.automatalib.serialization.taf.parser.TAFParser;
		    '''
	    }»
	'''
	
	def dispatch automatonTemplate(MealyTextAutomaton node)'''
		final String sulAsText = "«node.automaton.toMultiLine»";
			    	
    	try {
	    « switch node.format {
	    case DOT: '''
    		final InputModelData<String, CompactMealy<String, String>> imd = DOTParsers.mealy().readModel(sulAsText.getBytes());
	    	
	    	this.automaton = imd.model;
	    	this.alphabet = imd.alphabet;
	    '''
	    case TAF: '''
	    	final CompactMealy<String, String> mealy = TAFParser.parseMealy(sulAsText, new TAFParseDiagnosticListener() {
	    		@Override
    	        public void error(int i, int i1, String s, Object... objects) {
	            }
	    	            
	            @Override
	            public void warning(int i, int i1, String s, Object... objects) {
	            }
        	});
                	
        	this.automaton = mealy;
        	this.alphabet = mealy.getInputAlphabet();
	    '''
	    } »
	    } catch (IOException ignored) {
    	}
	'''
	
	def dispatch automatonTemplate(MealyFileAutomaton node)'''
		« val transitions = node.automaton.getEdges(MealyTransition) »
		« val states = node.automaton.mealyStates »
    	« val initialState = states.filter[isInit].head »
		
		/* Create Alphabet */
		final Alphabet<String> alphabet = new GrowingMapAlphabet<>();
    	« FOR i : transitions.map[e | e.input].toSet »
		alphabet.add("«i»");
    	« ENDFOR »
		
		/* Create Melay */
		final CompactMealy<String, String> mealy = new CompactMealy<>(alphabet, « states.size »);
		mealy.setInitialState(« states.indexOf(initialState) »);
        « FOR t : transitions »
            « val sourceElement = states.indexOf(t.sourceElement) »
            « val targetElement = states.indexOf(t.targetElement) »
            mealy.addTransition(« sourceElement », "« t.input »", « targetElement », "« t.output »");
        « ENDFOR »
        
        this.automaton = mealy;
        this.alphabet = mealy.getInputAlphabet();
	'''
	
	
	
}