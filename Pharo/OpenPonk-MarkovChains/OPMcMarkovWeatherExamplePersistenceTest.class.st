"
Integration tests ensuring that the Markov Chain weather example model correctly serializes and materializes.
"
Class {
	#name : 'OPMcMarkovWeatherExamplePersistenceTest',
	#superclass : 'OPExamplePersistenceTest',
	#category : 'OpenPonk-MarkovChains-Tests',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'Tests'
}

{ #category : 'hooks' }
OPMcMarkovWeatherExamplePersistenceTest >> createExampleModel [

	^ OPMcExamples exampleMarkovWeather
]
