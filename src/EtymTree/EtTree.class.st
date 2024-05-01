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
	" #descendant is like #inherit, but the arrow goes in the opposite direction. "
	self addEdges: m
		relations: (relations select: [:r | r type = #descendant])
		do: [:line |
			line fromHead:
				(BlArrowheadTriangle new
					scale: 4;
					border: (BlBorder paint: Color gray);
					background: Color gray)
		].
	" #derive is like #inherit, but the arrow is hollow. "
	self addEdges: m
		relations: (relations select: [:r | r type = #derive])
		do: [:line |
			line toHead:
				(BlArrowheadTriangle new
					scale: 4;
					border: (BlBorder paint: Color gray))
		].
	" #cognate is symmetric. "
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
