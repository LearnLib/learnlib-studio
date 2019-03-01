package de.learnlib.studio.symbol.hooks

import de.jabc.cinco.meta.runtime.hook.CincoPostCreateHook

import de.learnlib.studio.symbol.symbol.SibActivity
import de.learnlib.studio.symbol.symbol.SymbolFactory
import de.learnlib.studio.symbol.utils.DataTypeConverter
import de.learnlib.studio.symbol.utils.SibActivityChildrenLayouter


class SibActivityPostCreateHook extends CincoPostCreateHook<SibActivity> {
    
    override postCreate(SibActivity sib) {
        val externalActivity = sib.activity     

        sib.branches += externalActivity.branchesLists.head.branchs.map[newSibBranch(name, error)]

        externalActivity.inputParametersLists.head.inputParameters.forEach[p |
            val newInputPort = sib.newSibStaticInputPort(0, 0)
            newInputPort.name     = p.name
            newInputPort.dataType = DataTypeConverter.convertDataType(p.dataType)
        ]
        
        externalActivity.outputParametersLists.head.outputParameters.forEach[r |
            val newOutputPort = sib.newSibOutputPort(0, 0)
            newOutputPort.name     = r.name
            newOutputPort.dataType = DataTypeConverter.convertDataType(r.dataType)
        ]
        
        SibActivityChildrenLayouter.INSTANCE.layoutAll(sib)
    }
    
    private def newSibBranch(String name, boolean error) {
        val newSibBranch = SymbolFactory.eINSTANCE.createSibBranch()
        newSibBranch.name  = name
        newSibBranch.error = error
        return newSibBranch
    }
    
}
