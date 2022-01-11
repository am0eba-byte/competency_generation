<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="3.0">


    <!-- <xsl:output method="text" indent="yes"/>-->


    <!-- ebb: Here we have defined a series of global parameters that are just strings of text designed to match element names in the source document. Parameters are very similar to variables in XSLT, but have a little more flexibility.They could be received into this XSLT as input, so imagine these as INPUT PARAMETERS to this XSLT. -->

    <xsl:param name="formal_process" as="xs:string" select="'formalProcess'"/>
    <xsl:param name="knowledge_process" as="xs:string" select="'knowledgeProcess'"/>
    <xsl:param name="processPred" as="xs:string" select="'processPred'"/>
    <!-- <xsl:param name="specific_object" as="xs:string" select="'specificObject'"/>-->
    <xsl:param name="math_operation" as="xs:string" select="'mathOperation'"/>
    <xsl:param name="object" as="xs:string" select="'quant'"/>
    <xsl:param name="notationObject" as="xs:string" select="'notationObject'"/>

    <!-- K-5 SCOPE PARAMS -->
    <xsl:param name="int" as="xs:string" select="'int'"/>
    <xsl:param name="rational" as="xs:string" select="'rational'"/>
    <xsl:param name="algexp" as="xs:string" select="'algexp'"/>
    <xsl:param name="numexp" as="xs:string" select="'numexp'"/>
    <xsl:param name="wholenum" as="xs:string" select="'wholenum'"/>

    <!-- KEYS -->
    <!-- SCOPE KEYS -->
    <xsl:key name="scopes" match="string" use="@class ! tokenize(., '\s+')"/>

    <!-- NOTATION STRING KEY -->
    <xsl:key name="notationKey" match="string" use="@subclass ! normalize-space()"/>
    <!-- SUBCLASS NOTATION PARAMS -->
    <xsl:param name="notation" as="xs:string" select="'notation'"/>

    <!-- KEYS: all components -->
    <xsl:key name="elements" match="compParts" use="descendant::*"/>


    <!-- SENTENCE WRITER -->
    <xsl:template name="sentenceWriter" as="xs:string+">
        <xsl:param name="param1" as="element()+" required="yes"/>
        <xsl:param name="param2" as="element()+" required="yes"/>
        <xsl:param name="param3" as="element()*"/>
        <xsl:param name="param4" as="element()*"/>
        <xsl:param name="scopeParam" as="xs:string"/>
        <xsl:param name="NOparam3" as="element()*"/>

        <!-- MAX NUM OF PARAMS FOR ALL OTHER SCOPES: 3 -->
        
        <!-- MAX NUM OF PARAMS FOR RATIONAL NUMBERS + INTEGERS: 4 -->

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

                <xsl:choose>
                  
                    <xsl:when test="$param3">
                        <xsl:for-each select="$param3 ! normalize-space()">
                            <xsl:variable name="currLevel3" as="xs:string?" select="current()"/>
                            <xsl:choose>
                                <xsl:when test="$param4"> <!-- 4 param branch: always have notation objects -->
                                    <xsl:for-each select="$param4 ! normalize-space()">
                                        <xsl:variable name="currLevel4" as="xs:string?"
                                            select="current()"/>
                                        <xsl:for-each select="$scopeParam">
                                            <xsl:variable name="scopeInsert" as="xs:string"
                                                select="current()"/>
                                            <xsl:sequence
                                                select="concat($currLevel1, '&#x9;', $currLevel2, '&#x9;', $currLevel3, '&#x9;', 'involving ', $scopeInsert, '&#x9;', $currLevel4, '&#10;')"
                                            />
                                        </xsl:for-each>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:otherwise> <!-- 3 param branch: without notation object -->
                                    <xsl:for-each select="$scopeParam">
                                        <xsl:variable name="scopeInsert" as="xs:string"
                                            select="current()"/>
                                               <xsl:sequence
                                            select="concat($currLevel1, '&#x9;', $currLevel2, '&#x9;', $currLevel3, '&#x9;', 'involving ', $scopeInsert, '&#10;')"
                                        />
                                    </xsl:for-each>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise> 
                       <xsl:choose>
                           <xsl:when test="$NOparam3">
                               <xsl:for-each select="$NOparam3">  <!-- 3 param branch: with notation object -->
                                   <xsl:variable name="NO" as="xs:string?" select="current()"/>
                                  <xsl:for-each select="$scopeParam">
                                      <xsl:variable name="scopeInsert" as="xs:string" select="current()"/>
                                      <xsl:sequence
                                       select="concat($currLevel1, '&#x9;', $currLevel2, '&#x9;', 'involving ', $scopeInsert, '&#x9;', $NO, '&#10;')"
                                   />
                                  </xsl:for-each>
                               </xsl:for-each>
                           </xsl:when>
                           <xsl:otherwise> <!-- 2 param branch: never have notation objects -->
                               <xsl:for-each select="$scopeParam">
                            <xsl:variable name="scopeInsert" as="xs:string" select="current()"/>
                            <xsl:sequence
                                select="concat($currLevel1, '&#x9;', $currLevel2, '&#x9;', 'involving ', $scopeInsert, '&#10;')"
                            />
                        </xsl:for-each>
                           </xsl:otherwise>
</xsl:choose>
                    
                    </xsl:otherwise>
                </xsl:choose>

            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>


    <xsl:template match="/">
        <!--<xml>-->



        <!--**************** INTEGERS SCOPE *********************************************-->

        <!-- <xsl:comment>####################################</xsl:comment>
            <xsl:comment>Formal Process Branch </xsl:comment>
            <xsl:comment>####################################</xsl:comment>
            -->
   <!-- *********** NO NOTATION OBJECT ***********************************************************
       
            <xsl:comment>####################################</xsl:comment>
            <xsl:comment>INTEGERS: Formal Process + Process Predicate</xsl:comment>
            <xsl:comment>####################################</xsl:comment>-->
        <xsl:result-document method="text" href="integers/TSV/fp-Pp.tsv">
            <xsl:variable name="FP_int" as="element()+">

                <xsl:for-each select="key('scopes', $int)">
                    <xsl:sequence select=".[parent::* ! name() = $formal_process]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="PrPred_int" as="element()+">
                <xsl:for-each select="key('scopes', $int)">
                    <xsl:sequence select=".[parent::* ! name() = $processPred]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="intScopeString" select="'Integers'"/>


            <xsl:call-template name="sentenceWriter">
                <xsl:with-param name="param1" as="element()+" select="$FP_int"/>
                <xsl:with-param name="param2" as="element()+" select="$PrPred_int"/>
                <xsl:with-param name="scopeParam" as="xs:string" select="$intScopeString"/>
            </xsl:call-template>

        </xsl:result-document>

        <!--
            <xsl:comment>####################################</xsl:comment>
            <xsl:comment>INTEGERS: Formal Process + Math Operation + Quant Object</xsl:comment>
            <xsl:comment>####################################</xsl:comment>-->
        <xsl:result-document method="text" href="integers/TSV/fp-mathop.tsv">
            <xsl:variable name="FP_int" as="element()+">
                <xsl:for-each select="key('scopes', $int)">
                    <xsl:sequence select=".[parent::* ! name() = $formal_process]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="MathOP_int" as="element()+">
                <xsl:for-each select="key('scopes', $int)">
                    <xsl:sequence select=".[parent::* ! name() = $math_operation]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="QO_int" as="element()+">
                <xsl:for-each select="key('scopes', $int)">
                    <xsl:sequence select=".[parent::* ! name() = $object]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="intScopeString" select="'Integers'"/>


            <xsl:call-template name="sentenceWriter">
                <xsl:with-param name="param1" as="element()+" select="$FP_int"/>
                <xsl:with-param name="param2" as="element()+" select="$MathOP_int"/>
                <xsl:with-param name="param3" as="element()+" select="$QO_int"/>
                <xsl:with-param name="scopeParam" as="xs:string" select="$intScopeString"/>
            </xsl:call-template>

        </xsl:result-document>
        
        
    <!-- **************** WITH NOTATION OBJECT *********************************************** -->
        
        
       <!-- <xsl:comment>####################################</xsl:comment>
        <xsl:comment>INTEGERS: Formal Process (keyed to notation) + Process Predicate + Notation Object</xsl:comment>
        <xsl:comment>####################################</xsl:comment>-->
        <xsl:result-document method="text" href="integers/TSV/fp-Pp-n.tsv">
            <xsl:variable name="FP_int" as="element()+">
                
                <xsl:for-each select="key('notationKey', $notation) intersect key('scopes', $int)">
                    <xsl:sequence select=".[parent::* ! name() = $formal_process]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="PrPred_int" as="element()+">
                <xsl:for-each select="key('scopes', $int)">
                    <xsl:sequence select=".[parent::* ! name() = $processPred]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="NO_int" as="element()+">
                <xsl:for-each select="key('scopes', $int)">
                    <xsl:sequence select=".[parent::* ! name() = $notationObject]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="intScopeString" select="'Integers'"/>
            
            
            <xsl:call-template name="sentenceWriter">
                <xsl:with-param name="param1" as="element()+" select="$FP_int"/>
                <xsl:with-param name="param2" as="element()+" select="$PrPred_int"/>
                <xsl:with-param name="NOparam3" as="element()+" select="$NO_int"/>
                <xsl:with-param name="scopeParam" as="xs:string" select="$intScopeString"/>
            </xsl:call-template>
            
        </xsl:result-document>
        
        <!--
            <xsl:comment>####################################</xsl:comment>
            <xsl:comment>INTEGERS: Formal Process (keyed to notation) + Math Operation + Quant Object + Notation Object</xsl:comment>
            <xsl:comment>####################################</xsl:comment>-->
        <xsl:result-document method="text" href="integers/TSV/fp-mathop-n.tsv">
            <xsl:variable name="FP_int" as="element()+">
                <xsl:for-each select="key('notationKey', $notation) intersect key('scopes', $int)">
                    <xsl:sequence select=".[parent::* ! name() = $formal_process]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="MathOP_int" as="element()+">
                <xsl:for-each select="key('scopes', $int)">
                    <xsl:sequence select=".[parent::* ! name() = $math_operation]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="QO_int" as="element()+">
                <xsl:for-each select="key('scopes', $int)">
                    <xsl:sequence select=".[parent::* ! name() = $object]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="NO_int" as="element()+">
                <xsl:for-each select="key('scopes', $int)">
                    <xsl:sequence select=".[parent::* ! name() = $notationObject]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="intScopeString" select="'Integers'"/>
            
            
            <xsl:call-template name="sentenceWriter">
                <xsl:with-param name="param1" as="element()+" select="$FP_int"/>
                <xsl:with-param name="param2" as="element()+" select="$MathOP_int"/>
                <xsl:with-param name="param3" as="element()+" select="$QO_int"/>
                <xsl:with-param name="param4" as="element()+" select="$NO_int"/>
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
            <xsl:variable name="KP_int" as="element()+">
                <xsl:for-each select="key('scopes', $int)">
                    <xsl:sequence select=".[parent::* ! name() = $knowledge_process]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="PrPred_int" as="element()+">
                <xsl:for-each select="key('scopes', $int)">
                    <xsl:sequence select=".[parent::* ! name() = $processPred]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="intScopeString" select="'Integers'"/>

            <xsl:call-template name="sentenceWriter">
                <xsl:with-param name="param1" as="element()+" select="$KP_int"/>
                <xsl:with-param name="param2" as="element()+" select="$PrPred_int"/>
                <xsl:with-param name="scopeParam" as="xs:string" select="$intScopeString"/>
            </xsl:call-template>

        </xsl:result-document>


        <!--  <xsl:comment>####################################</xsl:comment>
            <xsl:comment>INTEGERS: Knowledge Process + Math Operation + Quant Object</xsl:comment>
            <xsl:comment>####################################</xsl:comment>-->
        <xsl:result-document method="text" href="integers/TSV/kp-mathop.tsv">
            <xsl:variable name="KP_int" as="element()+">
                <xsl:for-each select="key('scopes', $int)">
                    <xsl:sequence select=".[parent::* ! name() = $knowledge_process]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="MathOP_int" as="element()+">
                <xsl:for-each select="key('scopes', $int)">
                    <xsl:sequence select=".[parent::* ! name() = $math_operation]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="QO_int" as="element()+">
                <xsl:for-each select="key('scopes', $int)">
                    <xsl:sequence select=".[parent::* ! name() = $object]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="intScopeString" select="'Integers'"/>


            <xsl:call-template name="sentenceWriter">
                <xsl:with-param name="param1" as="element()+" select="$KP_int"/>
                <xsl:with-param name="param2" as="element()+" select="$MathOP_int"/>
                <xsl:with-param name="param3" as="element()+" select="$QO_int"/>
                <xsl:with-param name="scopeParam" as="xs:string" select="$intScopeString"/>
            </xsl:call-template>

        </xsl:result-document>


        <!--**************** RATIONAL NUMBERS SCOPE *********************************************-->

        <!-- <xsl:comment>####################################</xsl:comment>
            <xsl:comment>Formal Process Branch </xsl:comment>
            <xsl:comment>####################################</xsl:comment>
            -->
        
    <!-- ************** NO NOTATION OBJECT ****************************************************************
        
            <xsl:comment>####################################</xsl:comment>
            <xsl:comment>RATIONAL NUMBERS: Formal Process + Process Predicate</xsl:comment>
            <xsl:comment>####################################</xsl:comment>-->
        <xsl:result-document method="text" href="rational_nums/TSV/fp-Pp.tsv">
            <xsl:variable name="FP_rational" as="element()+">

                <xsl:for-each select="key('scopes', $rational)">
                    <xsl:sequence select=".[parent::* ! name() = $formal_process]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="PrPred_rational" as="element()+">
                <xsl:for-each select="key('scopes', $rational)">
                    <xsl:sequence select=".[parent::* ! name() = $processPred]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="rationalScopeString" select="'Rational Numbers'"/>


            <xsl:call-template name="sentenceWriter">
                <xsl:with-param name="param1" as="element()+" select="$FP_rational"/>
                <xsl:with-param name="param2" as="element()+" select="$PrPred_rational"/>
                <xsl:with-param name="scopeParam" as="xs:string" select="$rationalScopeString"/>
            </xsl:call-template>

        </xsl:result-document>

        <!--
            <xsl:comment>####################################</xsl:comment>
            <xsl:comment>RATIONAL NUMBERS: Formal Process + Math Operation + Quant Object</xsl:comment>
            <xsl:comment>####################################</xsl:comment>-->
        <xsl:result-document method="text" href="rational_nums/TSV/fp-mathop.tsv">
            <xsl:variable name="FP_rational" as="element()+">
                <xsl:for-each select="key('scopes', $rational)">
                    <xsl:sequence select=".[parent::* ! name() = $formal_process]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="MathOP_rational" as="element()+">
                <xsl:for-each select="key('scopes', $rational)">
                    <xsl:sequence select=".[parent::* ! name() = $math_operation]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="QO_rational" as="element()+">
                <xsl:for-each select="key('scopes', $rational)">
                    <xsl:sequence select=".[parent::* ! name() = $object]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="rationalScopeString" select="'Rational Numbers'"/>


            <xsl:call-template name="sentenceWriter">
                <xsl:with-param name="param1" as="element()+" select="$FP_rational"/>
                <xsl:with-param name="param2" as="element()+" select="$MathOP_rational"/>
                <xsl:with-param name="param3" as="element()+" select="$QO_rational"/>
                <xsl:with-param name="scopeParam" as="xs:string" select="$rationalScopeString"/>
            </xsl:call-template>

        </xsl:result-document>


<!-- ******************** WITH NOTATION OBJECT ************************************************************** -->
        
      <!--  <xsl:comment>####################################</xsl:comment>
        <xsl:comment>RATIONAL NUMBERS: Formal Process (keyed to notation) + Process Predicate + Notation Object</xsl:comment>
        <xsl:comment>####################################</xsl:comment>-->
        <xsl:result-document method="text" href="rational_nums/TSV/fp-Pp-n.tsv">
            <xsl:variable name="FP_rational" as="element()+">
                
                <xsl:for-each select="key('scopes', $rational) intersect key('notationKey', $notation)">
                    <xsl:sequence select=".[parent::* ! name() = $formal_process]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="PrPred_rational" as="element()+">
                <xsl:for-each select="key('scopes', $rational)">
                    <xsl:sequence select=".[parent::* ! name() = $processPred]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="NO_rational" as="element()+">
                <xsl:for-each select="key('scopes', $rational)">
                    <xsl:sequence select=".[parent::* ! name() = $notationObject]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="rationalScopeString" select="'Rational Numbers'"/>
            
            
            <xsl:call-template name="sentenceWriter">
                <xsl:with-param name="param1" as="element()+" select="$FP_rational"/>
                <xsl:with-param name="param2" as="element()+" select="$PrPred_rational"/>
                <xsl:with-param name="NOparam3" as="element()+" select="$NO_rational"/>
                <xsl:with-param name="scopeParam" as="xs:string" select="$rationalScopeString"/>
            </xsl:call-template>
            
        </xsl:result-document>
        
        <!--
            <xsl:comment>####################################</xsl:comment>
            <xsl:comment>RATIONAL NUMBERS: Formal Process (keyed to notation) + Math Operation + Quant Object + Notation Object</xsl:comment>
            <xsl:comment>####################################</xsl:comment>-->
        <xsl:result-document method="text" href="rational_nums/TSV/fp-mathop-n.tsv">
            <xsl:variable name="FP_rational" as="element()+">
                <xsl:for-each select="key('scopes', $rational) intersect key('notationKey', $notation)">
                    <xsl:sequence select=".[parent::* ! name() = $formal_process]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="MathOP_rational" as="element()+">
                <xsl:for-each select="key('scopes', $rational)">
                    <xsl:sequence select=".[parent::* ! name() = $math_operation]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="QO_rational" as="element()+">
                <xsl:for-each select="key('scopes', $rational)">
                    <xsl:sequence select=".[parent::* ! name() = $object]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="NO_rational" as="element()+">
                <xsl:for-each select="key('scopes', $rational)">
                    <xsl:sequence select=".[parent::* ! name() = $notationObject]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="rationalScopeString" select="'Rational Numbers'"/>
            
            
            <xsl:call-template name="sentenceWriter">
                <xsl:with-param name="param1" as="element()+" select="$FP_rational"/>
                <xsl:with-param name="param2" as="element()+" select="$MathOP_rational"/>
                <xsl:with-param name="param3" as="element()+" select="$QO_rational"/>
                <xsl:with-param name="param4" as="element()+" select="$NO_rational"/>
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
            <xsl:variable name="KP_rational" as="element()+">
                <xsl:for-each select="key('scopes', $rational)">
                    <xsl:sequence select=".[parent::* ! name() = $knowledge_process]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="PrPred_rational" as="element()+">
                <xsl:for-each select="key('scopes', $rational)">
                    <xsl:sequence select=".[parent::* ! name() = $processPred]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="rationalScopeString" select="'Rational Numbers'"/>

            <xsl:call-template name="sentenceWriter">
                <xsl:with-param name="param1" as="element()+" select="$KP_rational"/>
                <xsl:with-param name="param2" as="element()+" select="$PrPred_rational"/>
                <xsl:with-param name="scopeParam" as="xs:string" select="$rationalScopeString"/>
            </xsl:call-template>

        </xsl:result-document>


        <!--  <xsl:comment>####################################</xsl:comment>
            <xsl:comment>RATIONAL NUMBERS: Knowledge Process + Math Operation + Quant Object</xsl:comment>
            <xsl:comment>####################################</xsl:comment>-->
        <xsl:result-document method="text" href="rational_nums/TSV/kp-mathop.tsv">
            <xsl:variable name="KP_rational" as="element()+">
                <xsl:for-each select="key('scopes', $rational)">
                    <xsl:sequence select=".[parent::* ! name() = $knowledge_process]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="MathOP_rational" as="element()+">
                <xsl:for-each select="key('scopes', $rational)">
                    <xsl:sequence select=".[parent::* ! name() = $math_operation]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="QO_rational" as="element()+">
                <xsl:for-each select="key('scopes', $rational)">
                    <xsl:sequence select=".[parent::* ! name() = $object]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="rationalScopeString" select="'Rational Numbers'"/>


            <xsl:call-template name="sentenceWriter">
                <xsl:with-param name="param1" as="element()+" select="$KP_rational"/>
                <xsl:with-param name="param2" as="element()+" select="$MathOP_rational"/>
                <xsl:with-param name="param3" as="element()+" select="$QO_rational"/>
                <xsl:with-param name="scopeParam" as="xs:string" select="$rationalScopeString"/>
            </xsl:call-template>

        </xsl:result-document>




        <!--**************** ALGEBRAIC EXPRESSIONS SCOPE *********************************************-->


        <!-- <xsl:comment>####################################</xsl:comment>
            <xsl:comment>Formal Process Branch </xsl:comment>
            <xsl:comment>####################################</xsl:comment>
            -->
        <!--
            <xsl:comment>####################################</xsl:comment>
            <xsl:comment>ALGEBRAIC EXPRESSIONS: Formal Process + Process Predicate</xsl:comment>
            <xsl:comment>####################################</xsl:comment>-->
        <xsl:result-document method="text" href="algebra_exp/TSV/fp-Pp.tsv">
            <xsl:variable name="FP_algexp" as="element()+">

                <xsl:for-each select="key('scopes', $algexp)">
                    <xsl:sequence select=".[parent::* ! name() = $formal_process]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="PrPred_algexp" as="element()+">
                <xsl:for-each select="key('scopes', $algexp)">
                    <xsl:sequence select=".[parent::* ! name() = $processPred]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="algexpScopeString" select="'Algebraic Expressions'"/>


            <xsl:call-template name="sentenceWriter">
                <xsl:with-param name="param1" as="element()+" select="$FP_algexp"/>
                <xsl:with-param name="param2" as="element()+" select="$PrPred_algexp"/>
                <xsl:with-param name="scopeParam" as="xs:string" select="$algexpScopeString"/>
            </xsl:call-template>
        </xsl:result-document>


        <!--
            <xsl:comment>####################################</xsl:comment>
            <xsl:comment>ALGEBRAIC EXPRESSIONS: Formal Process + Math Operation + Quant Object</xsl:comment>
            <xsl:comment>####################################</xsl:comment>-->
        <xsl:result-document method="text" href="algebra_exp/TSV/fp-mathop.tsv">
            <xsl:variable name="FP_algexp" as="element()+">
                <xsl:for-each select="key('scopes', $algexp)">
                    <xsl:sequence select=".[parent::* ! name() = $formal_process]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="MathOP_algexp" as="element()+">
                <xsl:for-each select="key('scopes', $algexp)">
                    <xsl:sequence select=".[parent::* ! name() = $math_operation]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="QO_algexp" as="element()+">
                <xsl:for-each select="key('scopes', $algexp)">
                    <xsl:sequence select=".[parent::* ! name() = $object]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="algexpScopeString" select="'Algebraic Expressions'"/>


            <xsl:call-template name="sentenceWriter">
                <xsl:with-param name="param1" as="element()+" select="$FP_algexp"/>
                <xsl:with-param name="param2" as="element()+" select="$MathOP_algexp"/>
                <xsl:with-param name="param3" as="element()+" select="$QO_algexp"/>
                <xsl:with-param name="scopeParam" as="xs:string" select="$algexpScopeString"/>
            </xsl:call-template>
        </xsl:result-document>


        <!-- <xsl:comment>####################################</xsl:comment>
            <xsl:comment>Knowledge Process Branch </xsl:comment>
            <xsl:comment>####################################</xsl:comment>
            
            
            <xsl:comment>####################################</xsl:comment>
            <xsl:comment>ALGEBRAIC EXPRESSIONS: Knowledge Process + Process Pred</xsl:comment>
            <xsl:comment>####################################</xsl:comment>-->
        <xsl:result-document method="text" href="algebra_exp/TSV/kp-Pp.tsv">
            <xsl:variable name="KP_algexp" as="element()+">
                <xsl:for-each select="key('scopes', $algexp)">
                    <xsl:sequence select=".[parent::* ! name() = $knowledge_process]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="PrPred_algexp" as="element()+">
                <xsl:for-each select="key('scopes', $algexp)">
                    <xsl:sequence select=".[parent::* ! name() = $processPred]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="algexpScopeString" select="'Algebraic Expressions'"/>

            <xsl:call-template name="sentenceWriter">
                <xsl:with-param name="param1" as="element()+" select="$KP_algexp"/>
                <xsl:with-param name="param2" as="element()+" select="$PrPred_algexp"/>
                <xsl:with-param name="scopeParam" as="xs:string" select="$algexpScopeString"/>
            </xsl:call-template>
        </xsl:result-document>



        <!--  <xsl:comment>####################################</xsl:comment>
            <xsl:comment>ALGEBRAIC EXPRESSIONS: Knowledge Process + Math Operation + Quant Object</xsl:comment>
            <xsl:comment>####################################</xsl:comment>-->
        <xsl:result-document method="text" href="algebra_exp/TSV/kp-mathop.tsv">
            <xsl:variable name="KP_algexp" as="element()+">
                <xsl:for-each select="key('scopes', $algexp)">
                    <xsl:sequence select=".[parent::* ! name() = $knowledge_process]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="MathOP_algexp" as="element()+">
                <xsl:for-each select="key('scopes', $algexp)">
                    <xsl:sequence select=".[parent::* ! name() = $math_operation]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="QO_algexp" as="element()+">
                <xsl:for-each select="key('scopes', $algexp)">
                    <xsl:sequence select=".[parent::* ! name() = $object]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="algexpScopeString" select="'Algebraic Expressions'"/>


            <xsl:call-template name="sentenceWriter">
                <xsl:with-param name="param1" as="element()+" select="$KP_algexp"/>
                <xsl:with-param name="param2" as="element()+" select="$MathOP_algexp"/>
                <xsl:with-param name="param3" as="element()+" select="$QO_algexp"/>
                <xsl:with-param name="scopeParam" as="xs:string" select="$algexpScopeString"/>
            </xsl:call-template>
        </xsl:result-document>




        <!-- *************************** NUMERICAL EXPRESSIONS SCOPE **************************************** -->


        <!-- <xsl:comment>####################################</xsl:comment>
            <xsl:comment>Formal Process Branch </xsl:comment>
            <xsl:comment>####################################</xsl:comment>
            -->
        <!--
            <xsl:comment>####################################</xsl:comment>
            <xsl:comment>NUMERICAL EXPRESSIONS: Formal Process + Process Predicate</xsl:comment>
            <xsl:comment>####################################</xsl:comment>-->
        <xsl:result-document method="text" href="numeric_exp/TSV/fp-Pp.tsv">
            <xsl:variable name="FP_numexp" as="element()+">

                <xsl:for-each select="key('scopes', $numexp)">
                    <xsl:sequence select=".[parent::* ! name() = $formal_process]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="PrPred_numexp" as="element()+">
                <xsl:for-each select="key('scopes', $numexp)">
                    <xsl:sequence select=".[parent::* ! name() = $processPred]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="numexpScopeString" select="'Numerical Expressions'"/>


            <xsl:call-template name="sentenceWriter">
                <xsl:with-param name="param1" as="element()+" select="$FP_numexp"/>
                <xsl:with-param name="param2" as="element()+" select="$PrPred_numexp"/>
                <xsl:with-param name="scopeParam" as="xs:string" select="$numexpScopeString"/>
            </xsl:call-template>
        </xsl:result-document>


        <!--
            <xsl:comment>####################################</xsl:comment>
            <xsl:comment>NUMERICAL EXPRESSIONS: Formal Process + Math Operation + Quant Object</xsl:comment>
            <xsl:comment>####################################</xsl:comment>-->
        <xsl:result-document method="text" href="numeric_exp/TSV/fp-mathop.tsv">
            <xsl:variable name="FP_numexp" as="element()+">
                <xsl:for-each select="key('scopes', $numexp)">
                    <xsl:sequence select=".[parent::* ! name() = $formal_process]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="MathOP_numexp" as="element()+">
                <xsl:for-each select="key('scopes', $numexp)">
                    <xsl:sequence select=".[parent::* ! name() = $math_operation]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="QO_numexp" as="element()+">
                <xsl:for-each select="key('scopes', $numexp)">
                    <xsl:sequence select=".[parent::* ! name() = $object]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="numexpScopeString" select="'Numerical Expressions'"/>


            <xsl:call-template name="sentenceWriter">
                <xsl:with-param name="param1" as="element()+" select="$FP_numexp"/>
                <xsl:with-param name="param2" as="element()+" select="$MathOP_numexp"/>
                <xsl:with-param name="param3" as="element()+" select="$QO_numexp"/>
                <xsl:with-param name="scopeParam" as="xs:string" select="$numexpScopeString"/>
            </xsl:call-template>
        </xsl:result-document>


        <!-- <xsl:comment>####################################</xsl:comment>
            <xsl:comment>Knowledge Process Branch </xsl:comment>
            <xsl:comment>####################################</xsl:comment>
            
            
            <xsl:comment>####################################</xsl:comment>
            <xsl:comment>NUMERICAL EXPRESSIONS: Knowledge Process + Process Pred</xsl:comment>
            <xsl:comment>####################################</xsl:comment>-->
        <xsl:result-document method="text" href="numeric_exp/TSV/kp-Pp.tsv">
            <xsl:variable name="KP_numexp" as="element()+">
                <xsl:for-each select="key('scopes', $numexp)">
                    <xsl:sequence select=".[parent::* ! name() = $knowledge_process]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="PrPred_numexp" as="element()+">
                <xsl:for-each select="key('scopes', $numexp)">
                    <xsl:sequence select=".[parent::* ! name() = $processPred]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="numexpScopeString" select="'Numerical Expressions'"/>

            <xsl:call-template name="sentenceWriter">
                <xsl:with-param name="param1" as="element()+" select="$KP_numexp"/>
                <xsl:with-param name="param2" as="element()+" select="$PrPred_numexp"/>
                <xsl:with-param name="scopeParam" as="xs:string" select="$numexpScopeString"/>
            </xsl:call-template>
        </xsl:result-document>



        <!--  <xsl:comment>####################################</xsl:comment>
            <xsl:comment>NUMERICAL EXPRESSIONS: Knowledge Process + Math Operation + Quant Object</xsl:comment>
            <xsl:comment>####################################</xsl:comment>-->
        <xsl:result-document method="text" href="numeric_exp/TSV/kp-mathop.tsv">
            <xsl:variable name="KP_numexp" as="element()+">
                <xsl:for-each select="key('scopes', $numexp)">
                    <xsl:sequence select=".[parent::* ! name() = $knowledge_process]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="MathOP_numexp" as="element()+">
                <xsl:for-each select="key('scopes', $numexp)">
                    <xsl:sequence select=".[parent::* ! name() = $math_operation]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="QO_numexp" as="element()+">
                <xsl:for-each select="key('scopes', $numexp)">
                    <xsl:sequence select=".[parent::* ! name() = $object]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="numexpScopeString" select="'Numerical Expressions'"/>


            <xsl:call-template name="sentenceWriter">
                <xsl:with-param name="param1" as="element()+" select="$KP_numexp"/>
                <xsl:with-param name="param2" as="element()+" select="$MathOP_numexp"/>
                <xsl:with-param name="param3" as="element()+" select="$QO_numexp"/>
                <xsl:with-param name="scopeParam" as="xs:string" select="$numexpScopeString"/>
            </xsl:call-template>
        </xsl:result-document>


        <!--</xml>-->
    </xsl:template>

</xsl:stylesheet>
