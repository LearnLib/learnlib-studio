package de.learnlib.studio.experiment.codegen.templates.oracles

import graphmodel.Container
import graphmodel.Edge

import de.learnlib.studio.experiment.experiment.QueryCounterFilter
import de.learnlib.studio.experiment.experiment.QueryEdge
import de.learnlib.studio.experiment.codegen.GeneratorContext
import de.learnlib.studio.experiment.codegen.providers.OracleInformationProvider
import de.learnlib.studio.experiment.codegen.providers.LearnLibArtifactProvider
import de.learnlib.studio.experiment.codegen.templates.PerNodeTemplate
import de.learnlib.studio.experiment.codegen.templates.AbstractSourceTemplate

import de.learnlib.studio.experiment.codegen.templates.utils.ResultWriterTemplate

import static extension de.learnlib.studio.experiment.utils.ExperimentExtensions.isChildOfAComplexNode


class QueryCounterFilterTemplate
        extends AbstractSourceTemplate
        implements PerNodeTemplate<QueryCounterFilter>,
                   OracleInformationProvider<QueryCounterFilter>,
                   LearnLibArtifactProvider<QueryCounterFilter> {

    val QueryCounterFilter filter
    val int i

    new(GeneratorContext context) {
        this(context, null, -1)
    }

    new(GeneratorContext context, QueryCounterFilter filter, int i) {
        super(context, "oracles", "QueryCounter")
        this.filter  = filter
        this.i       = i
	}
	
    override learnLibArtifacts() {
        return #["learnlib-statistics"]
    }
    
    override getConstructorParameters() {
        val delegateNode = getOutgoing(QueryEdge).head.targetElement
        return #[delegateNode, node.name]
    }
    
    def <T extends Edge> getOutgoing(Class<T> clazz) {
        if (node.isChildOfAComplexNode) {
        	val successors = node.getOutgoing(clazz)
        	if (successors.empty) {
            	val container = node.container as Container
            	return container.getOutgoing(clazz)
        	} else {
        		return successors
        	}
        } else {
            return node.getOutgoing(clazz)
        }
    }
    
    override getExperimentImports() {
        return #[package + "." + className]
    }
    
    override getName() {
        return "counter" + i
    }

    override getNode() {
        return filter
    }
    
    override template() '''
        package « package »;

        import java.nio.file.Path;

        import net.automatalib.words.Alphabet;
        import de.learnlib.api.oracle.MembershipOracle.MealyMembershipOracle;

        import de.learnlib.filter.statistic.oracle.CounterOracle.MealyCounterOracle;
        
        import « reference(ResultWriterTemplate) »;


        public class « className » implements ExperimentOracle {

            private String name;
            private ExperimentOracle delegate;
            private MealyCounterOracle oracle;
            
            private long prevSum;
            private Path file;

            public « className»(ExperimentOracle delegate, String name) {
                this.name = name;
                this.delegate = delegate;
                this.oracle = new MealyCounterOracle(delegate.getOracle(), name);
                
                this.prevSum = 0;
            }
            
            public Alphabet getAlphabet() {
                return delegate.getAlphabet();
            }
            
            public MealyMembershipOracle<String, String> getOracle() {
                return oracle;
            }
            
            @Override
            public void postBlock() {
                long realCount = oracle.getCounter().getCount() - prevSum;
                
                System.out.println("Query Counter '" + name + "': " + realCount);
                try {
                    if (file == null) {
                        file = ResultWriter.getFile(this.name, "txt");
                    }
                    ResultWriter.writeData(file, Long.toString(realCount));
                } catch(Exception e) {
                    e.printStackTrace();
                }
                
                prevSum = oracle.getCounter().getCount();
            }

            
            public void dispose() {
                System.out.println("Query Counter '" + name + "': " + oracle.getCounter().getCount());
                ResultWriter.writeData(file, Long.toString(oracle.getCounter().getCount()));
                delegate = null;
            }
            
        }
        
    '''
	
}
