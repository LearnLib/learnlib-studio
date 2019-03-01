package de.learnlib.studio.experiment.checks

import de.learnlib.studio.experiment.mcam.modules.checks.ExperimentCheck
import de.learnlib.studio.experiment.experiment.Experiment
import de.learnlib.studio.experiment.experiment.SULMebembershipOracleSymbolType
import de.learnlib.studio.experiment.experiment.SULMembershipOracle


class SymbolTypeAmountCheck extends ExperimentCheck {
	
	override check(Experiment model) {
	    val sulOracles = model.SULMembershipOracles
	    
	    sulOracles.filter[amountOfGlobalSetUpSymbols > 1]
	              .forEach[addError("To many global set up symbols (at most 1 is allowed)!")]
	    
	    sulOracles.filter[getAmountOfSetUpSymbols > 1]
                  .forEach[addError("To many set up symbols (at most 1 is allowed)!")]
	    
	    sulOracles.filter[amountOfTearDownSymbols > 1]
                  .forEach[addError("To many tear down symbols (at most 1 is allowed)!")]
                  
      sulOracles.filter[amountOfGlobalTearDownSymbols > 1]
                  .forEach[addError("To many global tear down symbols (at most 1 is allowed)!")]
	}
	
	private def getAmountOfGlobalSetUpSymbols(SULMembershipOracle oracle) {
	    return getSymbolsOfType(oracle, SULMebembershipOracleSymbolType.GLOBAL_SET_UP).size
	}
	
	private def getAmountOfSetUpSymbols(SULMembershipOracle oracle) {
        return getSymbolsOfType(oracle, SULMebembershipOracleSymbolType.SET_UP).size
    }
	
	private def getAmountOfTearDownSymbols(SULMembershipOracle oracle) {
        return getSymbolsOfType(oracle, SULMebembershipOracleSymbolType.TEAR_DOWN).size
    }
    
    private def getAmountOfGlobalTearDownSymbols(SULMembershipOracle oracle) {
        return getSymbolsOfType(oracle, SULMebembershipOracleSymbolType.GLOBAL_TEAR_DOWN).size
    }
    
    private def getSymbolsOfType(SULMembershipOracle oracle, SULMebembershipOracleSymbolType type) {
        return oracle.SULMembershipOracleSymbols.filter[symbolType == type]
    }
	
}
