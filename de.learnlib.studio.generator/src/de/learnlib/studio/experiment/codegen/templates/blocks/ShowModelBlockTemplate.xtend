package de.learnlib.studio.experiment.codegen.templates.blocks

import de.learnlib.studio.experiment.experiment.ShowModel
import de.learnlib.studio.experiment.codegen.GeneratorContext
import de.learnlib.studio.experiment.codegen.templates.ExperimentDataTemplate
import de.learnlib.studio.experiment.codegen.templates.utils.ResultWriterTemplate
import de.learnlib.studio.experiment.codegen.templates.PerNodeTemplate

class ShowModelBlockTemplate extends AbstractBlockTemplate<ShowModel> implements PerNodeTemplate<ShowModel> {

    new(GeneratorContext context) {
        super(context, "blocks", "ShowModel")
    }
    
    new(GeneratorContext context, ShowModel node, int i) {
        super(context, node, i, "blocks", "ShowModel")
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
        import net.automatalib.serialization.dot.GraphDOT;
        
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
        		final MealyMachine<Object, String, Object, String> hypothesis = (MealyMachine<Object, String, Object, String>) data.getHypothesis();
        		
        		try {
        			«switch node.format {
        				case TAF: '''
        				// creating dummy buffer because the AUTWriter would otherwise close System.out
        				final ByteArrayOutputStream out = new ByteArrayOutputStream();
        				TAFSerializationMealy.getInstance().writeModel(out, hypothesis, data.getAlphabet());
        				System.out.println(out);
        				'''
        				case DOT: '''
						final StringBuilder sb = new StringBuilder();
						GraphDOT.write(hypothesis, data.getAlphabet(), sb);
						System.out.println(sb.toString());
        				'''       
        			}»
        		} catch (IOException e) {
        			e.printStackTrace();
        		}
        		
        		try {
        		  final Path file = ResultWriter.getFile("model", "mealy");
        		  final FileOutputStream fop = new FileOutputStream(file.toFile());
                  TAFSerializationMealy.getInstance().writeModel(fop, hypothesis, data.getAlphabet());
                } catch (IOException e) {
                    e.printStackTrace();
                }
        		
        		return successor;
        	}
            
        }
    '''

}
