Class {
	#name : 'OPMcExamples',
	#superclass : 'Object',
	#category : 'OpenPonk-MarkovChains-Examples',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'Examples'
}

{ #category : 'as yet unclassified' }
OPMcExamples class >> exampleEmpty [
	| project mc |
	project := OPProject new name: 'New Markov Chain'.
	mc := OPMc new name: 'New Markov Chain Diagram'.
	project addModel: mc.
	(OPWorkbench openProject: project) showAllElementsInAllDiagrams
]

{ #category : 'as yet unclassified' }
OPMcExamples class >> exampleMarkovChain [
	| project mc states stateNames |
	project := OPProject named: 'MC Example'.
	mc := OPMc named: 'Markov Chain Example'.
	project addModel: mc.	

	stateNames := #('a' 'b' 'c' 'd' 'e' 'f' 
					'g' 'h' 'i' 'j' 'k' 'l' 
					'm' 'n' 'o' 'p' 'q' 'r' 
					's' 't' 'u' 'v' 'w' 'x' 
					'y' 'z' 'At').
					
	states := Array new: 27.
	1 to: states size do: [ :i | 
		states at: i put: (OPMcState named: (stateNames at: i)).
		mc add: (states at: i) ].

	states do: [ :stateFrom |
		states do: [ :stateTo |
			mc add: (stateFrom -> stateTo name: '0.04') ] ].

	(OPWorkbench openProject: project) showAllElementsInAllDiagrams

]

{ #category : 'as yet unclassified' }
OPMcExamples class >> exampleMarkovWeather [
	| project mc sunny cloudy rainy |
	project := OPProject named: 'MC Weather Example'.
	mc := OPMc named: 'Markov Weather'.
	project addModel: mc.
	
	sunny := OPMcState named: 'sunny'.
	cloudy := OPMcState named: 'cloudy'.
	rainy := OPMcState named: 'rainy'.
	mc 
		add: sunny;
		add: cloudy;
		add: rainy.
	mc
		addAll:
		{ (sunny -> sunny name: '0.6').
		(sunny -> cloudy name: '0.3').
		(sunny -> rainy name: '0.1').
		(cloudy -> cloudy name: '0.3').
		(cloudy -> sunny name: '0.2').
		(cloudy -> rainy name: '0.5').
		(rainy -> rainy name: '0.5').
		(rainy -> sunny name: '0.4').
		(rainy -> cloudy name: '0.1'). }.
	(OPWorkbench openProject: project) showAllElementsInAllDiagrams
]

{ #category : 'world menu' }
OPMcExamples class >> menuCommandOn: aBuilder [

	<worldMenu>
	(aBuilder item: #OPMC)
		label: 'Markov Chains';
		icon: OPCoreIcons opMcDiagramIcon;
		action: [ self exampleEmpty ];
		parent: #MostUsedTools;
		order: 220;
		with: [ 
			(aBuilder item: #'MC Example')
				parent: #OPMC;
				label: 'Markov Chains Weather';
				icon: OPCoreIcons opMcDiagramIcon;
				action: [ self exampleMarkovWeather  ].
			(aBuilder item: #'MC Example 2')
				parent: #OPMC; 
				label: 'Upscaled Markov Chain';
				icon: OPCoreIcons opMcDiagramIcon;
				action: [ self exampleMarkovChain  ] ]
]
