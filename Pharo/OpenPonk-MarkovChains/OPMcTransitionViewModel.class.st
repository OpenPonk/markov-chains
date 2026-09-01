"
View model for Markov Chain transitions.
Handles model attachment logic between source and target states, and provides icons for the UI layer.
"
Class {
	#name : 'OPMcTransitionViewModel',
	#superclass : 'OPDirectedAssociationViewModel',
	#category : 'OpenPonk-MarkovChains-ViewModels',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'ViewModels'
}

{ #category : 'accessing' }
OPMcTransitionViewModel class >> modelClass [ ^ OPMcTransition
]

{ #category : 'construction' }
OPMcTransitionViewModel >> attachModelFrom: sourceViewModel to: targetViewModel [
	self model source: sourceViewModel model.
	self model target: targetViewModel model.
]

{ #category : 'accessing' }
OPMcTransitionViewModel >> icon [ ^ OPCoreIcons opFsmTransitionIcon
]
