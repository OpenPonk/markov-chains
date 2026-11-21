"
Abstract view model for Markov Chain vertices.
Manages hierarchy logic and child dependencies for the workbench integration.
"
Class {
	#name : 'OPMcVertexViewModel',
	#superclass : 'OPModelObjectViewModel',
	#category : 'OpenPonk-MarkovChains-ViewModels',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'ViewModels'
}

{ #category : 'testing' }
OPMcVertexViewModel class >> isAbstract [

	^ self = OPMcVertexViewModel
]

{ #category : 'accessing' }
OPMcVertexViewModel class >> modelClass [ ^ OPMcVertex
]

{ #category : 'accessing' }
OPMcVertexViewModel >> childrenModels [

	^ self model incoming asOrderedCollection
		  addAll: self model outgoing;
		  removeDuplicates;
		  yourself
]

{ #category : 'accessing' }
OPMcVertexViewModel >> dependentElements [

	^ (self model incoming , self model outgoing) asSet
]
