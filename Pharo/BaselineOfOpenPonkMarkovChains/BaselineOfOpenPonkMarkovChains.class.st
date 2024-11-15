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
			with: [ spec repository: 'github://openponk/openponk:v4.1.x' ].
		spec
			baseline: 'OpenPonkModel'
			with: [ spec repository: 'github://OpenPonk/openponk-model:v4.1.x' ].
		spec
			package: 'OpenPonk-MarkovChains'
			with: [
			spec requires: #( 'OpenPonkModel' 'Mustache' ) ].
		spec group: 'plugin' with: #( 'OpenPonk-MarkovChains' ).
		spec group: 'default' with: #( 'OpenPonk' 'plugin' ) ]
]
