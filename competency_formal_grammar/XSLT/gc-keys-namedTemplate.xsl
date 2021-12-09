<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:arj="http://arjuna.bil.com"
    exclude-result-prefixes="xs arj"
    version="3.0">
    
    <!--2021-12-08 ebb mb: This new XSLT is an experiment with xsl:keys for filtering and locating intersections/subsets using scopes. We have prepared a new input XML that applies scopes using @class attributes 
   on <string> elements nested variously anywhere that a <string> may be found to be a sentence component: (In this sample, it's <math_operation>, <object>, <specific_object>, <formal_process>, <knowledge_process>, <notation_object>, and also in the <whole_numbers_knowledge_subprocess>.
   
   Some <string> elements have a @class attribute. Some don't.
   Of those that have a @class attribute, some have a single value, and some have multiple values separated by a space.
   
   INPUT file is test_attScopes_competency_components.xml
   
   As ever, our GOAL is to produce a human-readable and easily edited stylesheet. This reads an XML document that expresses competency relationships, and this time expresses scope delimiters too,
 in a simple tree structure. The stylesheet outputs XML to mark the parts of a series of sentences organized in set combinations.
 
    
    -->   
    
    <!-- Sentence flow from EBNF:
        modified_competency = 
        ( ([ formal_process ] | [ knowledge_process, [ “by” knowledge_subprocess ] ]), ((math_operation,  object) | specific_object ), [ notation_object ] ) | math_practice_competency ;
 -->
   
    
    <xsl:output method="xml" indent="yes"/>
 
 <!-- ebb: Here we have defined a series of global parameters that are just strings of text designed to match element names in the source document. Parameters are very similar to variables in XSLT, but have a little more flexibility.They could be received into this XSLT as input, so imagine these as INPUT PARAMETERS to this XSLT. -->

    <xsl:param name="math_operation" as="xs:string" select="'math_operation'"/>
    <xsl:param name="object" as="xs:string" select="'object'"/>
    <xsl:param name="notation" as="xs:string" select="'notation_object'"/>
    <xsl:param name="specific_object" as="xs:string" select="'specific_object'"/>
    <xsl:param name="formal_process" as="xs:string" select="'formal_process'"/>
    <xsl:param name="knowledge_process" as="xs:string" select="'knowledge_process'"/>
<!-- mb: The below parameters include those that are specific to a particular scope's competency sentence possibilities. (More to come) -->
    <xsl:param name="wholeNumKSP" as="xs:string" select="'whole_numbers_knowledge_subprocess'"/>
    
 <!--ebb: We add some more strings for scope delimiters seeded throughout the document: -->
    <xsl:param name="wholenum" as="xs:string" select="'wholenum'"/>
    <xsl:param name="complex" as="xs:string" select="'complex'"/>
   
    
    <!--2021-12-08 ebb mb: Below we introduce an xsl:key that reaches for scope delimiters in our source document. We have "seeded" the input XML for this stylesheet with scopes specified by @class attributes on various keyed elements. The The key reaches for all <string> elements and where they have @class attributes, it tokenizes them on one or more spaces in case there are multiple values.--> 
    
    <xsl:key name="scopes" match="string" use="@class ! tokenize(., '\s+')"/>
   
    <!-- KEYS: all components -->
    <xsl:key name="elements" match="compParts" use="descendant::*"/>
    
  <!-- DOES NOT WORK   <xsl:variable name="mathops">
        <xsl:for-each select="key('elements', 'math_operation')">
            <xsl:sequence select="key('scopes', 'wholenum', current())"/>
        </xsl:for-each>
    </xsl:variable>-->
    
<!--    <!-\- KEYS: specific components: keyed to <string> elements. -\->
    <xsl:key name="math_operation" match="math_operation" use="string"/>
    <xsl:key name="object" match="object" use="string"/> 
    <xsl:key name="notation" match="notation" use="string"/> 
    <xsl:key name="specific_object" match="specific_object" use="string"/> 
    <xsl:key name="formal_process" match="formal_process" use="string"/> 
    <xsl:key name="knowledge_process" match="knowledge_process" use="string"/> 
    -->

 
<!--ebb: Here is our XSLT Named Template that handles the sentence construction: I've set this so we expect at least 
    two required input parameters. The rest are optional. 
    The input parameters are just strings that line up with the element names in the XML source document.
    In the function, we first generate a series of five variables based on the five possible input parameters. 
    Then we construct a series of nested for-each loops. I wonder if we can refine this, but it works to output 
    single sentence components together at the deepest available level. 
    So, if only two parameters are sent, the function outputs a "sentence" consisting of two elements. 
    And if five parameters are sentence, the function outputs a "sentence" of five elements.
    -->
    <xsl:template name="sentenceWriter" as="element()+">
        <xsl:param name="param1" as="element()+" required="yes"/>
        <xsl:param name="param2" as="element()+" required="yes"/>
        <xsl:param name="param3" as="element()*"/>
        <xsl:param name="param4" as="element()*"/>
        <xsl:param name="param5" as="element()*"/>
     
            <!-- YES WE DO NEED VARIABLES. JUST NOT THESE VARIABLES> 
            TAKE THE NODES, CONVERT THEM TO STRINGS FOR SENTENCE CONSTRUCTION.
            -->
        <xsl:variable name="var1" as="xs:string+" select="$param1/parent::* ! name()"/>
        <xsl:variable name="var2" as="xs:string+" select="$param2/parent::* ! name()"/>
        <xsl:variable name="var3" as="xs:string*" select="$param3/parent::* ! name()"/>
        <xsl:variable name="var4" as="xs:string*" select="$param4/parent::* ! name()"/>
        <xsl:variable name="var5" as="xs:string*" select="$param5/parent::* ! name()"/>
        
        <xsl:for-each select="$param1 ! normalize-space()">
            <xsl:variable name="currLevel1" as="xs:string" select="current()"/>
     
            <xsl:for-each select="$param2 ! normalize-space()">
              <xsl:variable name="currLevel2" as="xs:string?" select="current()"/>
          
          <xsl:choose><!-- CHOICE 1 -->
          <xsl:when test="$param3">
          <xsl:for-each select="$param3 ! normalize-space()">
                 <xsl:variable name="currLevel3" as="xs:string?" select="current()"/>
              <xsl:choose><!-- CHOICE 2 -->
                       <xsl:when test="$param4">
                           <xsl:for-each select="$param4 ! normalize-space()">
                       <xsl:variable name="currLevel4" as="xs:string?" select="current()"/>
                      <xsl:choose><!-- CHOICE 3 -->
                          <xsl:when test="$param5">
                              <xsl:for-each select="$param5 ! normalize-space()">
                           <componentSentence><!-- FIVE-PARAMETER SENTENCE -->
                               <xsl:element name="{$var1}">
                                   <xsl:sequence select="$currLevel1"/>
                               </xsl:element> 
                                  <xsl:element name="{$var2}">
                                   <xsl:sequence select="$currLevel2"/>
                                  </xsl:element> 
                               <xsl:element name="{$var3}">
                                   <xsl:sequence select="$currLevel3"/>
                               </xsl:element>
                               <xsl:element name="{$var4}">
                                   <xsl:sequence select="$currLevel4"/>
                               </xsl:element>
                               <xsl:element name="{$var5}">
                                   <xsl:sequence select="current()"/>
                               </xsl:element>
                           </componentSentence>
                       </xsl:for-each>
                      </xsl:when>
                         <xsl:otherwise><!-- FOUR-PARAMETER SENTENCE -->
                             <componentSentence>
                                 <xsl:element name="{$var1}">
                                     <xsl:sequence select="$currLevel1"/>
                                 </xsl:element> 
                                 <xsl:element name="{$var2}">
                                     <xsl:sequence select="$currLevel2"/>
                                 </xsl:element> 
                                 <xsl:element name="{$var3}">
                                     <xsl:sequence select="$currLevel3"/>
                                 </xsl:element> 
                                 <xsl:element name="{$var4}">
                                     <xsl:sequence select="$currLevel4"/>
                                 </xsl:element> 
                             </componentSentence>
                         </xsl:otherwise> 
                      </xsl:choose>
                       </xsl:for-each>      

                       </xsl:when>
                  <xsl:otherwise><!-- THREE-PARAMETER SENTENCE -->
                      <componentSentence>
                          <xsl:element name="{$var1}">
                              <xsl:sequence select="$currLevel1"/>
                          </xsl:element> 
                          <xsl:element name="{$var2}">
                              <xsl:sequence select="$currLevel2"/>
                          </xsl:element> 
                          <xsl:element name="{$var3}">
                              <xsl:sequence select="$currLevel3"/>
                          </xsl:element> 
                      </componentSentence>
                  </xsl:otherwise>
              </xsl:choose>
           </xsl:for-each>
          </xsl:when>
              <xsl:otherwise>
                  <!--TWO-PARAMETER SENTENCE -->
                  <componentSentence>
                      <xsl:element name="{$var1}">
                          <xsl:sequence select="$currLevel1"/>
                      </xsl:element> 
                      <xsl:element name="{$var2}">
                          <xsl:sequence select="$currLevel2"/>
                      </xsl:element> 
                  </componentSentence>
              </xsl:otherwise>
          </xsl:choose>
            
        </xsl:for-each>
        </xsl:for-each>
      </xsl:template>
    
    
    <!--ebb: In the xsl:template rule below, we set up each kind of sentence combination we want. 
        This is a template matching on the source document node and set to output a new XML file
        that groups different kinds of sentences. 
        (This could be split into separate XSLT stylesheets designed to handle one or two related combinations, 
        but for testing, we're putting them all together here.) 
     We use <xsl:call-templates> to invoke a named template, and inside, we deliver
     what parameters we need to construct a sentence. We pull these from the global parameters 
     defined at the top of this XSLT document. 
 -->  
   <xsl:template match="/">
       
       <!-- KEYED SCOPE VARIABLES: Here we define a series of variables to filter each of our sentence components by the presence of keyed scopes. If this XSLT were to accept parameter input, say, in the form of text strings identifying a scope, those input parameters could be fed in as a key value to the variables below. We could define these at the top of the stylesheet, but since they're essential to coordinating sentence constructions, perhaps it's better to work out the combinations in this template that directs how sentences are written. -->
     
       <xml>
           <xsl:comment>###############################</xsl:comment>
           <xsl:comment>SCOPE DELIMITER A: Math Operation Objects Without Notations, Scoped to Whole Numbers</xsl:comment>
           <xsl:comment>###############################</xsl:comment>
           <xsl:variable name="mathopWN" as="element()+">
               <xsl:for-each select="key('scopes', $wholenum)">
                   <xsl:sequence select=".[parent::* ! name() = $math_operation]"/>     
               </xsl:for-each>
           </xsl:variable>
           <xsl:variable name="objectWN" as="element()+">
               <xsl:for-each select="key('scopes', $wholenum)">
                   <xsl:sequence select=".[parent::* ! name() = $object]"/>          
               </xsl:for-each>
           </xsl:variable>
           <sentenceGroup xml:id="moW">
               <desc>Math operations and objects, scoped to whole numbers</desc>
         <xsl:call-template name="sentenceWriter">
               <xsl:with-param name="param1" as="element()+"  select="$mathopWN"/>
               <xsl:with-param name="param2" as="element()+" select="$objectWN"/>
           </xsl:call-template>
       </sentenceGroup>
           <xsl:comment>###############################</xsl:comment>
           <xsl:comment>SCOPE DELIMITER B: Math Operation Objects With Notations, Scoped to Complex numbers</xsl:comment>
           <xsl:comment>###############################</xsl:comment>
           <!--ebb: NOTE that this picks up complex numbers when scoped together with wholenumbers thanks to the power of tokenize()! :-) -->
           <xsl:variable name="mathopC" as="element()+">
               <xsl:for-each select="key('scopes', $complex)">
                   <xsl:sequence select=".[parent::* ! name() = $math_operation]"/>     
               </xsl:for-each>
           </xsl:variable>
           <xsl:variable name="objectC" as="element()+">
               <xsl:for-each select="key('scopes', $complex)">
                   <xsl:sequence select=".[parent::* ! name() = $object]"/>          
               </xsl:for-each>
           </xsl:variable>
           <xsl:variable name="notationC" as="element()+">
               <xsl:for-each select="key('scopes', $complex)">
                   <xsl:sequence select=".[parent::* ! name() = $notation]"/>          
               </xsl:for-each>
           </xsl:variable>
          <sentenceGroup xml:id="monC"> <desc>Math operations and objects with notations, scoped to complex numbers</desc>
           <xsl:call-template name="sentenceWriter">
               <xsl:with-param name="param1" as="element()+"  select="$mathopC"/>
               <xsl:with-param name="param2" as="element()+" select="$objectC"/>
               <xsl:with-param name="param3" as="element()+" select="$notationC"/>
           </xsl:call-template>
           </sentenceGroup>
   
           <xsl:comment>###############################</xsl:comment>
           <xsl:comment>SCOPE DELIMITER C: Math Operation Objects With Notations, Scoped to Both Whole Numbers and Complex numbers</xsl:comment>
           <xsl:comment>###############################</xsl:comment>
           <xsl:variable name="mathopWNC" as="element()+">
               <xsl:for-each select="key('scopes', $complex)">
                   <xsl:sequence select=".[contains(@class, $wholenum)][parent::* ! name() = $math_operation]"/>          
               </xsl:for-each>
           </xsl:variable>
           <xsl:variable name="objectWNC" as="element()+">
               <xsl:for-each select="key('scopes', $complex)">
                   <xsl:sequence select=".[contains(@class, $wholenum)][parent::* ! name() = $object]"/>          
               </xsl:for-each>
           </xsl:variable>
           <xsl:variable name="notationWNC" as="element()+">
               <xsl:for-each select="key('scopes', $complex)">
                   <xsl:sequence select=".[contains(@class, $wholenum)][parent::* ! name() = $notation]"/>          
               </xsl:for-each>
           </xsl:variable>
          <sentenceGroup xml:id="monWC"> <desc>Math operations and objects with notations, scoped to the limited subset of BOTH whole numbers AND complex numbers</desc>

           <xsl:call-template name="sentenceWriter">
               <xsl:with-param name="param1" as="element()+"  select="$mathopWNC"/>
               <xsl:with-param name="param2" as="element()+" select="$objectWNC"/>
               <xsl:with-param name="param3" as="element()+" select="$notationWNC"/>
           </xsl:call-template></sentenceGroup>
   
   
           <xsl:comment>###############################</xsl:comment>
           <xsl:comment>SCOPE DELIMITER D: Formal Processes with Specific Objects and Notations: , Scoped to Both Whole Numbers and Complex numbers</xsl:comment>
           <xsl:comment>###############################</xsl:comment>
           <xsl:variable name="formal_processWNC" as="element()+">
               <xsl:for-each select="key('scopes', $complex)">
                   <xsl:sequence select=".[contains(@class, $wholenum)][parent::* ! name() = $formal_process]"/>          
               </xsl:for-each>
           </xsl:variable>
           <xsl:variable name="specific_objectWNC" as="element()+">
               <xsl:for-each select="key('scopes', $complex)">
                   <xsl:sequence select=".[contains(@class, $wholenum)][parent::* ! name() = $specific_object]"/>          
               </xsl:for-each>
           </xsl:variable>
           <sentenceGroup xml:id="fpsonWC">
               <desc>Sentences describing formal processes with specific objects and notations, scoped to the limited subset of BOTH whole numbers AND complex numbers</desc>
 
               <xsl:call-template name="sentenceWriter">
                   <xsl:with-param name="param1" as="element()+" select="$formal_processWNC"/>
                   <xsl:with-param name="param2" as="element()+" select="$specific_objectWNC"/>
                   <xsl:with-param name="param3" as="element()+" select="$notationWNC"/>
               </xsl:call-template>
           </sentenceGroup>
           
           <xsl:comment>###############################</xsl:comment>
           <xsl:comment>SCOPE DELIMITER E: Knowledge Processes with Whole Number Subprocesses with Specific Objects and Notations, Scoped to Both Whole Numbers and Complex numbers</xsl:comment>
           <xsl:comment>###############################</xsl:comment>
           <xsl:variable name="knowledge_processWNC" as="element()+">
               <xsl:for-each select="key('scopes', $complex)">
                   <xsl:sequence select=".[contains(@class, $wholenum)][parent::* ! name() = $knowledge_process]"/>          
               </xsl:for-each>
           </xsl:variable>  
           <xsl:variable name="wholeNumkspWNC" as="element()+">
               <xsl:for-each select="key('scopes', $complex)">
                   <xsl:sequence select=".[contains(@class, $wholenum)][parent::* ! name() = $wholeNumKSP]"/>          
               </xsl:for-each>
           </xsl:variable>   
           
           <sentenceGroup xml:id="kpsmonWC">
                   <desc>Sentences describing knowledge processes and subprocesses associated with the whole numbers scope, with math operation objects and notations.</desc>
                   
               
                 <xsl:call-template name="sentenceWriter">
                     <xsl:with-param name="param1" as="element()+" select="$knowledge_processWNC"/>
                       <xsl:with-param name="param2" as="element()+" select="$wholeNumkspWNC"/>
                       <xsl:with-param name="param3" as="element()+" select="$mathopWNC"/>
                       <xsl:with-param name="param4" as="element()+" select="$objectWNC"/>
                       <xsl:with-param name="param5" as="element()+" select="$notationWNC"/>
                   </xsl:call-template>
               </sentenceGroup>
           
           
          
           <!--      <xsl:comment>###############################</xsl:comment>
           <xsl:comment>1. Math Operation Objects Without Notations</xsl:comment>
           <xsl:comment>###############################</xsl:comment>
      
         <sentenceGroup xml:id="mo">
             <desc>Sentences containing only math operation objects without notations.</desc>
  
             <xsl:call-template name="sentenceWriter">
                 <xsl:with-param name="param1" as="xs:string" select="$math_operation"/>
                 <xsl:with-param name="param2" as="xs:string" select="$object"/>
             </xsl:call-template>
         </sentenceGroup>
           
       
          
           
           <xsl:comment>###############################</xsl:comment>
           <xsl:comment>2. Math Operation Objects With Notations</xsl:comment>
           <xsl:comment>###############################</xsl:comment>
          <sentenceGroup xml:id="mon"> 
              <desc>Sentences containing math operation objects with notations.</desc>
              <xsl:call-template name="sentenceWriter">
                  <xsl:with-param name="param1" as="xs:string" select=""/>
                  <xsl:with-param name="param2" as="xs:string" select="$object"/>
                  <xsl:with-param name="param3" as="xs:string" select="$notation"/>
              </xsl:call-template>
           </sentenceGroup>
           
   
           
             <xsl:comment>###############################</xsl:comment>
           <xsl:comment>3. Specific Objects Without Notations</xsl:comment>
           <xsl:comment>###############################</xsl:comment>
           <sentenceGroup xml:id="so">
               <desc>Sentences describing only specific objects. Since this sentence only contains a single utterance, we question
               whether it counts as a complete sentence in the competency grammar.</desc>
               <xsl:for-each select="//specific_object/string ! normalize-space()">
                   <componentSentence>
                       <specificObject><xsl:sequence select="current()"/></specificObject>
                   </componentSentence>
               </xsl:for-each>
           </sentenceGroup>
           
          <xsl:comment>###############################</xsl:comment>
           <xsl:comment>4. Specific Objects With Notations</xsl:comment>
           <xsl:comment>###############################</xsl:comment>
           <sentenceGroup xml:id="son">
               <desc>Sentences describing specific objects and notations.</desc>
               <xsl:call-template name="sentenceWriter">
                   <xsl:with-param name="param1" as="xs:string" select="$specific_object"/>
                   <xsl:with-param name="param2" as="xs:string" select="$notation"/>
               </xsl:call-template>
           </sentenceGroup>
          
         <xsl:comment>###############################</xsl:comment>
           <xsl:comment>5. Formal Processes with Math Objects and No Notations</xsl:comment>
           <xsl:comment>###############################</xsl:comment>
           <sentenceGroup xml:id="fpmo">
               <desc>Sentences describing formal processes with math operations, and without notations.</desc>
               <xsl:call-template name="sentenceWriter">
                   <xsl:with-param name="param1" as="xs:string" select="$formal_process"/>
                   <xsl:with-param name="param2" as="xs:string" select="$math_operation"/>
                   <xsl:with-param name="param3" as="xs:string" select="$object"/>
               </xsl:call-template>
           </sentenceGroup>
           
           <xsl:comment>###############################</xsl:comment>
           <xsl:comment>6. Formal Processes with Math Objects and Notations</xsl:comment>
           <xsl:comment>###############################</xsl:comment>
           <sentenceGroup xml:id="fpmon">
               <desc>Sentences describing formal processes with math operations including notations.</desc>
               <xsl:call-template name="sentenceWriter">
                   <xsl:with-param name="param1" as="xs:string" select="$formal_process"/>
                   <xsl:with-param name="param2" as="xs:string" select="$math_operation"/>
                   <xsl:with-param name="param3" as="xs:string" select="$object"/>
                   <xsl:with-param name="param4" as="xs:string" select="$notation"/>
               </xsl:call-template>
           </sentenceGroup>
           
         <xsl:comment>###############################</xsl:comment>
           <xsl:comment>7. Formal Processes with Specific Objects and No Notations</xsl:comment>
           <xsl:comment>###############################</xsl:comment>
           <sentenceGroup xml:id="fpso">
               <desc>Sentences describing formal processes with specific objects alone.</desc>
               <xsl:call-template name="sentenceWriter">
                   <xsl:with-param name="param1" as="xs:string" select="$formal_process"/>
                   <xsl:with-param name="param2" as="xs:string" select="$specific_object"/>
               </xsl:call-template>
           </sentenceGroup>
           
            <xsl:comment>###############################</xsl:comment>
           <xsl:comment>8. Formal Processes with Specific Objects and Notations</xsl:comment>
           <xsl:comment>###############################</xsl:comment>
           <sentenceGroup xml:id="fpson">
               <desc>Sentences describing formal processs with specific objects and notations.</desc>
               <xsl:call-template name="sentenceWriter">
                   <xsl:with-param name="param1" as="xs:string" select="$formal_process"/>
                   <xsl:with-param name="param2" as="xs:string" select="$specific_object"/>
                   <xsl:with-param name="param3" as="xs:string" select="$notation"/>
               </xsl:call-template>
           </sentenceGroup>
           
           <xsl:comment>###############################</xsl:comment>
           <xsl:comment>9. Knowledge Processes with Math Operation Objects And No Notations</xsl:comment>
           <xsl:comment>###############################</xsl:comment>
           <sentenceGroup xml:id="kpmo">
               <desc>Sentences describing knowledge processes with math operation objects, without notations.</desc>
               <xsl:call-template name="sentenceWriter">
                   <xsl:with-param name="param1" as="xs:string" select="$knowledge_process"/>
                   <xsl:with-param name="param2" as="xs:string" select="$math_operation"/>
                   <xsl:with-param name="param3" as="xs:string" select="$object"/>
               </xsl:call-template>
           </sentenceGroup>
           
         <xsl:comment>###############################</xsl:comment>
           <xsl:comment>10. Knowledge Processes with Math Operation Objects And Notations</xsl:comment>
           <xsl:comment>###############################</xsl:comment>
           <sentenceGroup xml:id="kpmon">
               <desc>Sentences describing knowledge processes with math operation objects and notations.</desc>
               <xsl:call-template name="sentenceWriter">
                   <xsl:with-param name="param1" as="xs:string" select="$knowledge_process"/>
                   <xsl:with-param name="param2" as="xs:string" select="$math_operation"/>
                   <xsl:with-param name="param3" as="xs:string" select="$object"/>
                   <xsl:with-param name="param4" as="xs:string" select="$notation"/>
               </xsl:call-template>
           </sentenceGroup>
           
          <xsl:comment>###############################</xsl:comment>
           <xsl:comment>11. Knowledge Processes with Specific Objects Alone</xsl:comment>
           <xsl:comment>###############################</xsl:comment>
           <sentenceGroup xml:id="kpso">
               <desc>Sentences describing knowledge processes with specific objects and without notations.</desc>
               <xsl:call-template name="sentenceWriter">
                   <xsl:with-param name="param1" as="xs:string" select="$knowledge_process"/>
                   <xsl:with-param name="param2" as="xs:string" select="$specific_object"/>
               </xsl:call-template>
           </sentenceGroup>
           
        <xsl:comment>###############################</xsl:comment>
           <xsl:comment>12. Knowledge Processes with Specific Objects and Notations</xsl:comment>
           <xsl:comment>###############################</xsl:comment>
           <sentenceGroup xml:id="kpson">
               <desc>Sentences describing knowledge processes with specific objects and notations.</desc>
               <xsl:call-template name="sentenceWriter">
                   <xsl:with-param name="param1" as="xs:string" select="$knowledge_process"/>
                   <xsl:with-param name="param2" as="xs:string" select="$specific_object"/>
                   <xsl:with-param name="param3" as="xs:string" select="$notation"/>
               </xsl:call-template>
           </sentenceGroup>
           
           <xsl:comment>###############################</xsl:comment>
           <xsl:comment>13. Whole Numbers Scope: Knowledge Processes and Subprocesses with Math Operation Objects and No Notations</xsl:comment>
           <xsl:comment>###############################</xsl:comment>
           <sentenceGroup xml:id="kpsmo">
               <desc>Sentences describing knowledge processes and subprocesses associated with the whole numbers scope, with math operation objects and without notations.</desc>
               <xsl:call-template name="sentenceWriter">
                   <xsl:with-param name="param1" as="xs:string" select="$knowledge_process"/>
                   <xsl:with-param name="param2" as="xs:string" select="$wholeNumKSP"/>
                   <xsl:with-param name="param3" as="xs:string" select="$math_operation"/>
                   <xsl:with-param name="param4" as="xs:string" select="$object"/>
               </xsl:call-template>
           </sentenceGroup>
           
              <xsl:comment>###############################</xsl:comment>
           <xsl:comment>14. Whole Numbers Scope: Knowledge Processes and Subprocesses with Math Operation Objects and Notations</xsl:comment>
           <xsl:comment>###############################</xsl:comment>
           <sentenceGroup xml:id="kpsmon">
               <desc>Sentences describing knowledge processes and subprocesses associated with the whole numbers scope, with math operation objects and notations.</desc>
               <xsl:call-template name="sentenceWriter">
                   <xsl:with-param name="param1" as="xs:string" select="$knowledge_process"/>
                   <xsl:with-param name="param2" as="xs:string" select="$wholeNumKSP"/>
                   <xsl:with-param name="param3" as="xs:string" select="$math_operation"/>
                   <xsl:with-param name="param4" as="xs:string" select="$object"/>
                   <xsl:with-param name="param5" as="xs:string" select="$notation"/>
               </xsl:call-template>
           </sentenceGroup>
         <xsl:comment>###############################</xsl:comment>
           <xsl:comment>15. Whole Numbers Scope: Knowledge Processes and Subprocesses with Specific Objects</xsl:comment>
           <xsl:comment>###############################</xsl:comment>
           <sentenceGroup xml:id="kpsso">
               <desc>Sentences describing knowledge processes and subprocesses associated with the whole numbers scope, with specific objects and without notations.</desc>
               <xsl:call-template name="sentenceWriter">
                   <xsl:with-param name="param1" as="xs:string" select="$knowledge_process"/>
                   <xsl:with-param name="param2" as="xs:string" select="$wholeNumKSP"/>
                   <xsl:with-param name="param3" as="xs:string" select="$specific_object"/>
               </xsl:call-template>
           </sentenceGroup>
              <xsl:comment>###############################</xsl:comment>
           <xsl:comment>16. Whole Numbers Scope: Knowledge Processes and Subprocesses with Specific Objects and Notations</xsl:comment>
           <xsl:comment>###############################</xsl:comment>
           <sentenceGroup xml:id="kpsson">
               <desc>Sentences describing knowledge processes and subprocesses associated with the whole numbers scope, with specific objects and with notations.</desc>
               <xsl:call-template name="sentenceWriter">
                   <xsl:with-param name="param1" as="xs:string" select="$knowledge_process"/>
                   <xsl:with-param name="param2" as="xs:string" select="$wholeNumKSP"/>
                   <xsl:with-param name="param3" as="xs:string" select="$specific_object"/>
                   <xsl:with-param name="param4" as="xs:string" select="$notation"/>
               </xsl:call-template>
           </sentenceGroup>  -->
       </xml>
   </xsl:template>  
</xsl:stylesheet>