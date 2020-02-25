package de.learnlib.studio.experiment.codegen.templates.blocks.eqoracle

import de.learnlib.studio.experiment.codegen.GeneratorContext
import de.learnlib.studio.experiment.experiment.WPMethodEQOracle


class WpMethodEqOracleBlockTemplate extends AbstractEqBlockTemplate<WPMethodEQOracle> {

     new(GeneratorContext context) {
        super(context, "WpMethod", "MealyWpMethodEQOracle")
    }

    new(GeneratorContext context, WPMethodEQOracle node, int i) {
        super(context, node, i,  "WpMethod", "MealyWpMethodEQOracle")
    }

    override getAdditionalParameters() {
        return #[
            new ExposedParameter(Integer, "minDepth", node.minDepth),
            new ExposedParameter(Integer, "maxDepth", node.maxDepth)
        ]
    }

}
