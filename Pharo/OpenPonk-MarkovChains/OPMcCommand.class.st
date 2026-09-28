"
An abstract base class for Commander 1 model commands executed within a Markov Chains diagram editor.
"
Class {
	#name : 'OPMcCommand',
	#superclass : 'OPModelCommand',
	#category : 'OpenPonk-MarkovChains-Commands',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'Commands'
}

{ #category : 'testing' }
OPMcCommand class >> canBeExecutedInEditor: anEditor [
	"Answers true if the active editor plugin is Markov Chains."
	^ anEditor plugin isKindOf: OPMcPlugin
]

{ #category : 'testing' }
OPMcCommand class >> isAbstract [
	"Answers true if this class is the abstract root of Markov Chains model commands."
	^ self = OPMcCommand
]
