package de.learnlib.studio.experiment.codegen.templates.blocks.learner

import java.util.List

import de.learnlib.studio.experiment.codegen.GeneratorContext
import de.learnlib.studio.experiment.experiment.Learner
import de.learnlib.studio.experiment.codegen.providers.LearnLibArtifactProvider
import de.learnlib.studio.experiment.codegen.templates.blocks.BlockInterfaceTemplate
import de.learnlib.studio.experiment.codegen.templates.ExperimentDataTemplate
import de.learnlib.studio.experiment.codegen.templates.oracles.ExperimentOracleInterfaceTemplate
import de.learnlib.studio.experiment.codegen.templates.blocks.AbstractBlockTemplate
import de.learnlib.studio.experiment.codegen.templates.blocks.AbstractBlockInterfaceImplTemplate
import de.learnlib.studio.experiment.experiment.QueryEdge


abstract class AbstractLearnerBlockTemplate<L extends Learner>
			extends AbstractBlockTemplate<L>
			implements LearnLibArtifactProvider<L> {

    val String learnLibArtifact
    val String learnLibPackage
    val String algorithmClass
    val String builderClass
    val String statePackage
    val String stateClass

    new(GeneratorContext context, L learner, int i, String name, String learnLibArtifact, String learnLibPackage, String algorithmClass, String builderClass, String statePackage, String stateClass) {
        super(context, learner, i, "blocks.learner", name)
        this.learnLibArtifact = learnLibArtifact
        this.learnLibPackage = learnLibPackage
        this.algorithmClass = algorithmClass
        this.builderClass = builderClass
        this.statePackage = statePackage
        this.stateClass = stateClass
    }
    
    override learnLibArtifacts() {
        #[this.learnLibArtifact]
    }
    
    override getConstructorParameters() {
        var oracleNode = getOutgoing(QueryEdge).head.targetElement
        return #[name, oracleNode]
    }

    def getBuilderClass() {
        return builderClass
    }

    def getAdditionalLearnerImports() {
        return #[]
    }
    
    def List<Pair<String, String>> getAdditionalVariables() {
        return #[]
    }

	override template() '''
        package « package »;
        
        import java.io.Serializable;
        
        import « reference(ExperimentDataTemplate) »;
        import « reference(BlockInterfaceTemplate) »;
        
        import de.learnlib.api.algorithm.LearningAlgorithm.MealyLearner;
        import « learnLibPackage ».« algorithmClass »;
        import « learnLibPackage ».« builderClass »;
        import « statePackage ».« stateClass »;
        « FOR additonalImport : getAdditionalLearnerImports() »
            import « additonalImport»;
        « ENDFOR »
        
        import de.learnlib.api.oracle.MembershipOracle.MealyMembershipOracle;
        
        import net.automatalib.automata.transducers.impl.compact.CompactMealy;
        import net.automatalib.automata.transducers.MealyMachine;
        
        import « reference(ExperimentOracleInterfaceTemplate) »;
        import « reference(AbstractBlockInterfaceImplTemplate) »;
        
        
        public class « className » extends AbstractBlock {
        	
        	private transient « algorithmClass » learner;
        	private transient final ExperimentOracle oracle;
        	« FOR variable : additionalVariables »
        	   private transient final « variable.key » « variable.value »;
        	« ENDFOR »
        	
        	
            « constuctorStatement »
        	
        	@Override
        	public String startMessage() {
        		return "Learning with « algorithmClass »";
        	}
        	
        	@Override
        	public Block execute(ExperimentData data) {
        		System.out.println("execute start");
        		boolean firstStep = true;
        		if (learner == null) {
        			« getBuilderStatement() »
                    System.out.println("new learner created");
                    firstStep = !loadLearnerState(data);
                    System.out.println("state 'loaded'");
                } else {
                    firstStep = false;
                }
                
        		if (firstStep) {
        		    System.out.println("starting learning");
        			learner.startLearning();
        		} else {
        		    System.out.println("refining hypothesis" + learner.getHypothesisModel());
        			learner.refineHypothesis(data.getCounterexample());
        		}
        		
        		data.setAlphabet(oracle.getAlphabet());
        		data.setHypothesis((MealyMachine) learner.getHypothesisModel());
        		saveLearnerState(data);
        		
        		oracle.postBlock();
        		
        		System.out.println("done");
        		return successor;
        	}
        	
        	protected void saveLearnerState(ExperimentData data) {
        	   data.setState(blockId, learner.suspend());
            }
        	
        	protected boolean loadLearnerState(ExperimentData data) {
        	    Serializable learnerState = data.getState(blockId);
        	    if (learnerState != null) {
        	        learner.resume((« stateClass ») learnerState);
        	        return true;
        	    } else {
        	        return false;
                }
            }
        	
        }
    '''
    
    protected def getConstuctorStatement() '''
        public « className »(String blockId, ExperimentOracle oracle« getAdditionalVariablesParameterList ») {
            super(blockId);
            this.oracle  = oracle;
            « FOR variable : additionalVariables »
                this.« variable.value » = « variable.value »;
            « ENDFOR»
        }
    '''
    
    private def getAdditionalVariablesParameterList() '''
        « FOR variable : additionalVariables », « variable.key » « variable.value »« ENDFOR»
    '''
    
    protected def getBuilderStatement() '''
        learner = new « builderClass »<String, String>()
                                               .withAlphabet(oracle.getAlphabet())
                                               .withOracle(oracle.getOracle())
                                               .create();
    '''

}
