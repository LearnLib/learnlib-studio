package de.learnlib.studio.experiment.codegen.templates.serialization

import de.learnlib.studio.experiment.codegen.templates.AbstractSourceTemplate
import de.learnlib.studio.experiment.codegen.GeneratorContext
import de.learnlib.studio.experiment.codegen.templates.ExperimentDataTemplate

class ExperimentDataDeserializerTemplate extends AbstractSourceTemplate {
    
    new(GeneratorContext context) {
        super(context, "serialization", "ExperimentDataDeserializer")
    }
    

    override template() '''
        package « package »;
        
        import java.io.File;
        import java.io.FileInputStream;
        import java.io.ObjectInputStream;
        
        import « reference(ExperimentDataTemplate) »;
        
        
        public class ExperimentDataDeserializer {
            
            public ExperimentData read(String fileName) {
                try {
                    File file = new File(fileName);
                    FileInputStream fileInStream = new FileInputStream(file);
                    ObjectInputStream objectInStream = new ObjectInputStream(fileInStream);
                    
                    ExperimentData data = (ExperimentData) objectInStream.readObject();
                    
                    System.out.println("Read data from " + file.toString());
                    
                    objectInStream.close();
                    
                    return data;
                } catch (Exception e) {
                    e.printStackTrace();
                    return null;
                }
            }
            
        }
    '''
    
}