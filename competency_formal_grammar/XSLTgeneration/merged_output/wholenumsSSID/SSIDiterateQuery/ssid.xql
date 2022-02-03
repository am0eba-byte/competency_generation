let $thousand := //sentenceGroup[not(.[ends-with(@id, "sp")])]/componentSentence[position() mod 11 = 0]
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

let $thou := //sentenceGroup/componentSentence[@id = 1000]
let $zed := //sentenceGroup/componentSentence[@id = 0]


for $z at $pos in $zed
let $zID := $z/@id
let $newZID := concat($zID, '-', $pos)


return $newZID
