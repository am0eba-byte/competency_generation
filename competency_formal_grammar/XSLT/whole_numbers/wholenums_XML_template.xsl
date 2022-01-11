<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:arj="http://arjuna.bil.com"
    xmlns:saxon="http://saxon.sf.net/"
    exclude-result-prefixes="xs arj"
    version="3.0">
    
 
 <!--
 METHOD: XSLT parameters and a single XSLT named template that processes a series of conditions depending on the 
 number of input parameters, goes and looks up the information from the source tree. 
 This XSLT generates, currently, 8 different kinds of whole numbers scope sentence outputs based on 7 possible input parameters.
 -->
    
    <xsl:output method="xml" indent="yes"/>
 
 
    <!-- SCOPE KEY -->
    <xsl:key name="scopes" match="string" use="@class ! tokenize(., '\s+')"/>
    <!-- WHOLE NUMBERS SCOPE PARAM -->
    <xsl:param name="wholenum" as="xs:string" select="'wholenum'"/>
    
    <!-- NOTATION STRING KEY -->
    <xsl:key name="notationKey" match="string" use="@subclass ! normalize-space()"/>
    <!-- SUBCLASS NOTATION PARAMS -->
    <xsl:param name="notation" as="xs:string" select="'notation'"/>
    <xsl:param name="noNot" as="xs:string" select="'noNot'"/>
    
 
 <!-- GLOBAL COMPONENT PARAMETERS -->
    
    
    <xsl:param name="formal_process" as="xs:string" select="'formalProcess'"/>
    <xsl:param name="knowledge_process" as="xs:string" select="'knowledgeProcess'"/>
    <xsl:param name="knowledge_subprocess" as="xs:string" select="'knowledgeSubprocess'"/>
    <xsl:param name="processPred" as="xs:string" select="'processPred'"/>
    <xsl:param name="math_operation" as="xs:string" select="'mathOperation'"/>
    <xsl:param name="object" as="xs:string" select="'quant'"/>
    <xsl:param name="notationObject" as="xs:string" select="'notationObject'"/>
    
   

    <xsl:template name="sentenceWriter" as="element()+">
        <xsl:param name="param1" as="element()+" required="yes"/>
        <xsl:param name="param2" as="element()+" required="yes"/>
        <xsl:param name="param3" as="element()*"/>
        <xsl:param name="param4" as="element()*"/>
        <xsl:param name="scopeParam" as="xs:string?"/>
       
       
        <xsl:variable name="var1" as="xs:string+" select="$param1/parent::* ! name()"/>
        <xsl:variable name="var2" as="xs:string+" select="$param2/parent::* ! name()"/>
        <xsl:variable name="var3" as="xs:string*" select="$param3/parent::* ! name()"/>
        <xsl:variable name="var4" as="xs:string*" select="$param4/parent::* ! name()"/>
     
        
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
                                        <!-- FOUR-PARAMETER SENTENCE -->
                                       <xsl:choose> <xsl:when test="$scopeParam">
                                           <xsl:for-each select="$scopeParam">
                                            <xsl:variable name="scopeInsert" as="xs:string" select="current()"/>
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
                                                    <xsl:element name="scopeName">
                                                        <xsl:sequence select="concat('involving ', $scopeInsert)"/>
                                                    </xsl:element>
                                                </componentSentence>
                                        </xsl:for-each>
                                       </xsl:when>
                                           <xsl:otherwise>
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
                                   <xsl:choose>
                                      <xsl:when test="$scopeParam">
                                          <xsl:for-each select="$scopeParam">
                                        <xsl:variable name="scopeInsert" as="xs:string" select="current()"/>
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
                                        <xsl:element name="scopeName">
                                            <xsl:sequence select="concat('involving ', $scopeInsert)"/>
                                        </xsl:element>
                                    </componentSentence>
                                    </xsl:for-each>
                                      </xsl:when>
                                       <xsl:otherwise>
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
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <!--TWO-PARAMETER SENTENCE -->
                        <xsl:for-each select="$scopeParam">
                            <xsl:variable name="scopeInsert" as="xs:string" select="current()"/>
                        <componentSentence>
                            <xsl:element name="{$var1}">
                                <xsl:sequence select="$currLevel1"/>
                            </xsl:element> 
                            <xsl:element name="{$var2}">
                                <xsl:sequence select="$currLevel2"/>
                            </xsl:element> 
                            <xsl:element name="scopeName">
                                <xsl:sequence select="concat('involving ', $scopeInsert)"/>
                            </xsl:element>
                        </componentSentence>
                        </xsl:for-each>
                    </xsl:otherwise>
                </xsl:choose>
                
            </xsl:for-each>
        </xsl:for-each>
      </xsl:template>
    
    <!--ebb: In the xsl:template rule below, we set up each kind of sentence combination we want. 
        This is a template matching on the source document node and set to output a new XML file
        that groups different kinds of sentences. 
       
     We use <xsl:call-templates> to invoke a named template, and inside, we deliver
     what parameters we need to construct a sentence. We pull these from the global parameters 
     defined at the top of this XSLT document. 
 -->  
   <xsl:template match="/">
       <xml>
           
  <!-- ********************FORMAL PROCESS BRANCH************************** -->
           
   <!-- **************** WITH NOTATIONS ************************* -->
           <xsl:comment>###############################</xsl:comment>
           <xsl:comment>Formal Process (Keyed Notation Substrings) + Process Pred + Notation Object</xsl:comment>
           <xsl:comment>###############################</xsl:comment>
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
          
           
<sentenceGroup xml:id="fp-prPred-n">
           <xsl:call-template name="sentenceWriter">
               <xsl:with-param name="param1"  as="element()+" select="$FP_notation"/>
               <xsl:with-param name="param2" as="element()+" select="$PrPred"/>
               <xsl:with-param name="param3" as="element()+" select="$NO"/>
               
           </xsl:call-template>
           </sentenceGroup>
           
         <xsl:comment>###############################</xsl:comment>
           <xsl:comment>Formal Process (Keyed Notation Substrings) + Math Operation + Quant Object + Notation Object</xsl:comment>
           <xsl:comment>###############################</xsl:comment>
           <xsl:variable name="FP_notation" as="element()+">
               <xsl:for-each select="key('notationKey', $notation)">
                   <xsl:sequence select=".[parent::* ! name() = $formal_process]"/>          
               </xsl:for-each>
           </xsl:variable>
           <xsl:variable name="MathOp" as="element()+">
               <xsl:for-each select="key('scopes', $wholenum)">
                   <xsl:sequence select=".[parent::* ! name() = $math_operation]"/>
               </xsl:for-each>
           </xsl:variable>
           <xsl:variable name="QO" as="element()+">
               <xsl:for-each select="key('scopes', $wholenum)">
                   <xsl:sequence select=".[parent::* ! name() = $object]"/>
               </xsl:for-each>
           </xsl:variable>
           <xsl:variable name="NO" as="element()+">
               <xsl:for-each select="key('scopes', $wholenum)">
                   <xsl:sequence select=".[parent::* ! name() = $notationObject]"/>
               </xsl:for-each>
           </xsl:variable>
           <sentenceGroup xml:id="fp-mathOp-n">
             <xsl:call-template name="sentenceWriter">
                 <xsl:with-param name="param1" as="element()+" select="$FP_notation"/>
                 <xsl:with-param name="param2" as="element()+" select="$MathOp"/>
                 <xsl:with-param name="param3" as="element()+" select="$QO"/>
                 <xsl:with-param name="param4" as="element()+" select="$NO"/>
             </xsl:call-template>
         </sentenceGroup>
           
<!-- ******************** WITHOUT NOTATIONS ************************ -->
           <xsl:comment>###############################</xsl:comment>
           <xsl:comment>Formal Process(keyed to NoNot subclass) + Process Pred </xsl:comment>
           <xsl:comment>###############################</xsl:comment>
           <xsl:variable name="FP_noNot" as="element()+">
               <xsl:for-each select="key('notationKey', $noNot)">
                   <xsl:sequence select=".[parent::* ! name() = $formal_process]"/>          
               </xsl:for-each>
           </xsl:variable>
           <xsl:variable name="PrPred" as="element()+">
               <xsl:for-each select="key('scopes', $wholenum)">
                   <xsl:sequence select=".[parent::* ! name() = $processPred]"/>
               </xsl:for-each>
           </xsl:variable>
           <xsl:variable name="wholenumScopeString" select="'Whole Numbers'"/>
           
           <!-- ADD "involving Whole Numbers [subscope]" STRING -->
           <sentenceGroup xml:id="fp-prPred">
               <xsl:call-template name="sentenceWriter">
                   <xsl:with-param name="param1" as="element()+" select="$FP_noNot"/>
                   <xsl:with-param name="param2" as="element()+" select="$PrPred"/>
                   <xsl:with-param name="scopeParam" as="xs:string" select="$wholenumScopeString"/>
               </xsl:call-template>
           </sentenceGroup>
           
           <xsl:comment>###############################</xsl:comment>
           <xsl:comment>Formal Process(keyed to NoNot subclass) + Math Operation + Quant Object </xsl:comment>
           <xsl:comment>###############################</xsl:comment>
           <xsl:variable name="FP_noNotation" as="element()+">
               <xsl:for-each select="key('notationKey', $noNot)">
                   <xsl:sequence select=".[parent::* ! name() = $formal_process]"/>          
               </xsl:for-each>
           </xsl:variable>
           <xsl:variable name="MathOp" as="element()+">
               <xsl:for-each select="key('scopes', $wholenum)">
                   <xsl:sequence select=".[parent::* ! name() = $math_operation]"/>
               </xsl:for-each>
           </xsl:variable>
           <xsl:variable name="QO" as="element()+">
               <xsl:for-each select="key('scopes', $wholenum)">
                   <xsl:sequence select=".[parent::* ! name() = $object]"/>
               </xsl:for-each>
           </xsl:variable>
           <xsl:variable name="wholenumScopeString" select="'Whole Numbers'"/>
           
           <!-- ADD "involving Whole Numbers [subscope]" STRING -->
           <sentenceGroup xml:id="fp-mathOp">
               <xsl:call-template name="sentenceWriter">
                   <xsl:with-param name="param1" as="element()+" select="$FP_noNot"/>
                   <xsl:with-param name="param2" as="element()+" select="$MathOp"/>
                   <xsl:with-param name="param3" as="element()+" select="$QO"/>
                   <xsl:with-param name="scopeParam" as="xs:string" select="$wholenumScopeString"/>
               </xsl:call-template>
           </sentenceGroup>
        
           
           
           
   <!-- ************* KNOWLEDGE PROCESS BRANCH ************************************************* -->
           
   <!-- ***************** WITHOUT SUBPROCESS ************************************************* -->
           <xsl:comment>###############################</xsl:comment>
           <xsl:comment>Knowledge Process + Math Operation + Quant Object</xsl:comment>
           <xsl:comment>###############################</xsl:comment>
           <xsl:variable name="KP" as="element()+">
               <xsl:for-each select="key('scopes', $wholenum)">
                   <xsl:sequence select=".[parent::* ! name() = $knowledge_process]"/>
               </xsl:for-each>
           </xsl:variable>
           <xsl:variable name="MathOp" as="element()+">
               <xsl:for-each select="key('scopes', $wholenum)">
                   <xsl:sequence select=".[parent::* ! name() = $math_operation]"/>
               </xsl:for-each>
           </xsl:variable>
           <xsl:variable name="QO" as="element()+">
               <xsl:for-each select="key('scopes', $wholenum)">
                   <xsl:sequence select=".[parent::* ! name() = $object]"/>
               </xsl:for-each>
           </xsl:variable>
           <xsl:variable name="wholenumScopeString" select="'Whole Numbers'"/>
           
           <!-- ADD "involving Whole Numbers [subscope]" STRING -->
           <sentenceGroup xml:id="kp-mathOp">
              <xsl:call-template name="sentenceWriter">
                  <xsl:with-param name="param1" as="element()+" select="$KP"/>
                  <xsl:with-param name="param2" as="element()+" select="$MathOp"/>
                  <xsl:with-param name="param3" as="element()+" select="$QO"/>
                  <xsl:with-param name="scopeParam" as="xs:string" select="$wholenumScopeString"/>
               </xsl:call-template>
           </sentenceGroup>
           
         <xsl:comment>###############################</xsl:comment>
           <xsl:comment>Knowledge Processes + Process Pred</xsl:comment>
           <xsl:comment>###############################</xsl:comment>
           <xsl:variable name="KP" as="element()+">
               <xsl:for-each select="key('scopes', $wholenum)">
                   <xsl:sequence select=".[parent::* ! name() = $knowledge_process]"/>
               </xsl:for-each>
           </xsl:variable>
           <xsl:variable name="PrPred" as="element()+">
               <xsl:for-each select="key('scopes', $wholenum)">
                   <xsl:sequence select=".[parent::* ! name() = $processPred]"/>
               </xsl:for-each>
           </xsl:variable>
           <xsl:variable name="wholenumScopeString" select="'Whole Numbers'"/>
           
           <!-- ADD "involving Whole Numbers [subscope]" STRING -->
           <sentenceGroup xml:id="kp-prPred">
              <xsl:call-template name="sentenceWriter">
                  <xsl:with-param name="param1" as="element()+" select="$KP"/>
                  <xsl:with-param name="param2" as="element()+" select="$PrPred"/>
                  <xsl:with-param name="scopeParam" as="xs:string" select="$wholenumScopeString"/>
               </xsl:call-template>
           </sentenceGroup>
  
  <!-- ************ WITH SUBPROCESS *************************************************************** -->
  
           <xsl:comment>###############################</xsl:comment>
           <xsl:comment>Knowledge Process + Subprocess + Math Operation + Quant Object</xsl:comment>
           <xsl:comment>###############################</xsl:comment>
           <xsl:variable name="KP" as="element()+">
               <xsl:for-each select="key('scopes', $wholenum)">
                   <xsl:sequence select=".[parent::* ! name() = $knowledge_process]"/>
               </xsl:for-each>
           </xsl:variable>
           <xsl:variable name="KSP" as="element()+">
               <xsl:for-each select="key('scopes', $wholenum)">
                   <xsl:sequence select=".[parent::* ! name() = $knowledge_subprocess]"/>
               </xsl:for-each>
           </xsl:variable>
           <xsl:variable name="MathOp" as="element()+">
               <xsl:for-each select="key('scopes', $wholenum)">
                   <xsl:sequence select=".[parent::* ! name() = $math_operation]"/>
               </xsl:for-each>
           </xsl:variable>
           <xsl:variable name="QO" as="element()+">
               <xsl:for-each select="key('scopes', $wholenum)">
                   <xsl:sequence select=".[parent::* ! name() = $object]"/>
               </xsl:for-each>
           </xsl:variable>
           <xsl:variable name="wholenumScopeString" select="'Whole Numbers'"/>
           
           <!-- ADD "involving Whole Numbers [subscope]" STRING -->
           <sentenceGroup xml:id="kp-sp-mathop">
              <xsl:call-template name="sentenceWriter">
                  <xsl:with-param name="param1" as="element()+" select="$KP"/>
                  <xsl:with-param name="param2" as="element()+" select="$KSP"/>
                  <xsl:with-param name="param3" as="element()+" select="$MathOp"/>
                  <xsl:with-param name="param4" as="element()+" select="$QO"/>
                  <xsl:with-param name="scopeParam" as="xs:string" select="$wholenumScopeString"/>
               </xsl:call-template>
           </sentenceGroup>
         
           <xsl:comment>###############################</xsl:comment>
           <xsl:comment>Knowledge Process + Subprocess + Process Pred</xsl:comment>
           <xsl:comment>###############################</xsl:comment>
           <xsl:variable name="KP" as="element()+">
               <xsl:for-each select="key('scopes', $wholenum)">
                   <xsl:sequence select=".[parent::* ! name() = $knowledge_process]"/>
               </xsl:for-each>
           </xsl:variable>
           <xsl:variable name="KSP" as="element()+">
               <xsl:for-each select="key('scopes', $wholenum)">
                   <xsl:sequence select=".[parent::* ! name() = $knowledge_subprocess]"/>
               </xsl:for-each>
           </xsl:variable>
           <xsl:variable name="PrPred" as="element()+">
               <xsl:for-each select="key('scopes', $wholenum)">
                   <xsl:sequence select=".[parent::* ! name() = $processPred]"/>
               </xsl:for-each>
           </xsl:variable>
           <xsl:variable name="wholenumScopeString" select="'Whole Numbers'"/>
           
           <!-- ADD "involving Whole Numbers [subscope]" STRING -->
           <sentenceGroup xml:id="kp-sp-prPred">
               <xsl:call-template name="sentenceWriter">
                   <xsl:with-param name="param1" as="element()+" select="$KP"/>
                   <xsl:with-param name="param2" as="element()+" select="$KSP"/>
                   <xsl:with-param name="param3" as="element()+" select="$PrPred"/>
                   <xsl:with-param name="scopeParam" as="xs:string" select="$wholenumScopeString"/>
               </xsl:call-template>
           </sentenceGroup>
       </xml>
   </xsl:template>  
</xsl:stylesheet>