Class {
	#name : #EtTree,
	#superclass : #Object,
	#category : #EtymTree
}

{ #category : #accessing }
EtTree class >> addEdges: m relations: relations do: block [
	m edges
		stencil: [ :r |
			| line |
			line := BlLineElement new
				border: (BlBorder paint: Color gray).
			block value: line.
			line
		];
		connect: relations
			from: #from
			to: #to.
]

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

	self addEdges: m
		relations: (relations select: [:r | r type = #inherit])
		do: [:line |
			line toHead:
				(BlArrowheadTriangle new
					scale: 4;
					border: (BlBorder paint: Color gray);
					background: Color gray)
		].
	self addEdges: m
		relations: (relations select: [:r | r type = #derive])
		do: [:line |
			line fromHead:
				(BlArrowheadTriangle new
					scale: 4;
					border: (BlBorder paint: Color gray);
					background: Color gray)
		].
	self addEdges: m
		relations: (relations select: [:r | r type = #derive])
		do: [:line |
			line toHead:
				(BlArrowheadTriangle new
					scale: 4;
					border: (BlBorder paint: Color gray))
		].
	self addEdges: m
		relations: (relations select: [:r | r type = #cognate])
		do: [:line |
			| makeCircle |
			makeCircle := [ BlArrowheadCircle new
					scale: 4;
					border: (BlBorder paint: Color gray) ].

			line fromHead: makeCircle value;
				toHead: makeCircle value
		].

	"
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
	"

	m layout tree levelDistance: 20.
	^ m
]

{ #category : #accessing }
EtTree class >> viewWord: word [
	^ self viewRelations: (EtFetcher fetchRecursiveRelations: word)
]

{ #category : #accessing }
EtTree class >> viewWord: headword lang: lang [
	^ self viewWord: (EtWord new headword: headword lang: lang)
]
