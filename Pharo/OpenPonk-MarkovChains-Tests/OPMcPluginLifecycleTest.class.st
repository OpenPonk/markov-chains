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

{ #category : 'tests' }
OPMcPluginLifecycleTest >> testPluginMetadataAndRepositoryName [

	| pluginInstance |
	self assert: OPMcPlugin repositoryName equals: #'markov-chains'.
	self deny: OPMcPlugin isTestingOnly description: 'Markov Chains plugin class must not be marked as testing only'.

	pluginInstance := self plugin.
	self assert: pluginInstance name equals: 'MC Diagram'.
	self assert: pluginInstance modelClass identicalTo: OPMc.
	self assert: pluginInstance diagramControllerClass identicalTo: OPMcController.
	self assert: pluginInstance layouterClass identicalTo: OPMcLayouter.
	self assert: pluginInstance modelSerializerClass identicalTo: OPMcModelSerializer.
	self assert: pluginInstance supportsHidingElements description: 'Markov Chains plugin must support hiding elements'.
	self assert: pluginInstance icon bits equals: OPMcIcons opMcDiagramIcon bits
]
