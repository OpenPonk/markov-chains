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
	#category : 'OpenPonk-MarkovChains-Tests',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'Tests'
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
	mcPlugin := OPPluginRegistry default plugins
		detect: [ :eachPluginCandidate | eachPluginCandidate isKindOf: OPMcPlugin ].
	testEditor := (OPEditor on: mcPlugin)
		workbench: mockWorkbench;
		yourself.

	toolbarPresenter focusedEditor: testEditor.
	modelMenuItem := toolbarPresenter menu menuGroups first menuItems
		detect: [ :eachMenuItem | eachMenuItem name = 'Model' ].
	subMenuLabels := modelMenuItem subMenu menuGroups
		flatCollect: [ :eachGroup | eachGroup menuItems collect: [ :eachItem | eachItem name ] ].

	self assertCollection: subMenuLabels includesAll: #( 'Export as xmi' 'Import as xmi' 'Open Simulator' 'Open Predicted Simulation' 'Launch Server' )
]
