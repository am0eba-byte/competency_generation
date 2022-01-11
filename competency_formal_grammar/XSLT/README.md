# COMPETENCY GENERATION XSLT - PROCESS DOCUMENTATION


## General competency syntax for all scopes:
![Screen capture of competency grammar](scope_competency.png)


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
    <!-- The specific_object param is not used in competency sets keyed to specific scopes. -->
    <!-- All specific object competencies are generated once, with no filter rules. -->
    
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
    <!-- The wholenum scope param is only applied to the separate Whole Numbers scope -->
    <!-- competency generation workflow - see below for more details. -->    
    <xsl:param name="wholenum" as="xs:string" select="'wholenum'"/> 
```

##### Scope Key:
``
<xsl:key name="scopes" match="string" use="@class ! tokenize(., '\s+')"/>
``


## Scope Filtering - xsl:key Generator Implementations:

### How to use xsl:key and xsl:param to filter specific scope strings/handling instructions:

The XSLT sentence generator requires an `` xsl:variable `` that calls on a global `` xsl:key ``,
and applies a key-value `` xsl:param `` set to a string value of the scope or special filtering attribute.

#### Example of a Filtering Variable using an xsl:key:
Say you want to output a set competency sentences in the Imaginary Numbers scope that contains
a Knowledge Process (``knowledgeProcess`` strings in the input xml) and a Process Predicate(``processPred`` strings in input xml).

Each of the strings in a component element is tagged with a `@class` that has attribute values corresponding to
each of the scopes where that string may occur. To output ONLY the knowledgeProcess and processPred strings that 
can occur in Imaginary Numbers, we need two variables that call on the key of `scopes` and match
the `$imag` global param which selects the imaginary numbers attribute value. 
For each string that has an `@class` attribute value of `imag`, we tell it to call on a sequence of those strings
within a component whose node name is equal to a global component param:
###### Knowledge Process component variable:
```
            <xsl:variable name="KPimag" as="element()+">
                <xsl:for-each select="key('scopes', $imag)">
                    <xsl:sequence select=".[parent::* ! name() = $knowledge_process]"/>
                </xsl:for-each>
            </xsl:variable>
```
###### Process Predicate component variable:
```
            <xsl:variable name="PrPredimag" as="element()+">
                <xsl:for-each select="key('scopes', $imag)">
                    <xsl:sequence select=".[parent::* ! name() = $processPred]"/>
                </xsl:for-each>
            </xsl:variable>
```

Now, to apply those filtering rules to the Sentence Writer template, we must call on that template
and send to it these variables in the order in which they should occur in the sentence. To do that,
we apply `xsl:with-param` elements for each component variable within an `xsl:call-template` that calls
on our sentence writer template:

```
            <xsl:call-template name="sentenceWriter">
                <xsl:with-param name="param1" as="element()+" select="$KPimag"/>
                <xsl:with-param name="param2" as="element()+" select="$PrPredimag"/>
            </xsl:call-template>
```


## File Locations: 
### Generates scoped XML file:
XSLT script that generates a single XML file - each sentence group has a unique xml:id identifying what competency component strings comprise the sentences in that group, 
and which scope that sentence group is filtered through.

Location: `competency_generation\competency_formal_grammar\XSLT\XML-scopes-compgenerator.xsl`

## XML Output: 
The bulk XML output file for each scope competency is located within their respective folder names in this directory:

Location: `competency_generation\competency_formal_grammar\XSLT\scope_output\[scope-name]\*.xml`


#### Generates plain text (.txt) file:
Location: `competency_generation\competency_formal_grammar\XSLT\oneTXT-scopes-compgenerator.xsl`

## Plain Text (.txt) Output:
Location: `competency_generation\competency_formal_grammar\XSLT\scope_output\[scope-name]\text\[scopeName]SeedOutput.txt`

### Generates scoped TSV files:
XSLT script that does the same thing the XML generator above does, except instead of one big XML file with every sentence group inside, 
it generates separate tab-separated values (TSV) files for each collection of different sentence structure groups using xsl:result-document.

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


# Whole Numbers Scope Competency - Separate Workflow

### Whole Numbers Scope competency syntax:
![Screen capture of whole numbers competency grammar](whole_number_competency.png)

Given that the Whole Numbers scope is so vast, and contains a different sentence structure and set of grammar rules than the other scopes, 
Whole Numbers has its own special XSLT generator that will apply different filtering rules to output seed data for each Whole Numbers subscope set.

### Whole Numbers Scope Sub-Set:

- 0
- 1
- to 2
- to 3
- to 4
- to 5
- within 10
- within 20
- within 100
- within 120
- within 1000

## The Input

### Competency sentence components input XML
input file at: `competency_generation\competency_formal_grammar\XSLT\whole_numbers\competency_components_wholenums.xml`


## XSLT Generators:

#### Generates XML file:
location: `competency_generation\competency_formal_grammar\XSLT\whole_numbers\wholenums_XML_template.xsl`
Output at: `competency_generation\competency_formal_grammar\XSLT\whole_numbers\output\XML\wholeNumbers_compSeedData.xml`

#### Generates TSV files:
location: `competency_generation\competency_formal_grammar\XSLT\whole_numbers\TSV-wholenums-compgenerator.xsl`
Output files directory at:
`competency_generation\competency_formal_grammar\XSLT\whole_numbers\output\TSV\`

### Whole Numbers TSV File Naming Convention Key:

The TSV files are separated by which competency sentence components each group of sentences contains. They are named accordingly:

##### Formal Process Branch
- `fp-Pp` = Formal Process + Process Predicate (object subset)
- `fp-Pp-n` = Formal Process + Process Predicate + Notation Object
- `fp-mathop` = Formal Process + Math Operation + Quantitative Object (object subset)
- `fp-mathop-n` = Formal Process + Math Operation + Quantitative Object + Notation Object

##### Knowledge Process Branch
- `kp-Pp` = Knowledge Process + Process Predicate (object subset)
- `kp-sp-Pp` = Knowledge Process + Knowledge Subprocess + Process Predicate
- `kp-mathop` = Knowledge Process + Math Operation + Quantitative Object (object subset)
- `kp-sp-mathop` = Knowledge Process + Knowledge Subprocess + Math Operation + Quantitative Object



##### Global Whole Numbers Component Params:
  
 ```
 <xsl:param name="formal_process" as="xs:string" select="'formalProcess'"/>
 
    <xsl:param name="knowledge_process" as="xs:string" select="'knowledgeProcess'"/>
    
    <xsl:param name="knowledge_subprocess" as="xs:string" select="'knowledgeSubprocess'"/>
    
    <xsl:param name="processPred" as="xs:string" select="'processPred'"/>
    
    <xsl:param name="math_operation" as="xs:string" select="'mathOperation'"/>
    
    <xsl:param name="object" as="xs:string" select="'quant'"/>
    
    <xsl:param name="notationObject" as="xs:string" select="'notationObject'"/>
    
```

#### Scope Key:

 ``<xsl:key name="scopes" match="string" use="@class ! tokenize(., '\s+')"/>``

#### Scope Param:

`` <xsl:param name="wholenum" as="xs:string" select="'wholenum'"/> ``

### Notation Object Filtering - Special Formal Process String Keys
Since only two of the formalProcess strings will occur with a Notation Object string in the
Whole Numbers Competency sentences, the Formal process string elements have attributes which
define whether or not they go with a notation object, to be picked up by the following keys.

formalProcess strings that DO have notation obejcts are tagged with a `` @subclass="notation" `` attribute

formalProcess strings that do NOT have notation objects are tagged with a `` @subclass="noNot" `` attribute

#### Specific Formal Process + Notation String Key:

`` <xsl:key name="notationKey" match="string" use="@subclass ! normalize-space()"/> ``

#### Subclass Notation Params:

``` 
    <xsl:param name="notation" as="xs:string" select="'notation'"/>
    <xsl:param name="noNot" as="xs:string" select="'noNot'"/> 
```

#### How to use Notation Object key to filter Formal Process strings:
The Notation key works the same way that the scope filtering key does. Here's an example
of generating a set of Whole Numbers competency sentences that contain a Formal Process, a 
Process Predicate, and a Notation Object. 

```
           <xsl:variable name="FP_notation" as="element()+">
               <xsl:for-each select="key('notationKey', $notation)">
                   <xsl:sequence select=".[parent::* ! name() = $formal_process]"/>          
               </xsl:for-each>
           </xsl:variable>
           
           <xsl:variable name="PrPred" as="element()+">
               <xsl:for-each select="key('scopes', $wholenum)">
                   <xsl:sequence select=".[parent::* ! name() = $processPred]"/>
               </xsl:for-each>
           </xsl:variable>
           
           <xsl:variable name="NO" as="element()+">
               <xsl:for-each select="key('scopes', $wholenum)">
                   <xsl:sequence select=".[parent::* ! name() = $notationObject]"/>
               </xsl:for-each>
           </xsl:variable>
```

Notice how the variable for formalProcess uses the `notationKey` key name instead of `scopes`, and
calls on the `$notation` global parameter to grab only the formalProcess strings with a `notation` attribute value.
If you wanted to grab all of the formalProcess strings that do NOT go with a notation object, you'd
 call the `$noNot` param in that key instead.

Then, you call on the sentenceWriter template and apply those variables as ordered params using `xsl:with-param`, 
just as you would with the scopes variables:

```
           <xsl:call-template name="sentenceWriter">
               <xsl:with-param name="param1"  as="element()+" select="$FP_notation"/>
               <xsl:with-param name="param2" as="element()+" select="$PrPred"/>
               <xsl:with-param name="param3" as="element()+" select="$NO"/>
           </xsl:call-template>
```





## Considerations

- Whole Numbers scope specifications
- Filtering specific strings' exclusions (components that would never occur together if "x" string exists)
- - create subsets of objects that wouldn't occur together 
- Add attributes to strings with learning level connotations (primary, secondary, etc) and filter thru key intersections
- Add attributes for SCOPE RELATIONSHIPS (`@extends="[this_child_scope_ID]`) => to be represented in output XML's sentence elements
- Whole Numbers output:
- - implementing the whole numbers subscopes as separate outputs? (separate filtering needs for each wholenums subscope?)
- - notation objects + sub scopes? (some sub scopes do not make sense with notations, i.e. "0 in Base Ten")
- output with Knowledge Subprocess (kp-sp-mathop) - get rid of math operation?
- - example: from "Evaluate by adding to Adding Terms" (kp-sp-mathop) to "Evaluate Adding Terms by adding to" (kp-mathop-sp)



## Final Data Implementation



### K-5 focus lens:
- whole numbers
- numerical expressions
- algebraic expressions
- integers
- rational numbers (+ filtered notation objects?)

### scope competencies generated so far:

- complex numbers + imaginary numbers
- integers
- rational numbers
- algebraic expressions
- space
- the plane

### scopes to do:
- real numbers 
- unit fractions
- vectors
- matrices
- infinite numbers
- random numbers
- expected values
- probabilities


