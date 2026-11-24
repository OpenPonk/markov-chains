"
Verifies GraphML template rendering, node type mapping, model roundtrip export and import, memory file parsing, and error boundary handling for Markov chain models.
"
Class {
	#name : 'OPMcGraphMLTest',
	#superclass : 'TestCase',
	#instVars : [
		'graphML'
	],
	#category : 'OpenPonk-MarkovChains-Tests-Serialization',
	#package : 'OpenPonk-MarkovChains-Tests',
	#tag : 'Serialization'
}

{ #category : 'running' }
OPMcGraphMLTest >> setUp [

	super setUp.
	graphML := OPMcGraphML new
]

{ #category : 'running' }
OPMcGraphMLTest >> tearDown [

	graphML := nil.
	super tearDown
]

{ #category : 'tests' }
OPMcGraphMLTest >> testExportAndImportEmptyModelAndSpecialXmlCharacters [

	| emptyModel importedEmpty specialModel stateSpecial unnamedState specialTransition importedSpecial importedStatesByClass importedSpecialState importedUnnamedState importedTransition |
	emptyModel := OPMcExamples emptyModel.
	importedEmpty := graphML import: (graphML export: emptyModel) into: OPMc new.
	self assert: importedEmpty uuid equals: emptyModel uuid.
	self assert: importedEmpty name equals: 'New Markov Chain Diagram'.
	self assertEmpty: importedEmpty states.
	self assertEmpty: importedEmpty transitions.
	self assertEmpty: importedEmpty elements.

	specialModel := OPMc named: 'Chain & States <v1>'.
	stateSpecial := OPMcState named: 'S & A > B'.
	unnamedState := OPMcState named: ''.
	specialTransition := OPMcTransition from: stateSpecial to: unnamedState named: '0.5 & <1>'.
	specialModel addAll: {
			stateSpecial.
			unnamedState.
			specialTransition }.

	importedSpecial := graphML import: (graphML export: specialModel) into: OPMc new.
	self assert: importedSpecial uuid equals: specialModel uuid.
	self assert: importedSpecial name equals: 'Chain & States <v1>'.
	self assert: importedSpecial states size equals: 2.
	self assert: importedSpecial transitions size equals: 1.

	importedStatesByClass := (importedSpecial states collect: [ :eachState | eachState uuid -> eachState ]) asDictionary.
	importedSpecialState := importedStatesByClass at: stateSpecial uuid.
	importedUnnamedState := importedStatesByClass at: unnamedState uuid.
	self assert: importedSpecialState name equals: 'S & A > B'.
	self assert: importedUnnamedState name equals: ''.

	importedTransition := importedSpecial transitions first.
	self assert: importedTransition name equals: '0.5 & <1>'.
	self assert: importedTransition source identicalTo: importedSpecialState.
	self assert: importedTransition target identicalTo: importedUnnamedState
]

{ #category : 'tests' }
OPMcGraphMLTest >> testExportAndImportRoundtripWithStatesTransitionsAndSelfLoops [

	| originalModel stateSunny stateCloudy selfLoopTransition forwardTransition reverseTransition xmlString parsedDocument graphElement nodeTypes importedModel targetModel importedNodesByName importedTransitions |
	originalModel := OPMc named: 'Weather Chain'.
	stateSunny := OPMcState named: 'sunny'.
	stateCloudy := OPMcState named: 'cloudy'.
	selfLoopTransition := (stateSunny => stateSunny)
		                      name: '0.6';
		                      yourself.
	forwardTransition := (stateSunny => stateCloudy)
		                     name: 'a,b';
		                     yourself.
	reverseTransition := (stateCloudy => stateSunny)
		                     name: '1.0';
		                     yourself.
	originalModel addAll: {
			stateSunny.
			stateCloudy.
			selfLoopTransition.
			forwardTransition.
			reverseTransition }.

	xmlString := graphML export: originalModel.
	parsedDocument := XMLDOMParser parse: xmlString.
	graphElement := (parsedDocument root / #graph) first.
	self assert: (graphElement attributeAt: #id) equals: originalModel uuid asString.
	self assert: (graphElement / #node) size equals: 2.
	self assert: (graphElement / #edge) size equals: 3.
	nodeTypes := graphElement / #node collect: [ :eachNodeElement |
		             (eachNodeElement / #data detect: [ :eachData | (eachData attributeAt: #key) = 'node-type' ]) stringValue ].
	self assertCollection: nodeTypes hasSameElements: #( 'regular' 'regular' ).

	targetModel := OPMc new.
	importedModel := graphML import: xmlString into: targetModel.
	self assert: importedModel identicalTo: targetModel.
	self deny: importedModel identicalTo: originalModel.
	self assert: importedModel uuid equals: originalModel uuid.
	self assert: importedModel name equals: 'Weather Chain'.
	self assert: importedModel states size equals: 2.
	self assert: importedModel transitions size equals: 3.

	importedNodesByName := (importedModel states collect: [ :eachState | eachState name -> eachState ]) asDictionary.
	self assert: (importedNodesByName at: 'sunny') class identicalTo: OPMcState.
	self assert: (importedNodesByName at: 'sunny') uuid equals: stateSunny uuid.
	self assert: (importedNodesByName at: 'sunny') owner identicalTo: importedModel.
	self assert: (importedNodesByName at: 'cloudy') uuid equals: stateCloudy uuid.

	importedTransitions := (importedModel transitions collect: [ :eachTransition | eachTransition name -> eachTransition ])
		                       asDictionary.
	self assert: (importedTransitions at: '0.6') source identicalTo: (importedNodesByName at: 'sunny').
	self assert: (importedTransitions at: '0.6') target identicalTo: (importedNodesByName at: 'sunny').
	self assert: (importedTransitions at: '0.6') uuid equals: selfLoopTransition uuid.
	self assert: (importedTransitions at: 'a,b') source identicalTo: (importedNodesByName at: 'sunny').
	self assert: (importedTransitions at: 'a,b') target identicalTo: (importedNodesByName at: 'cloudy').
	self
		assert: ((importedTransitions at: 'a,b') matches: 'a')
		description: 'Imported transition must preserve comma-separated matching'.
	self deny: ((importedTransitions at: 'a,b') matches: 'c') description: 'Imported transition must reject unmatched token'.
	self assert: (importedTransitions at: '1.0') source identicalTo: (importedNodesByName at: 'cloudy').
	self assert: (importedTransitions at: '1.0') target identicalTo: (importedNodesByName at: 'sunny')
]

{ #category : 'tests' }
OPMcGraphMLTest >> testExportPackageFallsBackToDefaultExportFileName [

	| capturedFileNames |
	capturedFileNames := OrderedCollection new.
	(OPExportFileDialog stub
		 exportBlock: Any
		 defaultFileName: Any
		 extensions: Any
		 named: Any
		 title: Any) will: [ :exportBlock :defaultFileName :extensions :filterName :dialogTitle |
		capturedFileNames add: defaultFileName ].

	OPMcGraphML exportPackage: (OPMc named: '   ').
	OPMcGraphML exportPackage: Object new.

	self assert: capturedFileNames asArray equals: #( 'export.graphml' 'export.graphml' )
]

{ #category : 'tests' }
OPMcGraphMLTest >> testExportPackagePassesGraphMLExtensionsAndTitleToExportDialog [

	| modelWithSpecialName capturedBlock capturedFileName capturedExtensions capturedFilterName capturedTitle exportedXml |
	capturedBlock := nil.
	capturedFileName := nil.
	capturedExtensions := nil.
	capturedFilterName := nil.
	capturedTitle := nil.
	modelWithSpecialName := OPMc named: 'My / Chain'.
	(OPExportFileDialog stub
		 exportBlock: Any
		 defaultFileName: Any
		 extensions: Any
		 named: Any
		 title: Any) will: [ :exportBlock :defaultFileName :extensions :filterName :dialogTitle |
			capturedBlock := exportBlock.
			capturedFileName := defaultFileName.
			capturedExtensions := extensions.
			capturedFilterName := filterName.
			capturedTitle := dialogTitle ].

	OPMcGraphML exportPackage: modelWithSpecialName.

	self assert: capturedFileName equals: (FileNameSanitizer sanitize: 'My / Chain') , '.graphml'.
	self assert: capturedExtensions equals: #( graphml xml ).
	self assert: capturedFilterName equals: 'GraphML files'.
	self assert: capturedTitle equals: 'Choose a GraphML file to export to'.
	exportedXml := capturedBlock value.
	self assert: (exportedXml includesSubstring: '<graphml') description: 'Export block must generate GraphML XML'.
	self assert: (exportedXml includesSubstring: 'My / Chain') description: 'Export block must include model name'
]

{ #category : 'tests' }
OPMcGraphMLTest >> testImportErrorBoundaryCases [

	| missingNameXml missingNodeTypeXml danglingEdgeXml |
	self should: [ graphML import: '<graphml><broken' into: OPMc new ] raise: XMLWellFormednessException.

	missingNameXml := String streamContents: [ :stream |
			                  stream nextPutAll: '<?xml version="1.0" encoding="UTF-8"?>'.
			                  stream nextPutAll: '<graphml xmlns="http://graphml.graphdrawing.org/xmlns">'.
			                  stream nextPutAll: '<graph id="'.
			                  stream nextPutAll: UUID new asString.
			                  stream nextPutAll: '" edgedefault="directed"></graph></graphml>' ].
	self should: [ graphML import: missingNameXml into: OPMc new ] raise: KeyNotFound.

	missingNodeTypeXml := String streamContents: [ :stream |
			                      stream nextPutAll: '<?xml version="1.0" encoding="UTF-8"?>'.
			                      stream nextPutAll: '<graphml xmlns="http://graphml.graphdrawing.org/xmlns">'.
			                      stream nextPutAll: '<graph id="'.
			                      stream nextPutAll: UUID new asString.
			                      stream nextPutAll: '" edgedefault="directed"><data key="name">Chain</data>'.
			                      stream nextPutAll: '<node id="'.
			                      stream nextPutAll: UUID new asString.
			                      stream nextPutAll: '"><data key="name">S1</data></node></graph></graphml>' ].
	self should: [ graphML import: missingNodeTypeXml into: OPMc new ] raise: KeyNotFound.

	danglingEdgeXml := String streamContents: [ :stream |
			                   stream nextPutAll: '<?xml version="1.0" encoding="UTF-8"?>'.
			                   stream nextPutAll: '<graphml xmlns="http://graphml.graphdrawing.org/xmlns">'.
			                   stream nextPutAll: '<graph id="'.
			                   stream nextPutAll: UUID new asString.
			                   stream nextPutAll: '" edgedefault="directed"><data key="name">Broken</data>'.
			                   stream nextPutAll: '<edge id="'.
			                   stream nextPutAll: UUID new asString.
			                   stream nextPutAll: '" source="'.
			                   stream nextPutAll: UUID new asString.
			                   stream nextPutAll: '" target="'.
			                   stream nextPutAll: UUID new asString.
			                   stream nextPutAll: '"><data key="name">0.5</data></edge></graph></graphml>' ].
	self should: [ graphML import: danglingEdgeXml into: OPMc new ] raise: KeyNotFound
]

{ #category : 'tests' }
OPMcGraphMLTest >> testImportIntoTargetModelFromMemoryFile [

	| sourceModel xmlString memoryFile targetModel returnedModel |
	sourceModel := OPMcExamples exampleMarkovWeather.
	xmlString := graphML export: sourceModel.
	memoryFile := FileSystem memory / 'markov-weather-import.graphml'.
	memoryFile writeStreamDo: [ :stream | stream nextPutAll: xmlString ].

	targetModel := OPMc new.
	returnedModel := graphML import: memoryFile into: targetModel.
	self assert: returnedModel identicalTo: targetModel.
	self assert: targetModel uuid equals: sourceModel uuid.
	self assert: targetModel name equals: 'Markov Weather'.
	self assert: targetModel states size equals: 3.
	self assert: targetModel transitions size equals: 9.
	self
		assertCollection: (targetModel states collect: [ :eachState | eachState uuid -> eachState name ])
		hasSameElements: (sourceModel states collect: [ :eachState | eachState uuid -> eachState name ])
]

{ #category : 'tests' }
OPMcGraphMLTest >> testImportToModelInEditorUsesGraphMLFilterAndUpdatesEditor [

	| sourceModel memoryFile targetModel mockOpenDialog capturedTitle capturedExtensions capturedFilterName capturedOkAction openCalled mockEditor mockWorkbench mockProjectTree mockDiagramController mockLayouter refreshedAll showedAll appliedLayout capturedNotifications |
	sourceModel := OPMcExamples exampleMarkovWeather.
	memoryFile := FileSystem memory root / 'import-dialog.graphml'.
	memoryFile writeStreamDo: [ :stream | stream nextPutAll: (graphML export: sourceModel) ].
	targetModel := OPMc named: 'Initial Target'.

	capturedTitle := nil.
	capturedExtensions := nil.
	capturedFilterName := nil.
	capturedOkAction := nil.
	openCalled := false.
	capturedNotifications := OrderedCollection new.
	mockOpenDialog := Mock new.
	StOpenFilePresenter stub new willReturn: mockOpenDialog.
	(mockOpenDialog stub title: Any) will: [ :dialogTitle | capturedTitle := dialogTitle ].
	(mockOpenDialog stub extensions: Any named: Any) will: [ :extensions :filterName |
			capturedExtensions := extensions.
			capturedFilterName := filterName ].
	(mockOpenDialog stub okAction: Any) will: [ :actionBlock | capturedOkAction := actionBlock ].
	mockOpenDialog stub open will: [ openCalled := true ].

	refreshedAll := false.
	showedAll := false.
	appliedLayout := false.
	mockProjectTree := Mock new.
	mockProjectTree stub refresh will: [ refreshedAll := true ].
	mockWorkbench := Mock new.
	mockWorkbench stub projectTree willReturn: mockProjectTree.
	mockLayouter := Mock new.
	mockLayouter stub defaultLayout will: [ appliedLayout := true ].
	mockDiagramController := Mock new.
	mockDiagramController stub showAllElements will: [ showedAll := true ].
	mockDiagramController stub layouter willReturn: mockLayouter.
	mockEditor := Mock new.
	mockEditor stub workbench willReturn: mockWorkbench.
	mockEditor stub diagramController willReturn: mockDiagramController.

	OPMcGraphML importToModel: targetModel inEditor: mockEditor.

	self assert: openCalled description: 'importToModel:inEditor: must open the file dialog'.
	self assert: capturedTitle equals: 'Choose a GraphML file to import from'.
	self assert: capturedExtensions equals: #( graphml xml ).
	self assert: capturedFilterName equals: 'GraphML files'.

	[ capturedOkAction value: memoryFile ]
		on: InformativeNotification
		do: [ :notification |
				capturedNotifications add: notification messageText.
				notification resume ].

	self assertCollection: capturedNotifications hasSameElements: { ('Imported from ' , memoryFile fullName) }.
	self assert: targetModel uuid equals: sourceModel uuid.
	self assert: targetModel name equals: 'Markov Weather'.
	self assert: targetModel states size equals: 3.
	self assert: targetModel transitions size equals: 9.
	self assert: refreshedAll description: 'updateModelAfterImport: must refresh the project tree'.
	self assert: showedAll description: 'updateModelAfterImport: must show all diagram elements'.
	self assert: appliedLayout description: 'updateModelAfterImport: must apply default layout'
]

{ #category : 'tests' }
OPMcGraphMLTest >> testNodeForTypeReturnsOPMcStateInstance [

	| symbolState stringState unknownState |
	symbolState := graphML nodeForType: #regular.
	self assert: symbolState class identicalTo: OPMcState.
	self assert: symbolState graphmlType equals: #regular.
	self assert: symbolState isNormal description: 'Mapped symbol state must report as normal'.

	stringState := graphML nodeForType: 'regular'.
	self assert: stringState class identicalTo: OPMcState.
	self assert: stringState graphmlType equals: #regular.

	unknownState := graphML nodeForType: #unknownType.
	self assert: unknownState class identicalTo: OPMcState.
	self deny: unknownState identicalTo: symbolState
]

{ #category : 'tests' }
OPMcGraphMLTest >> testTemplateContainsGraphMlSchemaAndPlaceholders [

	| templateString parsedTemplate |
	templateString := graphML template.
	self
		assert: (templateString includesSubstring: 'http://graphml.graphdrawing.org/xmlns')
		description: 'Template must declare GraphML XML namespace'.
	self assert: (templateString includesSubstring: '<key id="name"') description: 'Template must declare name attribute key'.
	self
		assert: (templateString includesSubstring: '<key id="generated"')
		description: 'Template must declare generated timestamp key'.
	self assert: (templateString includesSubstring: '<key id="node-type"') description: 'Template must declare node-type key'.
	self assert: (templateString includesSubstring: '{{model.uuid}}') description: 'Template must include model uuid placeholder'.
	self assert: (templateString includesSubstring: '{{model.name}}') description: 'Template must include model name placeholder'.
	self
		assert: (templateString includesSubstring: '{{graphmlType}}')
		description: 'Template must include node graphmlType placeholder'.
	self
		assert: (templateString includesSubstring: '{{# model.transitions }}')
		description: 'Template must iterate over model transitions'.
	parsedTemplate := XMLDOMParser parse: templateString.
	self assert: parsedTemplate root name equals: 'graphml'
]
