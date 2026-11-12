"
Verifies the serialization and deserialization roundtrip persistence for Markov Chain models and diagrams.
"
Class {
	#name : 'OPMcPluginRoundtripTest',
	#superclass : 'OPAbstractPluginExampleRoundtripTest',
	#category : 'OpenPonk-MarkovChains-Tests-Plugin',
	#package : 'OpenPonk-MarkovChains-Tests',
	#tag : 'Plugin'
}

{ #category : 'accessing' }
OPMcPluginRoundtripTest class >> pluginClass [
	^ OPMcPlugin
]
