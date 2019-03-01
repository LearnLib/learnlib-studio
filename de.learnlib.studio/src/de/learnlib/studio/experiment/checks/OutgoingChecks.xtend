package de.learnlib.studio.experiment.checks

import java.util.List

import graphmodel.Node

import de.learnlib.studio.experiment.experiment.Experiment
import de.learnlib.studio.experiment.mcam.modules.checks.ExperimentCheck

import static extension de.learnlib.studio.experiment.utils.ExperimentExtensions.getAllLearners
import static extension de.learnlib.studio.experiment.utils.ExperimentExtensions.getAllEQOralces
import static extension de.learnlib.studio.experiment.utils.ExperimentExtensions.getAllFilters
import static extension de.learnlib.studio.experiment.utils.ExperimentExtensions.isChildOfAComplexNode


class OutgoingChecks extends ExperimentCheck {
    
    override check(Experiment model) {
        checkAlgorithms(model)
        checkEQOracles(model)
        checkFilter(model)
    }
    
    private def checkAlgorithms(Experiment experiment) {
        val learners = experiment.allLearners
        genericOutgoingChecks(learners, "Learner")
    }
    
    private def checkEQOracles(Experiment experiment) {
        val eqOracles = experiment.allEQOralces
        genericOutgoingChecks(eqOracles, "EQ Oracle")
    }
    
    private def genericOutgoingChecks(List<? extends Node> nodes, String description) {
        nodes.filter[childOfAComplexNode && outgoing.size > 0]
             .forEach[addError(it, "A " + description + " within a Complex " + description + " must not have an outgoing edge.")]
        
        nodes.filter[!childOfAComplexNode && outgoing.size == 0]
             .forEach[addWarning(it, "This " + description + " misses an outing edge.")]
    }
    
    private def checkFilter(Experiment experiment) {
        val filters = experiment.allFilters
        
        filters.filter[isContainedFilterWithIncomingEdgeFromTheOutside]
               .forEach[addError(it, "A Filter within a Complex Filter must not have an outgoing edge to the outside of the Complex Filter.")]
        
        filters.filter[!childOfAComplexNode && outgoing.size == 0]
             .forEach[addWarning(it, "This Filter misses an outgoing edge.")]
    }
    
    private def isContainedFilterWithIncomingEdgeFromTheOutside(Node n) {
        return n.isChildOfAComplexNode && n.outgoing.map[targetElement].exists[n.container != container]
    }
    
}