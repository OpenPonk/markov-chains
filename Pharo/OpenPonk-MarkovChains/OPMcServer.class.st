Class {
	#name : #OPMcServer,
	#superclass : #Object,
	#instVars : [
		'server',
		'image',
		'diagramController',
		'model',
		'currentHTML',
		'simulator',
		'modelPNG'
	],
	#category : #'OpenPonk-MarkovChains-Zinc'
}

{ #category : #toolbar }
OPMcServer class >> toolbarMenu: aBuilder [

	<opEditorToolbarMenu: #OPMcPlugin>
	(aBuilder item: 'Launch Server')
		icon: OPCoreIcons opMcDiagramIcon;
		action: [ self new launch: aBuilder model  ]
]

{ #category : #'as yet unclassified' }
OPMcServer >> getModelAsSVG [
	| xmlStream xmlString xmlFile |
	diagramController canvasPresenter currentCanvas zoomToFit.
	xmlStream := WriteStream on: ''.
	diagramController canvasPresenter currentCanvas svgExporter exportToStream: xmlStream.
	xmlString := xmlStream contents.
	xmlFile := (XMLDOMParser parse: xmlString).
	(xmlFile nodeAt: 1) attributeAt: #width put: self pngWidth.
	(xmlFile nodeAt: 1) attributeAt: #height put: self pngHeight.
	modelPNG := xmlFile asString.
	
]

{ #category : #accessing }
OPMcServer >> handleGetRequest: request [
	request hasEntity ifTrue: [ ^ ZnResponse badRequest: request ].
	(request uri equals: #home asUrl) ifTrue: [
		model workbench projectController project removeModel:
			diagramController model.
		model workbench projectController project addModel: (OPMc new name: 'New Markov Chain Diagram').
		model workbench projectController project ensureModelsHaveDiagrams.
		(model workbench openProject: (model workbench projectController project)) showAllElementsInAllDiagrams.
		diagramController := model workbench projectController controllers at: 1.
		model := diagramController editor.
		currentHTML := self htmlPlugin ].
	^ ZnResponse ok: (ZnEntity html: currentHTML)
]

{ #category : #accessing }
OPMcServer >> handlePostRequest: request [
   | part badRequest |
   badRequest := [ ^ ZnResponse badRequest: request ].
   request hasEntity ifFalse: badRequest.
   (request contentType matches: ZnMimeType multiPartFormData)
      ifTrue: [ 
			"Check if an xmi file is uploaded"
			part := (request entity partNamed: #file ifNone: [ nil ]).
			part ifNotNil: [ ^ self loadFile: (part entity) via: request ]. ].
	
	(request contentType matches: ZnMimeType applicationFormUrlEncoded)
		ifTrue: [ 
			"Check if / which radiobutton is selected regarding simulation method"
			(request entity includesField: #simType)
				ifTrue: [ ^ self loadSimType: (request entity) via: request  ]. ].
			
	(request contentType matches: ZnMimeType applicationFormUrlEncoded)
		ifTrue: [ 
			"Check for random simulation parameters"
			((request entity includesField: #nos) and: (request entity includesField: #idle))
				ifTrue: [ ^ self launchSimRnd: (request entity fields) via: request ]. ].
			
	(request contentType matches: ZnMimeType applicationFormUrlEncoded)
		ifTrue: [ 
			"Check for predicted simulation parameters"
			(((request entity includesField: #states) and: 
			 (request entity includesField: #idle)) and: 
			 (request entity includesField: #separator))
				ifTrue: [ ^ self launchSimPred: (request entity fields) via: request ]. ].
	badRequest.
]

{ #category : #accessing }
OPMcServer >> handleRequest: request [
   "request uri path = #mc ifTrue: [
      request method = #GET ifTrue: [
         ^ self handleGetRequest: request ].
      request method = #POST ifTrue: [
         ^ self handlePostRequest: request ] ]."
	(self siteTags includes: request uri path) ifTrue: [
      request method = #GET ifTrue: [
         ^ self handleGetRequest: request ].
      request method = #POST ifTrue: [
         ^ self handlePostRequest: request ] ].

   ^ ZnResponse notFound: request uri
]

{ #category : #'as yet unclassified' }
OPMcServer >> htmlPlugin [
	^ 
'<html>
 <head>
  <title>OpenPonk Remote Simulator</title>
 </head>
<body>
 <table style="background-color: #F1F1F1; border-color: #F1F1F1">	
  <tr>
   <th colspan="2" style="padding:5px">
    <img src="https://openponk.org/images/op-logo.jpg"/>
    <hr size="5" style="background-color: #000000">
   </th>
  </tr>
  <tr>
   <td style="padding:5px">Plugin:</td>
   <td style="padding:5px">Markov Chain</td>
  </tr>
  <form enctype="multipart/form-data" action="mc" method="POST">
  <tr>
   <td style="padding:5px">xmi-File:</td>
   <td><input type="file" name="file"/></td>
  </tr>
  <tr>
   <td></td>
   <td><input type="submit" value="Upload"/></td>
  </tr>
  </form>
 </table>
</body>
</html>'
]

{ #category : #accessing }
OPMcServer >> htmlSimPred [
   ^ 
'<html>
 <head>
  <title>OpenPonk Remote Simulator</title>
 </head>
<body>
 <table style="background-color: #F1F1F1; border-color: #F1F1F1">	
  <tr>
   <th colspan="3" style="padding:5px">
    <img src="https://openponk.org/images/op-logo.jpg"/>
    <hr size="5" style="background-color: #000000; border-color: transparent">
   </th>
  </tr>
  <tr height="15pt">
   <td style="padding:5px">Plugin:</td>
   <td style="padding:5px">Markov Chain</td>
   <td rowspan="4" style="padding:5px">{{{image}}}</td>
  </tr>
  <tr height="15pt">
   <td style="padding:5px" colspan="2">Simulation Parameter (Predicted)</td>
  </tr>
  <form enctype="application/x-www-form-urlencoded" action="mc" method="POST">
  <tr height="15pt">
   <td style="padding:5px">List of States:<br>Idle between Steps:<br>Separator:</td>
   <td>
    <input type="text" name="states"><br>
    <input type="text" name="idle" value="0.1"><br>
    <input type="text" name="separator" value=",">
   </td>
  </tr>
  <tr>
   <td></td>
   <td style="vertical-align: top"><input type="submit" value="Start"/></td>
  </tr>
  </form>
 </table>
</body>
</html>'
]

{ #category : #accessing }
OPMcServer >> htmlSimPredResults [
   ^ 
'<html>
 <head>
  <title>OpenPonk Remote Simulator</title>
 </head>
<body>
 <table style="background-color: #F1F1F1; border-color: #F1F1F1">	
  <tr>
   <th colspan="3" style="padding:5px">
    <img src="https://openponk.org/images/op-logo.jpg"/>
    <hr size="5" style="background-color: #000000; border-color: transparent">
   </th>
  </tr>
  <tr height="15pt">
   <td style="padding:5px">Plugin:</td>
   <td style="padding:5px">Markov Chain</td>
   <td rowspan="4" style="padding:5px">{{{image}}}</td>
  </tr>
  <tr height="15pt">
   <td style="padding:5px">Simulation Results</td>
  </tr>
  <tr>
   <td colspan="2" style="padding:5px; vertical-align:top">   
    <table cellspacing="0" cellpadding="0" border="0" width="325">
     <tr>
      <td>
       <table cellspacing="0" cellpadding="1" width="300" >
        <tr style="background-color: #F1F1F1">
         <th>States</th>
         <th>Enterings</th>
        </tr>
       </table>
      </td>
     </tr>
     <tr>
      <td>
       <div style="width:320px; height:300px; overflow:auto;">
        <table cellspacing="0" cellpadding="1" border="1" width="300" >
         {{# states}}
          <tr>
           <td style="padding:5px; width:115px">{{ name }}</td>
           <td style="padding:5px">{{ activation }}</td>
          </tr>
		   {{/ states}}
        </table>  
       </div>
      </td>
     </tr>
    </table>
   </td>
  </tr>
 </table>
</body>
</html>'
]

{ #category : #accessing }
OPMcServer >> htmlSimPredResultsFailure [
   ^ 
'<html>
 <head>
  <title>OpenPonk Remote Simulator</title>
 </head>
<body>
 <table style="background-color: #F1F1F1; border-color: #F1F1F1">	
  <tr>
   <th colspan="3" style="padding:5px">
    <img src="https://openponk.org/images/op-logo.jpg"/>
    <hr size="5" style="background-color: #000000; border-color: transparent">
   </th>
  </tr>
  <tr height="15pt">
   <td style="padding:5px">Plugin:</td>
   <td style="padding:5px">Markov Chain</td>
   <td rowspan="7" style="padding:5px">{{{image}}}</td>
  </tr>
  <tr height="15pt">
   <td style="padding:5px">Simulation Results</td>
  </tr>
  <tr>
   <td colspan="2" style="padding:5px; vertical-align:top">   
    <table cellspacing="0" cellpadding="0" border="0" width="325">
     <tr>
      <td>
       <table cellspacing="0" cellpadding="1" width="300" >
        <tr style="background-color: #F1F1F1">
         <th>States</th>
         <th>Enterings</th>
        </tr>
       </table>
      </td>
     </tr>
     <tr>
      <td>
       <div style="width:320px; height:250px; overflow:auto;">
        <table cellspacing="0" cellpadding="1" border="1" width="300" >
         {{# states}}
          <tr>
           <td style="padding:5px; width:115px">{{ name }}</td>
           <td style="padding:5px">{{ activation }}</td>
          </tr>
		   {{/ states}}
        </table>  
       </div>
      </td>
     </tr>
    </table>
   </td>
  </tr>
  <tr>
   <td colspan="2">Simulation Failure</td>
  </tr>
  <tr>
   <td colspan="2">State: <b>{{ state }}</b> at: <b>{{ position }}</b> not found</td>
  </tr>
  <tr>
   <td colspan="2">Transition: <b>{{ stateFrom }}</b> -> <b>{{ state }}</b></td>
  </tr>
 </table>
</body>
</html>'
]

{ #category : #accessing }
OPMcServer >> htmlSimRnd [
   ^ 
'<html>
 <head>
  <title>OpenPonk Remote Simulator</title>
 </head>
<body>
 <table style="background-color: #F1F1F1; border-color: #F1F1F1">	
  <tr>
   <th colspan="3" style="padding:5px">
    <img src="https://openponk.org/images/op-logo.jpg"/>
    <hr size="5" style="background-color: #000000; border-color: transparent">
   </th>
  </tr>
  <tr height="15pt">
   <td style="padding:5px">Plugin:</td>
   <td style="padding:5px">Markov Chain</td>
   <td rowspan="4" style="padding:5px">{{{image}}}</td>
  </tr>
  <tr height="15pt">
   <td style="padding:5px" colspan="2">Simulation Parameter (Random)</td>
  </tr>
  <form enctype="application/x-www-form-urlencoded" action="mc" method="POST">
  <tr height="15pt">
   <td style="padding:5px">Number of Steps:<br>Idle between Steps:</td>
   <td>
    <input type="text" name="nos" value="10"><br>
    <input type="text" name="idle" value="0.1">
   </td>
  </tr>
  <tr>
   <td></td>
   <td style="vertical-align: top"><input type="submit" value="Start"/></td>
  </tr>
  </form>
 </table>
</body>
</html>'
]

{ #category : #accessing }
OPMcServer >> htmlSimRndResults [
   ^ 
'<html>
 <head>
  <title>OpenPonk Remote Simulator</title>
 </head>
<body>
 <table style="background-color: #F1F1F1; border-color: #F1F1F1">	
  <tr>
   <th colspan="3" style="padding:5px">
    <img src="https://openponk.org/images/op-logo.jpg"/>
    <hr size="5" style="background-color: #000000; border-color: transparent">
   </th>
  </tr>
  <tr height="15pt">
   <td style="padding:5px">Plugin:</td>
   <td style="padding:5px">Markov Chain</td>
   <td rowspan="4" style="padding:5px">{{{image}}}</td>
  </tr>
  <tr height="15pt">
   <td style="padding:5px">Simulation Results</td>
  </tr>
  <tr>
   <td colspan="2" style="padding:5px; vertical-align:top">   
    <table cellspacing="0" cellpadding="0" border="0" width="325">
     <tr>
      <td>
       <table cellspacing="0" cellpadding="1" width="300" >
        <tr style="background-color: #F1F1F1">
         <th>States</th>
         <th>Enterings</th>
        </tr>
       </table>
      </td>
     </tr>
     <tr>
      <td>
       <div style="width:320px; height:300px; overflow:auto;">
        <table cellspacing="0" cellpadding="1" border="1" width="300" >
         {{# states}}
          <tr>
           <td style="padding:5px">{{ name }}</td>
           <td style="padding:5px">{{ activation }}</td>
          </tr>
		   {{/ states}}
        </table>  
       </div>
      </td>
     </tr>
    </table>
   </td>
  </tr>
 </table>
</body>
</html>'
]

{ #category : #'as yet unclassified' }
OPMcServer >> htmlSimType [
	^
'<html>
 <head>
  <title>OpenPonk Remote Simulator</title>
 </head>
<body>
 <table style="background-color: #F1F1F1; border-color: #F1F1F1">	
  <tr>
   <th colspan="3" style="padding:5px">
    <img src="https://openponk.org/images/op-logo.jpg"/>
    <hr size="5" style="background-color: #000000; border-color: transparent">
   </th>
  </tr>
  <tr height="15pt">
   <td style="padding:5px">Plugin:</td>
   <td style="padding:5px">Markov Chain</td>
   <td rowspan="3" style="padding:5px">{{{image}}}</td>
  </tr>
  <form enctype="application/x-www-form-urlencoded" action="mc" method="POST">
  <tr height="15pt">
   <td style="padding:5px">Simulation-Type:</td>
   <td>
    <input type="radio" name="simType" value="rndSim" checked> 
    Randomized Simulation<br/>
    <input type="radio" name="simType" value="predSim"> 
    Predicted Simulation<br/>
   </td>
  </tr>
  <tr>
   <td></td>
   <td style="vertical-align: top"><input type="submit" value="Upload"/></td>
  </tr>
  </form>
  <tr>
  <form enctype="application/x-www-form-urlencoded" action="home" method="GET">
   <td><input type="submit" value="Abort"/></td>
  </form>
  </tr>
 </table>
</body>
</html>'
]

{ #category : #'as yet unclassified' }
OPMcServer >> launch: aModel [
	server := ZnServer startDefaultOn: 8080.
	"server delegate map: #mc to: self.
	server delegate map: #home to: self."
	self siteTags do: [ :site | server delegate map: site to: self. ].
	currentHTML := self htmlPlugin.
	diagramController := aModel diagramController.
	model := aModel.
	
]

{ #category : #'as yet unclassified' }
OPMcServer >> launchSimPred: fields via: request [
	((((fields at: #states) value isNotEmpty) and: 
	 ((fields at: #idle) value asNumber asFloat > 0.0)) and:
	 ((fields at: #separator) value isNotEmpty))
		ifFalse: [ ^ ZnResponse badRequest: request ].
	simulator input text: (fields at: #states).
	simulator idleInput text: (fields at: #idle).
	simulator separatorInput text: (fields at: #separator).
	simulator startAction.
	simulator runAction.
	(simulator recognizer globalCounter < simulator recognizer inputs size)
		ifTrue: [ self getModelAsSVG.
					 currentHTML := self mustacheHtmlSimPredResultsFailure ]
		ifFalse: [ currentHTML := self mustacheHtmlSimPredResults ].
	^ ZnResponse redirect: #mc
	


]

{ #category : #'as yet unclassified' }
OPMcServer >> launchSimRnd: fields via: request [
	(((fields at: #nos) value asInteger > 0) and: ((fields at: #idle) value asNumber asFloat > 0.0))
		ifFalse: [ ^ ZnResponse badRequest: request ].
	simulator input text: (fields at: #nos).
	simulator idleInput text: (fields at: #idle).
	simulator startAction.
	simulator runAction.
	currentHTML := self mustacheHtmlSimRndResults.
	^ ZnResponse redirect: #mc
	


]

{ #category : #'as yet unclassified' }
OPMcServer >> loadFile: file via: request [
   (file notNil
      and: [ file contentType matches: 'application/octet-stream' asZnMimeType ])
      ifFalse: [ ^ ZnResponse badRequest: request ] 
		ifTrue: [ OPMcGraphML new import: file into: diagramController model.
					 OPMcGraphML updateModelAfterImport: model.
					 self getModelAsSVG.
					 currentHTML := self mustacheHtmlSimType ].
   ^ ZnResponse redirect: #mc
]

{ #category : #'as yet unclassified' }
OPMcServer >> loadSimType: field via: request [
   (field notNil
      and: [ field contentType matches: ZnMimeType applicationFormUrlEncoded ])
      ifFalse: [ ^ ZnResponse badRequest: request ].
	((field fields at: #simType) value = #rndSim)
		ifTrue: [ simulator := OPMcSimulator new openOn: diagramController.
					 currentHTML := self mustacheHtmlSimRnd  ].
	((field fields at: #simType) value = #predSim)
		ifTrue: [ simulator := OPMcPredictedSimulation new openOn: diagramController. 
					 currentHTML := self mustacheHtmlSimPred ].
   ^ ZnResponse redirect: #mc
]

{ #category : #accessing }
OPMcServer >> mustacheHtmlSimPred [
   ^ (MustacheTemplate on: self htmlSimPred)
		value:
			{(#image -> modelPNG contents)} asDictionary
]

{ #category : #accessing }
OPMcServer >> mustacheHtmlSimPredResults [
   ^ (MustacheTemplate on: self htmlSimPredResults)
		value:
			{(#states 
				-> 
					(simulator recognizer allStates sort: [ :a :b | a name < b name ]; collect: 
						[ :each | 
							Dictionary
								with: #name -> each name 
								with: #activation -> each activations ])).
			 (#image -> modelPNG contents)} asDictionary
]

{ #category : #accessing }
OPMcServer >> mustacheHtmlSimPredResultsFailure [
   ^ (MustacheTemplate on: self htmlSimPredResultsFailure)
		value:
			{(#states 
				-> 
					(simulator recognizer allStates sort: [ :a :b | a name < b name ]; collect: 
						[ :each | 
							Dictionary
								with: #name -> each name 
								with: #activation -> each activations ])).
			 (#image -> modelPNG contents).
			 (#state -> (simulator recognizer inputs at: 
					(simulator recognizer globalCounter + 1))).
			 (#stateFrom -> (simulator recognizer inputs at: 
					(simulator recognizer globalCounter))).
			 (#position -> (simulator recognizer globalCounter + 1)) } asDictionary
]

{ #category : #accessing }
OPMcServer >> mustacheHtmlSimRnd [
   ^ (MustacheTemplate on: self htmlSimRnd)
		value:
			{(#image -> modelPNG contents)} asDictionary
]

{ #category : #accessing }
OPMcServer >> mustacheHtmlSimRndResults [
	simulator recognizer allStates sort: [ :a :b | a name < b name ].
   ^ (MustacheTemplate on: self htmlSimRndResults)
		value:
			{(#states 
				-> 
					(simulator recognizer allStates sort: [ :a :b | a name < b name ]; collect: 
						[ :each | 
							Dictionary
								with: #name -> each name 
								with: #activation -> each activations ])).
			 (#image -> modelPNG contents)} asDictionary
]

{ #category : #accessing }
OPMcServer >> mustacheHtmlSimType [
   ^ (MustacheTemplate on: self htmlSimType)
		value:
			{(#image -> modelPNG contents)} asDictionary
]

{ #category : #'as yet unclassified' }
OPMcServer >> pngHeight [
	^ '300pt'
]

{ #category : #'as yet unclassified' }
OPMcServer >> pngWidth [
	^ '300pt'
]

{ #category : #'as yet unclassified' }
OPMcServer >> siteTags [
	^ { #mc.
		 #home. }
]

{ #category : #accessing }
OPMcServer >> value: request [
   ^ self handleRequest: request
]
