package de.learnlib.studio.experiment.codegen.templates.blocks

import de.learnlib.studio.experiment.codegen.templates.AbstractSourceTemplate
import de.learnlib.studio.experiment.codegen.GeneratorContext


class AbstractBlockInterfaceImplTemplate extends AbstractSourceTemplate {
    
    new(GeneratorContext context) {
        super(context, "blocks", "AbstractBlock")
    }
    
    override template() '''
        package « package »;
            
        import «context.modelPackage ».ExperimentData;
        
        
        public abstract class AbstractBlock implements Block {
            
            protected transient Block successor;
            protected final String blockId;
            
            
            public AbstractBlock(String blockId) {
                this.blockId = blockId;
            }
            
            @Override
            public String getBlockId() {
                return this.blockId;
            }
            
            public void setDefaultSuccessor(Block successor) {
                this.successor = successor;
            }
            
        }
    '''
    
}