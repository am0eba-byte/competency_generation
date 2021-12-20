# Competency Generation XSLT - Process Documentation

Experimentation on competency formal grammar syntax rules and generation of competency data

## General competency syntax for all scopes:
![Screen capture of competency grammar](scope_competency.png)

## Whole Numbers Scope competency syntax:
![Screen capture of whole numbers competency grammar](whole_number_competency.png)




## The Input

### Competency sentence components input XML
input file at: `competency_generation\competency_formal_grammar\XSLT\competency_components.xml`


## The XSLT generators

### No scope filtering (proof of concept):

#### Generates XML file:
location: `competency_generation\competency_formal_grammar\XSLT\XML-nokeys-compgenerator.xsl`
Output at: `competency_generation\competency_formal_grammar\XSLT\unfiltered-output\XML-unfiltered_nokeys_compOutput.xml`

#### Generates TSV files:
location: `competency_generation\competency_formal_grammar\XSLT\TSV-nokeys-compgenerator.xsl`
Output files directory at:
`competency_generation\competency_formal_grammar\XSLT\unfiltered-output\TSV\`

## Scope filtering - xsl:key script implementations:

### Generates scoped XML file:
XSLT script that generates a single XML file - each sentence group has a unique xml:id identifying what competency component strings comprise the sentences in that group, and which scope that sentence group is filtered through.

Location: `competency_generation\competency_formal_grammar\XSLT\XML-scopes-compgenerator.xsl`

## XML Output: 
The bulk XML output file for each scope competency is located within their respective folder names in this directory:

Location: `competency_generation\competency_formal_grammar\XSLT\scope_output\[scope-name]\*.xml`


### Generates scoped TSV files:
XSLT script that does the same thing the XML generator above does, except instead of one big XML file with every sentence group inside, it generates separate tab-separated values (TSV) files for each collection of different sentence structure groups using xsl:result-document.

Location: `competency_generation\competency_formal_grammar\XSLT\TSV-scopes-compgenerator.xsl`


## TSV Output:
Each collection of TSV output files for each scope is located within their respective folder names in this directory:

Collection Location: `competency_generation\competency_formal_grammar\XSLT\scope_output\[scope-name]\TSV`

### TSV File Naming Convention Key:

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







## Tools:
[BNFgen](https://baturin.org/tools/bnfgen/) 

[Railroad Syntax Diagram Generator](https://bottlecaps.de/rr/ui#_CharCode)



# Competency Generation options

Schematron:
specific scope competencies: excludes [insert list of things that this scope doesn't contain here]


XSLT xsl:keys

or

Python 
- lxml etree
    - XMLPullParser   

- XML Schema and [generate.DS](https://pypi.org/project/generateDS/) can be used to generate Python data structures from an XML schema and generates parsers that load an XML document into those data structures. We could use to define competency grammar, then load the competency_components.xml into. In addition, a separate file containing subclasses (stubs) is optionally generated. We could possibly use this to create scope filtering subclasses, and then we can add methods to the subclasses in order to process the contents of the XML document to generate output.

