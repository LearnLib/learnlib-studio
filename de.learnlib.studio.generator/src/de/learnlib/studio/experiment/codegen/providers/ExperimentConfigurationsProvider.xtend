package de.learnlib.studio.experiment.codegen.providers

import java.util.Set

import de.learnlib.studio.experiment.codegen.utils.ExperimentConfigurationsHelper.ExperimentConfiguration


interface ExperimentConfigurationsProvider extends GeneratorInformationProvider {
    
    def Set<ExperimentConfiguration> getConfigurations()
    
}
