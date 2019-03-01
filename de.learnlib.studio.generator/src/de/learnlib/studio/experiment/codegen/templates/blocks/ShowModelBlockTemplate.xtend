package de.learnlib.studio.experiment.codegen.templates.blocks

import de.learnlib.studio.experiment.experiment.ShowModel
import de.learnlib.studio.experiment.codegen.GeneratorContext
import de.learnlib.studio.experiment.codegen.providers.AutomataLibArtifactProvider
import de.learnlib.studio.experiment.codegen.templates.ExperimentDataTemplate
import de.learnlib.studio.experiment.codegen.templates.utils.ResultWriterTemplate


class ShowModelBlockTemplate
        extends AbstractBlockTemplate<ShowModel>
        implements AutomataLibArtifactProvider<ShowModel> {

    new(GeneratorContext context) {
        super(context, "blocks", "ShowModel")
    }

    new(GeneratorContext context, ShowModel node, int i) {
        super(context, node, i, "blocks", "ShowModel")
    }

    override automataLibArtifacts() {
        return #["automata-serialization-taf"]
    }
    
    override template() '''
        package «package»;
        
        import java.io.FileOutputStream;
        import java.io.ByteArrayOutputStream;
        import java.io.IOException;
        import java.nio.file.Path;
        
        import « reference(ExperimentDataTemplate) »;
        import « reference(ResultWriterTemplate) »;
        
        import net.automatalib.automata.transducers.MealyMachine;
        import net.automatalib.serialization.taf.TAFSerializationMealy;
        
        
        public class ShowModelBlock extends AbstractBlock {
        	
        	public ShowModelBlock(String blockId) {
        	   super(blockId);
            }
        	
        	@Override
        	public String startMessage() {
        		return "Exporting Model";
        	}
        	
        	@Override
        	public Block execute(ExperimentData data) {
        		@SuppressWarnings("unchecked")
        		MealyMachine<Object, String, Object, String> hypothesis = (MealyMachine<Object, String, Object, String>) data.getHypothesis();
        		
        		try {
        		    // creating dummy buffer because the AUTWriter would otherwise close System.out, which is no good
                    ByteArrayOutputStream out = new ByteArrayOutputStream();
        			TAFSerializationMealy.getInstance().writeModel(out, hypothesis, data.getAlphabet());
        			System.out.println(out);
        		} catch (IOException e) {
        			e.printStackTrace();
        		}
        		
        		try {
        		  Path file = ResultWriter.getFile("model", "mealy");
        		  FileOutputStream fop = new FileOutputStream(file.toFile());
                  TAFSerializationMealy.getInstance().writeModel(fop, hypothesis, data.getAlphabet());
                } catch (IOException e) {
                    e.printStackTrace();
                }
        		
        		return successor;
        	}
            
        }
    '''

}
