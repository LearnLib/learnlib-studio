Experiment _1xwykOjuEeiqDpGFnTsWVQ {
  Package "de.learnlib.studio.examples"
  Name "LearnMealy"
  Start _yt_3oO51Eei3ePoxSgb_jA at 150,50 size 100,65 {
  	-StartEdge-> _zYYRYO51Eei3ePoxSgb_jA  decorate "Text" at (0,0) decorate "" at (0,0) {
  		id _z7tn8O51Eei3ePoxSgb_jA
  	}
  }
  
  LStarAlgorithm _zYYRYO51Eei3ePoxSgb_jA at 140,200 size 120,65 {
  	-ModelEdge-> _0PhUwO51Eei3ePoxSgb_jA  decorate "Text" at (0,0) decorate "" at (0,0) {
  		id _1a7X8O51Eei3ePoxSgb_jA
  	}
  	
  	-QueryEdge-> _7evUgO51Eei3ePoxSgb_jA  decorate "Text" at (0,0) decorate "" at (0,0) decorate "" at (0,0) {
  		id _9KfrsO51Eei3ePoxSgb_jA
  	}
  }
  
  RandomWordEQOracle _0PhUwO51Eei3ePoxSgb_jA at 99,350 size 201,65 {
  	amount 20
  	minLength 5
  	maxLength 10
  	-WordEdge-> _zYYRYO51Eei3ePoxSgb_jA via (49,381) (49,233) decorate "Text" at (0,0) decorate "" at (0,0) {
  		id _2OlpgO51Eei3ePoxSgb_jA
  	}
  	
  	-ModelEdge-> _5AFgwO51Eei3ePoxSgb_jA  decorate "Text" at (0,0) decorate "" at (0,0) {
  		id _62lvYe51Eei3ePoxSgb_jA
  	}
  	
  	-QueryEdge-> _7evUgO51Eei3ePoxSgb_jA via (550,382) decorate "Text" at (0,0) decorate "" at (0,0) decorate "" at (0,0) {
  		id _9c4cMe51Eei3ePoxSgb_jA
  	}
  }
  
  ShowModel _5AFgwO51Eei3ePoxSgb_jA at 140,500 size 120,65 {
  }
  
  MealyMembershipOracle _7evUgO51Eei3ePoxSgb_jA at 450,200 size 201,65 {
  	libraryComponentUID "_ClQHoOj5Eei7hv4jTWl9Hg"
  }
  
  Comment _DnMpYe52Eei3ePoxSgb_jA at 610,240 size 311,35 {
  	text "Reference to '01-Mealy.mealy'. Double click to open the link."
  }
  
  Comment _5B4JIe54EeiMH6hO2z1V0w at 44,10 size 311,31 {
  	text "Simple experiment to learn an already exsiting Mealy machine. "
  }
}
