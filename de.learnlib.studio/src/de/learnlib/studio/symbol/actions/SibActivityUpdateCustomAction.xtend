package de.learnlib.studio.symbol.actions

import java.util.List

import de.jabc.cinco.meta.runtime.action.CincoCustomAction

import de.learnlib.studio.siblibrary.siblibrary.Parameter
import de.learnlib.studio.siblibrary.siblibrary.InputParameter
import de.learnlib.studio.siblibrary.siblibrary.OutputParameter
import de.learnlib.studio.symbol.symbol.SibActivity
import de.learnlib.studio.symbol.symbol.SibPort
import de.learnlib.studio.symbol.symbol.SibInputPort
import de.learnlib.studio.symbol.symbol.SibOutputPort
import de.learnlib.studio.symbol.utils.DataTypeConverter
import de.learnlib.studio.symbol.utils.SibActivityChildrenLayouter
import de.learnlib.studio.symbol.factory.SymbolFactory
import java.util.Comparator

class SibActivityUpdateCustomAction extends CincoCustomAction<SibActivity> {
    
    override getName() {
        return "Update Activity"
    }
    
    override execute(SibActivity sibActivity) {
        updateBranches(sibActivity)
        
        updateInputPorts(sibActivity)
        updateOutputPorts(sibActivity)
        
        sortSibPorts(sibActivity)
        
        SibActivityChildrenLayouter.INSTANCE.layoutAll(sibActivity)
    }
    
    private def updateBranches(SibActivity sibActivity) {
        val externalActivity = sibActivity.activity     

        sibActivity.branches.clear()
        sibActivity.branches += externalActivity.branchesLists.head.branchs.map[newSibBranch(name, error)]
    }
    
    private def newSibBranch(String name, boolean error) {
        val newSibBranch = SymbolFactory.eINSTANCE.createSibBranch()
        newSibBranch.name  = name
        newSibBranch.error = error
        return newSibBranch
    }
    
    private def updateInputPorts(SibActivity sibActivity) {
        val externalActivity = sibActivity.activity
        
        val parameters = externalActivity.inputParametersLists.head.inputParameters
        val ports      = sibActivity.sibInputPorts
        
        removeOldAndUnusedPorts(parameters, ports)
        
        createNewInputPorts(sibActivity, parameters, ports)
    }
    
    private def updateOutputPorts(SibActivity sibActivity) {
        val externalActivity = sibActivity.activity
        
        val parameters = externalActivity.outputParametersLists.head.outputParameters
        val ports      = sibActivity.sibOutputPorts
        
        removeOldAndUnusedPorts(parameters, ports)
        
        createNewOutputPorts(sibActivity, parameters, ports)
    }
    
    private def removeOldAndUnusedPorts(List<? extends Parameter> parameters, List<? extends SibPort> ports) {
        val oldPorts = ports.filter[port | parameters.forall[parameter | parameter.name != port.name]]
         oldPorts.forEach[delete()]
    }
    
    private def createNewInputPorts(SibActivity sibActivity, List<InputParameter> parameters, List<SibInputPort> ports) {
        val parametersWithoutPort = getParametersWithoutPort(parameters, ports)

        parametersWithoutPort.forEach[parameter |
            val newPort = sibActivity.newSibStaticInputPort(0, 0)
            newPort.name     = parameter.name
            newPort.dataType = DataTypeConverter.convertDataType(parameter.dataType)
        ]
    }
    
    private def createNewOutputPorts(SibActivity sibActivity, List<OutputParameter> parameters, List<SibOutputPort> ports) {
        val parametersWithoutPort = getParametersWithoutPort(parameters, ports)

        parametersWithoutPort.forEach[parameter |
            val newPort = sibActivity.newSibOutputPort(0, 0)
            newPort.name     = parameter.name
            newPort.dataType = DataTypeConverter.convertDataType(parameter.dataType)
        ]
    }
    
    private def getParametersWithoutPort(List<? extends Parameter> parameters, List<? extends SibPort> ports) {
        return parameters.filter[parameter | ports.forall[port | parameter.name != port.name]]
    }
    
    private def sortSibPorts(SibActivity sibActivity) {
        val dummySib = sibActivity.container.newSibActivity(sibActivity.activity, 0, 0)
        
        val newNodeList = sibActivity.nodes.sortWith(sibPortComparator)
        
        newNodeList.forEach[p | p.moveTo(dummySib, 0, 0)]
        newNodeList.forEach[p | p.moveTo(sibActivity, 0, 0)]
        
        dummySib.delete()
    }
    
    private def Comparator<SibPort> sibPortComparator() {
        return [node1, node2 |
            if (node1 instanceof SibInputPort && node2 instanceof SibOutputPort) {
                return -1
            } else if (node1 instanceof SibOutputPort && node2 instanceof SibInputPort) {
                return 1
            } else {
                return node1.name.compareTo(node2.name)
            }
        ]
    }
    
}
