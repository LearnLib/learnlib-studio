package de.learnlib.studio.experiment.checks

import java.util.List

import graphmodel.Node

import de.learnlib.studio.experiment.experiment.Experiment
import de.learnlib.studio.experiment.mcam.modules.checks.ExperimentCheck

import static extension de.learnlib.studio.experiment.utils.ExperimentExtensions.getAllLearners
import static extension de.learnlib.studio.experiment.utils.ExperimentExtensions.getAllEQOralces
import static extension de.learnlib.studio.experiment.utils.ExperimentExtensions.getAllOracles
import static extension de.learnlib.studio.experiment.utils.ExperimentExtensions.getAllFilters
import static extension de.learnlib.studio.experiment.utils.ExperimentExtensions.isChildOfAComplexNode


class IncomingChecks extends ExperimentCheck {
    
    override check(Experiment model) {
        checkAlgorithms(model)
        checkEQOracles(model)
        checkOracles(model)
        checkFilter(model)
    }
    
    private def checkAlgorithms(Experiment experiment) {
        val learners = experiment.allLearners
        genericIncomingChecks(learners, "Learner")
    }
    
    private def checkEQOracles(Experiment experiment) {
        val eqOracles = experiment.allEQOralces
        genericIncomingChecks(eqOracles, "EQ Oracle")
    }
    
    private def checkOracles(Experiment experiment) {
        val oracles = experiment.allOracles
        genericIncomingChecks(oracles, "Oracle")
    }
    
    private def genericIncomingChecks(List<? extends Node> nodes, String description) {
        nodes.filter[childOfAComplexNode && incoming.size > 0]
             .forEach[addError(it, "A " + description + " within a Complex " + description + " must not have an incoming edge.")]
        
        nodes.filter[!childOfAComplexNode && incoming.size == 0]
             .forEach[addWarning(it, "This " + description + " misses an incoming edge.")]
    }
    
    private def checkFilter(Experiment experiment) {
        val filters = experiment.allFilters
        
        filters.filter[isContainedFilterWithIncomingEdgeFromTheOutside]
               .forEach[addError(it, "A Filter within a Complex Filter must not have an incoming edge from outside the Complex Filter.")]
        
        filters.filter[!childOfAComplexNode && incoming.size == 0]
             .forEach[addWarning(it, "This Filter misses an incoming edge.")]
    }
    
    private def isContainedFilterWithIncomingEdgeFromTheOutside(Node n) {
        return n.isChildOfAComplexNode && n.incoming.map[sourceElement].exists[n.container != container]
    }
    
}