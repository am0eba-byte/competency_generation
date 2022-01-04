<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="3.0">
    
    
   <!-- <xsl:output method="text" indent="yes"/>-->
    
    
    <!-- ebb: Here we have defined a series of global parameters that are just strings of text designed to match element names in the source document. Parameters are very similar to variables in XSLT, but have a little more flexibility.They could be received into this XSLT as input, so imagine these as INPUT PARAMETERS to this XSLT. -->
    
    <xsl:param name="formal_process" as="xs:string" select="'formalProcess'"/>
    <xsl:param name="knowledge_process" as="xs:string" select="'knowledgeProcess'"/>
    <xsl:param name="knowledge_subprocess" as="xs:string" select="'knowledgeSubprocess'"/>
    <xsl:param name="processPred" as="xs:string" select="'processPred'"/>
    <xsl:param name="math_operation" as="xs:string" select="'mathOperation'"/>
    <xsl:param name="object" as="xs:string" select="'quant'"/>
    <xsl:param name="notationObject" as="xs:string" select="'notationObject'"/>
    <xsl:param name="subScope" as="xs:string" select="'subScope'"/>
    
   
    <!-- SCOPE KEY -->
    <xsl:key name="scopes" match="string" use="@class ! tokenize(., '\s+')"/>
    <!-- WHOLE NUMBERS SCOPE PARAM -->
    <xsl:param name="wholenum" as="xs:string" select="'wholenum'"/>
    
    <!-- SUBSCOPE TYPE KEY -->
    <xsl:key name="subType" match="string" use="@scopeClass ! tokenize(., '\s+')"/>
   <!-- SUBSCOPE TYPE PARAMS -->
    <xsl:param name="sing" as="xs:string" select="'sing'"/> <!-- 0, 1 -->
    <xsl:param name="to" as="xs:string" select="'to'"/> <!-- to 2, to 3, to 4, to 5 -->
    <xsl:param name="within" as="xs:string" select="'within'"/> <!-- within 10, within 20, within 100, etc. -->
        
    <!-- SUBSCOPE ID KEY -->
    <xsl:key name="subID" match="string" use="@id ! tokenize(., '\s+')"/>
    <!-- SUBSCOPE ID PARAMS -->
    <xsl:param name="zero" as="xs:string" select="'0'"/>
    <xsl:param name="one" as="xs:string" select="'1'"/>
    <xsl:param name="two" as="xs:string" select="'2'"/>
    <xsl:param name="three" as="xs:string" select="'3'"/>
    <xsl:param name="four" as="xs:string" select="'4'"/>
    <xsl:param name="five" as="xs:string" select="'5'"/>
    <xsl:param name="ten" as="xs:string" select="'10'"/>
    <xsl:param name="twenty" as="xs:string" select="'20'"/>
    <xsl:param name="hundred" as="xs:string" select="'100'"/>
    <xsl:param name="hundred20" as="xs:string" select="'120'"/>
    <xsl:param name="thousand" as="xs:string" select="'1000'"/>
    
    <!-- NOTATION STRING KEY -->
    <xsl:key name="notationKey" match="string" use="@subclass ! normalize-space()"/>
    <!-- SUBCLASS NOTATION PARAMS -->
    <xsl:param name="notation" as="xs:string" select="'notation'"/>
    <xsl:param name="noNot" as="xs:string" select="'noNot'"/>
    
    
    <!-- KEYS: all components -->
    <xsl:key name="elements" match="compParts" use="descendant::*"/>
    
    
    <!-- SENTENCE WRITER -->
    <xsl:template name="sentenceWriter" as="xs:string+">
        <xsl:param name="param1" as="element()+" required="yes"/>
        <xsl:param name="param2" as="element()+" required="yes"/>
        <xsl:param name="param3" as="element()*"/>
        <xsl:param name="param4" as="element()*"/>
        <xsl:param name="scopeParam" as="xs:string?"/>
        <xsl:param name="subScopeParam" as="xs:string*"/>
        
        <!-- MAX NUM OF PARAMS FOR ALL OTHER SCOPES: 3 -->
        
        <!-- MAX NUMBER OF COMPONENT PARAMS (whole numbers scope only): 5
            knowledge process + subprocess + math operation + object -->
        
        <!-- YES WE DO NEED VARIABLES. JUST NOT THESE VARIABLES> 
            TAKE THE NODES, CONVERT THEM TO STRINGS FOR SENTENCE CONSTRUCTION.
            -->
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
                            <xsl:choose>
                               <xsl:when test="$param4">
                                   <xsl:for-each select="$param4 ! normalize-space()">
                                       <xsl:variable name="currLevel4" as="xs:string?" select="current()"/>
                                       <!-- FOUR PARAMETER SENTENCES -->
                                      <xsl:choose> 
                                          <xsl:when test="$scopeParam">
                                              <xsl:for-each select="$scopeParam">
                                                  <xsl:variable name="scopeInsert" as="xs:string" select="current()"/>
                                                 <xsl:choose>
                                                     <xsl:when test="$subScopeParam">
                                                     <xsl:for-each select="$subScopeParam">
                                                     <xsl:variable name="subscopeInsert" as="xs:string" select="current()"/>
                                                     <xsl:sequence select="concat($currLevel1, '&#x9;', $currLevel2, '&#x9;', $currLevel3, '&#x9;', $currLevel4, '&#x9;', $scopeInsert, '&#x9;', $subscopeInsert, '&#10;')"/>
                                                 </xsl:for-each>
                                                 </xsl:when>
                                                     <xsl:otherwise>
                                                         <xsl:sequence select="concat($currLevel1, '&#x9;', $currLevel2, '&#x9;', $currLevel3, '&#x9;', $currLevel4, '&#x9;', $scopeInsert, '&#10;')"/>
                                                     </xsl:otherwise>
                                                 </xsl:choose>
                                              </xsl:for-each>
                                          </xsl:when>
                                          <xsl:otherwise>
                                              <xsl:sequence select="concat($currLevel1, '&#x9;', $currLevel2, '&#x9;', $currLevel3, '&#x9;', $currLevel4, '&#10;')"/>
                                          </xsl:otherwise>
                                      </xsl:choose>
                                   </xsl:for-each>
                                 
                       </xsl:when>
                            <xsl:otherwise><!-- THREE PARAM SENTENCE -->
                               <xsl:choose> 
                                   <xsl:when test="$scopeParam">
                                       <xsl:for-each select="$scopeParam">
                                           <xsl:variable name="scopeInsert" as="xs:string" select="current()"/>
                                           <xsl:choose>
                                               <xsl:when test="$subScopeParam">
                                                   <xsl:for-each select="$subScopeParam">
                                               <xsl:variable name="subscopeInsert" as="xs:string" select="current()"/>
                                               <xsl:sequence select="concat($currLevel1, '&#x9;', $currLevel2, '&#x9;', $currLevel3, '&#x9;', $scopeInsert, '&#x9;', $subscopeInsert, '&#10;')"/>
                                           </xsl:for-each>
                                               </xsl:when>
                                               <xsl:otherwise>
                                                   <xsl:sequence select="concat($currLevel1, '&#x9;', $currLevel2, '&#x9;', $currLevel3, '&#x9;', $scopeInsert, '&#10;')"/>
                                               </xsl:otherwise>
                                           </xsl:choose>
                                       </xsl:for-each>
                                   </xsl:when>
                                  <xsl:otherwise> 
                                      <xsl:sequence select="concat($currLevel1, '&#x9;', $currLevel2, '&#x9;', $currLevel3, '&#10;')"/>
                                  </xsl:otherwise>
                               </xsl:choose>
                            </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise><!-- TWO PARAMETER SENTENCE -->
                       <xsl:for-each select="$scopeParam"> 
                           <xsl:variable name="scopeInsert" as="xs:string" select="current()"/>
                           <xsl:choose>
                               <xsl:when test="$subScopeParam">
                                   <xsl:for-each select="$subScopeParam">
                               <xsl:variable name="subscopeInsert" as="xs:string" select="current()"/>
                               <xsl:sequence select="concat($currLevel1, '&#x9;', $currLevel2, '&#x9;', $scopeInsert, '&#x9;', $subscopeInsert, '&#10;')"/>
                           </xsl:for-each>
                               </xsl:when>
                               <xsl:otherwise>
                                   <xsl:sequence select="concat($currLevel1, '&#x9;', $currLevel2, '&#x9;', $scopeInsert, '&#10;')"/>
                               </xsl:otherwise>
                           </xsl:choose>
                       </xsl:for-each>
                       
                    </xsl:otherwise>
                </xsl:choose>
                
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    
    
    <xsl:template match="/">
        <!--<xml>-->
        
<!-- *******************FORMAL PROCESS BRANCH******************************************* -->
        
           
   <!--****************WITH NOTATIONS************************************************
            <xsl:comment>####################################</xsl:comment>
            <xsl:comment> Formal Process(keyed to Notation subclass) + Process Predicate + Notation Obj</xsl:comment>
            <xsl:comment>####################################</xsl:comment>-->
        <xsl:result-document method="text" href="TSV/fp-Pp-n.tsv">
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
            <xsl:variable name="wholenumScopeString" select="'involving Whole Numbers'"/>
            <xsl:variable name="subScope" as="element()+">
                <xsl:for-each select="key('scopes', $wholenum)">
                    <xsl:sequence select=".[parent::* ! name() = $subScope]"/>
                </xsl:for-each>
            </xsl:variable>
           
                <xsl:call-template name="sentenceWriter">
                    <xsl:with-param name="param1" as="element()+" select="$FP_notation"/>
                    <xsl:with-param name="param2" as="element()+" select="$PrPred"/>
                    <xsl:with-param name="param3" as="element()+" select="$NO"/>
                    <xsl:with-param name="scopeParam" as="xs:string" select="$wholenumScopeString"/>
                    <xsl:with-param name="subScopeParam" as="element()+" select="$subScope"/>
                </xsl:call-template>
          
        </xsl:result-document>
        
        <!--
            <xsl:comment>####################################</xsl:comment>
            <xsl:comment>Formal Process(keyed to Notation subclass) + Math Operation + Quant Object + Notation Obj</xsl:comment>
            <xsl:comment>####################################</xsl:comment>-->
        <xsl:result-document method="text" href="TSV/fp-mathop-n.tsv">
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
            <xsl:variable name="wholenumScopeString" select="'involving Whole Numbers'"/>
            <xsl:variable name="subScope" as="element()+">
                <xsl:for-each select="key('scopes', $wholenum)">
                    <xsl:sequence select=".[parent::* ! name() = $subScope]"/>
                </xsl:for-each>
            </xsl:variable>
            
         
                <xsl:call-template name="sentenceWriter">
                    <xsl:with-param name="param1" as="element()+" select="$FP_notation"/>
                    <xsl:with-param name="param2" as="element()+" select="$MathOp"/>
                    <xsl:with-param name="param3" as="element()+" select="$QO"/>
                    <xsl:with-param name="param4" as="element()+" select="$NO"/>
                    <xsl:with-param name="scopeParam" as="xs:string" select="$wholenumScopeString"/>
                    <xsl:with-param name="subScopeParam" as="element()+" select="$subScope"/>
                </xsl:call-template>
          
            </xsl:result-document>
            
        <!--****************WITHOUT NOTATIONS************************************************
            
            <xsl:comment>####################################</xsl:comment>
            <xsl:comment> Formal Process(keyed to NoNot subclass) + Process Predicate</xsl:comment>
            <xsl:comment>####################################</xsl:comment>-->
        <xsl:result-document method="text" href="TSV/fp-Pp.tsv">
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
            <xsl:variable name="wholenumScopeString" select="'involving Whole Numbers'"/>
            <xsl:variable name="subScope" as="element()+">
                <xsl:for-each select="key('scopes', $wholenum)">
                    <xsl:sequence select=".[parent::* ! name() = $subScope]"/>
                </xsl:for-each>
            </xsl:variable>
            
            <xsl:call-template name="sentenceWriter">
                <xsl:with-param name="param1" as="element()+" select="$FP_noNot"/>
                <xsl:with-param name="param2" as="element()+" select="$PrPred"/>
                <xsl:with-param name="scopeParam" as="xs:string" select="$wholenumScopeString"/>
                <xsl:with-param name="subScopeParam" as="element()+" select="$subScope"/>
            </xsl:call-template>
            
        </xsl:result-document>
        
        <!--
            <xsl:comment>####################################</xsl:comment>
            <xsl:comment>Formal Process(keyed to noNot subclass) + Math Operation + Quant Object </xsl:comment>
            <xsl:comment>####################################</xsl:comment>-->
        <xsl:result-document method="text" href="TSV/fp-mathop.tsv">
            <xsl:variable name="FP_noNot" as="element()+">
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
            <xsl:variable name="wholenumScopeString" select="'involving Whole Numbers'"/>
            <xsl:variable name="subScope" as="element()+">
                <xsl:for-each select="key('scopes', $wholenum)">
                    <xsl:sequence select=".[parent::* ! name() = $subScope]"/>
                </xsl:for-each>
            </xsl:variable>
            
            <xsl:call-template name="sentenceWriter">
                <xsl:with-param name="param1" as="element()+" select="$FP_noNot"/>
                <xsl:with-param name="param2" as="element()+" select="$MathOp"/>
                <xsl:with-param name="param3" as="element()+" select="$QO"/>
                <xsl:with-param name="scopeParam" as="xs:string" select="$wholenumScopeString"/>
                <xsl:with-param name="subScopeParam" as="element()+" select="$subScope"/>
            </xsl:call-template>
            
        </xsl:result-document>
            
            
            
           <!-- <xsl:comment>####################################</xsl:comment>
            <xsl:comment>Knowledge Process Branch </xsl:comment>
            <xsl:comment>####################################</xsl:comment> -->
            
<!-- ************** WITHOUT SUBPROCESS ************************************************* -->
          <!-- ################################################
            <xsl:comment>Knowledge Process + Process Pred</xsl:comment>
            <xsl:comment>####################################</xsl:comment>-->
        <xsl:result-document method="text" href="TSV/kp-Pp.tsv">
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
            <xsl:variable name="wholenumScopeString" select="'involving Whole Numbers'"/>
            <xsl:variable name="subScope" as="element()+">
                <xsl:for-each select="key('scopes', $wholenum)">
                    <xsl:sequence select=".[parent::* ! name() = $subScope]"/>
                </xsl:for-each>
            </xsl:variable>
      
                <xsl:call-template name="sentenceWriter">
                    <xsl:with-param name="param1" as="element()+" select="$KP"/>
                    <xsl:with-param name="param2" as="element()+" select="$PrPred"/>
                    <xsl:with-param name="scopeParam" as="xs:string" select="$wholenumScopeString"/>
                    <xsl:with-param name="subScopeParam" as="element()+" select="$subScope"/>
                </xsl:call-template>
           
            </xsl:result-document>
       
        
          <!--  <xsl:comment>####################################</xsl:comment>
            <xsl:comment>Knowledge Process + Math Operation + Quant Object</xsl:comment>
            <xsl:comment>####################################</xsl:comment>-->
        <xsl:result-document method="text" href="TSV/kp-mathop.tsv">
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
            <xsl:variable name="wholenumScopeString" select="'involving Whole Numbers'"/>
            <xsl:variable name="subScope" as="element()+">
                <xsl:for-each select="key('scopes', $wholenum)">
                    <xsl:sequence select=".[parent::* ! name() = $subScope]"/>
                </xsl:for-each>
            </xsl:variable>
         
                <xsl:call-template name="sentenceWriter">
                    <xsl:with-param name="param1" as="element()+" select="$KP"/>
                    <xsl:with-param name="param2" as="element()+" select="$MathOp"/>
                    <xsl:with-param name="param3" as="element()+" select="$QO"/>
                    <xsl:with-param name="scopeParam" as="xs:string" select="$wholenumScopeString"/>
                    <xsl:with-param name="subScopeParam" as="element()+" select="$subScope"/>
                </xsl:call-template>
           
            </xsl:result-document>
        
        
        
 <!-- ************************* WITH SUBPROCESS *********************************************** -->
        
        
        <!-- ################################################
            <xsl:comment>Knowledge Process + Subprocess + Process Pred</xsl:comment>
            <xsl:comment>####################################</xsl:comment>-->
        
        <xsl:result-document method="text" href="TSV/kp-sp-Pp.tsv">
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
            <xsl:variable name="wholenumScopeString" select="'involving Whole Numbers'"/>
            <xsl:variable name="subScope" as="element()+">
                <xsl:for-each select="key('scopes', $wholenum)">
                    <xsl:sequence select=".[parent::* ! name() = $subScope]"/>
                </xsl:for-each>
            </xsl:variable>
           
            <xsl:call-template name="sentenceWriter">
                <xsl:with-param name="param1" as="element()+" select="$KP"/>
                <xsl:with-param name="param2" as="element()+" select="$KSP"/>
                <xsl:with-param name="param3" as="element()+" select="$PrPred"/>
                <xsl:with-param name="scopeParam" as="xs:string" select="$wholenumScopeString"/>
                <xsl:with-param name="subScopeParam" as="element()+" select="$subScope"/>
            </xsl:call-template>
         
        </xsl:result-document>
        
        
        <!--  <xsl:comment>####################################</xsl:comment>
            <xsl:comment>Knowledge Process + Subprocess + Math Operation + Quant Object</xsl:comment>
            <xsl:comment>####################################</xsl:comment>-->
        <xsl:result-document method="text" href="TSV/kp-sp-mathop.tsv">
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
            <xsl:variable name="wholenumScopeString" select="'involving Whole Numbers'"/>
            <xsl:variable name="subScope" as="element()+">
                <xsl:for-each select="key('scopes', $wholenum)">
                    <xsl:sequence select=".[parent::* ! name() = $subScope]"/>
                </xsl:for-each>
            </xsl:variable>
            
            <xsl:call-template name="sentenceWriter">
                <xsl:with-param name="param1" as="element()+" select="$KP"/>
                <xsl:with-param name="param2" as="element()+" select="$KSP"/>
                <xsl:with-param name="param3" as="element()+" select="$MathOp"/>
                <xsl:with-param name="param4" as="element()+" select="$QO"/>
                <xsl:with-param name="scopeParam" as="xs:string" select="$wholenumScopeString"/>
                <xsl:with-param name="subScopeParam" as="element()+" select="$subScope"/>
            </xsl:call-template>
         
        </xsl:result-document>
        
    </xsl:template>
    
</xsl:stylesheet>