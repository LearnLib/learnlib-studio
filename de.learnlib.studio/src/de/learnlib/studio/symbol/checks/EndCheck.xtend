package de.learnlib.studio.symbol.checks

import de.learnlib.studio.symbol.mcam.modules.checks.SymbolCheck
import de.learnlib.studio.symbol.symbol.Symbol
import de.learnlib.studio.utils.Checker
import de.learnlib.studio.symbol.symbol.End


class EndCheck extends SymbolCheck {
	
	static val NAME_PATTERN = "[a-zA-Z0-9]([a-zA-Z0-9_]*[a-zA-Z0-9]+)*"
	
	override check(Symbol model) {
		val checker = new Checker<End>(this, model.ends)
		
		checker.addStringChecksFor([name])
							.notNullOrEmpty()
							.shouldFollowRegexPattern(NAME_PATTERN)
							.shouldBeUnique()
		
		checker.check()
	}
	
}
