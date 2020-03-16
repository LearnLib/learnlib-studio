package de.learnlib.studio.experiment.codegen.templates.blocks.eqoracle

import de.learnlib.studio.experiment.codegen.GeneratorContext
import de.learnlib.studio.experiment.codegen.templates.ExperimentDataTemplate
import de.learnlib.studio.experiment.codegen.templates.PerNodeTemplate
import de.learnlib.studio.experiment.codegen.templates.blocks.AbstractBlockInterfaceImplTemplate
import de.learnlib.studio.experiment.codegen.templates.blocks.AbstractBlockTemplate
import de.learnlib.studio.experiment.codegen.templates.blocks.BlockInterfaceTemplate
import de.learnlib.studio.experiment.codegen.templates.oracles.ExperimentOracleInterfaceTemplate
import de.learnlib.studio.experiment.experiment.EQOracle
import de.learnlib.studio.experiment.experiment.WordEdge

abstract class AbstractEqBlockTemplate<N extends EQOracle>
        extends AbstractBlockTemplate<N>
        implements PerNodeTemplate<N> {  
    
    val String learnLibClass
    
    new(GeneratorContext context, String name, String learnLibClass) {
        super(context, "blocks.eqoracles", name + "EqOracle")
        
        this.learnLibClass = learnLibClass
    }
    
    new(GeneratorContext context, N node, int i, String name, String learnLibClass) {
        super(context, node, i, "blocks.eqoracles", name + "EqOracle")
        
        this.learnLibClass = learnLibClass
    }
        
    override getConstructorParameters() {
        var oracleNode = node.outgoingQueryEdges.head.targetElement
        
        return #[name, oracleNode]
    }
    
    override getSuccessors() {
    	val wordEdgeTarget  = getOutgoing(WordEdge).head.targetElement
        
        return #["word" -> wordEdgeTarget]
    }
            
    protected def String createEqOracleTemplate()
        
    protected def String additionalImportsTemplate()
    
    override template() '''
        package « package »;

        import de.learnlib.api.oracle.EquivalenceOracle.MealyEquivalenceOracle;
        import de.learnlib.api.query.DefaultQuery;
        
        import net.automatalib.words.Word;

		« additionalImportsTemplate »

        import « reference(BlockInterfaceTemplate) »;
        import « reference(ExperimentDataTemplate) »;
        import « reference(ExperimentOracleInterfaceTemplate) »;
        import « reference(AbstractBlockInterfaceImplTemplate) »;

        public class « className » implements Block {

            private String blockId;

            private transient final ExperimentOracle oracle;
                        
            private transient DefaultQuery<String, Word<String>> counterExample;
            
            private transient Block wordSuccessor;
            private transient Block modelSuccessor;
            
            public « className »(String blockId, ExperimentOracle oracle) {
                this.blockId = blockId;
                this.oracle = oracle;
            }
            
            public void setModelSuccessor(Block modelSuccessor) {
                this.modelSuccessor = modelSuccessor;
            }
            
            public void setWordSuccessor(Block wordSuccessor) {
                this.wordSuccessor = wordSuccessor;
            }
            
            @Override
            public String getBlockId() {
                return this.blockId;
            }
            
            @Override
            public String startMessage() {
                return "Searching for a counterexample";
            }
            
            @Override
            public String endMessage() {
                if (counterExample == null) {
                    return "No counter example found";
                } else {
                    return "Found counter example " + counterExample;
                }
            }
            
            @Override
            public Block execute(ExperimentData data) {
                // Create a new EQ Oracle
                final MealyEquivalenceOracle<String, String> eqOracle = createEqOracle();
                
                // Counterexample Search
                counterExample = eqOracle.findCounterExample(data.getHypothesis(), oracle.getAlphabet());
                data.setCounterexample(counterExample);
                
                oracle.postBlock();
                
                // Next Step, depending if a Counterexample was found or not
                System.out.println("Counterexample:" + counterExample);
                System.out.println("Model Successor: " + modelSuccessor);
                System.out.println("Word Successor: " + wordSuccessor);
                if (counterExample == null) {
                    return modelSuccessor;
                } else {
                    return wordSuccessor;
                }
            }
            
            private MealyEquivalenceOracle<String, String> createEqOracle() {
            	«createEqOracleTemplate»
            }
        }
    '''
}