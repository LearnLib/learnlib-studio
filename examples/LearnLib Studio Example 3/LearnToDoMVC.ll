Experiment _DqNp4UG0EemCYrs8-0WYsA {
  Package "de.learnlib.studio.examples"
  Name "TodoMVCExperiment"
  Start _DqUXkUG0EemCYrs8-0WYsA at 110,50 size 100,65 {
  	-StartEdge-> _bWVEcEG1Eemn7p5CpfULMw  decorate "Text" at (0,0) decorate "" at (0,0) {
  		id _fpYOAUG1Eemn7p5CpfULMw
  	}
  }
  
  SULMembershipOracle _DqmEYUG0EemCYrs8-0WYsA at 1060,172 size 441,416 {
  	properties [  ]
  	SULMembershipOracleSymbol _DqzfwUG0EemCYrs8-0WYsA at 30,260 size 120,65 {
  		symbolType Normal
  		libraryComponentUID "_oKCecDkYEemqPd5oYbV-7A"
  	}
  	
  	SULMembershipOracleSymbol _DrAUEUG0EemCYrs8-0WYsA at 30,105 size 120,65 {
  		symbolType Normal
  		libraryComponentUID "_-uouEDU5EemvN4zECoJuXQ"
  	}
  	
  	SULMembershipOracleSymbol _DrNIYUG0EemCYrs8-0WYsA at 290,105 size 120,65 {
  		symbolType Normal
  		libraryComponentUID "_BQ7rsTU6EemvN4zECoJuXQ"
  	}
  	
  	SULMembershipOracleSymbol _DrVrQUG0EemCYrs8-0WYsA at 290,260 size 120,65 {
  		symbolType Normal
  		libraryComponentUID "_IZHqgTkYEemqPd5oYbV-7A"
  	}
  	
  	SULMembershipOracleSymbol _Dre1MUG0EemCYrs8-0WYsA at 160,105 size 120,65 {
  		symbolType Normal
  		libraryComponentUID "_Ci1UYTibEem3E5apuRswZA"
  	}
  	
  	SULMembershipOracleSymbol _Drn_IUG0EemCYrs8-0WYsA at 160,30 size 120,65 {
  		symbolType SetUp
  		libraryComponentUID "_D0-GQCroEembN-YkAOVBiQ"
  	}
  	
  	SULMembershipOracleSymbol _Dr2BkUG0EemCYrs8-0WYsA at 30,30 size 120,65 {
  		symbolType GlobalSetUp
  		libraryComponentUID "_zOnpkTbQEemghvnbWjei8w"
  	}
  	
  	SULMembershipOracleSymbol _DsGgQUG0EemCYrs8-0WYsA at 290,30 size 120,65 {
  		symbolType GlobalTearDown
  		libraryComponentUID "_VP5FASroEembN-YkAOVBiQ"
  	}
  	
  	SULMembershipOracleSymbol _DsPDIUG0EemCYrs8-0WYsA at 160,180 size 120,65 {
  		symbolType Normal
  		libraryComponentUID "_36cMMTkEEem51_uoaFqN2A"
  	}
  	
  	SULMembershipOracleSymbol _DsaCQUG0EemCYrs8-0WYsA at 290,180 size 120,65 {
  		symbolType Normal
  		libraryComponentUID "_lAc0ITkUEemULY-_1KY_vQ"
  	}
  	
  	SULMembershipOracleSymbol _DstkQUG0EemCYrs8-0WYsA at 30,180 size 120,65 {
  		symbolType Normal
  		libraryComponentUID "_bFCOgTkBEemoJ_Kxu2Qd7Q"
  	}
  	
  	SULMembershipOracleSymbol _Ds4jYUG0EemCYrs8-0WYsA at 160,340 size 120,65 {
  		symbolType Normal
  		libraryComponentUID "_GuDsUTkXEemqPd5oYbV-7A"
  	}
  	
  	SULMembershipOracleSymbol _DtEwoUG0EemCYrs8-0WYsA at 30,340 size 120,65 {
  		symbolType Normal
  		libraryComponentUID "_S7-soTkVEemULY-_1KY_vQ"
  	}
  	
  	SULMembershipOracleSymbol _DtLeUUG0EemCYrs8-0WYsA at 290,340 size 120,65 {
  		symbolType Normal
  		libraryComponentUID "_jU9bUTkXEemqPd5oYbV-7A"
  	}
  	
  	SULMembershipOracleSymbol _DtV2YUG0EemCYrs8-0WYsA at 160,260 size 120,65 {
  		symbolType Normal
  		libraryComponentUID "_H4nvETkkEem0-4HHaC5GYQ"
  	}
  }
  
  ShowModel _Dtm8IUG0EemCYrs8-0WYsA at 100,520 size 120,65 {
  }
  
  ComplexLearner _bWVEcEG1Eemn7p5CpfULMw at 21,172 size 277,121 {
  	DHCAlgorithm _dG64UEG1Eemn7p5CpfULMw at 16,40 size 120,65 {
  	}
  	
  	TTTAlgorithm _dvxoEUG1Eemn7p5CpfULMw at 146,40 size 120,65 {
  		acexAnalyzer BinarySearchBackward
  	}
  	-ModelEdge-> _iTayYEG1Eemn7p5CpfULMw  decorate "Text" at (0,0) decorate "" at (0,0) {
  		id _ytR8wUG1Eemn7p5CpfULMw
  	}
  	
  	-QueryEdge-> _4SqQ4EG1Eemn7p5CpfULMw via (417,232) (418,266) decorate "Text" at (0,0) decorate "" at (0,0) decorate "" at (0,0) {
  		id _8yGQoUG1Eemn7p5CpfULMw
  	}
  }
  
  ComplexEQOracle _iTayYEG1Eemn7p5CpfULMw at -36,360 size 391,111 {
  	RandomWordEQOracle _kHwd0UG1Eemn7p5CpfULMw at 10,30 size 180,65 {
  		amount 40
  		minLength 30
  		maxLength 70
  	}
  	
  	RandomWordEQOracle _kquoAUG1Eemn7p5CpfULMw at 200,30 size 180,65 {
  		amount 60
  		minLength 30
  		maxLength 80
  	}
  	-ModelEdge-> _Dtm8IUG0EemCYrs8-0WYsA  decorate "Text" at (0,0) decorate "" at (0,0) {
  		id _yPWqoUG1Eemn7p5CpfULMw
  	}
  	
  	-WordEdge-> _bWVEcEG1Eemn7p5CpfULMw via (-50,415) (-50,232) decorate "Text" at (0,0) decorate "" at (0,0) {
  		id _0i1JIEG1Eemn7p5CpfULMw
  	}
  	
  	-QueryEdge-> _4SqQ4EG1Eemn7p5CpfULMw via (442,415) (443,266) decorate "Text" at (0,0) decorate "" at (0,0) decorate "" at (0,0) {
  		id _9DXm0UG1Eemn7p5CpfULMw
  	}
  }
  
  ComplexFilter _4SqQ4EG1Eemn7p5CpfULMw at 490,172 size 461,189 {
  	QueryCounterFilter _5hHBAUG1Eemn7p5CpfULMw at 170,28 size 120,65 {
  		name "Amount of Queries"
  	}
  	
  	QueryCounterFilter _6fkNUUG1Eemn7p5CpfULMw at 10,108 size 120,65 {
  		name "Amount of Queries before Cache"
  		-QueryEdge-> _7rLE0UG1Eemn7p5CpfULMw  decorate "Text" at (0,0) decorate "" at (0,0) decorate "" at (0,0) {
  			id _8LKMcUG1Eemn7p5CpfULMw
  		}
  	}
  	
  	QueryCounterFilter _68CG4UG1Eemn7p5CpfULMw at 330,108 size 120,65 {
  		name "Amount of Queries after Cache"
  	}
  	
  	CacheFilter _7rLE0UG1Eemn7p5CpfULMw at 170,108 size 120,65 {
  		-QueryEdge-> _68CG4UG1Eemn7p5CpfULMw  decorate "Text" at (0,0) decorate "" at (0,0) decorate "" at (0,0) {
  			id _8XxsIUG1Eemn7p5CpfULMw
  		}
  	}
  	-QueryEdge-> _DqmEYUG0EemCYrs8-0WYsA via (1005,266) (1006,380) decorate "Text" at (0,0) decorate "" at (0,0) decorate "" at (0,0) {
  		id _9ZSzgUG1Eemn7p5CpfULMw
  	}
  }
}
