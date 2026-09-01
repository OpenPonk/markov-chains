"
Deprecated model representing an incoming transition in a Markov Chain diagram.
Retained for backward compatibility.
"
Class {
	#name : 'OPMcIncomingTransition',
	#superclass : 'OPMcTransition',
	#category : 'OpenPonk-MarkovChains-ViewModels',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'ViewModels'
}

{ #category : 'testing' }
OPMcIncomingTransition class >> isDeprecated [

	^ true
]

{ #category : 'instance creation' }
OPMcIncomingTransition class >> new [

	^ self superclass new
]
