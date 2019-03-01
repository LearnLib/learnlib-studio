package de.learnlib.studio.experiment.codegen.templates.config

import de.learnlib.studio.experiment.codegen.templates.AbstractSourceTemplate
import de.learnlib.studio.experiment.codegen.GeneratorContext


class CommandLineOptionsHandlerTemplate extends AbstractSourceTemplate {

    new(GeneratorContext context) {
        super(context, "config", "CommandLineOptionsHandler")
    }

    override template() '''
        package «package»;
        
        import org.apache.commons.cli.CommandLine;
        import org.apache.commons.cli.DefaultParser;
        import org.apache.commons.cli.HelpFormatter;
        import org.apache.commons.cli.Option;
        import org.apache.commons.cli.Options;
        import org.apache.commons.cli.ParseException;
        
        
        public class CommandLineOptionsHandler {
        
        	private Options options;
        	
        	public CommandLineOptionsHandler() {
        		this.options = new Options();
        		for (CommandLineOptions option : CommandLineOptions.values()) {
        			options.addOption(option.getOption());
        		}
        	}
        	
        	public boolean parse(String[] args) {
        		DefaultParser parser = new DefaultParser();
        		try {
        			CommandLine line = parser.parse(options, args);
        			
        			if (line.hasOption(CommandLineOptions.HELP.getOption().getOpt())) {
        				printHelpMessage();
        				return false;
        			}
        			
        			for (CommandLineOptions option : CommandLineOptions.values()) {
        			    Option cliOption = option.getOption();
        			    
                        String systemProperty = option.getSystemProperty();
                        
        			    String cliOptionAsString = cliOption.getOpt();
        			    if (cliOptionAsString == null) {
        			        cliOptionAsString = cliOption.getLongOpt();
        			    }
        			    
        				if (line.hasOption(cliOptionAsString)) {
        				    if (cliOption.hasArg()) {
                                System.setProperty(systemProperty, line.getOptionValue(cliOption.getOpt()));
                            } else {
                                System.setProperty(systemProperty, "true");
                            }
        				} else {
        				    String defaultValue = option.getDefaultValue();
        				    if (defaultValue != null) {
        				        System.setProperty(systemProperty, defaultValue);
        				    }
        				}
        			}
        			
        		} catch(ParseException e) {
        			printHelpMessage();
        			return false;
        		}
        		
        		return true;
        	}
        
        	private void printHelpMessage() {
        		HelpFormatter helpFormatter = new HelpFormatter();
        		helpFormatter.printHelp("Experiment",
        							    "Experiment created with LearnLib Studio.",
        							    options,
        							    "",
        							    true);
        	}
        	
        }
        
    '''

}
