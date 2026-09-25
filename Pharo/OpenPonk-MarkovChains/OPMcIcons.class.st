Class {
	#name : 'OPMcIcons',
	#superclass : 'Object',
	#category : 'OpenPonk-MarkovChains-Icons',
	#package : 'OpenPonk-MarkovChains',
	#tag : 'Icons'
}

{ #category : 'icons' }
OPMcIcons class >> opMcDiagramIcon [

	^ Form fromBinaryStream: self opMcDiagramIconContents base64Decoded asByteArray readStream
]

{ #category : 'icons' }
OPMcIcons class >> opMcDiagramIconContents [
	^ 'iVBORw0KGgoAAAANSUhEUgAAAA8AAAAPCAYAAAA71pVKAAAAq0lEQVQoU2NkoAAwUqCXgZDm/0DDcarBpxmkEQawqsOlGd1GrC5A1nwAaM1KIK4EYjkghmmA0U+AYs1AHAHEjiAnIWtmAvL/EhGALDB16M6GGYDNOyAXwDWi2wziozsV5hCs4ug2/AOqBtkOUnwViH9BbdOFehEmDzYUm/NgYiCFIDbIIJCBMJfBgwWX39ANhsU5inpcmvmBuj8hhTyI/wHdpYSSJ96Yo0gzAACCIBAWVWZIAAAAAElFTkSuQmCC'
]

{ #category : 'icons' }
OPMcIcons class >> opMcStateIcon [
	"Answers the icon for a Markov chain state."

	^ Form fromBinaryStream: self opMcStateIconContents base64Decoded asByteArray readStream
]

{ #category : 'icons' }
OPMcIcons class >> opMcStateIconContents [
	"Answers base64 encoded PNG data for a Markov chain state."

	^ 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABmJLR0QA/wD/AP+gvaeTAAAA
CXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH3gwREQMGFh81tQAAABl0RVh0Q29tbWVudABD
cmVhdGVkIHdpdGggR0lNUFeBDhcAAACSSURBVDjLrdO9DcJADIbhR4QG6QbJEvQZAIpscHuk
YpX02SEFy6SlCY1pgBDy80purE/32WebTxJqdBgiusglM9QY0SOjjMiRG0PzlSYE+YdBDk0z
5VyZp3qvJP3hPFVJern3ltOjLnBDi/vCB464ijGVKyooMRxspMAZjxUtXHDa/Im7jHHzIu2y
yrsc06pzfgKTTTJXZ7zJ7gAAAABJRU5ErkJggg=='
]

{ #category : 'icons' }
OPMcIcons class >> opMcTransitionIcon [
	"Answers the icon for a Markov chain transition."

	^ Form fromBinaryStream: self opMcTransitionIconContents base64Decoded asByteArray readStream
]

{ #category : 'icons' }
OPMcIcons class >> opMcTransitionIconContents [
	"Answers base64 encoded PNG data for a Markov chain transition."

	^ 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABmJLR0QA/wD/AP+gvaeTAAAA
CXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH3gwREQch13lF2gAAABl0RVh0Q29tbWVudABD
cmVhdGVkIHdpdGggR0lNUFeBDhcAAABqSURBVDjLY2AYBcQCRlwSzCQY8p+BgeEdAwPDKUpc
cICBgeEKAwODArKEBQkG/WBgYLBmYGCYwsDA0MDAwNDIwsDA4E+iN/5D2cEMDAyNpHolF2pA
LkyAhQTNdxgYGJ7gixFCQGc0NWMHAKweDmH+UsOrAAAAAElFTkSuQmCC'
]
