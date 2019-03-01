package de.learnlib.studio.experiment.codegen.templates.blocks.learner

import org.eclipse.xtend.lib.annotations.Data

import de.learnlib.studio.experiment.codegen.GeneratorContext
import de.learnlib.studio.experiment.codegen.templates.PerNodeTemplate
import de.learnlib.studio.experiment.experiment.QueryEdge
import de.learnlib.studio.experiment.experiment.TTTAlgorithm


class TTTBlockTemplate extends AbstractLearnerBlockTemplate<TTTAlgorithm> implements PerNodeTemplate<TTTAlgorithm> {
	
	@Data
	static class AcexAnalyzerConstructorWrapper {
		val String acexAnalyzer
		
		override toString() {
			return acexAnalyzer
		}
	}
	
	new(GeneratorContext context) {
        this(context, null, -1)
    }
	
	new(GeneratorContext context, TTTAlgorithm learner, int i) {
		super(context, learner, i, "tttLearner", "learnlib-ttt", "de.learnlib.algorithms.ttt.mealy", "TTTLearnerMealy", "TTTLearnerMealyBuilder", "de.learnlib.algorithms.ttt.base", "TTTLearnerState")
	}
	
    override getAdditionalLearnerImports() {
        return #["de.learnlib.acex.AcexAnalyzer"]
    }
    
	override getExperimentImports() {
		return super.experimentImports + #["de.learnlib.acex.analyzers.AcexAnalyzers"]
	}
	
    override getAdditionalVariables() {
        return #["AcexAnalyzer" -> "acexAnalyzer"]
    }
	
    override getConstructorParameters() {
        var oracleNode = getOutgoing(QueryEdge).get(0).targetElement
        
        return #[name, oracleNode, acexAnalyzerAsConstructorParameter]
    }
	
    override protected getBuilderStatement() '''
        learner = new « builderClass »<String, String>()
                                               .withAlphabet(oracle.getAlphabet())
                                               .withOracle(oracle.getOracle())
                                               .withAnalyzer(acexAnalyzer)
                                               .create();
    '''
	
	private def getAcexAnalyzerAsConstructorParameter() {
	    val analyzerEnumName = switch (node.acexAnalyzer) {
	        case LINEAR_FORWARD:         "LINEAR_FWD"
	        case LINEAR_BACKWARD:        "LINEAR_BWD"
	        case BINARY_SEARCH_BACKWARD: "BINARY_SEARCH_BWD"
	        case BINARY_SEARCH_FORWARD:  "BINARY_SEARCH_FWD"
	        case EXPONENTIAL_BACKWARD:   "EXPONENTIAL_BWD"
	        case EXPONENTIAL_FORWARD:    "EXPONENTIAL_FWD"
	    }
	    
	    val fullAnalyzerName = "AcexAnalyzers." + analyzerEnumName
	    
	    return new AcexAnalyzerConstructorWrapper(fullAnalyzerName)
	}
}
