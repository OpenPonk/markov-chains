Class {
	#name : 'OPMcGraphML',
	#superclass : 'Object',
	#category : 'OpenPonk-MarkovChains-Serialization',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'Serialization'
}

{ #category : 'toolbar' }
OPMcGraphML class >> exportPackage: aModel [

	StFBSaveFileDialog new
		title: 'Choose a XMI file to export to';
		okAction: [ :file | 
			file
				ensureDelete;
				writeStreamDo: [ :stream | 
					stream << (OPMcGraphML new export: aModel) ].
			UIManager default
				inform: (String streamContents: [ :s | 
						 s << 'Exported to ' << file pathString.
						 s
							 cr;
							 cr.
						 s << 'Click to open location' ])
				actionOnClick: [ file openInOSFileBrowser ] ];
		extensions: #( xmi xml uml ) named: 'XMI files';
		open
]

{ #category : 'toolbar' }
OPMcGraphML class >> importToModel: aModel withBuilder: aBuilder [

	StFBOpenFileDialog new
		title: 'Choose a XMI export of UML model';
		okAction: [ :file | 
			OPMcGraphML new import: file into: aModel.
			self inform: 'Imported from ' , file fullName.
			self updateModelAfterImport: (aBuilder model)];
		extensions: #( xmi xml uml ) named: 'XMI files';
		open.
]

{ #category : 'toolbar' }
OPMcGraphML class >> toolbarMenu: aBuilder [

	<opEditorToolbarMenu: #OPMcPlugin>
	(aBuilder item: 'Export as xmi')
		icon: OPCoreIcons opFsmDiagramIcon;
		action: [ self exportPackage: aBuilder model diagramController model ].
	(aBuilder item: 'Import as xmi')
		icon: OPCoreIcons opFsmDiagramIcon;
		action: [ self importToModel: aBuilder model diagramController model withBuilder: aBuilder ].
]

{ #category : 'as yet unclassified' }
OPMcGraphML class >> updateModelAfterImport: aModel [
	aModel workbench projectTree refresh.
	aModel diagramController showAllElements.
	aModel diagramController layouter defaultLayout
]

{ #category : 'public-exporting' }
OPMcGraphML >> export: aModel [
	^ (MustacheTemplate on: self template)
		value:
			{(#dateTime -> DateAndTime now truncated).
			(#model -> aModel).
			(#states
				->
					(aModel states
						collect: [ :each | 
							Dictionary
								with: #uuid -> each uuid
								with: #name -> each name
								with: #graphmlType -> each graphmlType ]))} asDictionary
]

{ #category : 'public-exporting' }
OPMcGraphML >> import: aXml into: model [
	| doc graph graphData node nodeData edge edgeData nodes |
	doc := XMLDOMParser parse: aXml.
	graph := (doc root / #graph) first.
	graphData := (graph / #data
		collect: [ :each | (each attributeAt: #key) -> each stringValue ])
		asDictionary.
	model uuid: (UUID fromString: (graph attributeAt: #id)).
	model name: (graphData at: #name).
	nodes := Dictionary new.
	graph / #node
		do: [ :each | 
			nodeData := (each / #data
				collect: [ :data | (data attributeAt: #key) -> data stringValue ])
				asDictionary.
			node := self nodeForType: (nodeData at: #'node-type').
			node uuid: (UUID fromString: (each attributeAt: #id)).
			node name: (nodeData at: #name).
			nodes at: node uuid put: node.
			model add: node ].
	graph / #edge
		do: [ :each | 
			edgeData := (each / #data
				collect: [ :data | (data attributeAt: #key) -> data stringValue ])
				asDictionary.
			(edge := OPMcTransition new)
				uuid: (UUID fromString: (each attributeAt: #id));
				name: (edgeData at: #name);
				source: (nodes at: (UUID fromString: (each attributeAt: #source)));
				target: (nodes at: (UUID fromString: (each attributeAt: #target))).
				"matchBlock:
					(OpalCompiler new
						source: (edgeData at: #matchBlock);
						evaluate)."
			model add: edge ].
	^ model
]

{ #category : 'public-exporting' }
OPMcGraphML >> nodeForType: aType [
	^ OPMcState new
]

{ #category : 'public-exporting' }
OPMcGraphML >> template [
	<script: '(XMLDOMParser parse: self new template) inspect'>
	^ '<?xml version="1.0" encoding="UTF-8"?>
<graphml
	xmlns="http://graphml.graphdrawing.org/xmlns"  
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://graphml.graphdrawing.org/xmlns
	http://graphml.graphdrawing.org/xmlns/1.0/graphml.xsd">

	<key id="name" attr.name="element name" attr.type="string" for="all" />
	<key id="generated" attr.name="generation datetime" attr.type="string" for="graph" />
	<key id="node-type" attr.name="node type" attr.type="string" for="node" />

	<graph id="{{model.uuid}}" edgedefault="directed">
		<data key="name">{{model.name}}</data>
		<data key="generated">{{dateTime}}</data>
		{{# states }}
		<node id="{{uuid}}">
			<data key="name">{{name}}</data>
			<data key="node-type">{{graphmlType}}</data>
		</node>
		{{/ states }}
		{{# model.transitions }}
		<edge id="{{uuid}}" source="{{source.uuid}}" target="{{target.uuid}}">
			<data key="name">{{name}}</data>
		</edge>
		{{/ model.transitions }}
	</graph>
</graphml>'
]
