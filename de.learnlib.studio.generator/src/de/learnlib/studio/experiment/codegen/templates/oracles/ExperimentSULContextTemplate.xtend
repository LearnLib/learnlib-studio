package de.learnlib.studio.experiment.codegen.templates.oracles

import de.learnlib.studio.experiment.codegen.templates.AbstractSourceTemplate
import de.learnlib.studio.experiment.codegen.GeneratorContext
import de.learnlib.studio.experiment.codegen.templates.NodeRelatedTemplate
import de.learnlib.studio.experiment.experiment.SULMembershipOracle


class ExperimentSULContextTemplate
        extends AbstractSourceTemplate
        implements NodeRelatedTemplate<SULMembershipOracle> {
    
    new(GeneratorContext context) {
        super(context, "oracles.symbols", "ExperimentSULContext")
    }
    
    override template() '''
        package « package »;
        
        import java.util.Map;
        import java.util.HashMap;
        
        
        public class « className » {
            
            private Map<String, Object> properties;
            private Map<String, Object> globalVariables;
            private Map<String, Object> queryVariables;
            
            public « className »(Map<String, Object> properties) {
                this.properties      = properties;
                this.globalVariables = new HashMap<>();
                this.queryVariables  = new HashMap<>();
            }
            
            public « className »(« className » globalContext) {
                this.properties      = globalContext.properties;
                this.globalVariables = globalContext.globalVariables;
                this.queryVariables  = new HashMap<>();
            }
            
            public void softReset() {
                this.queryVariables.clear();
            }
            
            public void hardReset() {
                this.globalVariables.clear();
                this.queryVariables.clear();
            }
            
            public Object getProperty(String key) {
                return properties.get(key);
            }
            
            public Map<String, Object> getGlobalVariables() {
                return globalVariables;
            }
            
            public Map<String, Object> getQueryVariables() {
                return queryVariables;
            }
            
        }
    '''
    
}