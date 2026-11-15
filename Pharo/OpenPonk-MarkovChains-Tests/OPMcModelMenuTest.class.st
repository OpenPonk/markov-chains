"
Verifies the population, state, and execution of Commander 1 model commands within the Markov Chains editor toolbar menu.
"
Class {
	#name : 'OPMcModelMenuTest',
	#superclass : 'TestCase',
	#instVars : [
		'toolbarPresenter',
		'mockWorkbench'
	],
	#category : 'OpenPonk-MarkovChains-Tests-Commands',
	#package : 'OpenPonk-MarkovChains-Tests',
	#tag : 'Commands'
}

{ #category : 'running' }
OPMcModelMenuTest >> setUp [
	| mockProjectController |
	super setUp.
	mockWorkbench := Mock new.
	mockProjectController := Mock new.
	mockProjectController stub undoManager willReturn: OPUndoManager new.
	mockWorkbench stub projectController willReturn: mockProjectController.
	mockWorkbench stub workbench willReturn: mockWorkbench.
	toolbarPresenter := OPWorkbenchToolbar newApplication: SpApplication defaultApplication.
	toolbarPresenter owner: mockWorkbench
]

{ #category : 'running' }
OPMcModelMenuTest >> tearDown [
	toolbarPresenter := nil.
	mockWorkbench := nil.
	super tearDown
]

{ #category : 'tests' }
OPMcModelMenuTest >> testModelMenuContainsMcCommanderActivationsWhenMcEditorFocused [
	"Verifies that the Model menu contains Markov Chains Commander 1 commands when an MC editor is focused."

	| mcPlugin testEditor modelMenuItem subMenuLabels |
	mcPlugin := OPPluginRegistry default plugins detect: [ :eachPluginCandidate | eachPluginCandidate isKindOf: OPMcPlugin ].
	testEditor := (OPEditor on: mcPlugin)
		              workbench: mockWorkbench;
		              yourself.

	toolbarPresenter focusedEditor: testEditor.
	modelMenuItem := toolbarPresenter menu menuGroups first menuItems detect: [ :eachMenuItem | eachMenuItem name = 'Model' ].
	subMenuLabels := modelMenuItem subMenu menuGroups flatCollect: [ :eachGroup |
		                 eachGroup menuItems collect: [ :eachItem | eachItem name ] ].

	self
		assertCollection: subMenuLabels
		includesAll: #( 'Export as GraphML...' 'Import from GraphML...' 'Open Simulator' 'Open Predicted Simulation'
		   'Launch Server' )
]

{ #category : 'tests' }
OPMcModelMenuTest >> testXmlCommandsExecuteDelegatesToMcGraphML [
	"Verifies menu names and execution delegation of GraphML export and import commands."

	| targetModel mockDiagramController mockEditor toolContext exportedModel importedModel importedEditor exportCommand importCommand |
	targetModel := OPMc named: 'Menu Command Chain'.
	mockDiagramController := Mock new.
	mockDiagramController stub model willReturn: targetModel.
	mockEditor := Mock new.
	mockEditor stub diagramController willReturn: mockDiagramController.

	exportedModel := nil.
	importedModel := nil.
	importedEditor := nil.
	(OPMcGraphML stub exportPackage: Any) will: [ :aModel | exportedModel := aModel ].
	(OPMcGraphML stub importToModel: Any inEditor: Any) will: [ :aModel :anEditor |
			importedModel := aModel.
			importedEditor := anEditor ].

	exportCommand := OPMcExportXmlCommand new.
	self assert: exportCommand defaultMenuItemName equals: 'Export as GraphML...'.
	importCommand := OPMcImportXmlCommand new.
	self assert: importCommand defaultMenuItemName equals: 'Import from GraphML...'.

	toolContext := CmdSimpleToolContext for: mockEditor.
	CmdCommandActivator new
		command: exportCommand;
		context: toolContext;
		executeCommand.
	self assert: exportedModel identicalTo: targetModel.

	CmdCommandActivator new
		command: importCommand;
		context: toolContext;
		executeCommand.
	self assert: importedModel identicalTo: targetModel.
	self assert: importedEditor identicalTo: mockEditor
]
