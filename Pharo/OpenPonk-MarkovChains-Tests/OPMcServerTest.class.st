"
Unit tests for the in-memory Markov Chain HTTP request handler, covering route dispatching, request validation, Mustache HTML template rendering, and simulator execution.
"
Class {
	#name : 'OPMcServerTest',
	#superclass : 'TestCase',
	#instVars : [
		'server',
		'markovChain',
		'stateSunny',
		'stateCloudy',
		'diagramController',
		'project',
		'projectController',
		'workbench',
		'beforeWindows'
	],
	#category : 'OpenPonk-MarkovChains-Tests-Zinc',
	#package : 'OpenPonk-MarkovChains-Tests',
	#tag : 'Zinc'
}

{ #category : 'helpers' }
OPMcServerTest >> postFormRequest: fieldAssociations [

	| formEntity |
	formEntity := ZnApplicationFormUrlEncodedEntity withAll: fieldAssociations asDictionary.
	^ (ZnRequest post: '/mc')
		  entity: formEntity;
		  yourself
]

{ #category : 'running' }
OPMcServerTest >> setUp [

	super setUp.
	beforeWindows := (self currentWorld submorphs select: [ :eachMorph | eachMorph isSystemWindow ]) asIdentitySet.
	server := OPMcServer new
]

{ #category : 'helpers' }
OPMcServerTest >> setUpHeadlessDiagramController [

	| transitionSunnyToCloudy transitionCloudyToSunny |
	markovChain := OPMc named: 'Server Test Chain'.
	stateSunny := OPMcState named: 'sunny'.
	stateCloudy := OPMcState named: 'cloudy'.
	transitionSunnyToCloudy := OPMcTransition from: stateSunny to: stateCloudy named: '1.0'.
	transitionCloudyToSunny := OPMcTransition from: stateCloudy to: stateSunny named: '1.0'.
	markovChain
		add: stateSunny;
		add: stateCloudy;
		add: transitionSunnyToCloudy;
		add: transitionCloudyToSunny.
	project := OPProject named: 'McServerHeadlessTest'.
	project addModel: markovChain.
	projectController := OPProjectController forProject: project.
	diagramController := OPMcController new.
	projectController addDiagramController: diagramController.
	diagramController model: markovChain.
	diagramController diagramElement: (OPOpenPonkDiagram forModelElement: markovChain).
	diagramController canvasPresenter: (OPHeadlessCanvasPresenter new
			 canvas: RSCanvas new;
			 yourself).
	diagramController showAllElements.
	server instVarNamed: #diagramController put: diagramController
]

{ #category : 'running' }
OPMcServerTest >> tearDown [

	workbench ifNotNil: [ :activeWorkbench |
			activeWorkbench close.
			workbench := nil ].
	beforeWindows ifNotNil: [
			self currentWorld submorphs copy do: [ :eachMorph |
				(eachMorph isSystemWindow and: [ (beforeWindows includes: eachMorph) not ]) ifTrue: [ eachMorph delete ] ] ].
	beforeWindows := nil.
	server := nil.
	diagramController := nil.
	projectController := nil.
	project := nil.
	markovChain := nil.
	stateSunny := nil.
	stateCloudy := nil.
	super tearDown
]

{ #category : 'tests' }
OPMcServerTest >> testConstantsAndStaticHtmlTemplates [

	self assertCollection: server siteTags hasSameElements: #( #mc #home ).
	self assert: server pngWidth equals: '300pt'.
	self assert: server pngHeight equals: '300pt'.

	self
		assert: (server htmlPlugin includesSubstring: 'enctype="multipart/form-data"')
		description: 'Plugin template must declare multipart file upload form'.
	self assert: (server htmlPlugin includesSubstring: 'name="file"') description: 'Plugin template must declare file input'.
	self
		assert: (server htmlPlugin includesSubstring: 'GraphML-File:')
		description: 'Plugin template must label upload field as GraphML-File'.
	self
		deny: (server htmlPlugin includesSubstring: 'xmi-File:')
		description: 'Plugin template must not retain copy-pasted xmi-File label'.
	self
		assert: (server htmlSimType includesSubstring: '{{{image}}}')
		description: 'Simulation type template must include image placeholder'.
	self
		assert: (server htmlSimType includesSubstring: 'value="rndSim"')
		description: 'Simulation type template must expose rndSim option'.
	self
		assert: (server htmlSimType includesSubstring: 'value="predSim"')
		description: 'Simulation type template must expose predSim option'.
	self
		assert: (server htmlSimType includesSubstring: 'action="home"')
		description: 'Simulation type template must include abort action to home'.
	self assert: (server htmlSimRnd includesSubstring: 'name="nos"') description: 'Random simulation template must declare nos field'.
	self
		assert: (server htmlSimRnd includesSubstring: 'name="idle"')
		description: 'Random simulation template must declare idle field'.
	self
		assert: (server htmlSimPred includesSubstring: 'name="states"')
		description: 'Predicted simulation template must declare states field'.
	self
		assert: (server htmlSimPred includesSubstring: 'name="separator"')
		description: 'Predicted simulation template must declare separator field'.
	self
		assert: (server htmlSimRndResults includesSubstring: '{{# states}}')
		description: 'Random results template must iterate over states'.
	self
		assert: (server htmlSimPredResults includesSubstring: '{{# states}}')
		description: 'Predicted results template must iterate over states'.
	self
		assert: (server htmlSimPredResultsFailure includesSubstring: 'Simulation Failure')
		description: 'Predicted failure template must include failure heading'.
	self
		assert: (server htmlSimPredResultsFailure includesSubstring: '{{ stateFrom }}')
		description: 'Predicted failure template must include stateFrom placeholder'
]

{ #category : 'tests' }
OPMcServerTest >> testHandleGetRequestValidationAndHomeReset [

	| requestWithEntity response initialModel |
	requestWithEntity := (ZnRequest get: '/mc')
		                     entity: (ZnEntity text: 'unexpected');
		                     yourself.
	response := server handleRequest: requestWithEntity.
	self assert: response statusLine code equals: 400.

	requestWithEntity := (ZnRequest get: '/home')
		                     entity: (ZnEntity text: 'unexpected');
		                     yourself.
	response := server handleRequest: requestWithEntity.
	self assert: response statusLine code equals: 400.

	initialModel := OPMcExamples exampleMarkovWeather.
	project := OPProject named: 'McServerHomeResetTest'.
	project addModel: initialModel.
	workbench := OPWorkbench openProject: project.
	workbench showAllElementsInAllDiagrams.
	diagramController := workbench projectController controllers first.
	server instVarNamed: #diagramController put: diagramController.
	server instVarNamed: #model put: diagramController editor.

	response := server handleRequest: (ZnRequest get: '/home').
	self assert: response statusLine code equals: 200.
	self assert: response contents equals: server htmlPlugin.
	self assert: (server instVarNamed: #currentHTML) equals: server htmlPlugin.
	self assert: project models size equals: 1.
	self assert: project models anyOne name equals: 'New Markov Chain Diagram'.
	self deny: (project models includes: initialModel) description: 'Home route must replace previous project model'.
	self assert: (server instVarNamed: #diagramController) identicalTo: workbench projectController controllers first.
	self assert: (server instVarNamed: #model) identicalTo: workbench projectController controllers first editor
]

{ #category : 'tests' }
OPMcServerTest >> testHandlePostRequestAndDirectHandlersRejectInvalidInputs [

	| multipartEntity multipartRequest response missingFileMultipart |
	self setUpHeadlessDiagramController.
	server instVarNamed: #modelPNG put: '<svg id="validation-svg"/>'.

	multipartEntity := ZnMultiPartFormDataEntity new.
	multipartEntity addPart: (ZnMimePart fieldName: #file entity: (ZnEntity text: 'not-octet-stream')).
	multipartRequest := (ZnRequest post: '/mc')
		                    entity: multipartEntity;
		                    yourself.
	response := server handleRequest: multipartRequest.
	self assert: response statusLine code equals: 400.

	response := server loadFile: nil via: multipartRequest.
	self assert: response statusLine code equals: 400.

	response := server loadFile: (ZnEntity text: '<graphml/>') via: multipartRequest.
	self assert: response statusLine code equals: 400.

	response := server loadSimType: nil via: (ZnRequest post: '/mc').
	self assert: response statusLine code equals: 400.

	response := server loadSimType: (ZnEntity text: 'simType=rndSim') via: (ZnRequest post: '/mc').
	self assert: response statusLine code equals: 400.

	response := server handleRequest: (self postFormRequest: { (#simType -> 'unknownType') }).
	self assert: response statusLine code equals: 302.
	self assert: response location equals: 'mc'.
	self assert: (server instVarNamed: #simulator) isNil description: 'Unknown simulation type must not instantiate a simulator'.

	response := server handleRequest: ((ZnRequest post: '/mc')
			             entity: (ZnEntity text: 'plain');
			             yourself).
	self assert: response statusLine code equals: 400.

	missingFileMultipart := ZnMultiPartFormDataEntity new.
	missingFileMultipart addPart: (ZnMimePart fieldName: #otherField entity: (ZnEntity text: 'value')).
	response := server handleRequest: ((ZnRequest post: '/mc')
			             entity: missingFileMultipart;
			             yourself).
	self assert: response statusLine code equals: 400.

	response := server handleRequest: (self postFormRequest: { (#unknownField -> '1') }).
	self assert: response statusLine code equals: 400.

	response := server handleRequest: (self postFormRequest: {
				             (#nos -> '0').
				             (#idle -> '0.001') }).
	self assert: response statusLine code equals: 400.

	response := server handleRequest: (self postFormRequest: {
				             (#nos -> '-2').
				             (#idle -> '0.001') }).
	self assert: response statusLine code equals: 400.

	response := server handleRequest: (self postFormRequest: {
				             (#nos -> '2').
				             (#idle -> '0') }).
	self assert: response statusLine code equals: 400.

	response := server handleRequest: (self postFormRequest: {
				             (#states -> '').
				             (#idle -> '0.001').
				             (#separator -> ',') }).
	self assert: response statusLine code equals: 400.

	response := server handleRequest: (self postFormRequest: {
				             (#states -> 'sunny,cloudy').
				             (#idle -> '0').
				             (#separator -> ',') }).
	self assert: response statusLine code equals: 400.

	response := server handleRequest: (self postFormRequest: {
				             (#states -> 'sunny,cloudy').
				             (#idle -> '0.001').
				             (#separator -> '') }).
	self assert: response statusLine code equals: 400
]

{ #category : 'tests' }
OPMcServerTest >> testLaunchSimRejectsNonNumericAndInvalidNumericInputsWithBadRequest [

	| response |
	self setUpHeadlessDiagramController.
	server instVarNamed: #modelPNG put: '<svg id="validation-svg"/>'.

	response := server handleRequest: (self postFormRequest: { (#simType -> 'rndSim') }).
	self assert: response statusLine code equals: 302.

	{
		{
			(#nos -> 'abc').
			(#idle -> '0.001') }.
		{
			(#nos -> '').
			(#idle -> '0.001') }.
		{
			(#nos -> '1.5').
			(#idle -> '0.001') }.
		{
			(#nos -> '2abc').
			(#idle -> '0.001') }.
		{
			(#nos -> '2').
			(#idle -> 'abc') }.
		{
			(#nos -> '2').
			(#idle -> '') }.
		{
			(#nos -> '2').
			(#idle -> '0.1abc') }.
		{
			(#nos -> '2').
			(#idle -> 'NaN') }.
		{
			(#nos -> '2').
			(#idle -> 'Infinity') } } do: [ :invalidRndFields |
			response := server handleRequest: (self postFormRequest: invalidRndFields).
			self assert: response statusLine code equals: 400 ].

	response := server handleRequest: (self postFormRequest: { (#simType -> 'predSim') }).
	self assert: response statusLine code equals: 302.

	{
		{
			(#states -> 'sunny,cloudy').
			(#idle -> 'abc').
			(#separator -> ',') }.
		{
			(#states -> 'sunny,cloudy').
			(#idle -> '').
			(#separator -> ',') }.
		{
			(#states -> 'sunny,cloudy').
			(#idle -> '0.1abc').
			(#separator -> ',') }.
		{
			(#states -> 'sunny,cloudy').
			(#idle -> 'NaN').
			(#separator -> ',') }.
		{
			(#states -> 'sunny,cloudy').
			(#idle -> 'Infinity').
			(#separator -> ',') } } do: [ :invalidPredFields |
			response := server handleRequest: (self postFormRequest: invalidPredFields).
			self assert: response statusLine code equals: 400 ]
]

{ #category : 'tests' }
OPMcServerTest >> testLoadFileAcceptsXmlAndGraphMlMimeTypesAndRejectsUnsupportedTypes [

	| graphMlXml supportedEntities multipartEntity multipartRequest response |
	project := OPProject named: 'McServerXmlMimeUploadTest'.
	project addModel: (OPMc named: 'Upload Target').
	workbench := OPWorkbench openProject: project.
	workbench showAllElementsInAllDiagrams.
	diagramController := workbench projectController controllers first.
	server instVarNamed: #diagramController put: diagramController.
	server instVarNamed: #model put: diagramController editor.

	graphMlXml := OPMcGraphML new export: OPMcExamples exampleMarkovWeather.
	supportedEntities := {
		                     ('weather.xml' -> (ZnEntity xml: graphMlXml)).
		                     ('weather-text.xml' -> (ZnEntity with: graphMlXml type: 'text/xml' asZnMimeType)).
		                     ('weather.graphml'
		                      -> (ZnByteArrayEntity with: graphMlXml utf8Encoded type: 'application/graphml+xml' asZnMimeType)) }.

	supportedEntities do: [ :eachPair |
			| targetModel |
			targetModel := OPMc named: 'Fresh Target'.
			diagramController model: targetModel.
			multipartEntity := ZnMultiPartFormDataEntity new.
			multipartEntity addPart: (ZnMimePart fieldName: #file fileName: eachPair key entity: eachPair value).
			multipartRequest := (ZnRequest post: '/mc')
				                    entity: multipartEntity;
				                    yourself.
			response := server handleRequest: multipartRequest.
			self assert: response statusLine code equals: 302.
			self assert: response location equals: 'mc'.
			self assert: targetModel states size equals: 3.
			self assert: targetModel transitions size equals: 9.
			self
				assert: ((server instVarNamed: #modelPNG) includesSubstring: '<svg')
				description: 'Supported XML/GraphML upload must regenerate SVG preview' ].

	multipartEntity := ZnMultiPartFormDataEntity new.
	multipartEntity addPart: (ZnMimePart fieldName: #file fileName: 'plain.txt' entity: (ZnEntity text: graphMlXml)).
	response := server handleRequest: ((ZnRequest post: '/mc')
			             entity: multipartEntity;
			             yourself).
	self assert: response statusLine code equals: 400
]

{ #category : 'tests' }
OPMcServerTest >> testLoadFileUploadImportsGraphMlAndRendersSvg [

	| initialModel graphMlXml bytesEntity multipartEntity multipartRequest response renderedHtml |
	initialModel := OPMc named: 'Upload Target'.
	project := OPProject named: 'McServerUploadTest'.
	project addModel: initialModel.
	workbench := OPWorkbench openProject: project.
	workbench showAllElementsInAllDiagrams.
	diagramController := workbench projectController controllers first.
	server instVarNamed: #diagramController put: diagramController.
	server instVarNamed: #model put: diagramController editor.

	graphMlXml := OPMcGraphML new export: OPMcExamples exampleMarkovWeather.
	bytesEntity := ZnByteArrayEntity bytes: graphMlXml utf8Encoded.
	multipartEntity := ZnMultiPartFormDataEntity new.
	multipartEntity addPart: (ZnMimePart fieldName: #file fileName: 'weather.graphml' entity: bytesEntity).
	multipartRequest := (ZnRequest post: '/mc')
		                    entity: multipartEntity;
		                    yourself.

	response := server handleRequest: multipartRequest.
	self assert: response statusLine code equals: 302.
	self assert: response location equals: 'mc'.
	self assert: diagramController model states size equals: 3.
	self assert: diagramController model transitions size equals: 9.
	self
		assert: ((server instVarNamed: #modelPNG) includesSubstring: '<svg')
		description: 'Upload handler must store generated SVG preview in modelPNG'.
	self
		assert: ((server instVarNamed: #modelPNG) includesSubstring: 'width="300pt"')
		description: 'Generated SVG preview must set configured width'.
	self
		assert: ((server instVarNamed: #modelPNG) includesSubstring: 'height="300pt"')
		description: 'Generated SVG preview must set configured height'.

	renderedHtml := (server handleRequest: (ZnRequest get: '/mc')) contents.
	self
		assert: (renderedHtml includesSubstring: 'Simulation-Type')
		description: 'GET /mc after file upload must render simulation type selector'.
	self assert: (renderedHtml includesSubstring: '<svg') description: 'Simulation type page must embed generated SVG preview'
]

{ #category : 'tests' }
OPMcServerTest >> testMustacheTemplatesEmbedModelImageAndSimulationStates [

	| renderedHtml predictedSimulation randomSimulator |
	self setUpHeadlessDiagramController.
	server instVarNamed: #modelPNG put: '<svg id="model-preview"/>'.

	{
		server mustacheHtmlSimType.
		server mustacheHtmlSimRnd.
		server mustacheHtmlSimPred } do: [ :eachRendered |
			self
				assert: (eachRendered includesSubstring: '<svg id="model-preview"/>')
				description: 'Mustache template must embed SVG markup'.
			self deny: (eachRendered includesSubstring: '{{{image}}}') description: 'Mustache template must replace raw image placeholder' ].

	predictedSimulation := OPMcPredictedSimulation new.
	predictedSimulation instVarNamed: #diagramController put: diagramController.
	server instVarNamed: #simulator put: predictedSimulation.

	predictedSimulation recognizer predictedInput: #( 'sunny' 'cloudy' 'sunny' 'cloudy' 'unknown' ) startingAt: stateSunny for: '0'.
	predictedSimulation recognizer nextUpToEndPredicted.
	renderedHtml := server mustacheHtmlSimPredResultsFailure.
	self assert: (renderedHtml includesSubstring: '<svg id="model-preview"/>') description: 'Failure template must embed model SVG'.
	self
		assert: (renderedHtml includesSubstring: 'State: <b>unknown</b> at: <b>5</b> not found')
		description: 'Failure template must render missing state and position'.
	self
		assert: (renderedHtml includesSubstring: 'Transition: <b>cloudy</b> -> <b>unknown</b>')
		description: 'Failure template must render failing transition'.
	self
		assert: (renderedHtml includesSubstring: '<td style="padding:5px; width:115px">cloudy</td>')
		description: 'Failure template must list repeated cloudy state from recognizer path'.
	self
		assert: (renderedHtml includesSubstring: '<td style="padding:5px; width:115px">sunny</td>')
		description: 'Failure template must list repeated sunny state from recognizer path'.
	self
		assert: (renderedHtml indexOfSubCollection: 'cloudy') < (renderedHtml indexOfSubCollection: 'sunny')
		description: 'Failure template states must be sorted alphabetically'.

	predictedSimulation resetAction.
	predictedSimulation recognizer predictedInput: #( 'sunny' 'cloudy' 'sunny' 'cloudy' ) startingAt: stateSunny for: '0'.
	predictedSimulation recognizer nextUpToEndPredicted.
	renderedHtml := server mustacheHtmlSimPredResults.
	self
		assert: (renderedHtml includesSubstring: '<td style="padding:5px; width:115px">cloudy</td>')
		description: 'Predicted results template must render cloudy state'.
	self
		assert: (renderedHtml includesSubstring: '<td style="padding:5px; width:115px">sunny</td>')
		description: 'Predicted results template must render sunny state'.
	self
		assert: (renderedHtml indexOfSubCollection: 'cloudy') < (renderedHtml indexOfSubCollection: 'sunny')
		description: 'Predicted results states must be sorted alphabetically'.
	self
		assert: (renderedHtml includesSubstring: '<svg id="model-preview"/>')
		description: 'Predicted results template must embed model SVG'.

	randomSimulator := OPMcSimulator new.
	randomSimulator instVarNamed: #diagramController put: diagramController.
	server instVarNamed: #simulator put: randomSimulator.
	randomSimulator resetAction.
	randomSimulator recognizer input: '4' startingAt: stateSunny for: '0'.
	randomSimulator recognizer nextUpToEnd.
	renderedHtml := server mustacheHtmlSimRndResults.
	self
		assert: (renderedHtml includesSubstring: '<td style="padding:5px">cloudy</td>')
		description: 'Random results template must render cloudy state'.
	self
		assert: (renderedHtml includesSubstring: '<td style="padding:5px">sunny</td>')
		description: 'Random results template must render sunny state'.
	self
		assert: (renderedHtml indexOfSubCollection: 'cloudy') < (renderedHtml indexOfSubCollection: 'sunny')
		description: 'Random results states must be sorted alphabetically'.
	self
		assert: (renderedHtml includesSubstring: '<svg id="model-preview"/>')
		description: 'Random results template must embed model SVG'
]

{ #category : 'tests' }
OPMcServerTest >> testPostWorkflowSelectsAndExecutesRandomAndPredictedSimulations [

	| response getResponse predictedSimulation renderedHtml |
	self setUpHeadlessDiagramController.
	server instVarNamed: #modelPNG put: '<svg id="workflow-svg"/>'.

	response := server handleRequest: (self postFormRequest: { (#simType -> 'rndSim') }).
	self assert: response statusLine code equals: 302.
	self assert: response location equals: 'mc'.
	self assert: (server instVarNamed: #simulator) class identicalTo: OPMcSimulator.

	getResponse := server handleRequest: (ZnRequest get: '/mc').
	self assert: getResponse statusLine code equals: 200.
	self
		assert: (getResponse contents includesSubstring: 'Simulation Parameter (Random)')
		description: 'GET /mc after selecting rndSim should serve random simulation form'.
	self
		assert: (getResponse contents includesSubstring: '<svg id="workflow-svg"/>')
		description: 'Random simulation form should embed model SVG'.

	response := server handleRequest: (self postFormRequest: {
				             (#nos -> '4').
				             (#idle -> '0.001') }).
	self assert: response statusLine code equals: 302.
	self assert: response location equals: 'mc'.
	self assert: (server instVarNamed: #simulator) recognizer globalCounter equals: 4.
	self assert: stateSunny activations equals: 2.
	self assert: stateCloudy activations equals: 2.
	renderedHtml := (server handleRequest: (ZnRequest get: '/mc')) contents.
	self
		assert: (renderedHtml includesSubstring: 'Simulation Results')
		description: 'GET /mc after random simulation should serve results page'.
	self
		assert: (renderedHtml includesSubstring: 'Enterings')
		description: 'Random simulation results should contain state activation table'.
	self
		assert: (renderedHtml includesSubstring: '<td style="padding:5px">cloudy</td>')
		description: 'Random simulation results should list cloudy state'.
	self
		assert: (renderedHtml includesSubstring: '<td style="padding:5px">sunny</td>')
		description: 'Random simulation results should list sunny state'.
	self
		assert: (renderedHtml includesSubstring: '<svg id="workflow-svg"/>')
		description: 'Random simulation results should embed model SVG'.

	response := server handleRequest: (self postFormRequest: { (#simType -> 'predSim') }).
	self assert: response statusLine code equals: 302.
	self assert: response location equals: 'mc'.
	predictedSimulation := server instVarNamed: #simulator.
	self assert: predictedSimulation class identicalTo: OPMcPredictedSimulation.

	getResponse := server handleRequest: (ZnRequest get: '/mc').
	self assert: getResponse statusLine code equals: 200.
	self
		assert: (getResponse contents includesSubstring: 'Simulation Parameter (Predicted)')
		description: 'GET /mc after selecting predSim should serve predicted simulation form'.
	self
		assert: (getResponse contents includesSubstring: '<svg id="workflow-svg"/>')
		description: 'Predicted simulation form should embed model SVG'.

	response := server handleRequest: (self postFormRequest: {
				             (#states -> 'sunny;cloudy;sunny;cloudy').
				             (#idle -> '0.001').
				             (#separator -> ';') }).
	self assert: response statusLine code equals: 302.
	self assert: response location equals: 'mc'.
	self assert: predictedSimulation recognizer globalCounter equals: 4.
	self assert: stateSunny activations equals: 2.
	self assert: stateCloudy activations equals: 2.
	renderedHtml := (server handleRequest: (ZnRequest get: '/mc')) contents.
	self
		assert: (renderedHtml includesSubstring: '<td style="padding:5px; width:115px">cloudy</td>')
		description: 'Predicted simulation results should list cloudy state'.
	self
		assert: (renderedHtml includesSubstring: '<td style="padding:5px; width:115px">sunny</td>')
		description: 'Predicted simulation results should list sunny state'.
	self
		assert: (renderedHtml includesSubstring: '<svg id="workflow-svg"/>')
		description: 'Predicted simulation results should embed model SVG'.

	response := server handleRequest: (self postFormRequest: {
				             (#states -> 'sunny;cloudy;sunny;cloudy;unknown').
				             (#idle -> '0.001').
				             (#separator -> ';') }).
	self assert: response statusLine code equals: 302.
	self assert: response location equals: 'mc'.
	renderedHtml := (server handleRequest: (ZnRequest get: '/mc')) contents.
	self
		assert: (renderedHtml includesSubstring: 'Simulation Failure')
		description: 'Predicted failure should serve failure results page'.
	self
		assert: (renderedHtml includesSubstring: 'State: <b>unknown</b> at: <b>5</b> not found')
		description: 'Predicted failure should render missing state and position'.
	self
		assert: (renderedHtml includesSubstring: 'Transition: <b>cloudy</b> -> <b>unknown</b>')
		description: 'Predicted failure should render failing transition'.
	self assert: (renderedHtml includesSubstring: '<svg') description: 'Predicted failure page must embed regenerated model SVG'
]

{ #category : 'tests' }
OPMcServerTest >> testRequestRoutingAndValueDispatch [

	| response |
	response := server value: (ZnRequest get: '/unknown').
	self assert: response statusLine code equals: 404.
	self assert: (response contents includesSubstring: 'Not Found') description: 'Unknown GET path should return Not Found message'.

	response := server handleRequest: (ZnRequest post: '/unknown').
	self assert: response statusLine code equals: 404.

	response := server handleRequest: (ZnRequest put: '/mc').
	self assert: response statusLine code equals: 404.

	response := server handleRequest: (ZnRequest get: '/mc').
	self assert: response statusLine code equals: 200.
	self assert: response entity contents isNil description: 'Fresh server has nil HTML body before launch or upload'.

	server instVarNamed: #currentHTML put: server htmlPlugin.
	response := server handleRequest: (ZnRequest get: '/mc').
	self assert: response statusLine code equals: 200.
	self assert: response contents equals: server htmlPlugin.

	response := server handleRequest: (ZnRequest post: '/mc').
	self assert: response statusLine code equals: 400.

	response := server handleRequest: (ZnRequest post: '/home').
	self assert: response statusLine code equals: 400
]
