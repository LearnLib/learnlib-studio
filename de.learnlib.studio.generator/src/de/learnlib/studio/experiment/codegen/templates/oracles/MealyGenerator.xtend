package de.learnlib.studio.experiment.codegen.templates.oracles

import de.jabc.cinco.meta.core.utils.EclipseFileUtils

import de.learnlib.studio.experiment.codegen.GeneratorContext
import de.learnlib.studio.experiment.experiment.MealyMembershipOracle
import de.learnlib.studio.mealy.mealy.Mealy
import de.learnlib.studio.mealy.mealy.MealyTransition
import de.learnlib.studio.experiment.codegen.templates.PerNodeTemplate
import de.learnlib.studio.experiment.codegen.templates.AbstractSourceTemplate
import de.learnlib.studio.experiment.codegen.providers.OracleInformationProvider
import de.learnlib.studio.experiment.codegen.providers.LearnLibArtifactProvider
import de.learnlib.studio.experiment.codegen.templates.ExperimentDataTemplate


class MealyGenerator
        extends AbstractSourceTemplate
        implements OracleInformationProvider<MealyMembershipOracle>,
                   PerNodeTemplate<MealyMembershipOracle>,
                   LearnLibArtifactProvider<MealyMembershipOracle> {
    
    val MealyMembershipOracle node
    val Mealy  model
    val String modelName
    
    new(GeneratorContext context) {
        super(context, "")
        this.node      = null
        this.model     = null
        this.modelName = null    
    }
    
    new(GeneratorContext context, MealyMembershipOracle mealy, int i) {
        super(context, "oracles", getModelName(mealy.mealyReference))
        this.node = mealy
        this.model = mealy.mealyReference
        this.modelName = getModelName(mealy.mealyReference)
    }
    
    private static def getModelName(Mealy model) {
        val fileName = EclipseFileUtils.getFileForModel(model).name
        val lastDotPosition = fileName.lastIndexOf('.')
        return fileName.substring(0, lastDotPosition)
    }
    
    def getMealyName() {
        return modelName
    }
    
    override learnLibArtifacts() {
        #["learnlib-membership-oracles"]
    }
    
    override getExperimentImports() {
        #[fullName]
    }
    
    override getConstructorParameters() {
        return #[]
    }
    
    override getNode() {
        return node
    }
    
    override template() '''
        « val mealyStates      = model.mealyStates »
        « val mealyInitState   = mealyStates.filter[s | s.init].get(0) »
        « val mealyTranstitons = model.getEdges(MealyTransition) »
        package « package »;
        
        import net.automatalib.words.Alphabet;
        
        import net.automatalib.words.impl.SimpleAlphabet;
        import net.automatalib.automata.transducers.impl.compact.CompactMealy;
        
        import de.learnlib.api.oracle.MembershipOracle.MealyMembershipOracle;
        import de.learnlib.oracle.membership.SimulatorOracle.MealySimulatorOracle;
        
        import « reference(ExperimentDataTemplate) »;
        
        
        public final class « className » implements ExperimentOracle {
            
            private Alphabet                              alphabet;
            private MealyMembershipOracle<String, String> oracle;
            
            
            public « className »() {
                /* Create Alphabet */
                alphabet = new SimpleAlphabet<>();
                « FOR i : mealyTranstitons.map[e | e.input].toSet »
                    alphabet.add("« i »");
                « ENDFOR »
                
                /* Create Melay */
                CompactMealy<String, String> mealy = new CompactMealy<>(alphabet, « mealyStates.size »);
                mealy.setInitialState(« mealyStates.indexOf(mealyInitState) »);
                « FOR t : mealyTranstitons »
                    « val sourceElement = mealyStates.indexOf(t.sourceElement) »
                    « val targetElement = mealyStates.indexOf(t.targetElement) »
                    mealy.addTransition(« sourceElement », "« t.input »", « targetElement », "« t.output »");
                « ENDFOR »
                
                oracle = new MealySimulatorOracle<>(mealy);
            } 
            
            public Alphabet getAlphabet() {
                return alphabet;
            }
            
            public MealyMembershipOracle<String, String> getOracle() {
                return oracle;
            }
            
            @Override
            public void postBlock() {}
            
        }
        
    '''
    
}
