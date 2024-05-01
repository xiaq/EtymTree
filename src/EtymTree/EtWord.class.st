Class {
	#name : #EtWord,
	#superclass : #Object,
	#instVars : [
		'headword',
		'lang'
	],
	#category : #EtymTree
}

{ #category : #accessing }
EtWord class >> langCodeToName [
	^ Dictionary newFrom: {
		" Latin and Romance languages I'm interested in "
		'la' -> 'Latin'.
		'fr' -> 'French'.
		'fro' -> 'Old French'.
		'frm' -> 'Middle French'.
		'es' -> 'Spanish'.
		'it' -> 'Italian'.
		
		" Germanic languages I'm interested in "
		'en' -> 'English'.
		'enm' -> 'Middle English'.
		'ang' -> 'Old English'.
		'nl' -> 'Dutch'.
		"
		'dum' -> 'Middle Dutch'.
		'odt' -> 'Old Dutch'.
		"
		'de' -> 'German'.
		"
		'gmh' -> 'Middle High German'.
		'goh' -> 'Old High German'.
		"
		'gmw-pro' -> 'Proto-West Germanic'.
		'non' -> 'Old Norse'.
		'gem-pro' -> 'Proto-Germanic'.
		
		'ine-pro' -> 'Proto-Indo-European'.
	}
]

{ #category : #accessing }
EtWord class >> supportedLang: lang [
	^ (self langCodeToName) at: lang ifPresent: [true] ifAbsent: [false]
]

{ #category : #accessing }
EtWord >> = other [
	^ {#class. #headword. #lang} allSatisfy: [:msg |
		(other perform: msg) = (self perform: msg)
	]
]

{ #category : #accessing }
EtWord >> fetchEtymology [
	^ EtFetcher fetchWordEtymology: self
]

{ #category : #accessing }
EtWord >> hash [
	^ headword hash bitXor: lang hash
]

{ #category : #accessing }
EtWord >> headword [
	^ headword
]

{ #category : #accessing }
EtWord >> headword: a lang: b [
	headword := a.
	lang := b
]

{ #category : #accessing }
EtWord >> lang [
	^ lang
]

{ #category : #accessing }
EtWord >> langName [
	^ (EtWord langCodeToName) at: lang
]

{ #category : #accessing }
EtWord >> page [
	(lang endsWith: '-pro') ifTrue: [
		^ 'Reconstruction:', self langName, '/', headword
	].
	^ headword
]

{ #category : #accessing }
EtWord >> printOn: aStream [
	aStream nextPutAll: headword, ' (', lang, ')'
]
