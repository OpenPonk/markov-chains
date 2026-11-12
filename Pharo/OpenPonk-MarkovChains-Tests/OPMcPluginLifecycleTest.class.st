"
Verifies the initialization, registration, and shutdown lifecycle of the Markov Chains plugin.
"
Class {
	#name : 'OPMcPluginLifecycleTest',
	#superclass : 'OPAbstractPluginExampleLifecycleTest',
	#category : 'OpenPonk-MarkovChains-Tests-Plugin',
	#package : 'OpenPonk-MarkovChains-Tests',
	#tag : 'Plugin'
}

{ #category : 'accessing' }
OPMcPluginLifecycleTest class >> pluginClass [
	"Answers the OPPlugin class under test."
	^ OPMcPlugin
]
