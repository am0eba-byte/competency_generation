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
      
 <xsl:variable name="mathOp" as="xs:string+" select="//math_operation/string ! normalize-space()"/>
 <xsl:variable name="mathOpObject" as="xs:string+" select="//math_operation/object/string ! normalize-space()"/>
 <xsl:variable name="notation" as="xs:string+" select="//notation_object/string ! normalize-space()"/>
 <xsl:variable name="specOp" as="xs:string+" select="//specific_object/string ! normalize-space()"/>  
 
 <xsl:variable name="formalProc" as="xs:string+" select="//formal_process/string ! normalize-space()"/>
 <xsl:variable name="knowledgeProc" as="xs:string+" select="//knowledge_process/string ! normalize-space()"/>
    
    <xsl:function name="arj:mathOpConstructor" as="element()+" >
        <xsl:for-each select="$mathOp">
            <xsl:variable name="currMO" as="xs:string" select="current()"/>
        <xsl:for-each select="$mathOpObject"> 
              <mathOP_object>
               <mathopString><xsl:value-of select="$currMO"/></mathopString>
                  <object><xsl:value-of select="current()"/></object>
           </mathOP_object>
        </xsl:for-each>
        </xsl:for-each>
    </xsl:function>
    
    <xsl:function name="arj:mathOpNoter" as="element()+" >
       <xsl:variable name="MOCoutput" as="element()+">
           <xsl:sequence select="arj:mathOpConstructor()"/>
       </xsl:variable>
        <xsl:for-each select="$MOCoutput">
            <xsl:variable name="currMOC" as="element()" select="current()"/>
            <xsl:for-each select="$notation">
                <mathOpNotation>
                    <xsl:sequence select="$currMOC"/>
                <notation><xsl:sequence select="current()"/></notation>
                </mathOpNotation>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:function>
    
    <xsl:function name="arj:specOpNoter" as="element()+">
        <xsl:for-each select="$specOp">
            <xsl:variable name="currSOP" as="xs:string" select="current()"/>
          <xsl:for-each select="$notation">  
              <specOpNotation>
                  <specificObject><xsl:sequence select="$currSOP"/></specificObject>
                  <notation><xsl:sequence select="current()"/></notation>
              </specOpNotation>
          </xsl:for-each>
        </xsl:for-each>
    </xsl:function>  
    <xsl:function name="arj:formalProcMathOp" as="element()+">
        <xsl:for-each select="$formalProc">
            <xsl:variable name="currFOP" as="xs:string" select="current()"/>
            <xsl:for-each select="arj:mathOpConstructor()">
                <formalProcMathOp>
                    <formalProc><xsl:sequence select="$currFOP"/></formalProc>
                    <xsl:sequence select="current()"/>
                </formalProcMathOp>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:function>
    <xsl:function name="arj:formalProcMathOpNoter" as="element()+">
        <xsl:for-each select="$formalProc">
            <xsl:variable name="currFOP" as="xs:string" select="current()"/>
            <xsl:for-each select="arj:mathOpNoter()">
                <formalProcMathOp>
                    <formalProc><xsl:sequence select="$currFOP"/></formalProc>
                    <xsl:sequence select="current()"/>
                </formalProcMathOp>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:function>
    <xsl:function name="arj:formalProcSpecNoter" as="element()+">
        <xsl:for-each select="$formalProc">
            <xsl:variable name="currF" as="xs:string" select="current()"/>
            <xsl:for-each select="arj:specOpNoter()">
                <formalProcSpecOp>
                    <formalProc><xsl:sequence select="$currF"/></formalProc>
                    <xsl:sequence select="current()"/>
                </formalProcSpecOp>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:function>
    <xsl:function name="arj:knowlMathOp" as="element()+">
        <xsl:for-each select="$knowledgeProc">
            <xsl:variable name="currKP" as="xs:string" select="current()"/>
            <xsl:for-each select="arj:mathOpConstructor()">
                <knowledgeProcMathOp>
                    <knowledgeProc><xsl:sequence select="$currKP"/></knowledgeProc>
                    <xsl:sequence select="current()"/>
                </knowledgeProcMathOp>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:function>
    <xsl:function name="arj:knowlMathOpNoter" as="element()+">
        <xsl:for-each select="$knowledgeProc">
            <xsl:variable name="currK" as="xs:string" select="current()"/>
            <xsl:for-each select="arj:mathOpNoter()">
                <knowledgeProcMathOp>
                    <knowledgeProc><xsl:sequence select="$currK"/></knowledgeProc>
                    <xsl:sequence select="current()"/>
                </knowledgeProcMathOp>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:function>
    <xsl:function name="arj:knowlSpecOp" as="element()+">
        <xsl:for-each select="$knowledgeProc">
            <xsl:variable name="currKO" as="xs:string" select="current()"/>
            <xsl:for-each select="$specOp">
                <knowledgeProcMathOp>
                    <knowledgeProc><xsl:sequence select="$currKO"/></knowledgeProc>
                    <specificObject><xsl:sequence select="current()"/></specificObject>
                </knowledgeProcMathOp>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:function>
    
   <xsl:template match="/">
       <xml>
           <xsl:comment>###############################</xsl:comment>
           <xsl:comment>1. Math Operation Objects Without Notations</xsl:comment>
           <xsl:comment>###############################</xsl:comment>
      
         <sentenceGroup xml:id="mo">
             <desc>Sentences containing only math operation objects without notations.</desc>
             <xsl:for-each select="arj:mathOpConstructor()">
               <componentSentence>
                   <xsl:sequence select="current()"/>
               </componentSentence>
           </xsl:for-each>
         </sentenceGroup>
          
           
           <xsl:comment>###############################</xsl:comment>
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
           
       </xml>
   </xsl:template> 
    

   
    
    
</xsl:stylesheet>