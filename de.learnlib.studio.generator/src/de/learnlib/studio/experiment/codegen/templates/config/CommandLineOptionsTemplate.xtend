package de.learnlib.studio.experiment.codegen.templates.config

import de.learnlib.studio.experiment.codegen.GeneratorContext
import de.learnlib.studio.experiment.codegen.templates.AbstractSourceTemplate


class CommandLineOptionsTemplate extends AbstractSourceTemplate {

    new(GeneratorContext context) {
        super(context, "config", "CommandLineOptions")
    }

    override template() '''
        package «package»;
        
        import org.apache.commons.cli.Option;
        
        
        public enum CommandLineOptions {
        	
        	SINGLE_STEP(Option.builder("s")
                              .longOpt("singlestep")
                              .argName("Single Step")
                              .desc("Only do one step at a time.")
                              .build(),
                        "singlestep"),
        	
        	RESUME(Option.builder("i")
                         .longOpt("inputFile")
                         .argName("Input File")
                         .desc("Load the state of a previous run from an input file.")
                         .numberOfArgs(1)
                         .build(),
        	       "resume_file"),
        	       
        	LIST(Option.builder()
                         .longOpt("list")
                         .argName("List Experiment Configurations")
                         .desc("List all possible Experiment Configurations.")
                         .build(),
                   "list_configurations"),
            
            SELECT_CONFIGURATION(Option.builder("c")
                         .longOpt("configuration")
                         .argName("Select a Configuration")
                         .desc("Select one Experiment Configuration.")
                         .numberOfArgs(1)
                         .build(),
                   "set_configuration"),

            SELECT_OUPUT_DIR(Option.builder("o")
                                     .longOpt("output")
                                     .argName("The output directory")
                                     .desc("Select the output directory.")
                                     .numberOfArgs(1)
                                     .build(),
                               "outputDir",
                               "result"),

        	VERBOSE(Option.builder("v")
                          .longOpt("verbose")
                          .argName("Verbose")
                          .desc("Print out more details.")
                          .build(),
                    "verbose"),
        	
        	HELP(Option.builder("h")
                       .longOpt("help")
                       .argName("Help")
                       .desc("Print this help message.")
                       .build(),
                 "");
        	
        	
        	private Option option;
        	private String systemProperty;
        	private String defaultValue;
        	
        	
        	private CommandLineOptions(Option option, String systemProperty) {
        		this.option         = option;
        		this.systemProperty = systemProperty;
        	}
        	
        	private CommandLineOptions(Option option, String systemProperty, String defaultValue) {
                this.option         = option;
                this.systemProperty = systemProperty;
                this.defaultValue   = defaultValue;
            }
        	
        	public Option getOption() {
        		return option;
        	}
        	
        	public String getSystemProperty() {
        		return "« context.modelName »." + systemProperty;
        	}
        	
        	public String getDefaultValue() {
        	    return defaultValue;
        	}
        	
        	public boolean isSet() {
        	    String property = System.getProperty(getSystemProperty());
        	    return property != null;
        	}
        }
    '''

}
