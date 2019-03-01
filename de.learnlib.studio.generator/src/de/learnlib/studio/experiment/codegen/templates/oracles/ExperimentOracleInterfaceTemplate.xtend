package de.learnlib.studio.experiment.codegen.templates.oracles

import de.learnlib.studio.experiment.codegen.GeneratorContext
import de.learnlib.studio.experiment.codegen.templates.AbstractSourceTemplate
import de.learnlib.studio.experiment.codegen.providers.LearnLibArtifactProvider
import de.learnlib.studio.experiment.experiment.Oracle


class ExperimentOracleInterfaceTemplate
        extends AbstractSourceTemplate
        implements LearnLibArtifactProvider<Oracle> {
	
	new(GeneratorContext context) {
		super(context, "oracles", "ExperimentOracle")
	}
	
	override learnLibArtifacts() {
        #["learnlib-membership-oracles"]
    }
    
	override template() '''
		package « package »;
		
		import net.automatalib.words.Alphabet;
		import de.learnlib.api.oracle.MembershipOracle.MealyMembershipOracle;
		
		
		public interface « className » {
			
			Alphabet getAlphabet();
			
			MealyMembershipOracle<String, String> getOracle();
			
			void postBlock();
			
		}
	'''
	
}
