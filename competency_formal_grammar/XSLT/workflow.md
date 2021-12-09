# Workflow

Generate all expansions of acyclic EBNF grammar. 

**NB:** This method will break if there are cycles in the grammar.


Process          | Output            | Note
----             |----               |----
EBNF to RNC      | *productions.rnc* |manual (can be automated?)
RNC to RNG       | *productions.rng* | Trang (inside \<oXygen/\>)
Simplify RNG     | *inline-refs.xml* | *inline-refs.xsl*; dereference `<ref>`, remove `<define>`
Create edge list | *edges.xml*       | *edges.xsl* 
Create path list | *paths.xml*       | *paths.xsl*

----

**Notes:** 

1. Relax NG prohibits *group of "string" or "data" element* structures, so terminals are implemented as patterns that resolve to strings.
1. The simplify-RNG step will drop into infinite recursion if there are cycles in the grammar.
2. To process children of `<choice>` differently, change modes for just one step, applying templates in no mode, since no child of `<choice>` ever calls another child of the same `<choice>`. (Tip from Joel Kalvesmaki on xml.com Slack 2021-12-07)
