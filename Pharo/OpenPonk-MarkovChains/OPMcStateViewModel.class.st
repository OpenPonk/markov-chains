"
View model for Markov Chain states.
Provides icons and form building specifications to the workbench without GUI dependencies.
"
Class {
	#name : 'OPMcStateViewModel',
	#superclass : 'OPMcVertexViewModel',
	#category : 'OpenPonk-MarkovChains-ViewModels',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'ViewModels'
}

{ #category : 'accessing' }
OPMcStateViewModel class >> modelClass [ ^ OPMcState
]

{ #category : 'accessing' }
OPMcStateViewModel >> icon [

	^ OPCoreIcons opFsmRegularStateIcon
]
