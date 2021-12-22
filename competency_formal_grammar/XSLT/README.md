# COMPETENCY GENERATION XSLT - PROCESS DOCUMENTATION


## General competency syntax for all scopes:
![Screen capture of competency grammar](scope_competency.png)

## Whole Numbers Scope competency syntax:
![Screen capture of whole numbers competency grammar](whole_number_competency.png)

[Click Here to see the Full Interactive Competency Grammar Syntax Diagram](https://am0eba-byte.github.io/competency_generation/)


## The Input

### Competency sentence components input XML
input file at: `competency_generation\competency_formal_grammar\XSLT\competency_components.xml`


## No Scope Filtering (Proof of Concept):

#### Generates XML file:
location: `competency_generation\competency_formal_grammar\XSLT\XML-nokeys-compgenerator.xsl`
Output at: `competency_generation\competency_formal_grammar\XSLT\unfiltered-output\XML-unfiltered_nokeys_compOutput.xml`

#### Generates TSV files:
location: `competency_generation\competency_formal_grammar\XSLT\TSV-nokeys-compgenerator.xsl`
Output files directory at:
`competency_generation\competency_formal_grammar\XSLT\unfiltered-output\TSV\`


## The XSLT generators

The XSLT generator scripts have two basic components:
 1) The Sentence Writer Template handles the sentence construction: 
 Governed by input parameters (`xsl:param`) which define strings that line up with the element names of each competency sentence component in the XML source document.
  It expects at least two required input parameters, and no more than three.
    In the function, we first generate a series of three variables based on the three possible input parameters, grapping their parent node name as a string. 
    Then it constructs a series of nested for-each loops. 
    So, if only two parameters are sent, the function outputs a "sentence" consisting of two elements. 
    And if three parameters are in a sentence, the function outputs a "sentence" of three elements.
    
 2) The Sentence Generator xsl:template rule: 
  This sets up each kind of sentence combination we want, organized by the types of sentence structures constructed by the Sentence Writer template, and then applies `xsl:key` functions to filter through each component's `@class` attributes and output only those who match the given scope param we tell it to. 
        This is a template matching on the source document node and set to output groups of different kinds of sentences. 
        (This could be split into separate XSLT stylesheets designed to handle one or two related combinations, 
        but for now, we're putting them all together here.) 
     Each sentence group needs an `<xsl:variable>` which grabs the `xsl:key` value of a specific scope param and generates an `<xsl:squence>` of the strings within a given component in the source document (pulled from the global parameters 
     defined at the top of the XSLT document)  who are tagged with the given scope class attribute.
     We use `<xsl:call-templates>` to invoke a named template, and inside, we deliver
     what keyed variables we need to construct a sentence. 
     
##### Global Component Params:
  
 ```
 <xsl:param name="formal_process" as="xs:string" select="'formal_process'"/>
 
    <xsl:param name="knowledge_process" as="xs:string" select="'knowledge_process'"/>
    
    <xsl:param name="processPred" as="xs:string" select="'processPred'"/>
    
    <xsl:param name="specific_object" as="xs:string" select="'specific_object'"/>
    
    <xsl:param name="math_operation" as="xs:string" select="'math_operation'"/>
    <xsl:param name="object" as="xs:string" select="'quant'"/> 
```
    
    
##### Global Scope Params:

``` 
<xsl:param name="complex" as="xs:string" select="'complex'"/>
    <xsl:param name="imag" as="xs:string" select="'imag'"/>
    <xsl:param name="int" as="xs:string" select="'int'"/>
    <xsl:param name="rational" as="xs:string" select="'rational'"/>
    <xsl:param name="real" as="xs:string" select="'real'"/>
    <xsl:param name="unit" as="xs:string" select="'unit'"/>
    <xsl:param name="vector" as="xs:string" select="'vector'"/>
    <xsl:param name="matrix" as="xs:string" select="'matrix'"/>
    <xsl:param name="infinite" as="xs:string" select="'infinite'"/>
    <xsl:param name="random" as="xs:string" select="'random'"/>
    <xsl:param name="expect" as="xs:string" select="'expect'"/>
    <xsl:param name="prob" as="xs:string" select="'prob'"/>
    <xsl:param name="plane" as="xs:string" select="'plane'"/>
    <xsl:param name="space" as="xs:string" select="'space'"/>
    <xsl:param name="algexp" as="xs:string" select="'algexp'"/>
    <xsl:param name="numexp" as="xs:string" select="'numexp'"/>
    <xsl:param name="wholenum" as="xs:string" select="'wholenum'"/> 
```

##### Scope Key:
``
<xsl:key name="scopes" match="string" use="@class ! tokenize(., '\s+')"/>
``



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
- rational numbers
- algebraic expressions

### scopes to do:
- real numbers 
- unit fractions
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

