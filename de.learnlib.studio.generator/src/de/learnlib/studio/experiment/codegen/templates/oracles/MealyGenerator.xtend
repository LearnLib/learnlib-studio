package de.learnlib.studio.experiment.codegen.templates.oracles

import de.learnlib.studio.experiment.codegen.GeneratorContext
import de.learnlib.studio.experiment.codegen.providers.OracleInformationProvider
import de.learnlib.studio.experiment.codegen.templates.AbstractSourceTemplate
import de.learnlib.studio.experiment.codegen.templates.ExperimentDataTemplate
import de.learnlib.studio.experiment.codegen.templates.PerNodeTemplate
import de.learnlib.studio.experiment.codegen.utils.EscapeUtils
import de.learnlib.studio.experiment.experiment.MealySULMembershipOracle

class MealyGenerator
        extends AbstractSourceTemplate
        implements OracleInformationProvider<MealySULMembershipOracle>,
                   PerNodeTemplate<MealySULMembershipOracle> {
                   	
   	protected extension EscapeUtils = new EscapeUtils
    
    val MealySULMembershipOracle node
        
    new(GeneratorContext context) {
        super(context, "")
        this.node      = null 
    }
    
    new(GeneratorContext context, MealySULMembershipOracle node, int i) {
        super(context, "oracles")
        this.node = node
    }
        
    override getExperimentImports() {
        #[fullName]
    }
    
    override getConstructorParameters() {
        return #[]
    }
    
    override getNode() {
        return node
    }
        
    override template() '''
        package « package »;
        
        import de.name.automata.MealyAutomaton«automatonId.escapeId»;
        
        import net.automatalib.words.Alphabet;
                
        import de.learnlib.api.oracle.MembershipOracle.MealyMembershipOracle;
        import de.learnlib.oracle.membership.SimulatorOracle.MealySimulatorOracle;
        
        import « reference(ExperimentOracleInterfaceTemplate) »;
        import « reference(ExperimentDataTemplate) »;
              
        public final class « className » implements ExperimentOracle {
            
            private MealyMembershipOracle<String, String> oracle;
            private Alphabet<String> alphabet;
            
            public « className »() {                                               
                final MealyAutomaton«automatonId.escapeId» automaton = new MealyAutomaton«automatonId.escapeId»();
                this.alphabet = automaton.getAlphabet();
                this.oracle = new MealySimulatorOracle<>(automaton.getAutomaton());
            } 
            
            public Alphabet getAlphabet() {
                return alphabet;
            }
            
            public MealyMembershipOracle<String, String> getOracle() {
                return oracle;
            }
            
            @Override
            public void postBlock() {
            }
        }
        
    '''
    
    def getAutomatonId() {
    	node.outgoingSULEdges.head.targetElement.incomingModelEdges.head.sourceElement.id
    }
}
