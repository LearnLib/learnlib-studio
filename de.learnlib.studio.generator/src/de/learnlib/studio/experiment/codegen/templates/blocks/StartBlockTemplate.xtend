package de.learnlib.studio.experiment.codegen.templates.blocks

import de.learnlib.studio.experiment.codegen.GeneratorContext
import de.learnlib.studio.experiment.experiment.Start
import de.learnlib.studio.experiment.codegen.templates.ExperimentDataTemplate

class StartBlockTemplate
        extends AbstractBlockTemplate<Start>{
    
    new(GeneratorContext context) {
        super(context, "blocks", "Start")
    }
    
    new(GeneratorContext context, Start node, int i) {
        super(context, node, i, "blocks", "Start")
    }
    
    override getName() {
        "start"
    }
    
    override template() '''
        package « package »;
        
        import « reference(ExperimentDataTemplate) »;
        
        
        public class StartBlock extends AbstractBlock {
            
            public StartBlock(String blockId) {
                super(blockId);
            }
            
            @Override
            public String startMessage() {
                return "Starting";
            }
            
            @Override
            public Block execute(ExperimentData data) {
                return successor;
            }
            
        }
    '''
    
}
