<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="3.0">
    
    
   <!-- <xsl:output method="text" indent="yes"/>-->
    
    
    <!-- ebb: Here we have defined a series of global parameters that are just strings of text designed to match element names in the source document. Parameters are very similar to variables in XSLT, but have a little more flexibility.They could be received into this XSLT as input, so imagine these as INPUT PARAMETERS to this XSLT. -->
    
    <xsl:param name="formal_process" as="xs:string" select="'formal_process'"/>
    <xsl:param name="knowledge_process" as="xs:string" select="'knowledge_process'"/>
    
    <xsl:param name="processPred" as="xs:string" select="'processPred'"/>
    
    <xsl:param name="specific_object" as="xs:string" select="'specific_object'"/>
    
    <xsl:param name="math_operation" as="xs:string" select="'math_operation'"/>
    <xsl:param name="object" as="xs:string" select="'quant'"/>
   
   <!-- SCOPE PARAMS -->
    <xsl:param name="complex" as="xs:string" select="'complex'"/>
    <xsl:param name="imag" as="xs:string" select="'imag'"/>
    
    <!-- KEYS -->
    <!-- SCOPE KEYS -->
    <xsl:key name="scopes" match="string" use="@class ! tokenize(., '\s+')"/>
    
    <!-- KEYS: all components -->
    <xsl:key name="elements" match="compParts" use="descendant::*"/>
    
    
    <!-- SENTENCE WRITER -->
    <xsl:template name="sentenceWriter" as="xs:string+">
        <xsl:param name="param1" as="element()+" required="yes"/>
        <xsl:param name="param2" as="element()+" required="yes"/>
        <xsl:param name="param3" as="element()*"/>
        
        <!-- MAX NUM OF PARAMS FOR ALL OTHER SCOPES: 3 -->
        
        <!-- MAX NUMBER OF COMPONENT PARAMS (whole numbers scope only): 5
            knowledge process + subprocess + math operation + object -->
        
        <!-- YES WE DO NEED VARIABLES. JUST NOT THESE VARIABLES> 
            TAKE THE NODES, CONVERT THEM TO STRINGS FOR SENTENCE CONSTRUCTION.
            -->
        <xsl:variable name="var1" as="xs:string+" select="$param1/parent::* ! name()"/>
        <xsl:variable name="var2" as="xs:string+" select="$param2/parent::* ! name()"/>
        <xsl:variable name="var3" as="xs:string*" select="$param3/parent::* ! name()"/>
        
        <xsl:for-each select="$param1 ! normalize-space()">
            <xsl:variable name="currLevel1" as="xs:string" select="current()"/>
            
            <xsl:for-each select="$param2 ! normalize-space()">
                <xsl:variable name="currLevel2" as="xs:string?" select="current()"/>
                
                <xsl:choose><!-- CHOICE 1 -->
                    <xsl:when test="$param3">
                        <xsl:for-each select="$param3 ! normalize-space()">
                            <xsl:variable name="currLevel3" as="xs:string?" select="current()"/>
                            <xsl:sequence select="concat($currLevel1, '&#x9;', $currLevel2, '&#x9;', $currLevel3,'&#10;')"/>
                            <!--<componentSentence>
                                <xsl:element name="{$var1}">
                                    <xsl:sequence select="$currLevel1"/>
                                </xsl:element> 
                                <xsl:element name="{$var2}">
                                    <xsl:sequence select="$currLevel2"/>
                                </xsl:element> 
                                <xsl:element name="{$var3}">
                                    <xsl:sequence select="$currLevel3"/>
                                </xsl:element>
                            </componentSentence>-->
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="concat($currLevel1, '&#x9;', $currLevel2, '&#10;')"/>
                        <!--<componentSentence>
                            <xsl:element name="{$var1}">
                                <xsl:sequence select="$currLevel1"/>
                            </xsl:element> 
                            <xsl:element name="{$var2}">
                                <xsl:sequence select="$currLevel2"/>
                            </xsl:element> 
                        </componentSentence>-->
                    </xsl:otherwise>
                </xsl:choose>
                
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    
    
    <xsl:template match="/">
        <!--<xml>-->
           <!-- <xsl:comment>####################################</xsl:comment>
            <xsl:comment>Formal Process Branch </xsl:comment>
            <xsl:comment>####################################</xsl:comment>
            -->
            <!--
            <xsl:comment>####################################</xsl:comment>
            <xsl:comment>COMPLEX + IMAGINARY NUMBERS: Formal Process + Process Predicate</xsl:comment>
            <xsl:comment>####################################</xsl:comment>-->
        <xsl:result-document method="text" href="TSV/fp-Pp.tsv">
          <xsl:variable name="FPcomplex" as="element()+">
              <xsl:for-each select="key('scopes', $complex) intersect key('scopes', $imag)">
                  <xsl:sequence select=".[parent::* ! name() = $formal_process]"/>
              </xsl:for-each>
          </xsl:variable>
            <xsl:variable name="PrPredcomplex" as="element()+">
                <xsl:for-each select="key('scopes', $complex) intersect key('scopes', $imag)">
                    <xsl:sequence select=".[parent::* ! name() = $processPred]"/>
                </xsl:for-each>
            </xsl:variable>
            
            <!--<sentenceGroup xml:id="fpPp_complex">-->
                <xsl:call-template name="sentenceWriter">
                    <xsl:with-param name="param1" as="element()+" select="$FPcomplex"/>
                    <xsl:with-param name="param2" as="element()+" select="$PrPredcomplex"/>
                </xsl:call-template>
            <!--</sentenceGroup>-->
        </xsl:result-document>
        
            <!--<xsl:comment>####################################</xsl:comment>
            <xsl:comment>COMPLEX + IMAGINARY NUMBERS: Formal Process + Specific Object</xsl:comment>
            <xsl:comment>####################################</xsl:comment>-->
        <xsl:result-document method="text" href="TSV/fp-so.tsv">
            <xsl:variable name="FPcomplex" as="element()+">
                <xsl:for-each select="key('scopes', $complex) intersect key('scopes', $imag)">
                    <xsl:sequence select=".[parent::* ! name() = $formal_process]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="SpecObjcomplex" as="element()+">
                <xsl:for-each select="key('scopes', $complex) intersect key('scopes', $imag)">
                    <xsl:sequence select=".[parent::* ! name() = $specific_object]"/>
                </xsl:for-each>
            </xsl:variable>
            
            <!--<sentenceGroup xml:id="fpSo_complex">-->
                <xsl:call-template name="sentenceWriter">
                    <xsl:with-param name="param1" as="element()+" select="$FPcomplex"/>
                    <xsl:with-param name="param2" as="element()+" select="$SpecObjcomplex"/>
                </xsl:call-template>
            <!--</sentenceGroup>-->
        </xsl:result-document>
        <!--
            <xsl:comment>####################################</xsl:comment>
            <xsl:comment>COMPLEX + IMAGINARY NUMBERS: Formal Process + Math Operation + Quant Object</xsl:comment>
            <xsl:comment>####################################</xsl:comment>-->
        <xsl:result-document method="text" href="TSV/fp-mathop.tsv">
            <xsl:variable name="FPcomplex" as="element()+">
                <xsl:for-each select="key('scopes', $complex) intersect key('scopes', $imag)">
                    <xsl:sequence select=".[parent::* ! name() = $formal_process]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="MathOpcomplex" as="element()+">
                <xsl:for-each select="key('scopes', $complex) intersect key('scopes', $imag)">
                    <xsl:sequence select=".[parent::* ! name() = $math_operation]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="QOcomplex" as="element()+">
                <xsl:for-each select="key('scopes', $complex) intersect key('scopes', $imag)">
                    <xsl:sequence select=".[parent::* ! name() = $object]"/>
                </xsl:for-each>
            </xsl:variable>
            
            <!--<sentenceGroup xml:id="fpMathOP_complex">-->
                <xsl:call-template name="sentenceWriter">
                    <xsl:with-param name="param1" as="element()+" select="$FPcomplex"/>
                    <xsl:with-param name="param2" as="element()+" select="$MathOpcomplex"/>
                    <xsl:with-param name="param3" as="element()+" select="$QOcomplex"/>
                </xsl:call-template>
            <!--</sentenceGroup>-->
            </xsl:result-document>
            
           <!-- <xsl:comment>####################################</xsl:comment>
            <xsl:comment>Knowledge Process Branch </xsl:comment>
            <xsl:comment>####################################</xsl:comment>
            
            
            <xsl:comment>####################################</xsl:comment>
            <xsl:comment>COMPLEX + IMAGINARY NUMBERS: Knowledge Process + Process Pred</xsl:comment>
            <xsl:comment>####################################</xsl:comment>-->
        <xsl:result-document method="text" href="TSV/kp-Pp.tsv">
            <xsl:variable name="KPcomplex" as="element()+">
                <xsl:for-each select="key('scopes', $complex) intersect key('scopes', $imag)">
                    <xsl:sequence select=".[parent::* ! name() = $knowledge_process]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="PrPredcomplex" as="element()+">
                <xsl:for-each select="key('scopes', $complex) intersect key('scopes', $imag)">
                    <xsl:sequence select=".[parent::* ! name() = $processPred]"/>
                </xsl:for-each>
            </xsl:variable>
           <!-- <sentenceGroup xml:id="KpPp_complex">-->
                <xsl:call-template name="sentenceWriter">
                    <xsl:with-param name="param1" as="element()+" select="$KPcomplex"/>
                    <xsl:with-param name="param2" as="element()+" select="$PrPredcomplex"/>
                </xsl:call-template>
            <!--</sentenceGroup>-->
            </xsl:result-document>
        
           <!-- <xsl:comment>####################################</xsl:comment>
            <xsl:comment>COMPLEX + IMAGINARY NUMBERS: Knowledge Process + Specific Object</xsl:comment>
            <xsl:comment>####################################</xsl:comment>-->
        <xsl:result-document method="text" href="TSV/kp-so.tsv">
            <xsl:variable name="KPcomplex" as="element()+">
                <xsl:for-each select="key('scopes', $complex) intersect key('scopes', $imag)">
                    <xsl:sequence select=".[parent::* ! name() = $knowledge_process]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="SpecObjcomplex" as="element()+">
                <xsl:for-each select="key('scopes', $complex) intersect key('scopes', $imag)">
                    <xsl:sequence select=".[parent::* ! name() = $specific_object]"/>
                </xsl:for-each>
            </xsl:variable>
            <!--<sentenceGroup xml:id="KpSo_complex">-->
                <xsl:call-template name="sentenceWriter">
                    <xsl:with-param name="param1" as="element()+" select="$KPcomplex"/>
                    <xsl:with-param name="param2" as="element()+" select="$SpecObjcomplex"/>
                </xsl:call-template>
            <!--</sentenceGroup>-->
            </xsl:result-document>
        
          <!--  <xsl:comment>####################################</xsl:comment>
            <xsl:comment>COMPLEX + IMAGINARY NUMBERS: Knowledge Process + Math Operation + Quant Object</xsl:comment>
            <xsl:comment>####################################</xsl:comment>-->
        <xsl:result-document method="text" href="TSV/kp-mathop.tsv">
            <xsl:variable name="KPcomplex" as="element()+">
                <xsl:for-each select="key('scopes', $complex) intersect key('scopes', $imag)">
                    <xsl:sequence select=".[parent::* ! name() = $knowledge_process]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="MathOpcomplex" as="element()+">
                <xsl:for-each select="key('scopes', $complex) intersect key('scopes', $imag)">
                    <xsl:sequence select=".[parent::* ! name() = $math_operation]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="QOcomplex" as="element()+">
                <xsl:for-each select="key('scopes', $complex) intersect key('scopes', $imag)">
                    <xsl:sequence select=".[parent::* ! name() = $object]"/>
                </xsl:for-each>
            </xsl:variable>
            
           <!-- <sentenceGroup xml:id="KpMathOP_complex">-->
                <xsl:call-template name="sentenceWriter">
                    <xsl:with-param name="param1" as="element()+" select="$KPcomplex"/>
                    <xsl:with-param name="param2" as="element()+" select="$MathOpcomplex"/>
                    <xsl:with-param name="param3" as="element()+" select="$QOcomplex"/>
                </xsl:call-template>
            <!--</sentenceGroup>-->
            </xsl:result-document>
            
        <!--</xml>-->
    </xsl:template>
    
</xsl:stylesheet>