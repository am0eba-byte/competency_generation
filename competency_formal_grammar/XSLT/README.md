# COMPETENCY GENERATION XSLT - PROCESS DOCUMENTATION

## The Input

### Competency sentence components input XML
input file at: `competency_generation\competency_formal_grammar\XSLT\competency_components.xml`


## The XSLT generators

### No scope filtering (proof of concept):

#### Generates XML file:
location: `competency_generation\competency_formal_grammar\XSLT\old_draftXSLT\generate_competencies_namedTemplate.xsl`
#### Generates TSV files:
location: `competency_generation\competency_formal_grammar\XSLT\old_draftXSLT\TSVgenerate_competencies_namedTemplate.xsl`


### Scope filtering - xsl:key script implementations:

#### Generates scoped XML file:
XSLT script that generates a single XML file - each sentence group has a unique xml:id identifying what competency component strings comprise the sentences in that group, and which scope that sentence group is filtered through.

Location: `competency_generation\competency_formal_grammar\XSLT\reworkedTREE_XSLTgenerator.xsl`

### XML Output: 
The bulk XML output file for each scope competency is located within their respective folder names in this directory:

Location: `competency_generation\competency_formal_grammar\XSLT\scope_output\[scope-name]\*.xml`


#### Generates scoped TSV files:
XSLT script that does the same thing the XML generator above does, except instead of one big XML file with every sentence group inside, it generates separate tab-separated values (TSV) files for each collection of different sentence structure groups using xsl:result-document.

Location: `competency_generation\competency_formal_grammar\XSLT\TSV-reworkedTREE_compgenerator.xsl`


### TSV Output:
Each collection of TSV output files for each scope is located within their respective folder names in this directory:

Location: `competency_generation\competency_formal_grammar\XSLT\scope_output\[scope-name]\TSV`

#### TSV File Naming Convention Key:

The TSV files are separated by which competency sentence components each group of sentences contains. They are named accordingly:

##### Formal Process Branch
- `fp-Pp` = Formal Process + Process Predicate (object subset)
- `fp-so` = Formal Process + Specific Object
- `fp-mathop` = Formal Process + Math Operation + Quantitative Object (object subset)

##### Knowledge Process Branch
- `kp-Pp` = Knowledge Process + Process Predicate (object subset)
- `kp-so` = Knowledge Process + Specific Object
- `kp-mathop` = Knowledge Process + Math Operation + Quantitative Object (object subset)



## Considerations

- Whole Numbers scope specifications
- Filtering specific strings' exclusions (components that would never occur together if "x" string exists)
- - create subsets of objects that wouldn't occur together 
- Making Sense of the Nonsense output
- creating separate XSLT generators for each scope

## Final Data Implementation



### short term focus scopes:

- complex numbers + imaginary numbers
- integers

### scopes to do:
- rational numbers
- real numbers 
- unit fractions
- real numbers
- vectors
- matrices
- infinite numbers
- random numbers
- expected values
- probabilities
- the plane
- space
- algebraic expressions
- numerical expressions
- whole numbers

