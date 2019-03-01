package de.learnlib.studio.experiment.codegen.templates.blocks.eqoracle

import de.learnlib.studio.experiment.experiment.WMethodEQOracle
import de.learnlib.studio.experiment.codegen.GeneratorContext


class WMethodEqOracleBlockTemplate extends AbstractEqBlockTemplate<WMethodEQOracle> {

     new(GeneratorContext context) {
        super(context, "WMethod", "WMethodEQOracle", "MealyWMethodEQOracle")
    }

    new(GeneratorContext context, WMethodEQOracle node, int i) {
        super(context, node, i, "WMethod", "WMethodEQOracle", "MealyWMethodEQOracle")
    }
    
    override getAdditionalParameters() {
        return #[
            new ExposedParameter(Integer, "maxDepth", node.maxDepth)
        ]
    }

}
