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
  
    
   
    <!-- SCOPE KEY -->
    <xsl:key name="scopes" match="string" use="@class ! tokenize(., '\s+')"/>
    <!-- WHOLE NUMBERS SCOPE PARAM -->
    <xsl:param name="wholenum" as="xs:string" select="'wholenum'"/>
    
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
                                       <xsl:sequence select="concat($currLevel1, '&#x9;', $currLevel2, '&#x9;', $currLevel3, '&#x9;', $currLevel4, '&#10;')"/>
                                   </xsl:for-each>
                                 
                       </xsl:when>
                            <xsl:otherwise><!-- THREE PARAM SENTENCE -->
                                <xsl:sequence select="concat($currLevel1, '&#x9;', $currLevel2, '&#x9;', $currLevel3, '&#10;')"/> 
                            </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise><!-- TWO PARAMETER SENTENCE -->
                        <xsl:sequence select="concat($currLevel1, '&#x9;', $currLevel2, '&#10;')"/> <!-- , '&#x9;', 'involving Complex Numbers', -->
                       
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
           
                <xsl:call-template name="sentenceWriter">
                    <xsl:with-param name="param1" as="element()+" select="$FP_notation"/>
                    <xsl:with-param name="param2" as="element()+" select="$PrPred"/>
                    <xsl:with-param name="param3" as="element()+" select="$NO"/>
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
            
         
                <xsl:call-template name="sentenceWriter">
                    <xsl:with-param name="param1" as="element()+" select="$FP_notation"/>
                    <xsl:with-param name="param2" as="element()+" select="$MathOp"/>
                    <xsl:with-param name="param3" as="element()+" select="$QO"/>
                    <xsl:with-param name="param4" as="element()+" select="$NO"/>
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
            
            <xsl:call-template name="sentenceWriter">
                <xsl:with-param name="param1" as="element()+" select="$FP_noNot"/>
                <xsl:with-param name="param2" as="element()+" select="$PrPred"/>
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
            
            <xsl:call-template name="sentenceWriter">
                <xsl:with-param name="param1" as="element()+" select="$FP_noNot"/>
                <xsl:with-param name="param2" as="element()+" select="$MathOp"/>
                <xsl:with-param name="param3" as="element()+" select="$QO"/>
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
      
                <xsl:call-template name="sentenceWriter">
                    <xsl:with-param name="param1" as="element()+" select="$KP"/>
                    <xsl:with-param name="param2" as="element()+" select="$PrPred"/>
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
         
                <xsl:call-template name="sentenceWriter">
                    <xsl:with-param name="param1" as="element()+" select="$KP"/>
                    <xsl:with-param name="param2" as="element()+" select="$MathOp"/>
                    <xsl:with-param name="param3" as="element()+" select="$QO"/>
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
           
            <xsl:call-template name="sentenceWriter">
                <xsl:with-param name="param1" as="element()+" select="$KP"/>
                <xsl:with-param name="param2" as="element()+" select="$KSP"/>
                <xsl:with-param name="param3" as="element()+" select="$PrPred"/>
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
            
            <xsl:call-template name="sentenceWriter">
                <xsl:with-param name="param1" as="element()+" select="$KP"/>
                <xsl:with-param name="param2" as="element()+" select="$KSP"/>
                <xsl:with-param name="param3" as="element()+" select="$MathOp"/>
                <xsl:with-param name="param4" as="element()+" select="$QO"/>
            </xsl:call-template>
         
        </xsl:result-document>
        
    </xsl:template>
    
</xsl:stylesheet>