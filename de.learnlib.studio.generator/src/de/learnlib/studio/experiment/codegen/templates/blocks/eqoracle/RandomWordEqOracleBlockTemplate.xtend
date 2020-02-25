package de.learnlib.studio.experiment.codegen.templates.blocks.eqoracle

import de.learnlib.studio.experiment.experiment.RandomWordEQOracle
import de.learnlib.studio.experiment.codegen.GeneratorContext
import de.learnlib.studio.experiment.codegen.templates.blocks.eqoracle.AbstractEqBlockTemplate.StaticParameter


class RandomWordEqOracleBlockTemplate extends AbstractEqBlockTemplate<RandomWordEQOracle> {

     new(GeneratorContext context) {
        super(context, "RandomWord", "MealyRandomWordsEQOracle")
    }

    new(GeneratorContext context, RandomWordEQOracle node, int i) {
        super(context, node, i, "RandomWord", "MealyRandomWordsEQOracle")
    }
    
    override getAdditionalParameters() {
        return #[
            new ExposedParameter(Integer, "minLength", node.minLength),
            new ExposedParameter(Integer, "maxLength", node.maxLength),
            new ExposedParameter(Integer, "amount", node.amount),
            new StaticParameter("new Random()")
        ]
    }

}
