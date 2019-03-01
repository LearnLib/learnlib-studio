package de.learnlib.studio.experiment.codegen.templates

import de.learnlib.studio.experiment.codegen.GeneratorContext
import de.learnlib.studio.experiment.codegen.templates.config.CommandLineOptionsTemplate
import de.learnlib.studio.experiment.codegen.templates.config.CommandLineOptionsHandlerTemplate
import de.learnlib.studio.experiment.codegen.templates.serialization.ExperimentDataDeserializerTemplate
import de.learnlib.studio.experiment.codegen.providers.ExperimentConfigurationsProvider

class MainTemplate extends AbstractSourceTemplate {

    new(GeneratorContext context) {
        super(context, "Main")
    }

    override template() '''
        package «package»;
        
        import java.util.List;
        import java.util.ArrayList;
        
        import « reference(CommandLineOptionsTemplate) »;
        import « reference(CommandLineOptionsHandlerTemplate) »;
        import « reference(ExperimentDataTemplate) »;
        import « reference(ExperimentDataDeserializerTemplate) »;
        
        
        public class Main {
            
            public static void main(String[] args) {
                CommandLineOptionsHandler optionsHandler = new CommandLineOptionsHandler();
                boolean parsingOk = optionsHandler.parse(args);
                
                if (parsingOk) {
                    List<AbstractExperiment> experiments = createExperiments();
                    
                    if (CommandLineOptions.LIST.isSet()) {
                        printConfigurationsList(experiments);
                    } else if (CommandLineOptions.SELECT_CONFIGURATION.isSet()) {
                    	String configurationNoAsString = System.getProperty(CommandLineOptions.SELECT_CONFIGURATION.getSystemProperty());
                    	System.out.println("Selected Configuration No. " + configurationNoAsString);
                    	
                    	int configurationNo = Integer.parseInt(configurationNoAsString) - 1;
                    	AbstractExperiment experiment = experiments.get(configurationNo);
                    	
                    	experiment.executeAll();
                    } else {
                        runAllExperiments(experiments);
                    }
                }
            }
            
            private static List<AbstractExperiment> createExperiments() {
            	List<AbstractExperiment> experiments = new ArrayList<>(« experimentClassNames.size »);
            	
            	« FOR experimentName : experimentClassNames SEPARATOR "\n" »
                    « experimentName » « experimentName.toFirstLower » = new « experimentName »();
                    experiments.add(« experimentName.toFirstLower »);
                « ENDFOR »
            	
            	return experiments;
        	}
        	
        	private static void printConfigurationsList(List<AbstractExperiment> experiments) {
        		for (int i = 0; i < experiments.size(); i++) {
                    AbstractExperiment experiment = experiments.get(i);
                    System.out.println("Configuration " + (i + 1) + ": " + experiment.getConfigurationAsString());
                }
        	}
        	
        	private static void runAllExperiments(List<AbstractExperiment> experiments) {
        		for (AbstractExperiment experiment : experiments) {
                    System.out.println(" --- " + experiment.getConfigurationAsString() + " ---");
                    if (CommandLineOptions.RESUME.isSet()) {
                        String fileName = System.getProperty(CommandLineOptions.RESUME.getSystemProperty());
                        ExperimentDataDeserializer deserializer = new ExperimentDataDeserializer();
                        ExperimentData data = deserializer.read(fileName);
                        experiment.setData(data);
                    }
                    
                    if (CommandLineOptions.SINGLE_STEP.isSet()) {
                        experiment.executeOne();
                        System.out.println();
                    } else {
                        experiment.executeAll();
                    }
                }
        	}
            
        }
        
    '''

    def getExperimentClassNames() {
        val configurations = context.getProvider(ExperimentConfigurationsProvider).configurations
        val baseName = context.model.name.toFirstUpper
        
        if (configurations.size == 1) {
            return #[baseName]
        } else {
            val results = newLinkedList()
            configurations.forEach[config, i |
                results += baseName + (i + 1)  
            ]
            return results
        }
    }

}
