<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:arj="http://arjuna.bil.com"
    xmlns:saxon="http://saxon.sf.net/"
    exclude-result-prefixes="xs arj"
    version="3.0">
    
    <!-- Sentence flow from EBNF:
        modified_competency = 
        ( ([ formal_process ] | [ knowledge_process, [ “by” knowledge_subprocess ] ]), ((math_operation,  object) | specific_object ), [ notation_object ] ) | math_practice_competency ;
 -->
    
 <!--2021-12-04 ebb: GOAL: a human-readable and easily edited stylesheet. This reads an XML document that expresses competency relationships 
 in a simple tree structure, and outputs XML to mark the parts of a series of sentences organized in set combinations.
 Currently, any and all combinations are maximally generated, until we have set some indications of more exclusive combination rules. 
 
 METHOD: XSLT parameters and a single XSLT named template that processes a series of conditions depending on the 
 number of input parameters, goes and looks up the information from the source tree. 
 This XSLT generates, currently, 16 different kinds of sentence outputs based on 7 possible input parameters.
 
 -->
    
    <xsl:output method="xml" indent="yes"/>
 
    <xsl:key name="scopes" match="string" use="@class ! tokenize(., '\s+')"/>
 
 <!-- ebb: Here we have defined seven different global parameters that are just strings of text designed to match 
element names in the source document. Parameters are very similar to variables in XSLT, but have a little more flexibility. 
 -->
    
    <xsl:param name="math_operation" as="xs:string" select="'math_operation'"/>
    <xsl:param name="object" as="xs:string" select="'object'"/>
    <xsl:param name="notation" as="xs:string" select="'notation_object'"/>
    <xsl:param name="specific_object" as="xs:string" select="'specific_object'"/>
    <xsl:param name="formal_process" as="xs:string" select="'formal_process'"/>
    <xsl:param name="knowledge_process" as="xs:string" select="'knowledge_process'"/>
    
    <!-- mb: The below parameters include those that are specific to a particular scope's competency sentence possibilities. (More to come) -->
    <xsl:param name="wholeNumKSP" as="xs:string" select="'whole_numbers_knowledge_subprocess'"/>
    
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
        <xsl:param name="param1" as="xs:string" required="yes"/>
        <xsl:param name="param2" as="xs:string" required="yes"/>
        <xsl:param name="param3" as="xs:string?"/>
        <xsl:param name="param4" as="xs:string?"/>
        <xsl:param name="param5" as="xs:string?"/>
      
       <xsl:variable name="allParams" select="($param1, $param2, $param3, $param4, $param5)" as="xs:string+"/>
  <!--ebb: Seems like we should be able to construct these variable names from a for-loop, but apparently not permitted due to how XSLT stylesheets
      get compiled and run. So we'll "hard code" them (sigh). 
        <xsl:for-each select="($param1, $param2, $param3, $param4,$param5)">
           
           <xsl:variable name="variableName" as="xs:string">
               <xsl:sequence select="xs:QName(current())"/>
           </xsl:variable>
            
            <xsl:variable name="EQName(var{position()})" select="//*[name() = current()]/string ! normalize-space()"/>
            
        </xsl:for-each> -->
            
            
      <xsl:variable name="var1" as="xs:string+">
           <xsl:sequence select="//*[name() = $param1]/string ! normalize-space()"/>
      </xsl:variable>
        <xsl:variable name="var2" as="xs:string*">
            <xsl:sequence select="//*[name() = $param2]/string ! normalize-space()"/>
        </xsl:variable>
        <xsl:variable name="var3" as="xs:string*">
            <xsl:sequence select="//*[name() = $param3]/string ! normalize-space()"/>
        </xsl:variable>
        <xsl:variable name="var4" as="xs:string*">
            <xsl:sequence select="//*[name() = $param4]/string ! normalize-space()"/>
        </xsl:variable>
        <xsl:variable name="var5" as="xs:string*">
            <xsl:sequence select="//*[name() = $param5]/string ! normalize-space()"/>
        </xsl:variable>
        
        <xsl:for-each select="$var1">
            <xsl:variable name="currLevel1" as="xs:string" select="current()"/>
     
      <xsl:for-each select="$var2">
              <xsl:variable name="currLevel2" as="xs:string?" select="current()"/>
          
          <xsl:choose><!-- CHOICE 1 -->
          <xsl:when test="$param3">
          <xsl:for-each select="$var3">
                 <xsl:variable name="currLevel3" as="xs:string?" select="current()"/>
              <xsl:choose><!-- CHOICE 2 -->
                       <xsl:when test="$param4">
                       <xsl:for-each select="$var4">
                       <xsl:variable name="currLevel4" as="xs:string?" select="current()"/>
                      <xsl:choose><!-- CHOICE 3 -->
                          <xsl:when test="$param5">
                          <xsl:for-each select="$var5">
                           <componentSentence><!-- FIVE-PARAMETER SENTENCE -->
                               <xsl:element name="{$param1}">
                                   <xsl:sequence select="$currLevel1"/>
                               </xsl:element> 
                                  <xsl:element name="{$param2}">
                                   <xsl:sequence select="$currLevel2"/>
                                  </xsl:element> 
                               <xsl:element name="{$param3}">
                                   <xsl:sequence select="$currLevel3"/>
                               </xsl:element>
                               <xsl:element name="{$param4}">
                                   <xsl:sequence select="$currLevel4"/>
                               </xsl:element>
                               <xsl:element name="{$param5}">
                                   <xsl:sequence select="current()"/>
                               </xsl:element>
                           </componentSentence>
                       </xsl:for-each>
                      </xsl:when>
                         <xsl:otherwise><!-- FOUR-PARAMETER SENTENCE -->
                             <componentSentence>
                                 <xsl:element name="{$param1}">
                                     <xsl:sequence select="$currLevel1"/>
                                 </xsl:element> 
                                 <xsl:element name="{$param2}">
                                     <xsl:sequence select="$currLevel2"/>
                                 </xsl:element> 
                                 <xsl:element name="{$param3}">
                                     <xsl:sequence select="$currLevel3"/>
                                 </xsl:element> 
                                 <xsl:element name="{$param4}">
                                     <xsl:sequence select="$currLevel4"/>
                                 </xsl:element> 
                             </componentSentence>
                         </xsl:otherwise> 
                      </xsl:choose>
                       </xsl:for-each>      

                       </xsl:when>
                  <xsl:otherwise><!-- THREE-PARAMETER SENTENCE -->
                      <componentSentence>
                          <xsl:element name="{$param1}">
                              <xsl:sequence select="$currLevel1"/>
                          </xsl:element> 
                          <xsl:element name="{$param2}">
                              <xsl:sequence select="$currLevel2"/>
                          </xsl:element> 
                          <xsl:element name="{$param3}">
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
                      <xsl:element name="{$param1}">
                          <xsl:sequence select="$currLevel1"/>
                      </xsl:element> 
                      <xsl:element name="{$param2}">
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
       <xml>
           <xsl:comment>###############################</xsl:comment>
           <xsl:comment>TEST. Math Operation Objects Without Notations, SCOPED to Whole Numbers</xsl:comment>
           <xsl:comment>###############################</xsl:comment>
           <xsl:variable name="mathopWNS">
               <xsl:for-each select="key('scopes', 'wholenum')">
                   <xsl:sequence select=".[parent::* ! name() = $math_operation]"/>          
               </xsl:for-each>
           </xsl:variable>
           <xsl:variable name="objectWNS">
               <xsl:for-each select="key('scopes', 'wholenum')">
                   <xsl:sequence select=".[parent::* ! name() = $object]"/>          
               </xsl:for-each>
           </xsl:variable>
          
           
           <xsl:call-template name="sentenceWriter">
               <xsl:with-param name="param1" as="xs:string" select="$mathopWNS"/>
               <xsl:with-param name="param2" as="xs:string" select="$objectWNS"/>
           </xsl:call-template>
           
           
         <xsl:comment>###############################</xsl:comment>
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
                  <xsl:with-param name="param1" as="xs:string" select="$math_operation"/>
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
           </sentenceGroup> 
       </xml>
   </xsl:template>  
</xsl:stylesheet>