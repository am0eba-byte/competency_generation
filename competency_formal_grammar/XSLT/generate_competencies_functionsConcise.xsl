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
 -->
    
    <xsl:output method="xml" indent="yes"/>
    
   <!--Named Template Call: (Was a function).
       I've switched to Named Templates after rewading Michael Kay on the subject: Named Templates are designed for outputting new elements, 
       which is what we're doing with the sentence constructions. Functions are preferred for XPath calculations that don't directly construct new trees.
       
  * ebb: Our sentenceWriter named template should be able to take be FOUR input parameters: two required, two optional.
  
   (a): (three params: two required, one optional: pulls from variable X, for-each over variable Y, add Z (notation) variable
         Examples: 
         MathOP + mathOPObject
         Knowledge Process + SpecOP
         specOP + notation: 
         Formal Process + MathOP + mathOPObject + Notation?
         Knowledge Process + SpecOP + Notation?
       
    (b) (four params: three required, one optional? OR just make this a possibility in function (a): s
    For expressing Scopes as Knowledge Subprocesses 
   
   Param 1 defines the outside wrapper element, and can be: 
        mathOp
        specOp
        formalProc
        knowledgeProc
        
   Param 2 can be:
        mathOp (if formal proc or knowledgeProc are param1)
        specOp (if formal proc or knowledgeProc are param1)
        mathOpObject
        notation (if specOp is param 1)
        wholeNumKSP (if knowlege subprocess present: this can ONLY be a param2)
   
   Param 3 can be:
      Any of these if used with SubProcess  
        mathOp (if knowlege subprocess present)
        specOp (if knowlege subprocess present)
        mathOpObject
        notation
        
   Param 4 can only be:
        notation
        
   THINKING: need to define input parameters as element names in order to construct the variables on the fly, since matching input param names to existing
   variables seems dodgy. Also, really, no need to define the variables globally anyway if we can do this within the named template. 
   -->
    
    
    
    <xsl:variable name="mathOp" as="xs:string+" select="//math_operation/string ! normalize-space()"/>
    <xsl:variable name="mathOpObject" as="xs:string+" select="//math_operation/object/string ! normalize-space()"/>
    <xsl:variable name="notation" as="xs:string+" select="//notation_object/string ! normalize-space()"/>
    <xsl:variable name="specOp" as="xs:string+" select="//specific_object/string ! normalize-space()"/>  
    <xsl:variable name="formalProc" as="xs:string+" select="//formal_process/string ! normalize-space()"/>
    <xsl:variable name="knowledgeProc" as="xs:string+" select="//knowledge_process/string ! normalize-space()"/>
    <xsl:variable name="wholeNumKSP" as="xs:string+" select="//knowledge_process/whole_numbers_knowledge_subprocess/string ! normalize-space()"/>   
    
    <xsl:template name="arj:sentenceWriter" as="element()+">
        <xsl:param name="param1" as="xs:string" required="yes"/>
        <xsl:param name="param2" as="xs:string?"/>
        <xsl:param name="param3" as="xs:string?"/>
        <xsl:param name="param4" as="xs:string?"/>
        <xsl:param name="param5" as="xs:string?"/>
       
       <xsl:variable name="allParams" select="($param1, $param2, $param3, $param4, $param5)" as="xs:string+"/>
  <!--ebb: Seems like we should be able to construct these variable names from a for-loop, but apparently not permitted due to how XSLT stylesheets
      get compiled and run. So we'll hard code it. -->
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
               <xsl:for-each select="$var3">
                   <xsl:variable name="currLevel3" as="xs:string?" select="current()"/>
                   <xsl:for-each select="$var4">
                       <xsl:variable name="currLevel4" as="xs:string?" select="current()"/>
                       <xsl:for-each select="$var5">
                           <componentSentence>
                               <xsl:element name="{$param1}">
                                   <xsl:sequence select="$currLevel1"/>
                               </xsl:element> 
                              <xsl:if test="$param2"> 
                                  <xsl:element name="{$param2}">
                                   <xsl:sequence select="$currLevel2"/>
                                  </xsl:element> 
                              </xsl:if>
                               <xsl:if test="$param3"><xsl:element name="{$param3}">
                                   <xsl:sequence select="$currLevel2"/>
                                  </xsl:element> 
                               </xsl:if>
                               <xsl:if test="$param4"><xsl:element name="{$param4}">
                                   <xsl:sequence select="$currLevel2"/>
                                   </xsl:element> 
                               </xsl:if>
                               <xsl:if test="$param5">
                                   <xsl:element name="{$param5}">
                                   <xsl:sequence select="$currLevel2"/>
                                   </xsl:element> 
                               </xsl:if>
                           </componentSentence>
                       </xsl:for-each>
                       </xsl:for-each>      
                </xsl:for-each>
        </xsl:for-each>
        </xsl:for-each>
      </xsl:template>
    
   
   <xsl:template match="/">
       <xml>
           <xsl:comment>###############################</xsl:comment>
           <xsl:comment>1. Math Operation Objects Without Notations</xsl:comment>
           <xsl:comment>###############################</xsl:comment>
      
         <sentenceGroup xml:id="mo">
             <desc>Sentences containing only math operation objects without notations.</desc>
            <!-- <xsl:for-each select="arj:mathOpConstructor()">
               <componentSentence>
                   <xsl:sequence select="current()"/>
               </componentSentence>
           </xsl:for-each>-->
             <xsl:call-template name="arj:sentenceWriter">
                 <xsl:with-param name="param1" as="xs:string" select="'math_operation'"/>
                 <xsl:with-param name="param2" as="xs:string" select="'object'"/>
             </xsl:call-template>
         </sentenceGroup>
          
           
    <!--       <xsl:comment>###############################</xsl:comment>
           <xsl:comment>2. Math Operation Objects With Notations</xsl:comment>
           <xsl:comment>###############################</xsl:comment>
          <sentenceGroup xml:id="mon"> 
              <desc>Sentences containing math operation objects with notations.</desc>
              <xsl:for-each select="arj:mathOpNoter()">
               <componentSentence>
                   <xsl:sequence select="current()"/>
               </componentSentence>
           </xsl:for-each>
           </sentenceGroup>
           
           <xsl:comment>###############################</xsl:comment>
           <xsl:comment>3. Specific Objects Without Notations</xsl:comment>
           <xsl:comment>###############################</xsl:comment>
           <sentenceGroup xml:id="so">
               <desc>Sentences describing only specific objects.</desc>
               <xsl:for-each select="$specOp">
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
               <xsl:for-each select="arj:specOpNoter()">
                   <componentSentence>
                       <xsl:sequence select="current()"/>
                   </componentSentence>
               </xsl:for-each> 
           </sentenceGroup>
          
           <xsl:comment>###############################</xsl:comment>
           <xsl:comment>5. Formal Processes with Math Objects and No Notations</xsl:comment>
           <xsl:comment>###############################</xsl:comment>
           <sentenceGroup xml:id="fpmo">
               <desc>Sentences describing formal processes with math operations.</desc>
               <xsl:for-each select="arj:formalProcMathOp()">
                   <componentSentence>
                       <xsl:sequence select="current()"/>
                   </componentSentence>
               </xsl:for-each>
           </sentenceGroup>
           
           <xsl:comment>###############################</xsl:comment>
           <xsl:comment>6. Formal Processes with Math Objects and Notations</xsl:comment>
           <xsl:comment>###############################</xsl:comment>
           <sentenceGroup xml:id="fpmon">
               <desc>Sentences describing formal processes with math operations including notations.</desc>
               <xsl:for-each select="arj:formalProcMathOpNoter()">
                   <componentSentence>
                       <xsl:sequence select="current()"/>
                   </componentSentence>
               </xsl:for-each>
           </sentenceGroup>
           
           <xsl:comment>###############################</xsl:comment>
           <xsl:comment>7. Formal Processes with Specific Objects and No Notations</xsl:comment>
           <xsl:comment>###############################</xsl:comment>
           <sentenceGroup xml:id="fpso">
               <desc>Sentences describing formal processes with specific objects alone.</desc>
               <xsl:for-each select="$formalProc">
                   <xsl:variable name="currFP" as="xs:string" select="current()"/>
                   <xsl:for-each select="$specOp">
                   <componentSentence>
                       <formalProc><xsl:sequence select="$currFP"/></formalProc>
                       <specificObject><xsl:sequence select="current()"/></specificObject>
                   </componentSentence>
               </xsl:for-each></xsl:for-each>
           </sentenceGroup>
           
           <xsl:comment>###############################</xsl:comment>
           <xsl:comment>8. Formal Processes with Specific Objects and Notations</xsl:comment>
           <xsl:comment>###############################</xsl:comment>
           <sentenceGroup xml:id="fpson">
               <desc>Sentences describing formal processs with specific objects and notations.</desc>
               <xsl:for-each select="arj:formalProcSpecNoter()">
                   <componentSentence>
                       <xsl:sequence select="current()"/>
                   </componentSentence>
               </xsl:for-each>
           </sentenceGroup>
           
           <xsl:comment>###############################</xsl:comment>
           <xsl:comment>9. Knowledge Processes with Math Operation Objects And No Notations</xsl:comment>
           <xsl:comment>###############################</xsl:comment>
           <sentenceGroup xml:id="kpmo">
               <desc>Sentences describing knowledge processes with math operation objects, without notations.</desc>
              <xsl:for-each select="arj:knowlMathOp()">
                  <componentSentence>
                      <xsl:sequence select="current()"/>
                  </componentSentence>
              </xsl:for-each> 
           </sentenceGroup>
           
           <xsl:comment>###############################</xsl:comment>
           <xsl:comment>10. Knowledge Processes with Math Operation Objects And Notations</xsl:comment>
           <xsl:comment>###############################</xsl:comment>
           <sentenceGroup xml:id="kpmon">
               <desc>Sentences describing knowledge processes with math operation objects, without notations.</desc>
               <xsl:for-each select="arj:knowlMathOpNoter()">
                   <componentSentence>
                       <xsl:sequence select="current()"/>
                   </componentSentence>
               </xsl:for-each> 
           </sentenceGroup>
           
           <xsl:comment>###############################</xsl:comment>
           <xsl:comment>11. Knowledge Processes with Specific Objects Alone</xsl:comment>
           <xsl:comment>###############################</xsl:comment>
           <sentenceGroup xml:id="kpso">
               <desc>Sentences describing knowledge processes with specific objects and without notations.</desc>
               <xsl:for-each select="arj:knowlSpecOp()">
                   <componentSentence>
                       <xsl:sequence select="current()"/>
                   </componentSentence>
               </xsl:for-each>  
           </sentenceGroup>
           
           <xsl:comment>###############################</xsl:comment>
           <xsl:comment>12. Knowledge Processes with Specific Objects and Notations</xsl:comment>
           <xsl:comment>###############################</xsl:comment>
           <sentenceGroup xml:id="kpson">
               <desc>Sentences describing knowledge processes with specific objects and without notations.</desc>
               <xsl:for-each select="arj:knowlSpecOpNoter()">
                   <componentSentence>
                       <xsl:sequence select="current()"/>
                   </componentSentence>
               </xsl:for-each>  
           </sentenceGroup>
           
           <xsl:comment>###############################</xsl:comment>
           <xsl:comment>13. Whole Numbers Scope: Knowledge Processes and Subprocesses with Math Operation Objects and No Notations</xsl:comment>
           <xsl:comment>###############################</xsl:comment>
           <sentenceGroup xml:id="kpson">
               <desc>Sentences describing knowledge processes and subprocesses associated with the whole numbers scope, with math operation objects and without notations.</desc>
               <xsl:for-each select="arj:subKnowlWholeNum()">
                   <xsl:variable name="skwn" select="current()" as="element()"/>
                   <xsl:for-each select="arj:mathOpConstructor()">
                   <componentSentence>
                       <xsl:sequence select="$skwn"/>
                       <xsl:sequence select="current()"/>
                   </componentSentence>
                   </xsl:for-each>
               </xsl:for-each>  
           </sentenceGroup>
           
           <xsl:comment>###############################</xsl:comment>
           <xsl:comment>14. Whole Numbers Scope: Knowledge Processes and Subprocesses with Math Operation Objects and Notations</xsl:comment>
           <xsl:comment>###############################</xsl:comment>
           <sentenceGroup xml:id="kpson">
               <desc>Sentences describing knowledge processes and subprocesses associated with the whole numbers scope, with math operation objects and notations.</desc>
               <xsl:for-each select="arj:subKnowlWholeNum()">
                   <xsl:variable name="skwn" select="current()" as="element()"/>
                   <xsl:for-each select="arj:mathOpNoter()">
                       <componentSentence>
                           <xsl:sequence select="$skwn"/>
                           <xsl:sequence select="current()"/>
                       </componentSentence>
                   </xsl:for-each>
               </xsl:for-each>  
           </sentenceGroup>
           <xsl:comment>###############################</xsl:comment>
           <xsl:comment>15. Whole Numbers Scope: Knowledge Processes and Subprocesses with Specific Objects</xsl:comment>
           <xsl:comment>###############################</xsl:comment>
           <sentenceGroup xml:id="kpson">
               <desc>Sentences describing knowledge processes and subprocesses associated with the whole numbers scope, with specific objects and without notations.</desc>
               <xsl:for-each select="arj:subKnowlWholeNum()">
                   <xsl:variable name="skwn" select="current()" as="element()"/>
                   <xsl:for-each select="$specOp">
                       <componentSentence>
                           <xsl:sequence select="$skwn"/>
                           <xsl:sequence select="current()"/>
                       </componentSentence>
                   </xsl:for-each>
               </xsl:for-each>  
           </sentenceGroup>
           <xsl:comment>###############################</xsl:comment>
           <xsl:comment>16. Whole Numbers Scope: Knowledge Processes and Subprocesses with Specific Objects and Notations</xsl:comment>
           <xsl:comment>###############################</xsl:comment>
           <sentenceGroup xml:id="kpson">
               <desc>Sentences describing knowledge processes and subprocesses associated with the whole numbers scope, with specific objects and with notations.</desc>
               <xsl:for-each select="arj:subKnowlWholeNum()">
                   <xsl:variable name="skwn" select="current()" as="element()"/>
                   <xsl:for-each select="arj:specOpNoter()">
                       <componentSentence>
                           <xsl:sequence select="$skwn"/>
                           <xsl:sequence select="current()"/>
                       </componentSentence>
                   </xsl:for-each>
               </xsl:for-each>  
           </sentenceGroup> -->
       </xml>
   </xsl:template>  
</xsl:stylesheet>