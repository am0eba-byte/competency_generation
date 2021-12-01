(:modified_competency = 
        ( ([ formal_process ] | [ knowledge_process, [ “by” knowledge_subprocess ] ]), ((math_operation,  object) | specific_object ), [ notation_object ] ) | math_practice_competency:)
        
let $root := doc("competency_components.xml")/xml
let $domains := $root/domains
let $scopes := $domains/scopes
let $compParts := $root/compParts
let $process := $compParts/process//*/string[not(ancestor::whole_numbers_knowledge_subprocess) and not(child::insert)]

let $knowledge := $compParts/process/knowledge/knowledge_process/string
let $WHknowledgeSub := $compParts//whole_numbers_knowledge_subprocess/string
(:let $WhNumKnowFull := concat($knowledge, ' by ', $WHknowledgeSub):)
let $objChoice := $compParts/object_choice//*/string
let $notatObj := $compParts/notation_object
for $o in $objChoice
for $p in $process
return concat($p, ' ', $o, ' ',  "&#10;")

