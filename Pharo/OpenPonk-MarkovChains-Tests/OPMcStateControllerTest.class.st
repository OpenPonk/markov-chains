"
Tests controller interactions, state probabilities, and circular shape rendering for Markov Chain states.
"
Class {
	#name : 'OPMcStateControllerTest',
	#superclass : 'OPMcElementControllerTest',
	#category : 'OpenPonk-MarkovChains-Tests-Controllers',
	#package : 'OpenPonk-MarkovChains-Tests',
	#tag : 'Controllers'
}

{ #category : 'constants' }
OPMcStateControllerTest class >> diagramElementClass [
	^ OPMcStateShape
]

{ #category : 'constants' }
OPMcStateControllerTest >> controllerClass [
	^ OPMcStateController
]

{ #category : 'constants' }
OPMcStateControllerTest >> modelClass [
	^ OPMcState
]

{ #category : 'tests' }
OPMcStateControllerTest >> testAdornmentsSelectConnectionAndVertexCreationTools [

	| palette mockEditor mockWorkbench capturedActions mockBuilder transitionTool nodeTool targetState targetController createdTransitions |
	diagramController model add: model.
	controller := diagramController showWithoutDependentInDiagramModel: model.
	mockWorkbench := Mock new.
	mockEditor := Mock new.
	mockEditor stub workbench willReturn: mockWorkbench.
	palette := OPPalette new.
	palette owner: mockEditor.
	palette createPaletteFor: diagramController.
	mockEditor stub palette willReturn: palette.
	diagramController editor: mockEditor.
	[
		capturedActions := OrderedCollection new.
		mockBuilder := Mock new.
		(mockBuilder stub addIconShape: Any action: Any) will: [ :iconShape :actionBlock | capturedActions add: actionBlock ].

		(controller diagramElement instVarNamed: #adornmentCreationBlock) value: mockBuilder.
		self assert: capturedActions size equals: 2.

		capturedActions second value.
		transitionTool := palette selectedTool.
		self assert: transitionTool class identicalTo: OPConnectionCreationTool.
		self assert: (transitionTool instVarNamed: #factory) value class identicalTo: OPMcTransitionController.

		capturedActions first value.
		nodeTool := palette selectedTool.
		self assert: nodeTool class identicalTo: OPNodeCreationTool.
		self assert: (nodeTool instVarNamed: #factory) value class identicalTo: OPMcStateController.

		targetState := OPMcState named: 'Target'.
		diagramController model add: targetState.
		targetController := diagramController showWithoutDependentInDiagramModel: targetState.
		(nodeTool instVarNamed: #onComplete) value: targetController.
		createdTransitions := diagramController model transitions.
		self assert: createdTransitions size equals: 1.
		self assert: createdTransitions first source identicalTo: controller model.
		self assert: createdTransitions first target identicalTo: targetState ] ensure: [ diagramController editor: nil ]
]

{ #category : 'tests' }
OPMcStateControllerTest >> testUnhookDiagramElementResetsAdornmentCreationBlock [

	| shape |
	diagramController model add: model.
	controller := diagramController showWithoutDependentInDiagramModel: model.
	shape := controller diagramElement.
	controller unhookDiagramElement.
	self
		assert: ((shape instVarNamed: #adornmentCreationBlock) value: nil) isNil
		description: 'Unhooked adornmentCreationBlock must be a no-op'
]
