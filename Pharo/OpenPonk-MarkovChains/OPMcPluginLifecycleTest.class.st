Class {
	#name : 'OPMcPluginLifecycleTest',
	#superclass : 'OPAbstractPluginExampleLifecycleTest',
	#category : 'OpenPonk-MarkovChains-Tests',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'Tests'
}

{ #category : 'accessing' }
OPMcPluginLifecycleTest class >> pluginClass [
	"Answers the OPPlugin class under test."
	^ OPMcPlugin
]
