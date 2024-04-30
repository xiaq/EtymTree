Class {
	#name : #EtRelation,
	#superclass : #Object,
	#instVars : [
		'type',
		'from',
		'to'
	],
	#category : #EtymTree
}

{ #category : #accessing }
EtRelation >> between: a and: b type: t [
	word1 := a.
	word2 := b.
	type := t.
]

{ #category : #accessing }
EtRelation >> from [ 
	^ from
]

{ #category : #accessing }
EtRelation >> from: a to: b type: t [
	from := a.
	to := b.
	type := t.
]

{ #category : #accessing }
EtRelation >> printOn: aStream [
	from printOn: aStream.
	aStream nextPutAll: ' --'.
	type printOn: aStream.
	aStream nextPutAll: '--> '.
	to printOn: aStream.
]

{ #category : #accessing }
EtRelation >> to [ 
	^ to
]

{ #category : #accessing }
EtRelation >> type [
	^ type
]
