package de.learnlib.studio.experiment.codegen.templates.oracles

import graphmodel.Container
import graphmodel.Edge

import de.learnlib.studio.experiment.experiment.CacheFilter
import de.learnlib.studio.experiment.experiment.QueryEdge
import de.learnlib.studio.experiment.codegen.GeneratorContext
import de.learnlib.studio.experiment.codegen.providers.OracleInformationProvider
import de.learnlib.studio.experiment.codegen.templates.PerNodeTemplate
import de.learnlib.studio.experiment.codegen.templates.AbstractSourceTemplate

import static extension de.learnlib.studio.experiment.utils.ExperimentExtensions.isChildOfAComplexNode


class CacheFilterTemplate
        extends AbstractSourceTemplate
        implements PerNodeTemplate<CacheFilter>,
                   OracleInformationProvider<CacheFilter> {

    val GeneratorContext context
    val CacheFilter filter
    val int i

    new(GeneratorContext context) {
        this(context, null, -1)
    }

    new(GeneratorContext context, CacheFilter filter, int i) {
        super(context, "oracles", "OracleCache")
        this.context = context
        this.filter  = filter
        this.i       = i
	}
	
    override getConstructorParameters() {
        val delegateNode = getOutgoing(QueryEdge).head.targetElement
        return #[delegateNode]
    }
    
    def <T extends Edge> getOutgoing(Class<T> clazz) {
        if (node.isChildOfAComplexNode) {
        	val successor = node.getOutgoing(clazz)
        	if (successor === null) {
            	val container = node.container as Container
            	return container.getOutgoing(clazz)
        	} else {
        		return successor
        	}
        } else {
            return node.getOutgoing(clazz)
        }
    }
    
    override getExperimentImports() {
        return #[package + "." + className]
    }
    
    override getName() {
        return "cache" + i
    }

    override getNode() {
        return filter
    }
    
    override template() '''
        package « package »;
        
        import net.automatalib.words.Alphabet;
        import de.learnlib.api.oracle.MembershipOracle.MealyMembershipOracle;
        
        import de.learnlib.filter.cache.mealy.MealyCaches;
        
        
        public class « className » implements ExperimentOracle {
            
            private ExperimentOracle delegate;
            
            
            public « className »(ExperimentOracle delegate) {
                this.delegate = delegate;
            }
            
            public Alphabet getAlphabet() {
                return delegate.getAlphabet();
            }
            
            public MealyMembershipOracle<String, String> getOracle() {
                return MealyCaches.createCache(delegate.getAlphabet(), delegate.getOracle());
            }
            
            @Override
            public void postBlock() {
            }
            
        }
        
    '''
	
}
