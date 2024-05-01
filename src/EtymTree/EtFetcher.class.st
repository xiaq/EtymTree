Class {
	#name : #EtFetcher,
	#superclass : #Object,
	#category : #EtymTree
}

{ #category : #accessing }
EtFetcher class >> allRegexMatches: str regex: r do: block [
	| stream rx |
	stream := str readStream.
	rx := r asRegex.
	[rx searchStream: stream] whileTrue: [
		block value: ((2 to: rx subexpressionCount) collect: [:i | rx subexpression: i])
	]
]

{ #category : #accessing }
EtFetcher class >> fetchRecursiveRelations: word [
	^ self fetchRecursiveRelations: word maxIterations: 100
]

{ #category : #accessing }
EtFetcher class >> fetchRecursiveRelations: word maxIterations: maxIterations [
	| relations visitedWords nextWords i |
	relations := OrderedCollection new.
	visitedWords := Set new.
	nextWords := { word } asSet.
	i := 0.
	[ nextWords size > 0 ] whileTrue: [
		| w newRelations |
		Transcript print: ('#{1}: nextWords: {2}, relations: {3}' format: {i. nextWords. relations size}); cr.
		w := nextWords atRandom.
		Transcript print: ('  w: {1}' format: {w}); cr.
		nextWords remove: w.
		visitedWords add: w.

		newRelations := self fetchRelations: w.
		relations addAll: newRelations.
		newRelations do: [:r |
			| w2 |
			w2 := r to.
			(visitedWords includes: w2) ifFalse: [
				nextWords add: w2.
			]
		].
		i := i + 1.
		i >= maxIterations ifTrue: [^ relations].
	].
	^ relations.
]

{ #category : #accessing }
EtFetcher class >> fetchRelations: word [
	| deriveRx inheritRx text relations cognateRx descendantRx langRx ignoreRx headwordRx |
	text := EtFetcher fetchWordText: word.
	relations := OrderedCollection new.

	langRx := '\|([^|}]*)'.
	ignoreRx := '\|[^|}]*'.
	headwordRx := '\|\*?([^|}]*)'.
	inheritRx := '\{\{inh(erited)?', ignoreRx, langRx, headwordRx.
	EtFetcher allRegexMatches: text regex: inheritRx do: [:sub |
		| to |
		to := EtWord new headword: (sub at: 3) lang: (sub at: 2).
		relations add: (EtRelation new from: word to: to type: #inherit)
	].
	deriveRx := '\{\{der(ived)?', ignoreRx, langRx, headwordRx.
	EtFetcher allRegexMatches: text regex: deriveRx do: [:sub |
		| to |
		to := EtWord new headword: (sub at: 3) lang: (sub at: 2).
		relations add: (EtRelation new from: word to: to type: #derive)
	].
	cognateRx := '\{\{cog(nate)?', langRx, headwordRx.
	EtFetcher allRegexMatches: text regex: cognateRx do: [:sub |
		| to |
		to := EtWord new headword: (sub at: 3) lang: (sub at: 2).
		relations add: (EtRelation new from: word to: to type: #cognate)
	].
	descendantRx := '\{\{(desc|descendant|desctree|descendants_tree)', langRx, headwordRx.
	EtFetcher allRegexMatches: text regex: descendantRx do: [:sub |
		| to |
		to := EtWord new headword: (sub at: 3) lang: (sub at: 2).
		relations add: (EtRelation new from: word to: to type: #descendant)
	].
	^ relations select: [:w | EtWord supportedLang: w to lang]
]

{ #category : #accessing }
EtFetcher class >> fetchWordText: word [
	"Fetch the word from Wiktionary and returns its wikitext.
	Returns an empty string if the word is not found."
	| dict wikitext sections langIndex from body json |

	(EtWord supportedLang: (word lang)) ifFalse: [^ '' asWideString].
	
	body := ZnClient new get: (self getUrl: word).
	json := STON fromString: body.
	json at: 'error' ifPresent: [^ '' asWideString].
	
	dict := json at: 'parse'.
	wikitext := dict at: 'wikitext' at: '*'.
	sections := dict at: 'sections'.
	" Find the index of the language section."
	langIndex := sections detectIndex: [:s |
		(s at: 'line') = word langName and:
		[(s at: 'toclevel') = 1]
	] ifNone: [^ '' asWideString].
	from := ((sections at: langIndex) at: 'byteoffset') + 1.
	" Find the next top-level section. "
	langIndex + 1 to: sections size do: [:i |
		| section |
		section := sections at: i.
		(section at: 'toclevel') = 1 ifTrue: [
			" We found the next top-level section, return the text in between. "
			^ wikitext sliceFrom: from to: (section at: 'byteoffset').
		]
	].
	" There is no more top-level section, return all the remaining text. "
	^ wikitext sliceFrom: from.
]

{ #category : #accessing }
EtFetcher class >> getUrl: word [
	^ 'https://en.wiktionary.org/w/api.php?action=parse&format=json&prop=wikitext|sections&page=', word page urlEncoded
]
