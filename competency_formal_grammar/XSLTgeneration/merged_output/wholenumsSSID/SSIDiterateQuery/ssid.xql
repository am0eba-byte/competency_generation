(:let $thousand := //sentenceGroup[not(.[ends-with(@id, "sp")])]/componentSentence[position() mod 11 = 0]
let $zero := //sentenceGroup[not(.[ends-with(@id, "sp")])]/componentSentence[position() mod 11 = 1]
let $one := //sentenceGroup[not(.[ends-with(@id, "sp")])]/componentSentence[position() mod 11 = 2]
let $two := //sentenceGroup[not(.[ends-with(@id, "sp")])]/componentSentence[position() mod 11 = 3]
let $three := //sentenceGroup[not(.[ends-with(@id, "sp")])]/componentSentence[position() mod 11 = 4]
let $four := //sentenceGroup[not(.[ends-with(@id, "sp")])]/componentSentence[position() mod 11 = 5]
let $five := //sentenceGroup[not(.[ends-with(@id, "sp")])]/componentSentence[position() mod 11 = 6]
let $ten := //sentenceGroup[not(.[ends-with(@id, "sp")])]/componentSentence[position() mod 11 = 7]
let $twenty := //sentenceGroup[not(.[ends-with(@id, "sp")])]/componentSentence[position() mod 11 = 8]
let $hundred := //sentenceGroup[not(.[ends-with(@id, "sp")])]/componentSentence[position() mod 11 = 9]
let $oneTwenty := //sentenceGroup[not(.[ends-with(@id, "sp")])]/componentSentence[position() mod 11 = 10]
:)

let $thousand := //sentenceGroup/componentSentence[@id = 1000]
let $zero := //sentenceGroup/componentSentence[@id = 0]
let $one := //sentenceGroup/componentSentence[@id = 1]
let $two := //sentenceGroup/componentSentence[@id = 2]
let $three := //sentenceGroup/componentSentence[@id = 3]
let $four := //sentenceGroup/componentSentence[@id = 4]
let $five := //sentenceGroup/componentSentence[@id = 5]
let $ten := //sentenceGroup/componentSentence[@id = 10]
let $twenty := //sentenceGroup/componentSentence[@id = 20]
let $hundred := //sentenceGroup/componentSentence[@id = 100]
let $oneTwenty := //sentenceGroup/componentSentence[@id = 120]

for $z at $pos in $zero
let $zID := $z/@id
let $newZID := concat($zID, '-', $pos)


return $newZID
