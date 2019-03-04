Experiment _ryrnYOj7EeiE6OLN7QX5og {
  Package "de.learnlib.studio.examples"
  Name "LearnStack"
  Start _ryxuAej7EeiE6OLN7QX5og at 110,50 size 100,65 {
  	-StartEdge-> _rz8LoOj7EeiE6OLN7QX5og  decorate "Text" at (0,0) decorate "" at (0,0) {
  		id _aSvXwO53EeiMH6hO2z1V0w
  	}
  }
  
  CacheFilter _rzUgkOj7EeiE6OLN7QX5og at 700,200 size 120,65 {
  	-QueryEdge-> _ghDUIe53EeiMH6hO2z1V0w  decorate "Text" at (0,0) decorate "" at (0,0) decorate "" at (0,0) {
  		id _h1uoEe53EeiMH6hO2z1V0w
  	}
  }
  
  TTTAlgorithm _rz8LoOj7EeiE6OLN7QX5og at 100,200 size 120,65 {
  	acexAnalyzer BinarySearchBackward
  	-ModelEdge-> _r0JnAOj7EeiE6OLN7QX5og  decorate "Text" at (0,0) decorate "" at (0,0) {
  		id _arufgO53EeiMH6hO2z1V0w
  	}
  	
  	-QueryEdge-> _26feQThYEemGN6aaZ6xZTw  decorate "Text" at (0,0) decorate "" at (0,0) decorate "" at (0,0) {
  		id _4OXg8ThYEemGN6aaZ6xZTw
  	}
  }
  
  RandomWordEQOracle _r0JnAOj7EeiE6OLN7QX5og at 59,350 size 201,65 {
  	amount 20
  	minLength 5
  	maxLength 10
  	-ModelEdge-> _r0V0QOj7EeiE6OLN7QX5og  decorate "Text" at (0,0) decorate "" at (0,0) {
  		id _a9choe53EeiMH6hO2z1V0w
  	}
  	
  	-WordEdge-> _rz8LoOj7EeiE6OLN7QX5og via (52,383) (52,233) decorate "Text" at (0,0) decorate "" at (0,0) {
  		id _bsgnEe53EeiMH6hO2z1V0w
  	}
  	
  	-QueryEdge-> _3qy50ThYEemGN6aaZ6xZTw  decorate "Text" at (0,0) decorate "" at (0,0) decorate "" at (0,0) {
  		id _4tV78DhYEemGN6aaZ6xZTw
  	}
  }
  
  ShowModel _r0V0QOj7EeiE6OLN7QX5og at 100,500 size 120,65 {
  }
  
  SULMembershipOracle _ghDUIe53EeiMH6hO2z1V0w at 940,82 size 201,301 {
  	properties [ EnvironmentProperty _XjifMO56EeiMH6hO2z1V0w {
  			name "stackSize"
  			value "2"
  		} ]
  	SULMembershipOracleSymbol _Kc8ekCuSEemvnL14raFhhQ at 40,28 size 120,65 {
  		symbolType SetUp
  		libraryComponentUID "__PiyACuREemvnL14raFhhQ"
  	}
  	
  	SULMembershipOracleSymbol _nlhSECukEemwEPKgfVvK1Q at 40,116 size 120,65 {
  		symbolType Normal
  		libraryComponentUID "_kdH9wSukEemwEPKgfVvK1Q"
  	}
  	
  	SULMembershipOracleSymbol _vatssSukEemwEPKgfVvK1Q at 24,206 size 151,65 {
  		symbolType Normal
  		libraryComponentUID "_mdfTASukEemwEPKgfVvK1Q"
  	}
  }
  
  Comment _Bl704e55EeiMH6hO2z1V0w at 780,367 size 301,31 {
  	text "See the SUL properties to change the max size of the stack."
  }
  
  QueryCounterFilter _26feQThYEemGN6aaZ6xZTw at 390,200 size 120,65 {
  	name "Learner Queries"
  	-QueryEdge-> _rzUgkOj7EeiE6OLN7QX5og  decorate "Text" at (0,0) decorate "" at (0,0) decorate "" at (0,0) {
  		id _55-uMThYEemGN6aaZ6xZTw
  	}
  }
  
  QueryCounterFilter _3qy50ThYEemGN6aaZ6xZTw at 390,350 size 120,65 {
  	name "EQ Queries"
  	-QueryEdge-> _rzUgkOj7EeiE6OLN7QX5og via (644,382) decorate "Text" at (0,0) decorate "" at (0,0) decorate "" at (0,0) {
  		id _5AWXgThYEemGN6aaZ6xZTw
  	}
  }
}
