package de.learnlib.studio.wizards.experiments

import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.core.runtime.Path
import org.eclipse.jface.wizard.WizardPage
import org.eclipse.swt.SWT
import org.eclipse.swt.events.SelectionAdapter
import org.eclipse.swt.events.SelectionEvent
import org.eclipse.swt.layout.GridData
import org.eclipse.swt.layout.GridLayout
import org.eclipse.swt.widgets.Button
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.FileDialog
import org.eclipse.swt.widgets.Label
import org.eclipse.swt.widgets.TabFolder
import org.eclipse.swt.widgets.TabItem
import org.eclipse.swt.widgets.Text

import de.jabc.cinco.meta.runtime.xapi.WorkspaceExtension

import de.learnlib.studio.experiment.experiment.Experiment
import de.learnlib.studio.mealy.mealy.Mealy
import de.learnlib.studio.symbol.symbol.Symbol
import java.nio.file.FileSystems

class ExperimentWizardMQOraclePage extends WizardPage {
    
    TabFolder tabFolder
    
	Text mealyText
	Text symbolText
    
    String[] symbolNames
    
    new() {
        super("mqOraclePage")
        title = "Experiment Setup Wizard"
        description = "Please select the MQ Oracle you want to use."
        pageComplete = true
    }
    
    override createControl(Composite parent) {
        val container = new Composite(parent, SWT::NULL)
        val layout = new GridLayout()
        container.setLayout(layout)
        layout.numColumns = 1
        layout.verticalSpacing = 9
        
        val Label label = new Label(container, SWT::NULL)
        label.setText("&EQ Oracle:")
        
        this.tabFolder = new TabFolder(container, SWT::NONE)
        val gd = new GridData(GridData::FILL_BOTH)
        tabFolder.layoutData = gd
        
        createMealyTab(tabFolder)   
        createSymbolTab(tabFolder)
        
        setControl(container)
    }
    
    def getMQ() {
        val activeTab = tabFolder.selection
        
        "active tab: " + activeTab
    }
    
    private def createMealyTab(TabFolder parent) {
        val newTabItem  = new TabItem(parent, SWT::NONE)
        newTabItem.text = "Mealy"
        
        var innerContainer = new Composite(parent, SWT.BORDER)
        var innerContainerLayout = new GridLayout()
        innerContainerLayout.numColumns = 3
        innerContainerLayout.verticalSpacing = 9
        innerContainer.layout = innerContainerLayout
        newTabItem.control = innerContainer
        
        val label = new Label(innerContainer, SWT::NULL)
        label.text = "Mealy Machine:"
        
        mealyText = new Text(innerContainer, SWT::BORDER)
        mealyText.layoutData = new GridData(GridData::FILL_HORIZONTAL)
        
        var button = new Button(innerContainer, SWT::PUSH)
        button.setText("Browse...")
        button.addSelectionListener(new SelectionAdapter() {

            override void widgetSelected(SelectionEvent e) {
                val dialog = new FileDialog(getShell(), SWT::OPEN)
                dialog.filterNames      = #["Mealy Machines", "All Files"]
                dialog.filterExtensions = #["*.mealy", "*.*"]
                
                val workspaceRoot = ResourcesPlugin.workspace.root.location.toOSString()
                println(workspaceRoot)
                dialog.filterPath = workspaceRoot
                println("Filter path" + dialog.filterPath)
		        	
		        val path = dialog.open()
		        if (!path.isNullOrEmpty) {
					mealyText.text = path
					symbolText.text = ""
					pageComplete = true
		        }
            }

        })
    }
    
    
    private def createSymbolTab(TabFolder parent) {
        val newTabItem  = new TabItem(parent, SWT::NONE)
        newTabItem.text = "Symbols"
        
        var innerContainer = new Composite(parent, SWT.BORDER)
        var innerContainerLayout = new GridLayout()
        innerContainerLayout.numColumns = 3
        innerContainerLayout.verticalSpacing = 9
        innerContainer.layout = innerContainerLayout
        newTabItem.control = innerContainer
        
        val label = new Label(innerContainer, SWT::NULL)
        label.text = "Symbols:"
        
        symbolText = new Text(innerContainer, SWT::BORDER)
        symbolText.layoutData = new GridData(GridData::FILL_HORIZONTAL)
        
        var button = new Button(innerContainer, SWT::PUSH)
        button.setText("Browse...")
        button.addSelectionListener(new SelectionAdapter() {

            override void widgetSelected(SelectionEvent e) {
                val dialog = new FileDialog(getShell(), SWT::OPEN.bitwiseOr(SWT::MULTI))
                dialog.filterNames      = #["Symbols", "All Files"]
                dialog.filterExtensions = #["*.symbol", "*.*"]
                
                val workspaceRoot = ResourcesPlugin.workspace.root.location.toOSString()
                println(workspaceRoot)
                dialog.filterPath = workspaceRoot
                println("Filter path" + dialog.filterPath)
		        	
		        val path = dialog.open()
		        if (!path.isNullOrEmpty) {
					symbolNames = dialog.fileNames
                    symbolText.text = path
				    mealyText.text = ""
			        pageComplete = true
		        }
            }

        })
    }
    
    
    private def createTree(Composite parent, boolean multiSelect) {
//        var swt_flags = SWT::BORDER
//        swt_flags = swt_flags.bitwiseOr(SWT::H_SCROLL)
//        swt_flags = swt_flags.bitwiseOr(SWT::V_SCROLL)
//        if (multiSelect) {
//            swt_flags = swt_flags.bitwiseOr(SWT::CHECK)
//        }
//        val tree = new Tree(parent, swt_flags)
//        tree.layoutData = new GridData(GridData::FILL_BOTH)
//        tree.setHeaderVisible(true)
//        
//        var column1 = new TreeColumn(tree, SWT::LEFT);
//        column1.setText("Resource");
//        column1.setWidth(200);
//        
//        val roots = File.listRoots()
//        roots.forEach[root | 
//            val newTreeItem = new TreeItem(tree, 0)
//            newTreeItem.text = root.toString()
//            newTreeItem.data = root
//            new TreeItem(newTreeItem, 0)
//        ]    
//        tree.addListener(SWT::Expand, [event | 
//            val treeItem = event.item as TreeItem
//            val items = treeItem.items
//            
//            items.forEach[item |
//                if (item.data !== null) {
//                    return
//                }
//                item.dispose
//            ]
//            
//            val treeItemFile = treeItem.data as File
//            val treeItemFiles = treeItemFile.listFiles()
//            if (treeItemFiles === null) {
//                return
//            }
//            treeItemFiles.forEach[f | 
//                val newTreeItem = new TreeItem(treeItem, 0)
//                newTreeItem.text = f.getName()
//                newTreeItem.data = f
//                if (f.isDirectory) {
//                    new TreeItem(newTreeItem, 0)
//                }
//            ]
//        ])
//        
//        tree.addListener(SWT::Selection, [event | 
//            pageComplete = true
//        ])
//
//        return tree
    }
    
    def createExperimentNode(Experiment experiment) {
        println("########################")
        println("Creating MQ")
        
        if (tabFolder.selectionIndex == 0) {
		    println("\tBased on Mealy")
            val mealyPath = mealyText.text
		    println("\t" + mealyPath)
		
			val location = Path.fromOSString(mealyPath)
			val ifile= ResourcesPlugin.workspace.getRoot().getFileForLocation(location)
			println(ifile)
			
		    val mealyReference = new WorkspaceExtension().getGraphModel(ifile, Mealy)
		    
		    println(mealyReference)
		    
			return experiment.newMealyMembershipOracle(mealyReference, 700, 200)
		} else {
		    println("\tBased on Symbols")
		    val firstSymbolPath = FileSystems.getDefault().getPath(symbolText.text)
		    val symbolFolder = firstSymbolPath.getParent()
		    
			val sulMQ = experiment.newSULMembershipOracle(700, 200, 180, symbolNames.size * 75 + 30)
			
			symbolNames.forEach[n, i |
			    val filePath = symbolFolder.resolve(n)
			    val absolutePath = filePath.toFile().absolutePath
                val location = Path.fromOSString(absolutePath)
                val ifile = ResourcesPlugin.workspace.getRoot().getFileForLocation(location)
                val symbolReference = new WorkspaceExtension().getGraphModel(ifile, Symbol)
                sulMQ.newSULMembershipOracleSymbol(symbolReference, 30, i * 75 + 30)
			]
			
			return sulMQ
		}
		
    }
    
}
