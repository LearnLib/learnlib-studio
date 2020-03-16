package de.learnlib.studio.experiment.codegen.templates.oracles

import de.learnlib.studio.experiment.experiment.SULMembershipOracle
import de.learnlib.studio.experiment.experiment.SULMebembershipOracleSymbolType
import de.learnlib.studio.experiment.experiment.SULMembershipOracleSymbol
import de.learnlib.studio.experiment.experiment.EnvironmentProperty
import de.learnlib.studio.experiment.codegen.templates.PerNodeTemplate
import de.learnlib.studio.experiment.codegen.templates.AbstractSourceTemplate
import de.learnlib.studio.experiment.codegen.providers.OracleInformationProvider
import de.learnlib.studio.experiment.codegen.GeneratorContext

import static de.learnlib.studio.experiment.codegen.templates.oracles.symbols.SymbolTemplate.sanitizeName

class SULOracleTemplate 
            extends AbstractSourceTemplate
            implements OracleInformationProvider<SULMembershipOracle>, PerNodeTemplate<SULMembershipOracle> {

    val SULMembershipOracle sulOracle

    new(GeneratorContext context) {
        this(context, null, -1)
    }

    new(GeneratorContext context, SULMembershipOracle sulOracle, int i) {
        super(context, "oracles", "SulOracle" + (i +1))
        this.sulOracle = sulOracle
    }

    override getNode() {
        return sulOracle
    }
    
    override getConstructorParameters() {
        return #[]
    }
    
    override getExperimentImports() {
        return #[fullName]
    }
    
    override template() '''
        package « package »;
        
        import java.util.List;
        import java.util.ArrayList;
        import java.util.Map;
        import java.util.HashMap;
        
        import net.automatalib.words.Alphabet;
                
        import net.automatalib.words.impl.GrowingMapAlphabet;
        
        import de.learnlib.mapper.ContextExecutableInputSUL.ContextHandler;
        import de.learnlib.mapper.api.SULMapper;
        import de.learnlib.mapper.ContextExecutableInputSUL;
        import de.learnlib.api.SUL;
        import de.learnlib.oracle.membership.SULOracle;
        import de.learnlib.api.oracle.MembershipOracle.MealyMembershipOracle;
        import de.learnlib.mapper.api.ContextExecutableInput;
        import de.learnlib.api.exception.SULException;
        import de.learnlib.mapper.SULMappers;
        
        import « reference(ExperimentSULContextTemplate) »;
        
        
        public class « className » implements ExperimentOracle {
            
            public static class ExperimentContextHandler implements ContextHandler<ExperimentSULContext> {
                
                private ContextExecutableInput<String, ExperimentSULContext> globalSetUpSymbol;
                private ContextExecutableInput<String, ExperimentSULContext> setUpSymbol;
                private ContextExecutableInput<String, ExperimentSULContext> tearDownSymbol;
                private ContextExecutableInput<String, ExperimentSULContext> globalTearDownSymbol;
                
                private ExperimentSULContext globalContext;
                
                public ExperimentContextHandler(ContextExecutableInput<String, ExperimentSULContext> globalSetUpSymbol,
                                                ContextExecutableInput<String, ExperimentSULContext> setUpSymbol,
                                                ContextExecutableInput<String, ExperimentSULContext> tearDownSymbol,
                                                ContextExecutableInput<String, ExperimentSULContext> globalTearDownSymbol) {
                    this.globalSetUpSymbol    = globalSetUpSymbol;
                    this.setUpSymbol          = setUpSymbol;
                    this.tearDownSymbol       = tearDownSymbol;
                    this.globalTearDownSymbol = globalTearDownSymbol;
                }
                
                public void prepareContext() {
                    System.out.println("!!! Prepare Context");
                    Map<String, Object> properites = new HashMap<>();
                    « FOR EnvironmentProperty property : sulOracle.properties »
                        properites.put("« property.name »", « property.value »);
                    « ENDFOR »
                    globalContext = new ExperimentSULContext(properites);
                    if (globalSetUpSymbol != null) {
                        globalSetUpSymbol.execute(globalContext);
                    }
                }
                
                public ExperimentSULContext createContext() {
                    System.out.println("!!! Create Context");
                    ExperimentSULContext newContext = new ExperimentSULContext(globalContext);
                    
                    if (setUpSymbol != null) {
                        setUpSymbol.execute(newContext);
                    }
                    return newContext;
                }
                
                public void disposeContext(ExperimentSULContext context) {
                    System.out.println("!!! Dispose Context");
                    if (tearDownSymbol != null) {
                        tearDownSymbol.execute(context);
                    }
                    context.softReset();
                }
                
                public void cleanUp() {
                    System.out.println("!!! Clean up Context");
                    if (globalTearDownSymbol != null) {
                        globalTearDownSymbol.execute(globalContext);
                    }
                    globalContext.hardReset();
                }
            }
            
            public static class ExperimentSULMapper implements SULMapper<String, String, ContextExecutableInput<String, ExperimentSULContext>, String> {
                private final Map<String, ContextExecutableInput<String, ExperimentSULContext>> symbolMap;
            
                public ExperimentSULMapper(Map<String, ContextExecutableInput<String, ExperimentSULContext>> symbolMap) {
                    this.symbolMap = symbolMap;
                }
            
                @Override
                public ContextExecutableInput<String, ExperimentSULContext> mapInput(String abstractInput) {
                    System.out.println("Map Input: " + abstractInput + " -> " + symbolMap.get(abstractInput));
                    return symbolMap.get(abstractInput);
                }
            
                @Override
                public String mapOutput(String result) {
                    System.out.println("Map Output: " + result);
                    return result;
                }
            
                @Override
                public MappedException<? extends String> mapUnwrappedException(RuntimeException e) throws RuntimeException {
                    System.out.println("Map Unwrapped Exception: " + e);
                    return null;
                }
            
                @Override
                public MappedException<? extends String> mapWrappedException(SULException e) throws SULException {
                    System.out.println("Map Wrapped Exception: " + e);
                    return null;
                }
            
                @Override
                public void post() {
                }
            
                @Override
                public void pre() {
                }
            
                @Override
                public boolean canFork() {
                    return true;
                }
            
                @Override
                public SULMapper<String, String, ContextExecutableInput<String, ExperimentSULContext>, String> fork()
                            throws UnsupportedOperationException {
                    return new ExperimentSULMapper(new HashMap<>(symbolMap));
                }
            }
            
            private Alphabet alphabet;
            MealyMembershipOracle<String, String> oracle;
            private ExperimentContextHandler contextHandler;
            
            public « className »() {
                Map<String, ContextExecutableInput<String, ExperimentSULContext>> symbols = new HashMap<>();
                « FOR symbol : sulOracle.nodes.filter[symbolType == SULMebembershipOracleSymbolType.NORMAL] »
                    symbols.put("« symbol.symbolReference.name »", new « package ».symbols.« sanitizeName(symbol.symbolReference.name) »());
                « ENDFOR »
                
                /* Create Alphabet */
                alphabet = new GrowingMapAlphabet<>();
                « FOR symbol : sulOracle.nodes.filter[symbolType == SULMebembershipOracleSymbolType.NORMAL] »
                    alphabet.add("« symbol.symbolReference.name »");
                « ENDFOR »
                ContextExecutableInput<String, ExperimentSULContext> globalSetUpSymbol    = « getGlobalSetUpSymbolInstance() »;
                ContextExecutableInput<String, ExperimentSULContext> setUpSymbol          = « getSetUpSymbolInstance() »;
                ContextExecutableInput<String, ExperimentSULContext> tearDownSymbol       = « getTearDownSymbolInstance() »;
                ContextExecutableInput<String, ExperimentSULContext> globalTearDownSymbol = « getGlobalTearDownSymbolInstance() »;
                
                contextHandler = new ExperimentContextHandler(globalSetUpSymbol, setUpSymbol, tearDownSymbol, globalTearDownSymbol);
                ContextExecutableInputSUL<ContextExecutableInput<String, ExperimentSULContext>, String, ExperimentSULContext> ceiSUL = new ContextExecutableInputSUL(contextHandler);
                ExperimentSULMapper symbolMapper = new ExperimentSULMapper(symbols);
                SUL<String, String> mappedSUL = SULMappers.apply(symbolMapper, ceiSUL);
                
                oracle = new SULOracle<>(mappedSUL);
            }
            
            @Override
            public Alphabet getAlphabet() {
                return alphabet;
            }
            
            @Override
            public MealyMembershipOracle<String, String> getOracle() {
                return oracle;
            }

            @Override
            public void postBlock() {}
            
            public void setUp() {
                 contextHandler.prepareContext();
            }
            
            public void dispose() {
                contextHandler.cleanUp();
            }
            
        }
        
    '''
    
    private def getSymbolInstance(SULMebembershipOracleSymbolType type) {
        val symbol = sulOracle.nodes.findFirst[symbolType == type]
        return getSymbolInstance(symbol)
    }
    
    private def getGlobalSetUpSymbolInstance() {
        return getSymbolInstance(SULMebembershipOracleSymbolType.GLOBAL_SET_UP)
    }
    
    private def getSetUpSymbolInstance() {
        return getSymbolInstance(SULMebembershipOracleSymbolType.SET_UP)
    }
    
    private def getTearDownSymbolInstance() {
        return getSymbolInstance(SULMebembershipOracleSymbolType.TEAR_DOWN)
    }
    
    private def getGlobalTearDownSymbolInstance() {
        return getSymbolInstance(SULMebembershipOracleSymbolType.GLOBAL_TEAR_DOWN)
    }
    
    private def getSymbolInstance(SULMembershipOracleSymbol symbol) {
        if (symbol !== null) {
            val setUpSymbolName = symbol.symbolReference.name
            return "new " + package + ".symbols." + sanitizeName(setUpSymbolName) + "()"    
        } else {
            return "null"
        }
    }
}
