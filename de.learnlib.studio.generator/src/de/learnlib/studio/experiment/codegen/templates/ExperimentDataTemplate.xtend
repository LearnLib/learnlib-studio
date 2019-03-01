package de.learnlib.studio.experiment.codegen.templates

import de.learnlib.studio.experiment.codegen.GeneratorContext
import de.learnlib.studio.experiment.codegen.templates.blocks.BlockInterfaceTemplate


class ExperimentDataTemplate extends AbstractSourceTemplate {

    new(GeneratorContext context) {
        super(context, "ExperimentData")
    }

    override template() '''
        package « package »;
        
        import java.io.Serializable;
        import java.util.Map;
        import java.util.HashMap;
        
        import net.automatalib.automata.transducers.MealyMachine;
        import net.automatalib.words.Alphabet;
        import net.automatalib.words.Word;
        
        import de.learnlib.api.oracle.MembershipOracle.MealyMembershipOracle;
        import de.learnlib.api.query.DefaultQuery;
        
        import « reference(BlockInterfaceTemplate) »;
        
        
        public class ExperimentData implements Serializable {
            
            private String currentBlockId;
            
            private Alphabet<String> alphabet;
            
            private MealyMachine hypothesis;
            
            private transient DefaultQuery<String, Word<String>> counterexample;
            
            private Map<String, Serializable> states;
            
            
            public ExperimentData() {
                this.states = new HashMap<>();
            }
            
            public String getCurrentBlockId() {
               return currentBlockId;
            }
            
            public void setCurrentBlock(Block currentBlock) {
                this.currentBlockId = currentBlock.getBlockId();
            }
            
            public Alphabet<String> getAlphabet() {
                return alphabet;
            }
            
        	public void setAlphabet(Alphabet<String> alphabet) {
        		this.alphabet = alphabet;
        	}
            
        	public MealyMachine getHypothesis() {
        	   return hypothesis;
        	}
            
            public void setHypothesis(MealyMachine hypothesis) {
        	   this.hypothesis = hypothesis;
            }
            
        	public DefaultQuery<String, Word<String>> getCounterexample() {
        		return counterexample;
        	}
            
        	public void setCounterexample(DefaultQuery<String, Word<String>> counterexample) {
        		this.counterexample = counterexample;
        	}
        	
            public Serializable getState(String id) {
                return states.get(id);
            }
            
            public void setState(String id, Serializable state) {
                states.put(id, state);
            }
        }
        
    '''

}
