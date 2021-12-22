<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="3.0">
    
    
   <!-- <xsl:output method="text" indent="yes"/>-->
    
    
    <!-- ebb: Here we have defined a series of global parameters that are just strings of text designed to match element names in the source document. Parameters are very similar to variables in XSLT, but have a little more flexibility.They could be received into this XSLT as input, so imagine these as INPUT PARAMETERS to this XSLT. -->
    
    <xsl:param name="formal_process" as="xs:string" select="'formalProcess'"/>
    <xsl:param name="knowledge_process" as="xs:string" select="'knowledgeProcess'"/>
    
    <xsl:param name="processPred" as="xs:string" select="'processPred'"/>
    
   <!-- <xsl:param name="specific_object" as="xs:string" select="'specificObject'"/>-->
    
    <xsl:param name="math_operation" as="xs:string" select="'mathOperation'"/>
    <xsl:param name="object" as="xs:string" select="'quant'"/>
   
   <!-- SCOPE PARAMS -->
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
    <xsl:param name="wholenum" as="xs:string" select="'wholenum'"/>
    
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
        <xsl:param name="scopeParam" as="xs:string"/>
        
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
                            
                            <xsl:for-each select="$scopeParam">
                                <xsl:variable name="scopeInsert" as="xs:string" select="current()"/>
                                <xsl:sequence select="concat($currLevel1, '&#x9;', $currLevel2, '&#x9;', $currLevel3, '&#x9;', 'involving ', $scopeInsert, '&#10;')"/>
                            </xsl:for-each>
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
                        <xsl:for-each select="$scopeParam">
                            <xsl:variable name="scopeInsert" as="xs:string" select="current()"/>
                            <xsl:sequence select="concat($currLevel1, '&#x9;', $currLevel2, '&#x9;', 'involving ', $scopeInsert, '&#10;')"/>
                        </xsl:for-each>
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
        
<!-- *******************COMPLEX NUMBERS SCOPE******************************************* -->
        
           <!-- <xsl:comment>####################################</xsl:comment>
            <xsl:comment>Formal Process Branch </xsl:comment>
            <xsl:comment>####################################</xsl:comment>
            -->
            <!--
            <xsl:comment>####################################</xsl:comment>
            <xsl:comment>COMPLEX NUMBERS: Formal Process + Process Predicate</xsl:comment>
            <xsl:comment>####################################</xsl:comment>-->
        <xsl:result-document method="text" href="complex_nums/TSV/fp-Pp.tsv">
          <xsl:variable name="FPcomplex" as="element()+">
              <!--  intersect key('scopes', $imag) -->
              <xsl:for-each select="key('scopes', $complex)">
                  <xsl:sequence select=".[parent::* ! name() = $formal_process]"/>
              </xsl:for-each>
          </xsl:variable>
            <xsl:variable name="PrPredcomplex" as="element()+">
                <xsl:for-each select="key('scopes', $complex)">
                    <xsl:sequence select=".[parent::* ! name() = $processPred]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="complexScopeString" select="'Complex Numbers'"/>
               
            
            <!--<sentenceGroup xml:id="fpPp_complex">-->
                <xsl:call-template name="sentenceWriter">
                    <xsl:with-param name="param1" as="element()+" select="$FPcomplex"/>
                    <xsl:with-param name="param2" as="element()+" select="$PrPredcomplex"/>
                    <xsl:with-param name="scopeParam" as="xs:string" select="$complexScopeString"/>
                </xsl:call-template>
            <!--</sentenceGroup>-->
        </xsl:result-document>
        
        <!--
            <xsl:comment>####################################</xsl:comment>
            <xsl:comment>COMPLEX NUMBERS: Formal Process + Math Operation + Quant Object</xsl:comment>
            <xsl:comment>####################################</xsl:comment>-->
        <xsl:result-document method="text" href="complex_nums/TSV/fp-mathop.tsv">
            <xsl:variable name="FPcomplex" as="element()+">
                <xsl:for-each select="key('scopes', $complex)">
                    <xsl:sequence select=".[parent::* ! name() = $formal_process]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="MathOpcomplex" as="element()+">
                <xsl:for-each select="key('scopes', $complex)">
                    <xsl:sequence select=".[parent::* ! name() = $math_operation]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="QOcomplex" as="element()+">
                <xsl:for-each select="key('scopes', $complex)">
                    <xsl:sequence select=".[parent::* ! name() = $object]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="complexScopeString" select="'Complex Numbers'"/>
            
            <!--<sentenceGroup xml:id="fpMathOP_complex">-->
                <xsl:call-template name="sentenceWriter">
                    <xsl:with-param name="param1" as="element()+" select="$FPcomplex"/>
                    <xsl:with-param name="param2" as="element()+" select="$MathOpcomplex"/>
                    <xsl:with-param name="param3" as="element()+" select="$QOcomplex"/>
                    <xsl:with-param name="scopeParam" as="xs:string" select="$complexScopeString"/>
                </xsl:call-template>
            <!--</sentenceGroup>-->
            </xsl:result-document>
            
           <!-- <xsl:comment>####################################</xsl:comment>
            <xsl:comment>Knowledge Process Branch </xsl:comment>
            <xsl:comment>####################################</xsl:comment>
            
            
            <xsl:comment>####################################</xsl:comment>
            <xsl:comment>COMPLEX NUMBERS: Knowledge Process + Process Pred</xsl:comment>
            <xsl:comment>####################################</xsl:comment>-->
        <xsl:result-document method="text" href="complex_nums/TSV/kp-Pp.tsv">
            <xsl:variable name="KPcomplex" as="element()+">
                <xsl:for-each select="key('scopes', $complex)">
                    <xsl:sequence select=".[parent::* ! name() = $knowledge_process]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="PrPredcomplex" as="element()+">
                <xsl:for-each select="key('scopes', $complex)">
                    <xsl:sequence select=".[parent::* ! name() = $processPred]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="complexScopeString" select="'Complex Numbers'"/>
           <!-- <sentenceGroup xml:id="KpPp_complex">-->
                <xsl:call-template name="sentenceWriter">
                    <xsl:with-param name="param1" as="element()+" select="$KPcomplex"/>
                    <xsl:with-param name="param2" as="element()+" select="$PrPredcomplex"/>
                    <xsl:with-param name="scopeParam" as="xs:string" select="$complexScopeString"/>
                </xsl:call-template>
            <!--</sentenceGroup>-->
            </xsl:result-document>
       
        
          <!--  <xsl:comment>####################################</xsl:comment>
            <xsl:comment>COMPLEX NUMBERS: Knowledge Process + Math Operation + Quant Object</xsl:comment>
            <xsl:comment>####################################</xsl:comment>-->
        <xsl:result-document method="text" href="complex_nums/TSV/kp-mathop.tsv">
            <xsl:variable name="KPcomplex" as="element()+">
                <xsl:for-each select="key('scopes', $complex)">
                    <xsl:sequence select=".[parent::* ! name() = $knowledge_process]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="MathOpcomplex" as="element()+">
                <xsl:for-each select="key('scopes', $complex)">
                    <xsl:sequence select=".[parent::* ! name() = $math_operation]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="QOcomplex" as="element()+">
                <xsl:for-each select="key('scopes', $complex)">
                    <xsl:sequence select=".[parent::* ! name() = $object]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="complexScopeString" select="'Complex Numbers'"/>
            
           <!-- <sentenceGroup xml:id="KpMathOP_complex">-->
                <xsl:call-template name="sentenceWriter">
                    <xsl:with-param name="param1" as="element()+" select="$KPcomplex"/>
                    <xsl:with-param name="param2" as="element()+" select="$MathOpcomplex"/>
                    <xsl:with-param name="param3" as="element()+" select="$QOcomplex"/>
                    <xsl:with-param name="scopeParam" as="xs:string" select="$complexScopeString"/>
                </xsl:call-template>
            <!--</sentenceGroup>-->
            </xsl:result-document>
        
        
        
<!--**************** IMAGINARY NUMBERS SCOPE *********************************************-->
        
        <!-- <xsl:comment>####################################</xsl:comment>
            <xsl:comment>Formal Process Branch </xsl:comment>
            <xsl:comment>####################################</xsl:comment>
            -->
        <!--
            <xsl:comment>####################################</xsl:comment>
            <xsl:comment>IMAGINARY NUMBERS: Formal Process + Process Predicate</xsl:comment>
            <xsl:comment>####################################</xsl:comment>-->
        <xsl:result-document method="text" href="imaginary_nums/TSV/fp-Pp.tsv">
            <xsl:variable name="FPimag" as="element()+">
                <!--  intersect key('scopes', $imag) -->
                <xsl:for-each select="key('scopes', $imag)">
                    <xsl:sequence select=".[parent::* ! name() = $formal_process]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="PrPredimag" as="element()+">
                <xsl:for-each select="key('scopes', $imag)">
                    <xsl:sequence select=".[parent::* ! name() = $processPred]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="imagScopeString" select="'Imaginary Numbers'"/>
            
           
            <xsl:call-template name="sentenceWriter">
                <xsl:with-param name="param1" as="element()+" select="$FPimag"/>
                <xsl:with-param name="param2" as="element()+" select="$PrPredimag"/>
                <xsl:with-param name="scopeParam" as="xs:string" select="$imagScopeString"/>
            </xsl:call-template>
           
        </xsl:result-document>
        
        <!--
            <xsl:comment>####################################</xsl:comment>
            <xsl:comment>IMAGINARY NUMBERS: Formal Process + Math Operation + Quant Object</xsl:comment>
            <xsl:comment>####################################</xsl:comment>-->
        <xsl:result-document method="text" href="imaginary_nums/TSV/fp-mathop.tsv">
            <xsl:variable name="FPimag" as="element()+">
                <xsl:for-each select="key('scopes', $imag)">
                    <xsl:sequence select=".[parent::* ! name() = $formal_process]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="MathOpimag" as="element()+">
                <xsl:for-each select="key('scopes', $imag)">
                    <xsl:sequence select=".[parent::* ! name() = $math_operation]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="QOimag" as="element()+">
                <xsl:for-each select="key('scopes', $imag)">
                    <xsl:sequence select=".[parent::* ! name() = $object]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="imagScopeString" select="'Imaginary Numbers'"/>
            
           
            <xsl:call-template name="sentenceWriter">
                <xsl:with-param name="param1" as="element()+" select="$FPimag"/>
                <xsl:with-param name="param2" as="element()+" select="$MathOpimag"/>
                <xsl:with-param name="param3" as="element()+" select="$QOimag"/>
                <xsl:with-param name="scopeParam" as="xs:string" select="$imagScopeString"/>
            </xsl:call-template>
           
        </xsl:result-document>
        
        <!-- <xsl:comment>####################################</xsl:comment>
            <xsl:comment>Knowledge Process Branch </xsl:comment>
            <xsl:comment>####################################</xsl:comment>
            
            
            <xsl:comment>####################################</xsl:comment>
            <xsl:comment>IMAGINARY NUMBERS: Knowledge Process + Process Pred</xsl:comment>
            <xsl:comment>####################################</xsl:comment>-->
        <xsl:result-document method="text" href="imaginary_nums/TSV/kp-Pp.tsv">
            <xsl:variable name="KPimag" as="element()+">
                <xsl:for-each select="key('scopes', $imag)">
                    <xsl:sequence select=".[parent::* ! name() = $knowledge_process]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="PrPredimag" as="element()+">
                <xsl:for-each select="key('scopes', $imag)">
                    <xsl:sequence select=".[parent::* ! name() = $processPred]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="imagScopeString" select="'Imaginary Numbers'"/>
           
            <xsl:call-template name="sentenceWriter">
                <xsl:with-param name="param1" as="element()+" select="$KPimag"/>
                <xsl:with-param name="param2" as="element()+" select="$PrPredimag"/>
                <xsl:with-param name="scopeParam" as="xs:string" select="$imagScopeString"/>
            </xsl:call-template>
            
        </xsl:result-document>
        
        
        <!--  <xsl:comment>####################################</xsl:comment>
            <xsl:comment>IMAGINARY NUMBERS: Knowledge Process + Math Operation + Quant Object</xsl:comment>
            <xsl:comment>####################################</xsl:comment>-->
        <xsl:result-document method="text" href="imaginary_nums/TSV/kp-mathop.tsv">
            <xsl:variable name="KPimag" as="element()+">
                <xsl:for-each select="key('scopes', $imag)">
                    <xsl:sequence select=".[parent::* ! name() = $knowledge_process]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="MathOpimag" as="element()+">
                <xsl:for-each select="key('scopes', $imag)">
                    <xsl:sequence select=".[parent::* ! name() = $math_operation]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="QOimag" as="element()+">
                <xsl:for-each select="key('scopes', $imag)">
                    <xsl:sequence select=".[parent::* ! name() = $object]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="imagScopeString" select="'Imaginary Numbers'"/>
            
            
            <xsl:call-template name="sentenceWriter">
                <xsl:with-param name="param1" as="element()+" select="$KPimag"/>
                <xsl:with-param name="param2" as="element()+" select="$MathOpimag"/>
                <xsl:with-param name="param3" as="element()+" select="$QOimag"/>
                <xsl:with-param name="scopeParam" as="xs:string" select="$imagScopeString"/>
            </xsl:call-template>
           
        </xsl:result-document>
        
        
        
 <!--**************** INTEGERS SCOPE *********************************************-->
        
        <!-- <xsl:comment>####################################</xsl:comment>
            <xsl:comment>Formal Process Branch </xsl:comment>
            <xsl:comment>####################################</xsl:comment>
            -->
        <!--
            <xsl:comment>####################################</xsl:comment>
            <xsl:comment>INTEGERS: Formal Process + Process Predicate</xsl:comment>
            <xsl:comment>####################################</xsl:comment>-->
        <xsl:result-document method="text" href="integers/TSV/fp-Pp.tsv">
            <xsl:variable name="FPint" as="element()+">
              
                <xsl:for-each select="key('scopes', $int)">
                    <xsl:sequence select=".[parent::* ! name() = $formal_process]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="PrPredint" as="element()+">
                <xsl:for-each select="key('scopes', $int)">
                    <xsl:sequence select=".[parent::* ! name() = $processPred]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="intScopeString" select="'Integers'"/>
            
            
            <xsl:call-template name="sentenceWriter">
                <xsl:with-param name="param1" as="element()+" select="$FPint"/>
                <xsl:with-param name="param2" as="element()+" select="$PrPredint"/>
                <xsl:with-param name="scopeParam" as="xs:string" select="$intScopeString"/>
            </xsl:call-template>
            
        </xsl:result-document>
        
        <!--
            <xsl:comment>####################################</xsl:comment>
            <xsl:comment>INTEGERS: Formal Process + Math Operation + Quant Object</xsl:comment>
            <xsl:comment>####################################</xsl:comment>-->
        <xsl:result-document method="text" href="integers/TSV/fp-mathop.tsv">
            <xsl:variable name="FPint" as="element()+">
                <xsl:for-each select="key('scopes', $int)">
                    <xsl:sequence select=".[parent::* ! name() = $formal_process]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="MathOpint" as="element()+">
                <xsl:for-each select="key('scopes', $int)">
                    <xsl:sequence select=".[parent::* ! name() = $math_operation]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="QOint" as="element()+">
                <xsl:for-each select="key('scopes', $int)">
                    <xsl:sequence select=".[parent::* ! name() = $object]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="intScopeString" select="'Integers'"/>
            
            
            <xsl:call-template name="sentenceWriter">
                <xsl:with-param name="param1" as="element()+" select="$FPint"/>
                <xsl:with-param name="param2" as="element()+" select="$MathOpint"/>
                <xsl:with-param name="param3" as="element()+" select="$QOint"/>
                <xsl:with-param name="scopeParam" as="xs:string" select="$intScopeString"/>
            </xsl:call-template>
            
        </xsl:result-document>
        
        <!-- <xsl:comment>####################################</xsl:comment>
            <xsl:comment>Knowledge Process Branch </xsl:comment>
            <xsl:comment>####################################</xsl:comment>
            
            
            <xsl:comment>####################################</xsl:comment>
            <xsl:comment>INTEGERS: Knowledge Process + Process Pred</xsl:comment>
            <xsl:comment>####################################</xsl:comment>-->
        <xsl:result-document method="text" href="integers/TSV/kp-Pp.tsv">
            <xsl:variable name="KPint" as="element()+">
                <xsl:for-each select="key('scopes', $int)">
                    <xsl:sequence select=".[parent::* ! name() = $knowledge_process]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="PrPredint" as="element()+">
                <xsl:for-each select="key('scopes', $int)">
                    <xsl:sequence select=".[parent::* ! name() = $processPred]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="intScopeString" select="'Integers'"/>
            
            <xsl:call-template name="sentenceWriter">
                <xsl:with-param name="param1" as="element()+" select="$KPint"/>
                <xsl:with-param name="param2" as="element()+" select="$PrPredint"/>
                <xsl:with-param name="scopeParam" as="xs:string" select="$intScopeString"/>
            </xsl:call-template>
            
        </xsl:result-document>
        
        
        <!--  <xsl:comment>####################################</xsl:comment>
            <xsl:comment>INTEGERS: Knowledge Process + Math Operation + Quant Object</xsl:comment>
            <xsl:comment>####################################</xsl:comment>-->
        <xsl:result-document method="text" href="integers/TSV/kp-mathop.tsv">
            <xsl:variable name="KPint" as="element()+">
                <xsl:for-each select="key('scopes', $int)">
                    <xsl:sequence select=".[parent::* ! name() = $knowledge_process]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="MathOpint" as="element()+">
                <xsl:for-each select="key('scopes', $int)">
                    <xsl:sequence select=".[parent::* ! name() = $math_operation]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="QOint" as="element()+">
                <xsl:for-each select="key('scopes', $int)">
                    <xsl:sequence select=".[parent::* ! name() = $object]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="intScopeString" select="'Integers'"/>
            
            
            <xsl:call-template name="sentenceWriter">
                <xsl:with-param name="param1" as="element()+" select="$KPint"/>
                <xsl:with-param name="param2" as="element()+" select="$MathOpint"/>
                <xsl:with-param name="param3" as="element()+" select="$QOint"/>
                <xsl:with-param name="scopeParam" as="xs:string" select="$intScopeString"/>
            </xsl:call-template>
            
        </xsl:result-document>
        
        
<!--**************** RATIONAL NUMBERS SCOPE *********************************************-->
        
        <!-- <xsl:comment>####################################</xsl:comment>
            <xsl:comment>Formal Process Branch </xsl:comment>
            <xsl:comment>####################################</xsl:comment>
            -->
        <!--
            <xsl:comment>####################################</xsl:comment>
            <xsl:comment>RATIONAL NUMBERS: Formal Process + Process Predicate</xsl:comment>
            <xsl:comment>####################################</xsl:comment>-->
        <xsl:result-document method="text" href="rational_nums/TSV/fp-Pp.tsv">
            <xsl:variable name="FPrational" as="element()+">
                
                <xsl:for-each select="key('scopes', $rational)">
                    <xsl:sequence select=".[parent::* ! name() = $formal_process]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="PrPredrational" as="element()+">
                <xsl:for-each select="key('scopes', $rational)">
                    <xsl:sequence select=".[parent::* ! name() = $processPred]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="rationalScopeString" select="'Rational Numbers'"/>
            
            
            <xsl:call-template name="sentenceWriter">
                <xsl:with-param name="param1" as="element()+" select="$FPrational"/>
                <xsl:with-param name="param2" as="element()+" select="$PrPredrational"/>
                <xsl:with-param name="scopeParam" as="xs:string" select="$rationalScopeString"/>
            </xsl:call-template>
            
        </xsl:result-document>
        
        <!--
            <xsl:comment>####################################</xsl:comment>
            <xsl:comment>RATIONAL NUMBERS: Formal Process + Math Operation + Quant Object</xsl:comment>
            <xsl:comment>####################################</xsl:comment>-->
        <xsl:result-document method="text" href="rational_nums/TSV/fp-mathop.tsv">
            <xsl:variable name="FPrational" as="element()+">
                <xsl:for-each select="key('scopes', $rational)">
                    <xsl:sequence select=".[parent::* ! name() = $formal_process]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="MathOprational" as="element()+">
                <xsl:for-each select="key('scopes', $rational)">
                    <xsl:sequence select=".[parent::* ! name() = $math_operation]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="QOrational" as="element()+">
                <xsl:for-each select="key('scopes', $rational)">
                    <xsl:sequence select=".[parent::* ! name() = $object]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="rationalScopeString" select="'Rational Numbers'"/>
            
            
            <xsl:call-template name="sentenceWriter">
                <xsl:with-param name="param1" as="element()+" select="$FPrational"/>
                <xsl:with-param name="param2" as="element()+" select="$MathOprational"/>
                <xsl:with-param name="param3" as="element()+" select="$QOrational"/>
                <xsl:with-param name="scopeParam" as="xs:string" select="$rationalScopeString"/>
            </xsl:call-template>
            
        </xsl:result-document>
        
        <!-- <xsl:comment>####################################</xsl:comment>
            <xsl:comment>Knowledge Process Branch </xsl:comment>
            <xsl:comment>####################################</xsl:comment>
            
            
            <xsl:comment>####################################</xsl:comment>
            <xsl:comment>RATIONAL NUMBERS: Knowledge Process + Process Pred</xsl:comment>
            <xsl:comment>####################################</xsl:comment>-->
        <xsl:result-document method="text" href="rational_nums/TSV/kp-Pp.tsv">
            <xsl:variable name="KPrational" as="element()+">
                <xsl:for-each select="key('scopes', $rational)">
                    <xsl:sequence select=".[parent::* ! name() = $knowledge_process]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="PrPredrational" as="element()+">
                <xsl:for-each select="key('scopes', $rational)">
                    <xsl:sequence select=".[parent::* ! name() = $processPred]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="rationalScopeString" select="'Rational Numbers'"/>
            
            <xsl:call-template name="sentenceWriter">
                <xsl:with-param name="param1" as="element()+" select="$KPrational"/>
                <xsl:with-param name="param2" as="element()+" select="$PrPredrational"/>
                <xsl:with-param name="scopeParam" as="xs:string" select="$rationalScopeString"/>
            </xsl:call-template>
            
        </xsl:result-document>
        
        
        <!--  <xsl:comment>####################################</xsl:comment>
            <xsl:comment>RATIONAL NUMBERS: Knowledge Process + Math Operation + Quant Object</xsl:comment>
            <xsl:comment>####################################</xsl:comment>-->
        <xsl:result-document method="text" href="rational_nums/TSV/kp-mathop.tsv">
            <xsl:variable name="KPrational" as="element()+">
                <xsl:for-each select="key('scopes', $rational)">
                    <xsl:sequence select=".[parent::* ! name() = $knowledge_process]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="MathOprational" as="element()+">
                <xsl:for-each select="key('scopes', $rational)">
                    <xsl:sequence select=".[parent::* ! name() = $math_operation]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="QOrational" as="element()+">
                <xsl:for-each select="key('scopes', $rational)">
                    <xsl:sequence select=".[parent::* ! name() = $object]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="rationalScopeString" select="'Rational Numbers'"/>
            
            
            <xsl:call-template name="sentenceWriter">
                <xsl:with-param name="param1" as="element()+" select="$KPrational"/>
                <xsl:with-param name="param2" as="element()+" select="$MathOprational"/>
                <xsl:with-param name="param3" as="element()+" select="$QOrational"/>
                <xsl:with-param name="scopeParam" as="xs:string" select="$rationalScopeString"/>
            </xsl:call-template>
            
        </xsl:result-document>
            
        <!--</xml>-->
    </xsl:template>
    
</xsl:stylesheet>