"
Verifies the serialization and deserialization roundtrip persistence for Markov Chain models and diagrams.
"
Class {
	#name : 'OPMcPluginRoundtripTest',
	#superclass : 'OPAbstractPluginExampleRoundtripTest',
	#category : 'OpenPonk-MarkovChains-Tests',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'Tests'
}

{ #category : 'accessing' }
OPMcPluginRoundtripTest class >> pluginClass [
	^ OPMcPlugin
]
