package de.learnlib.studio.experiment.utils

import java.util.List

import graphmodel.ModelElement
import graphmodel.Container

import de.learnlib.studio.experiment.experiment.Experiment
import de.learnlib.studio.experiment.experiment.Learner
import de.learnlib.studio.experiment.experiment.EQOracle
import de.learnlib.studio.experiment.experiment.Oracle
import de.learnlib.studio.experiment.experiment.Filter
import de.learnlib.studio.experiment.experiment.SULMembershipOracle


class ExperimentExtensions {
    
    static def List<Learner> getAllLearners(Experiment experiment) {
        val learners = <Learner> newLinkedList(experiment.learners)
        experiment.complexLearners.forEach[nonComplexLearners.forEach[learners.add(it)]]
        return learners
    }
    
    static def List<EQOracle> getAllEQOralces(Experiment experiment) {
        val eqOracles = <EQOracle> newLinkedList(experiment.EQOracles)
        experiment.complexEQOracles.forEach[it.nonComplexEQOracles.forEach[eqOracles.add(it)]]
        return eqOracles
    }
    
    static def List<Oracle> getAllOracles(Experiment experiment) {
        val oracles = <Oracle> newLinkedList(experiment.oracles)
        experiment.complexOracles.forEach[it.nonComplexOracles.forEach[oracles.add(it)]]
        return oracles
    }
    
    static def List<Filter> getAllFilters(Experiment experiment) {
        val filters = <Filter> newLinkedList(experiment.filters)
        experiment.complexFilters.forEach[it.nonComplexFilters.forEach[filters.add(it)]]
        return filters
    }
    
    static def isComplexNode(ModelElement node) {
        return node instanceof Container && !(node instanceof SULMembershipOracle)    
    }
    
    static def isChildOfAComplexNode(ModelElement node) {
        val container = node.container
        return container instanceof Container && !(container instanceof SULMembershipOracle)
    }
    
}