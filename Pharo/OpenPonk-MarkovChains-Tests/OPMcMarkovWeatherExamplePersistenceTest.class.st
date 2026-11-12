"
Integration tests ensuring that the Markov Chain weather example model correctly serializes and materializes.
"
Class {
	#name : 'OPMcMarkovWeatherExamplePersistenceTest',
	#superclass : 'OPExamplePersistenceTest',
	#category : 'OpenPonk-MarkovChains-Tests-Examples',
	#package : 'OpenPonk-MarkovChains-Tests',
	#tag : 'Examples'
}

{ #category : 'hooks' }
OPMcMarkovWeatherExamplePersistenceTest >> createExampleModel [

	^ OPMcExamples exampleMarkovWeather
]
