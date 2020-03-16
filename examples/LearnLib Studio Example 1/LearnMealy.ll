Experiment _A5mq8GeSEeqwOMumdKukOA {
  Start _A57bEGeSEeqwOMumdKukOA at 750,140 size 100,65 {
  	-StartEdge-> _EGjvIGeSEeqwOMumdKukOA  decorate "Text" at (0,0) decorate "" at (0,0) {
  		id _EoL1gGeSEeqwOMumdKukOA
  	}
  }
  
  MealyFileAutomaton _DHh7EGeSEeqwOMumdKukOA at 1130,480 size 310,65 {
  	libraryComponentUID "_ClQHoOj5Eei7hv4jTWl9Hg"
  	-ModelEdge-> _KB7hYGeSEeqwOMumdKukOA  decorate "Text" at (0,0) decorate "" at (0,0) {
  		id _LBp5AWeSEeqwOMumdKukOA
  	}
  	
  	-ModelEdge-> _FPOAUGeSEeqwOMumdKukOA  decorate "Text" at (0,0) decorate "" at (0,0) {
  		id _NXGGYWeSEeqwOMumdKukOA
  	}
  }
  
  TTTAlgorithm _EGjvIGeSEeqwOMumdKukOA at 740,300 size 120,65 {
  	acexAnalyzer BinarySearchBackward
  	-ModelEdge-> _FPOAUGeSEeqwOMumdKukOA  decorate "Text" at (0,0) decorate "" at (0,0) {
  		id _Gvv-8GeSEeqwOMumdKukOA
  	}
  	
  	-QueryEdge-> _JhtJMGeSEeqwOMumdKukOA  decorate "Text" at (0,0) decorate "" at (0,0) decorate "" at (0,0) {
  		id _LRlLYGeSEeqwOMumdKukOA
  	}
  }
  
  MealySimulatorEQOracle _FPOAUGeSEeqwOMumdKukOA at 685,500 size 230,65 {
  	-ModelEdge-> _GGm7UGeSEeqwOMumdKukOA  decorate "Text" at (0,0) decorate "" at (0,0) {
  		id _HD8GQWeSEeqwOMumdKukOA
  	}
  	
  	-QueryEdge-> _JhtJMGeSEeqwOMumdKukOA  decorate "Text" at (0,0) decorate "" at (0,0) decorate "" at (0,0) {
  		id _Lx9UkWeSEeqwOMumdKukOA
  	}
  	
  	-WordEdge-> _EGjvIGeSEeqwOMumdKukOA via (595,422) decorate "Text" at (0,0) decorate "" at (0,0) {
  		id _MZE-8GeSEeqwOMumdKukOA
  	}
  }
  
  ShowModel _GGm7UGeSEeqwOMumdKukOA at 705,660 size 195,65 {
  	format DOT
  }
  
  MealySULMembershipOracle _JhtJMGeSEeqwOMumdKukOA at 1190,208 size 120,65 {
  	-SULEdge-> _KB7hYGeSEeqwOMumdKukOA  decorate "Text" at (0,0) decorate "" at (0,0) {
  		id _KaJ0IGeSEeqwOMumdKukOA
  	}
  }
  
  MealySimulatorSUL _KB7hYGeSEeqwOMumdKukOA at 1200,310 size 120,65 {
  }
}
