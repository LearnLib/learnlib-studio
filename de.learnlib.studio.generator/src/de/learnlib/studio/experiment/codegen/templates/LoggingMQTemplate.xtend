package de.learnlib.studio.experiment.codegen.templates

import de.learnlib.studio.experiment.codegen.GeneratorContext


class LoggingMQTemplate extends AbstractSourceTemplate {
	
	new(GeneratorContext context) {
		super(context, "LoggingMQ")
	}
	
	override template() '''
		package « package »;
		
		import java.util.Collection;
		
		import de.learnlib.api.oracle.MembershipOracle;
		import de.learnlib.api.oracle.MembershipOracle.MealyMembershipOracle;
		import de.learnlib.api.query.Query;
		import de.learnlib.util.MQUtil;
		import net.automatalib.words.Word;
		
		
		public class LoggingMQ<I, O> implements MealyMembershipOracle<I, O> {
		
			private MealyMembershipOracle<I, O> realOracle;
			
			public LoggingMQ(MealyMembershipOracle<I, O> oracle) {
				realOracle = oracle;
			}
		
			@Override
			public void processQueries(Collection<? extends Query<I, Word<O>>> queries) {
				MQUtil.answerQueries(this, queries);
			}
		
			@Override
			public Word<O> answerQuery(Word<I> prefix, Word<I> suffix) {
				Word<O> answerQuery = realOracle.answerQuery(prefix, suffix);
				
				System.out.println(prefix + "/" + suffix + ": " + answerQuery);
				
				return answerQuery;
			}
		
			@Override
			public MembershipOracle<I, Word<O>> asOracle() {
				return realOracle.asOracle();
			}
		
		}
		
	'''
	
}
