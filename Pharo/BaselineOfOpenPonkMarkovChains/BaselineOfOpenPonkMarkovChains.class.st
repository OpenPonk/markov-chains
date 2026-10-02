"
Metacello baseline for the OpenPonk Markov Chains plugin, defining its package dependencies and load configurations.
"
Class {
	#name : 'BaselineOfOpenPonkMarkovChains',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfOpenPonkMarkovChains',
	#package : 'BaselineOfOpenPonkMarkovChains'
}

{ #category : 'baselines' }
BaselineOfOpenPonkMarkovChains >> baseline: spec [

	<baseline>
	spec for: #common do: [
		spec
			baseline: 'Mustache'
			with: [ spec repository: 'github://noha/mustache:a8db6a2' ].
		spec
			baseline: 'OpenPonk'
			with: [ spec repository: 'github://openponk/openponk:v5.0.1' ].
		spec
			baseline: 'OpenPonkModel'
			with: [ spec repository: 'github://openponk/openponk-model:v5.0.1' ].
		spec
			package: 'OpenPonk-MarkovChains'
			with: [
			spec requires: #( 'OpenPonkModel' 'Mustache' ) ].
		spec group: 'plugin' with: #( 'OpenPonk-MarkovChains' ).
		spec group: 'default' with: #( 'OpenPonk' 'plugin' ) ]
]
