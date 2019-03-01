package de.learnlib.studio.experiment.codegen.templates.oracles.symbols

import java.util.Map

import graphmodel.Node

import de.learnlib.studio.symbol.symbol.End
import de.learnlib.studio.symbol.symbol.Start
import de.learnlib.studio.symbol.symbol.Symbol
import de.learnlib.studio.siblibrary.siblibrary.Activity
import de.learnlib.studio.symbol.symbol.SibActivity
import de.learnlib.studio.experiment.codegen.GeneratorContext
import de.learnlib.studio.experiment.codegen.providers.MavenArtifactProvider
import de.learnlib.studio.experiment.codegen.templates.AbstractSourceTemplate
import de.learnlib.studio.experiment.codegen.templates.PerNodeTemplate
import de.learnlib.studio.experiment.experiment.SULMembershipOracleSymbol
import de.learnlib.studio.symbol.symbol.SibStaticInputPort
import de.learnlib.studio.symbol.symbol.StartParameterScope
import de.learnlib.studio.symbol.symbol.EndParameterScope
import de.learnlib.studio.symbol.symbol.StartOutputPort
import de.learnlib.studio.symbol.symbol.EndInputPort
import de.learnlib.studio.symbol.symbol.SibPort
import de.learnlib.studio.symbol.symbol.DataType


class SymbolTemplate
        extends AbstractSourceTemplate
        implements PerNodeTemplate<SULMembershipOracleSymbol>, MavenArtifactProvider<SULMembershipOracleSymbol> {
            
    val Symbol symbol
    
    val Map<Activity, Integer> typeCounter
    val Map<Node, Integer>     nodeCounter
    
    new(GeneratorContext context, SULMembershipOracleSymbol symbol, int i) {
        super(context, "oracles.symbols", sanitizeName(symbol.symbolReference.name))
        
        this.symbol = symbol.symbolReference
        this.typeCounter = newHashMap()
        this.nodeCounter = newHashMap()
    }
    
    override getArtifacts() {
        return symbol.sibActivitys.map[activity.container.mavenArtifacts].flatten.toList
    }
    
    override template() '''
        package « package »;
        
        import java.util.Map;
        import java.util.HashMap;
        import java.util.function.BiFunction;
        import java.util.function.Supplier;
        
        import de.learnlib.mapper.api.ContextExecutableInput;
        
        
        public class « className » implements ContextExecutableInput<String, ExperimentSULContext> {
            
            interface Block {  
            }
            
            interface StartBlock extends Block {
                public Block apply(ExperimentSULContext context, Map<String, Object> localVariables);
            }
            
            interface EndBlock extends Block {
                public String apply(ExperimentSULContext context, Map<String, Object> localVariables);
            }
            
            interface ActivityBlock extends Block {
                public Supplier<Block> apply(Map<String, Object> localVariables);
            }
            
            « FOR node : symbol.starts »
                « val startBlock = symbol.starts.get(0) »
                private Block « getNameForNode(startBlock) » = new StartBlock() {
                    « val startSuccessor = node.successors.get(0) »
                    public Block apply(ExperimentSULContext context, Map<String, Object> localVariables) {
                        « FOR outputPort : startBlock.startOutputPorts »
                            « readFromStorage(outputPort) »
                        « ENDFOR»
                        return « getNameForNode(startSuccessor) »;
                    }
                };
            « ENDFOR »
            « FOR node : symbol.ends »
                private Block « getNameForNode(node) » = new EndBlock() {
                    public String apply(ExperimentSULContext context, Map<String, Object> localVariables) {
                        « FOR inputPort : node.endInputPorts »
                                « writeToStorage(inputPort) »
                        « ENDFOR»
                        return "« node.name »";
                    }
                };
            « ENDFOR »
            « FOR node : symbol.sibs »
                private Block « getNameForNode(node) » = new ActivityBlock() {
                    « val availableVars = node.sibInputPorts.map[p | p.name].toSet »
                    « FOR output : node.sibOutputPorts »
                        « IF availableVars.add(output.name) »
                            « convertDataTypeToActualType(output.dataType) » « output.name » = null;
                        « ENDIF »
                    « ENDFOR »
                      
                    public Supplier<Block> apply(Map<String, Object> localVariables) {
                        « FOR param : node.sibStaticInputPorts »
                            « getStaticParameterStatement(param)  »
                        « ENDFOR »
                        « FOR param : node.sibDynamicInputPorts »
                            « val dataSource = param.incomingDataFlows.head.sourceElement »
                            « val convertedDataType = convertDataTypeToActualType(param.dataType) »
                            « convertedDataType » « param.name » = (« convertedDataType ») localVariables.get("« storageIdFor(dataSource) »");
                        « ENDFOR »
                        
                        « FOR output : node.branches »
                            Supplier<Block> « output.name » = () -> {
                                « FOR o : node.sibOutputPorts »
                                    localVariables.put("« storageIdFor(o)»", « o.name »);
                                « ENDFOR »
                                « val controlFlow = node.outgoingControlFlows.findFirst[branches.contains(output.name)] »
                                « val successor = controlFlow.targetElement »
                                return « getNameForNode(successor) »;
                            };
                        « ENDFOR »
                        
                        // --- CODE FROM SIB ---
                        « val currentActivity = (node as SibActivity).activity »
                        « currentActivity.code?.code ?: "// No Code found :(" »
                        // ---------------------
                    }
                };
            « ENDFOR »
            
            public String execute(ExperimentSULContext context) {
                Map<String, Object> localVariables = new HashMap<>();
                
                Block current = ((StartBlock) start).apply(context, localVariables);
                while (current instanceof ActivityBlock) {
                    current = ((ActivityBlock) current).apply(localVariables).get();
                }
                
                return ((EndBlock) current).apply(context, localVariables);
            }
            
        } 
    '''
    
    private def getNameForNode(Node node) {
        switch (node) {
            Start: "start"
            End:   sanitizeName(node.name) + "End"
            SibActivity: {
                val activity = node.activity as Activity
                val counter = nodeCounter.computeIfAbsent(node, [n | typeCounter.compute(activity, [a, c | if (c === null) 0 else c + 1])])
                return "activity" + sanitizeName(activity.name) + counter
            }
        }
    }
    
    private def convertDataTypeToActualType(DataType type) {
        switch (type) {
			case BOOLEAN: "Boolean"
			case INTEGER: "Integer"
			case OBJECT:  "Object"
			case REAL:    "Double"
			case TEXT:    "String"
        }
    }
    
    private def readFromStorage(StartOutputPort outputPort) '''
        « val name = outputPort.name »
        « val variableName = "valueOf" + name.toFirstUpper »
        « val convertedDataType = convertDataTypeToActualType(outputPort.dataType) »
        « convertedDataType » « variableName » = (« convertedDataType ») « getStorageName(outputPort.scope, name) »;
        localVariables.put("« storageIdFor(outputPort) »", « variableName »);
    '''
    
    private def getStorageName(StartParameterScope scope, String name) {
        switch scope {
        	case PROPERTY: '''context.getProperty("« name »")'''
            case GLOBAL:   '''context.getGlobalVariables().get("« name »")'''
            case QUERY:    '''context.getQueryVariables().get("« name »")'''
        }
    }
    
    private def writeToStorage(EndInputPort inputPort) '''
        « val dataSource = inputPort.incomingDataFlows.head.sourceElement »
        « val name = inputPort.name »
        « val variableName = "valueOf" + name.toFirstUpper »
        « val convertedDataType = convertDataTypeToActualType(inputPort.dataType) »
        « convertedDataType » « variableName » = (« convertedDataType ») localVariables.get("« storageIdFor(dataSource) »");
        « getStorageName(inputPort.scope) ».put("« name »", « variableName »);
    '''
    
    private def getStorageName(EndParameterScope scope) {
        switch scope {
            case GLOBAL: "context.getGlobalVariables()"
            case QUERY:  "context.getQueryVariables()"
        }
    }
    
    private dispatch def storageIdFor(StartOutputPort port) {
        return getNameForNode(port.container) + "::" + port.name
    }
    
    private dispatch def storageIdFor(EndInputPort port) {
        return getNameForNode(port.container) + "::" + port.name
    }
    
    private dispatch def storageIdFor(SibPort port) {
        return getNameForNode(port.container) + "::" + port.name
    }
     
    private def getStaticParameterStatement(SibStaticInputPort parameter) {
		val dataTypeAsString = convertDataTypeToActualType(parameter.dataType)
        val value = if (parameter.dataType == DataType.TEXT) { "\"" + parameter.value + "\"" }
                    else                                     { parameter.value }
        
        return '''« dataTypeAsString » « parameter.name » = « value »;'''
    }
    
    static def sanitizeName(String name) {
        val parts = name.trim.split(" ")
        
        val result = new StringBuilder()
        for (String s : parts) {
           result.append(s.toFirstUpper)
        }
        
        return result.toString()
    }
 
}
