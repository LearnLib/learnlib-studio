package de.learnlib.studio.experiment.codegen.templates.blocks

import de.learnlib.studio.experiment.codegen.GeneratorContext
import de.learnlib.studio.experiment.codegen.templates.AbstractSourceTemplate


class BlockInterfaceTemplate extends AbstractSourceTemplate {
	
	new(GeneratorContext context) {
		super(context, "blocks", "Block")
	}
	
	override template() '''
		package « package »;
		
		import java.io.Serializable;
		
		import «context.modelPackage ».ExperimentData;
		
		
		public interface Block extends Serializable {
			
			String getBlockId();
			
			String startMessage();
			
			default String endMessage() {
			    return "";
		    }
			
			Block execute(ExperimentData data);
			
		}
	'''
	
}
