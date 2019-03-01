package de.learnlib.studio.experiment.codegen.providers

import de.learnlib.studio.experiment.codegen.providers.ExperimentConfigurationsProvider
import de.learnlib.studio.experiment.codegen.utils.ExperimentConfigurationsHelper
import de.learnlib.studio.experiment.codegen.GeneratorContext

class ExperimentConfigurationsProviderImpl implements ExperimentConfigurationsProvider {
    
    val GeneratorContext context
    
    new(GeneratorContext context) {
        this.context = context
    }
    
    override getConfigurations() {
        return new ExperimentConfigurationsHelper().findConfigurations(context.model)
    }
    
}