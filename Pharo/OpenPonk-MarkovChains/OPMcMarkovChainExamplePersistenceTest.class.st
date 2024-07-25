Class {
	#name : 'OPMcMarkovChainExamplePersistenceTest',
	#superclass : 'OPExamplePersistenceTest',
	#category : 'OpenPonk-MarkovChains-Tests',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'Tests'
}

{ #category : 'hooks' }
OPMcMarkovChainExamplePersistenceTest >> createExampleModel [

	^ OPMcExamples exampleMarkovChain
]
