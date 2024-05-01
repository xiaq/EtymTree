Class {
	#name : #EtTree,
	#superclass : #Object,
	#category : #EtymTree
}

{ #category : #accessing }
EtTree class >> viewRelations: relations [
	| m |
	m := GtMondrian new.
	m nodes
		stencil: [ :w | 
			BrLabel new
				border: (BlBorder paint: Color lightGray);
				text: w asString;
				aptitude: BrLabelAptitude new;
				padding: (BlInsets all: 5) ];
		with: (relations flatCollectAsSet: [:r | {r from. r to}]).

	m edges
		stencil: [ :r | 
			| toHead |
			toHead := BlArrowheadTriangle new
					scale: 4;
					border: (BlBorder paint: Color gray).
			r type = #inherit ifTrue: [ toHead background: Color gray ].
			BlLineElement new
				border: (BlBorder paint: Color gray);
				toHead: toHead ];
		connect: (relations select: [ :r | r type ~= #cognate ])
			from: #from
			to: #to.

	m edges
		stencil: [ :r | 
			| makeCircle |
			makeCircle := [ BlArrowheadCircle new
					scale: 4;
					border: (BlBorder paint: Color gray) ].

			BlLineElement new
				border: (BlBorder paint: Color gray);
				fromHead: makeCircle value;
				toHead: makeCircle value ];
		passive;
		connect: (relations select: [ :r | r type = #cognate ])
			from: #from
			to: #to.

	m layout tree levelDistance: 20.
	^ m
]

{ #category : #accessing }
EtTree class >> viewWord: word [
	self viewRelations: (EtFetcher fetchRecursiveRelations: word)
]

{ #category : #accessing }
EtTree class >> viewWord: headword lang: lang [
	self viewWord: (EtWord new headword: headword lang: lang)
]
