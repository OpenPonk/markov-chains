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
