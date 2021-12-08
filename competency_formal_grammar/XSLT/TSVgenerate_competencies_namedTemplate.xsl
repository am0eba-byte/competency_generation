<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:arj="http://arjuna.bil.com"
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
    
   <!-- <xsl:output method="text" indent="yes"/>-->
 
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
    
    <!-- mb: This parameter attempts to capture the insert element within a string which wraps a list of possibilities which can occur within one string in a competency component. -->
    <!--<xsl:param name="insert" as="xs:string" select="'insert'"/>-->
    
    
<!--ebb: Here is our XSLT Named Template that handles the sentence construction: I've set this so we expect at least 
    two required input parameters. The rest are optional. 
    The input parameters are just strings that line up with the element names in the XML source document.
    In the function, we first generate a series of five variables based on the five possible input parameters. 
    Then we construct a series of nested for-each loops. I wonder if we can refine this, but it works to output 
    single sentence components together at the deepest available level. 
    So, if only two parameters are sent, the function outputs a "sentence" consisting of two elements. 
    And if five parameters are sentence, the function outputs a "sentence" of five elements.
    -->
    <xsl:template name="arj:sentenceWriter" as="xs:string+">
        <xsl:param name="param1" as="xs:string" required="yes"/>
        <xsl:param name="param2" as="xs:string" required="yes"/>
        <xsl:param name="param3" as="xs:string?"/>
        <xsl:param name="param4" as="xs:string?"/>
        <xsl:param name="param5" as="xs:string?"/>
        <!--<xsl:param name="insert" as="xs:string"/>-->
      <!-- mb: question for Dr. B: how does XSLT know which parameters to apply here? -->
      
       <xsl:variable name="allParams" select="($param1, $param2, $param3, $param4, $param5)" as="xs:string+"/>
  <!--ebb: Seems like we should be able to construct these variable names from a for-loop, but apparently not permitted due to how XSLT stylesheets
      get compiled and run. So we'll "hard code" them (sigh). -->
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
        
        <!-- hopefully the below variable captures the strings in insert -->
       <!-- <xsl:variable name="var6" as="xs:string*">
            <xsl:sequence select="//string[./name() = $insert]//string ! normalize-space()"/>
        </xsl:variable>-->
        
       
        
        
        <!-- MB: QUESTION: why are there optional as=xs:strings in every variable except the first?-->
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
                           <!-- FIVE-PARAMETER SENTENCE -->
                           
                           <!-- WITH PARAM COMPONENT NAMES -->
                             <!-- <xsl:sequence select="concat($param1, '&#x9;', $currLevel1, '&#x9;', $param2, '&#x9;', $currLevel2, '&#x9;', $param3, '&#x9;', $currLevel3, '&#x9;', $param4, '&#x9;', $currLevel4, '&#x9;', $param5, '&#x9;', current(), '&#10;')"/>-->
                              
                              <!-- WITHOUT PARAM COMPONENT NAMES -->
                              <xsl:sequence select="concat( $currLevel1, '&#x9;', $currLevel2,  '&#x9;', $currLevel3, '&#x9;', $currLevel4, '&#x9;', current(), '&#10;')"/>
                              
                              
                                  <!-- MB: I put current() instead of currLevel5 because that is what was selected in the param5 sequence in the original generation code: -->
                              
                              <!-- <xsl:element name="{$param5}">
                                   <xsl:sequence select="current()"/>
                               </xsl:element>-->
                           
                       </xsl:for-each>
                      </xsl:when>
                         <xsl:otherwise><!-- FOUR-PARAMETER SENTENCE -->
                             
                             <!-- WITH PARAM COMPONENT NAMES -->
                    <!--         <xsl:sequence select="concat($param1, '&#x9;', $currLevel1, '&#x9;', $param2, '&#x9;', $currLevel2, '&#x9;', $param3, '&#x9;', $currLevel3, '&#x9;', $param4, '&#x9;', $currLevel4, '&#10;')"/>-->
                             
                             <!-- WITHOUT PARAM COMPONENT NAMES -->
                             <xsl:sequence select="concat($currLevel1, '&#x9;', $currLevel2, '&#x9;', $currLevel3, '&#x9;', $currLevel4, '&#10;')"/>
                             
                         </xsl:otherwise> 
                      </xsl:choose>
                       </xsl:for-each>      

                       </xsl:when>
                  <xsl:otherwise><!-- THREE-PARAMETER SENTENCE -->
                      
                      <!-- WITH PARAM COMPONENT NAMES -->
                      <!--<xsl:sequence select="concat($param1, '&#x9;', $currLevel1, '&#x9;', $param2, '&#x9;', $currLevel2, '&#x9;', $param3, '&#x9;', $currLevel3, '&#10;')"/>-->
                      
                      <!-- WITHOUT PARAM COMPONENT NAMES -->
                      <xsl:sequence select="concat( $currLevel1, '&#x9;',  $currLevel2, '&#x9;', $currLevel3, '&#10;')"/>
                     
                  </xsl:otherwise>
              </xsl:choose>
           </xsl:for-each>
          </xsl:when>
              <xsl:otherwise>
                  <!--TWO-PARAMETER SENTENCE -->
                  
                  <!-- WITH PARAM COMPONENT NAMES -->
                  <!--<xsl:sequence select="concat($param1, '&#x9;', $currLevel1, '&#x9;', $param2, '&#x9;', $currLevel2, '&#10;')"/>-->
                  
                  <!-- WITHOUT PARAM COMPONENT NAMES  -->
                  <xsl:sequence select="concat($currLevel1, '&#x9;', $currLevel2, '&#10;')"/>
                  
              </xsl:otherwise>
          </xsl:choose>
            
        </xsl:for-each>
        </xsl:for-each>
      </xsl:template>
    
 <!--ebb: Here is a template matching on the source document node and set to output a new XML file that groups 
     16 different kinds of sentences. We use <xsl:call-templates> to invoke a named template, and inside, we deliver
     what parameters we need to construct a sentence. We pull these from the global parameters defined at the top of this
     XSLT document. 
 -->  
   <xsl:template match="/">
       <!--<xml>-->
       
       <xsl:sequence select="concat('###############################', '&#10;', '2. Math Operation Objects Without Notations', '&#10;', '###############################', '&#10;')"/>
       
      
       <!-- Sentences containing math operation objects without notations. -->
       <xsl:result-document method="text" href="output/mo.tsv">
       <!--  <sentenceGroup xml:id="mo">-->
             
  
             <xsl:call-template name="arj:sentenceWriter">
                 <xsl:with-param name="param1" as="xs:string" select="$math_operation"/>
                 <xsl:with-param name="param2" as="xs:string" select="$object"/>
             </xsl:call-template>
         <!--</sentenceGroup>-->
          </xsl:result-document>
           
           <xsl:sequence select="concat('###############################', '&#10;', '2. Math Operation Objects With Notations', '&#10;', '###############################', '&#10;')"/>
           
       <!-- Sentences containing math operation objects with notations. -->
       <xsl:result-document method="text" href="output/mon.tsv">
          <!--<sentenceGroup xml:id="mon"> -->
              
              <xsl:call-template name="arj:sentenceWriter">
                  <xsl:with-param name="param1" as="xs:string" select="$math_operation"/>
                  <xsl:with-param name="param2" as="xs:string" select="$object"/>
                  <xsl:with-param name="param3" as="xs:string" select="$notation"/>
              </xsl:call-template>
           <!--</sentenceGroup>-->
           </xsl:result-document>
           
           <xsl:sequence select="concat('###############################', '&#10;', '3. Specific Objects Without Notations', '&#10;', '###############################', '&#10;')"/>
             
       <!-- Sentences describing specific objects alone. -->
       <xsl:result-document method="text" href="output/so.tsv"> 
           <!--<sentenceGroup xml:id="so">-->
           <!-- ebb: ??? should this really be considered a complete sentence on its own?  mb: yes indeedy-->
           <!--    <desc>Sentences describing only specific objects. Since this sentence only contains a single utterance, we question
               whether it counts as a complete sentence in the competency grammar.</desc>-->
               <xsl:for-each select="//specific_object/string ! normalize-space()">
                   
                   <xsl:sequence select="concat('specificObject', '&#x9;', current(), '&#10;')"/>
                   
                  <!-- <componentSentence>
                       <specificObject><xsl:sequence select="current()"/></specificObject>
                   </componentSentence>-->
               </xsl:for-each>
           <!--</sentenceGroup>-->
           </xsl:result-document>
           
           
       <xsl:sequence select="concat('###############################', '&#10;', '3. Specific Objects With Notations', '&#10;', '###############################', '&#10;')"/>
      
       <!-- Sentences describing specific objects and notations. -->
       <xsl:result-document method="text" href="output/son.tsv">
          <!-- <sentenceGroup xml:id="son">-->
              
               <xsl:call-template name="arj:sentenceWriter">
                   <xsl:with-param name="param1" as="xs:string" select="$specific_object"/>
                   <xsl:with-param name="param2" as="xs:string" select="$notation"/>
               </xsl:call-template>
           <!--</sentenceGroup>-->
          
          </xsl:result-document>
       <xsl:sequence select="concat('###############################', '&#10;', '5. Formal Processes with Math Objects and No Notations', '&#10;', '###############################', '&#10;')"/>
          
         
       <!-- Sentences describing formal processes with math operations, and without notations. -->
       
          <xsl:result-document method="text" href="output/fpmo.tsv"> <!--<sentenceGroup xml:id="fpmo">-->
               
               <xsl:call-template name="arj:sentenceWriter">
                   <xsl:with-param name="param1" as="xs:string" select="$formal_process"/>
                   <xsl:with-param name="param2" as="xs:string" select="$math_operation"/>
                   <xsl:with-param name="param3" as="xs:string" select="$object"/>
               </xsl:call-template>
          <!-- </sentenceGroup>-->
          </xsl:result-document>
           
           
       <xsl:sequence select="concat('###############################', '&#10;', '6. Formal Processes with Math Objects and Notations', '&#10;', '###############################', '&#10;')"/>
           
       <!-- Sentences describing formal processes with math operations including notations. -->
          
       <xsl:result-document method="text" href="output/fpmon.tsv">
              <!--<sentenceGroup xml:id="fpmon">-->
              
               <xsl:call-template name="arj:sentenceWriter">
                   <xsl:with-param name="param1" as="xs:string" select="$formal_process"/>
                   <xsl:with-param name="param2" as="xs:string" select="$math_operation"/>
                   <xsl:with-param name="param3" as="xs:string" select="$object"/>
                   <xsl:with-param name="param4" as="xs:string" select="$notation"/>
               </xsl:call-template>
           <!--</sentenceGroup>-->
          </xsl:result-document>
           
           
       <xsl:sequence select="concat('###############################', '&#10;', '7. Formal Processes with Specific Objects and No Notations', '&#10;', '###############################', '&#10;')"/>
              
       <!-- Sentences describing formal processes with specific objects alone. -->
       <xsl:result-document method="text" href="output/fpso.tsv">
              <!--<sentenceGroup xml:id="fpso">-->
               
               <xsl:call-template name="arj:sentenceWriter">
                   <xsl:with-param name="param1" as="xs:string" select="$formal_process"/>
                   <xsl:with-param name="param2" as="xs:string" select="$specific_object"/>
               </xsl:call-template>
           <!--</sentenceGroup>-->
          </xsl:result-document>
           
           
       <xsl:sequence select="concat('###############################', '&#10;', '8. Formal Processes with Specific Objects and Notations', '&#10;', '###############################', '&#10;')"/>
       
       
       <!-- Sentences describing formal processs with specific objects and notations. -->
       <xsl:result-document method="text" href="output/fpson.tsv"> 
              <!--<sentenceGroup xml:id="fpson">-->
               
               <xsl:call-template name="arj:sentenceWriter">
                   <xsl:with-param name="param1" as="xs:string" select="$formal_process"/>
                   <xsl:with-param name="param2" as="xs:string" select="$specific_object"/>
                   <xsl:with-param name="param3" as="xs:string" select="$notation"/>
               </xsl:call-template>
           <!--</sentenceGroup>-->
          </xsl:result-document>
           
           
       <xsl:sequence select="concat('###############################', '&#10;', '9. Knowledge Processes with Math Operation Objects And No Notations', '&#10;', '###############################', '&#10;')"/>
       <!--  Sentences describing knowledge processes with math operation objects, without notations. -->
       
       <xsl:result-document  method="text" href="output/kpmo.tsv">
              <!-- <sentenceGroup xml:id="kpmo">-->
             
               <xsl:call-template name="arj:sentenceWriter">
                   <xsl:with-param name="param1" as="xs:string" select="$knowledge_process"/>
                   <xsl:with-param name="param2" as="xs:string" select="$math_operation"/>
                   <xsl:with-param name="param3" as="xs:string" select="$object"/>
               </xsl:call-template>
           <!--</sentenceGroup>-->
           </xsl:result-document>
           
           
       <xsl:sequence select="concat('###############################', '&#10;', '10. Knowledge Processes with Math Operation Objects And Notations', '&#10;', '###############################', '&#10;')"/>
       <!--  Sentences describing knowledge processes with math operation objects and notations. -->
       <xsl:result-document method="text" href="output/kpmon.tsv"> 
             <!--<sentenceGroup xml:id="kpmon">-->
              
               <xsl:call-template name="arj:sentenceWriter">
                   <xsl:with-param name="param1" as="xs:string" select="$knowledge_process"/>
                   <xsl:with-param name="param2" as="xs:string" select="$math_operation"/>
                   <xsl:with-param name="param3" as="xs:string" select="$object"/>
                   <xsl:with-param name="param4" as="xs:string" select="$notation"/>
               </xsl:call-template>
           <!--</sentenceGroup>-->
         </xsl:result-document>
           
           
       <xsl:sequence select="concat('###############################', '&#10;', '11. Knowledge Processes with Specific Objects Alone', '&#10;', '###############################', '&#10;')"/>
       <!--  Sentences describing knowledge processes with specific objects and without notations. -->
       <xsl:result-document method="text" href="output/kpso.tsv">
              <!-- <sentenceGroup xml:id="kpso">-->
              
               <xsl:call-template name="arj:sentenceWriter">
                   <xsl:with-param name="param1" as="xs:string" select="$knowledge_process"/>
                   <xsl:with-param name="param2" as="xs:string" select="$specific_object"/>
               </xsl:call-template>
           <!--</sentenceGroup>-->
           </xsl:result-document>
           
           
       <xsl:sequence select="concat('###############################', '&#10;', '12. Knowledge Processes with Specific Objects and Notations', '&#10;', '###############################', '&#10;')"/>
       <!-- Sentences describing knowledge processes with specific objects and notations. -->
       <xsl:result-document method="text" href="output/kpson.tsv"> 
              <!--<sentenceGroup xml:id="kpson">-->
               
               <xsl:call-template name="arj:sentenceWriter">
                   <xsl:with-param name="param1" as="xs:string" select="$knowledge_process"/>
                   <xsl:with-param name="param2" as="xs:string" select="$specific_object"/>
                   <xsl:with-param name="param3" as="xs:string" select="$notation"/>
               </xsl:call-template>
           <!--</sentenceGroup>-->
          </xsl:result-document>
           
           
       <xsl:sequence select="concat('###############################', '&#10;', '13. Whole Numbers Scope: Knowledge Processes and Subprocesses with Math Operation Objects and No Notations', '&#10;', '###############################', '&#10;')"/>
       <!-- Sentences describing knowledge processes and subprocesses associated with the whole numbers scope, with math operation objects and without notations. -->
       <xsl:result-document method="text" href="output/kpkspmoo.tsv">
               <!--<sentenceGroup xml:id="kpson">-->
              
               <xsl:call-template name="arj:sentenceWriter">
                   <xsl:with-param name="param1" as="xs:string" select="$knowledge_process"/>
                   <xsl:with-param name="param2" as="xs:string" select="$wholeNumKSP"/>
                   <xsl:with-param name="param3" as="xs:string" select="$math_operation"/>
                   <xsl:with-param name="param4" as="xs:string" select="$object"/>
               </xsl:call-template>
           <!--</sentenceGroup>-->
           </xsl:result-document>
           
           
       <xsl:sequence select="concat('###############################', '&#10;', '14. Whole Numbers Scope: Knowledge Processes and Subprocesses with Math Operation Objects and Notations', '&#10;', '###############################', '&#10;')"/>
       <!-- Sentences describing knowledge processes and subprocesses associated with the whole numbers scope, with math operation objects and notations. -->
       <xsl:result-document method="text" href="output/kpkspmoon.tsv">
               <sentenceGroup xml:id="kpkspmoon">
               
               <xsl:call-template name="arj:sentenceWriter">
                   <xsl:with-param name="param1" as="xs:string" select="$knowledge_process"/>
                   <xsl:with-param name="param2" as="xs:string" select="$wholeNumKSP"/>
                   <xsl:with-param name="param3" as="xs:string" select="$math_operation"/>
                   <xsl:with-param name="param4" as="xs:string" select="$object"/>
                   <xsl:with-param name="param5" as="xs:string" select="$notation"/>
               </xsl:call-template>
           </sentenceGroup>
           </xsl:result-document>
       
       
       <xsl:sequence select="concat('###############################', '&#10;', '15. Whole Numbers Scope: Knowledge Processes and Subprocesses with Specific Objects', '&#10;', '###############################', '&#10;')"/>
       <!-- Sentences describing knowledge processes and subprocesses associated with the whole numbers scope, with specific objects and without notations. -->
       <xsl:result-document method="text" href="output/kpkspso.tsv">
              <!-- <sentenceGroup xml:id="kpson">-->
               
               <xsl:call-template name="arj:sentenceWriter">
                   <xsl:with-param name="param1" as="xs:string" select="$knowledge_process"/>
                   <xsl:with-param name="param2" as="xs:string" select="$wholeNumKSP"/>
                   <xsl:with-param name="param3" as="xs:string" select="$specific_object"/>
               </xsl:call-template>
           <!--</sentenceGroup>-->
           </xsl:result-document>
       
       
       <xsl:sequence select="concat('###############################', '&#10;', '16. Whole Numbers Scope: Knowledge Processes and Subprocesses with Specific Objects and Notations', '&#10;', '###############################', '&#10;')"/>
       <!-- Sentences describing knowledge processes and subprocesses associated with the whole numbers scope, with specific objects and with notations. -->
       <xsl:result-document method="text" href="output/kpkspson.tsv">
              <!--<sentenceGroup xml:id="kpson">-->
               
               <xsl:call-template name="arj:sentenceWriter">
                   <xsl:with-param name="param1" as="xs:string" select="$knowledge_process"/>
                   <xsl:with-param name="param2" as="xs:string" select="$wholeNumKSP"/>
                   <xsl:with-param name="param3" as="xs:string" select="$specific_object"/>
                   <xsl:with-param name="param4" as="xs:string" select="$notation"/>
               </xsl:call-template>
           <!--</sentenceGroup>--> 
          </xsl:result-document>
       <!--</xml>-->
   </xsl:template>  
</xsl:stylesheet>