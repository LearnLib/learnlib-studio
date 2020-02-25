package de.learnlib.studio.experiment.codegen.templates.blocks.eqoracle

import java.util.List

import org.eclipse.xtend.lib.annotations.Data

import de.learnlib.studio.experiment.experiment.EQOracle
import de.learnlib.studio.experiment.experiment.QueryEdge
import de.learnlib.studio.experiment.codegen.GeneratorContext
import de.learnlib.studio.experiment.codegen.templates.ExperimentDataTemplate
import de.learnlib.studio.experiment.codegen.templates.blocks.AbstractBlockTemplate
import de.learnlib.studio.experiment.codegen.templates.blocks.AbstractBlockInterfaceImplTemplate
import de.learnlib.studio.experiment.codegen.templates.blocks.BlockInterfaceTemplate
import de.learnlib.studio.experiment.codegen.templates.oracles.ExperimentOracleInterfaceTemplate
import de.learnlib.studio.experiment.codegen.templates.PerNodeTemplate
import de.learnlib.studio.experiment.codegen.providers.LearnLibArtifactProvider
import de.learnlib.studio.experiment.experiment.WordEdge
import de.learnlib.studio.experiment.experiment.ModelEdge

abstract class AbstractEqBlockTemplate<N extends EQOracle>
        extends AbstractBlockTemplate<N>
        implements LearnLibArtifactProvider<N>, PerNodeTemplate<N> {
    
    @Data
    static class Parameter<T> {
    }
    
    @Data
    static class ExposedParameter<T> extends Parameter<T> {
        Class<T> dataType
        String name
        T value
    }
    
    @Data
    static class StaticParameter<T> extends Parameter<T> {
        T value
    }
    
    
    val String learnLibClass
    
    new(GeneratorContext context, String name, String learnLibClass) {
        super(context, "blocks.eqoracles", name + "EqOracle")
        
        this.learnLibClass = learnLibClass
    }
    
    new(GeneratorContext context, N node, int i, String name, String learnLibClass) {
        super(context, node, i, "blocks.eqoracles", name + "EqOracle")
        
        this.learnLibClass = learnLibClass
    }
    
    override learnLibArtifacts() {
        return #["learnlib-equivalence-oracles"]
    }
    
    override getConstructorParameters() {
        var oracleNode = getOutgoing(QueryEdge).head.targetElement
        
        return #[name, oracleNode] + additionalParameters.filter(ExposedParameter).map[value]
    }
    
    override getSuccessors() {
    	val wordEdgeTarget  = getOutgoing(WordEdge).head.targetElement
        val modelEdgeTarget = getOutgoing(ModelEdge).head.targetElement
        
        return #["word" -> wordEdgeTarget, "model" -> modelEdgeTarget]
    }
    
    def List<Parameter<?>> getAdditionalParameters()
    
    override template() '''
        package « package »;

        import java.util.Random;

        import de.learnlib.api.oracle.EquivalenceOracle.MealyEquivalenceOracle;
        import de.learnlib.api.query.DefaultQuery;

        import de.learnlib.oracle.equivalence.« learnLibClass »;

        import net.automatalib.words.Word;

        import « reference(BlockInterfaceTemplate) »;
        import « reference(ExperimentDataTemplate) »;
        import « reference(ExperimentOracleInterfaceTemplate) »;
        import « reference(AbstractBlockInterfaceImplTemplate) »;


        public class « className » implements Block {

            private String blockId;

            private transient final ExperimentOracle oracle;

            « FOR p : additionalParameters.filter(ExposedParameter) »
                private final « p.dataType.name » « p.name »;
            « ENDFOR »
            
            private transient DefaultQuery<String, Word<String>> counterExample;
            
            private transient Block wordSuccessor;
            private transient Block modelSuccessor;
            
            public « className »(String blockId, ExperimentOracle oracle« constructorParameterList ») {
                this.blockId = blockId;
                this.oracle = oracle;
                
                « FOR p : additionalParameters.filter(ExposedParameter) »
                    this.« p.name » = « p.name »;
                « ENDFOR »
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
                return "Searching for a counter example with « className »(" + « FOR p : additionalParameters SEPARATOR " + \", \" + " AFTER " + " »« parameterValue(p) »« ENDFOR »")";
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
                MealyEquivalenceOracle<String, String> eqOracle = new « learnLibClass »<>(oracle.getOracle()« FOR p : additionalParameters », « parameterValue(p) »« ENDFOR »);
                
                // Counterexample Search
                counterExample = eqOracle.findCounterExample(data.getHypothesis(), oracle.getAlphabet());
                data.setCounterexample(counterExample);
                
                oracle.postBlock();
                
                // Next Step, depending if a Counterexample was found or not
                System.out.println("Counter Example:" + counterExample);
                System.out.println("\tModel Successor: " + modelSuccessor);
                System.out.println("\tWord Successor: " + wordSuccessor);
                if (counterExample == null) {
                    return modelSuccessor;
                } else {
                    return wordSuccessor;
                }
            }
            
        }
    '''
    
    private def parameterValue(Parameter<?> parameter) {
        switch (parameter) {
            ExposedParameter: parameter.name
            StaticParameter:  parameter.value
        }
    }
    
    private def getConstructorParameterList() '''
        « FOR p : additionalParameters.filter(ExposedParameter) », « p.dataType.name » « p.name »« ENDFOR »'''
}