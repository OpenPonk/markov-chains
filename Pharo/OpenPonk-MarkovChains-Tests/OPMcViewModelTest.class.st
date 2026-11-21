"
Verifies structural hierarchy, model class mappings, attachment helpers, and icon definitions across Markov chain view models.
"
Class {
	#name : 'OPMcViewModelTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-MarkovChains-Tests-ViewModels',
	#package : 'OpenPonk-MarkovChains-Tests',
	#tag : 'ViewModels'
}

{ #category : 'tests' }
OPMcViewModelTest >> testViewModelChildrenDependentElementsAndIcons [

	| markovChain stateAlpha stateBeta transitionAlphaBeta mcViewModel stateAlphaViewModel stateBetaViewModel transitionViewModel |
	markovChain := OPMc named: 'Chain'.
	mcViewModel := OPMcViewModel new model: markovChain.
	self assertEmpty: mcViewModel childrenModels.
	self assert: mcViewModel modelRootViewModel identicalTo: mcViewModel.
	self assert: mcViewModel icon bits equals: OPMcIcons opMcDiagramIcon bits.

	stateAlpha := OPMcState named: 'alpha'.
	stateBeta := OPMcState named: 'beta'.
	transitionAlphaBeta := (stateAlpha => stateBeta)
		                       name: '0.5';
		                       yourself.
	markovChain addAll: {
			stateAlpha.
			stateBeta.
			transitionAlphaBeta }.

	self assertCollection: mcViewModel childrenModels hasSameElements: {
			stateAlpha.
			stateBeta }.

	stateAlphaViewModel := OPMcStateViewModel new model: stateAlpha.
	stateBetaViewModel := OPMcStateViewModel new model: stateBeta.
	self assert: stateAlphaViewModel icon bits equals: OPMcIcons opMcStateIcon bits.
	self assertCollection: stateAlphaViewModel childrenModels hasSameElements: { transitionAlphaBeta }.
	self assertCollection: stateAlphaViewModel dependentElements hasSameElements: { transitionAlphaBeta }.
	self assertCollection: stateBetaViewModel dependentElements hasSameElements: { transitionAlphaBeta }.

	transitionViewModel := OPMcTransitionViewModel new model: (OPMcTransition new
			                        name: '1.0';
			                        yourself).
	self assert: transitionViewModel icon bits equals: OPMcIcons opMcTransitionIcon bits.
	transitionViewModel attachModelFrom: stateAlphaViewModel to: stateBetaViewModel.
	self assert: transitionViewModel model source identicalTo: stateAlpha.
	self assert: transitionViewModel model target identicalTo: stateBeta
]

{ #category : 'tests' }
OPMcViewModelTest >> testViewModelMetadataAndClassMappings [

	self assert: OPMcVertexViewModel isAbstract description: 'Base vertex view model must report as abstract'.
	self deny: OPMcStateViewModel isAbstract description: 'State view model must not report as abstract'.
	self deny: OPMcViewModel isAbstract description: 'Diagram view model must not report as abstract'.
	self deny: OPMcTransitionViewModel isAbstract description: 'Transition view model must not report as abstract'.

	self assert: OPMcViewModel modelClass identicalTo: OPMc.
	self assert: OPMcViewModel commonModelClassPrefix equals: 'OPMc'.
	self assert: OPMcVertexViewModel modelClass identicalTo: OPMcVertex.
	self assert: OPMcStateViewModel modelClass identicalTo: OPMcState.
	self assert: OPMcTransitionViewModel modelClass identicalTo: OPMcTransition
]
