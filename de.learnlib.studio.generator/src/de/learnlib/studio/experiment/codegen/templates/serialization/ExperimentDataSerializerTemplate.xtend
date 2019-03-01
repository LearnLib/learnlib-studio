package de.learnlib.studio.experiment.codegen.templates.serialization

import de.learnlib.studio.experiment.codegen.templates.AbstractSourceTemplate
import de.learnlib.studio.experiment.codegen.GeneratorContext
import de.learnlib.studio.experiment.codegen.templates.ExperimentDataTemplate

class ExperimentDataSerializerTemplate extends AbstractSourceTemplate {
    
    new(GeneratorContext context) {
        super(context, "serialization", "ExperimentDataSerializer")
    }
    

    override template() '''
        package « package »;
        
        import java.io.File;
        import java.io.FileOutputStream;
        import java.io.ObjectOutputStream;
        
        import « reference(ExperimentDataTemplate) »;
        
        public class ExperimentDataSerializer {
            
            public void write(ExperimentData data) {
                try {
                    File file = File.createTempFile("experiment-data", ".ser");
                    FileOutputStream fileOutStream = new FileOutputStream(file);
                    ObjectOutputStream objectOutStream = new ObjectOutputStream(fileOutStream);
                    
                    objectOutStream.writeObject(data);
                    
                    System.out.println("     Wrote state to " + file.toString());
                    
                    objectOutStream.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            
        }
    '''
    
}