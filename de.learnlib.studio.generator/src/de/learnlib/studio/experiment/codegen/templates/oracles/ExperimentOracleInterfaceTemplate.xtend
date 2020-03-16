package de.learnlib.studio.experiment.codegen.templates.oracles

import de.learnlib.studio.experiment.codegen.GeneratorContext
import de.learnlib.studio.experiment.codegen.templates.AbstractSourceTemplate

class ExperimentOracleInterfaceTemplate extends AbstractSourceTemplate {
	
	new(GeneratorContext context) {
		super(context, "oracles", "ExperimentOracle")
	}
	
	override template() '''
		package « package »;
		
		import net.automatalib.words.Alphabet;
		import de.learnlib.api.oracle.MembershipOracle.MealyMembershipOracle;
		
		
		public interface « className » {
			
			Alphabet<String> getAlphabet();
			
			MealyMembershipOracle<String, String> getOracle();
			
			void postBlock();
			
		}
	'''
	
}
