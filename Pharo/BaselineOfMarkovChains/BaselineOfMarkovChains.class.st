Class {
	#name : #BaselineOfMarkovChains,
	#superclass : #BaselineOf,
	#category : #BaselineOfMarkovChains
}

{ #category : #baselines }
BaselineOfMarkovChains >> baseline: spec [

	<baseline>
	spec for: #common do: [
		spec
			baseline: 'Mustache'
			with: [ spec repository: 'github://noha/mustache:v1.1' ].
		spec baseline: 'XMLParser' with: [
			spec
				repository: 'github://pharo-contributions/XML-XMLParser:3.5.x/src';
				loads: #( Core ) ].
		spec baseline: 'XPath' with: [
			spec
				repository: 'github://pharo-contributions/XML-XPath:3450f91/src';
				loads: #( Core ) ].
		spec
			baseline: 'OpenPonk'
			with: [ spec repository: 'github://openponk/openponk' ].
		spec
			baseline: 'OpenPonkModel'
			with: [ spec repository: 'github://OpenPonk/openponk-model' ].
		spec
			package: 'OpenPonk-MarkovChains'
			with: [
			spec requires: #( 'OpenPonkModel' 'Mustache' 'XMLParser'
			   'XPath' ) ].
		spec group: 'plugin' with: #( 'OpenPonk-MarkovChains' ).
		spec group: 'default' with: #( 'OpenPonk' 'plugin' ) ]
]
