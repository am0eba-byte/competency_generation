<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="3.0">



    <!--<xsl:output method="xml" indent="yes"/>-->


    <!-- ebb: Here we have defined a series of global parameters that are just strings of text designed to match element names in the source document. Parameters are very similar to variables in XSLT, but have a little more flexibility.They could be received into this XSLT as input, so imagine these as INPUT PARAMETERS to this XSLT. -->

    <xsl:param name="formal_process" as="xs:string" select="'formalProcess'"/>
    <xsl:param name="knowledge_process" as="xs:string" select="'knowledgeProcess'"/>

    <xsl:param name="processPred" as="xs:string" select="'processPred'"/>

    <!--<xsl:param name="specific_object" as="xs:string" select="'specificObject'"/>-->

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


    <!-- ... involving [scope name] -->

    <!-- SENTENCE WRITER -->
    <xsl:template name="sentenceWriter" as="element()+">
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
        <!-- add new variable(?) to insert scope string @ end of sentence -->
        <!--<xsl:variable name="scopeName" as="xs:string*" select="key('scopes', current())"/>-->

        <xsl:for-each select="$param1 ! normalize-space()">
            <xsl:variable name="currLevel1" as="xs:string" select="current()"/>

            <xsl:for-each select="$param2 ! normalize-space()">
                <xsl:variable name="currLevel2" as="xs:string?" select="current()"/>

                <xsl:choose>
                    <!-- CHOICE 1 -->
                    <xsl:when test="$param3">
                        <xsl:for-each select="$param3 ! normalize-space()">
                            <xsl:variable name="currLevel3" as="xs:string?" select="current()"/>
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
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
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


    <xsl:template match="/">
       

        <!--**************** INTEGERS SCOPE *********************************************-->
        <xsl:result-document method="xml" href="integers/integersNestedOutput.xml">
            <xml>
                <xsl:comment>####################################</xsl:comment>
                <xsl:comment>Formal Process Branch </xsl:comment>
                <xsl:comment>####################################</xsl:comment>
                <xsl:comment>####################################</xsl:comment>
                <xsl:comment>INTEGERS: Formal Process + Process Predicate</xsl:comment>
                <xsl:comment>####################################</xsl:comment>

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

                <sentenceGroup xml:id="integers">
                    <xsl:call-template name="sentenceWriter">
                        <xsl:with-param name="param1" as="element()+" select="$FPint"/>
                        <xsl:with-param name="param2" as="element()+" select="$PrPredint"/>
                        <xsl:with-param name="scopeParam" as="xs:string" select="$intScopeString"/>
                    </xsl:call-template>
                </sentenceGroup>
                <xsl:comment>####################################</xsl:comment>
                <xsl:comment>INTEGERS: Formal Process + Math Operation + Quant Object</xsl:comment>
                <xsl:comment>####################################</xsl:comment>

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

                <sentenceGroup xml:id="integers">
                    <xsl:call-template name="sentenceWriter">
                        <xsl:with-param name="param1" as="element()+" select="$FPint"/>
                        <xsl:with-param name="param2" as="element()+" select="$MathOpint"/>
                        <xsl:with-param name="param3" as="element()+" select="$QOint"/>
                        <xsl:with-param name="scopeParam" as="xs:string" select="$intScopeString"/>
                    </xsl:call-template>
                </sentenceGroup>
                <xsl:comment>####################################</xsl:comment>
                <xsl:comment>Knowledge Process Branch </xsl:comment>
                <xsl:comment>####################################</xsl:comment>
                <xsl:comment>####################################</xsl:comment>
                <xsl:comment>INTEGERS: Knowledge Process + Process Pred</xsl:comment>
                <xsl:comment>####################################</xsl:comment>

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
                <sentenceGroup xml:id="integers">
                    <xsl:call-template name="sentenceWriter">
                        <xsl:with-param name="param1" as="element()+" select="$KPint"/>
                        <xsl:with-param name="param2" as="element()+" select="$PrPredint"/>
                        <xsl:with-param name="scopeParam" as="xs:string" select="$intScopeString"/>
                    </xsl:call-template>
                </sentenceGroup>
                <xsl:comment>####################################</xsl:comment>
                <xsl:comment>INTEGERS: Knowledge Process + Math Operation + Quant Object</xsl:comment>
                <xsl:comment>####################################</xsl:comment>

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

                <sentenceGroup xml:id="integers">
                    <xsl:call-template name="sentenceWriter">
                        <xsl:with-param name="param1" as="element()+" select="$KPint"/>
                        <xsl:with-param name="param2" as="element()+" select="$MathOpint"/>
                        <xsl:with-param name="param3" as="element()+" select="$QOint"/>
                        <xsl:with-param name="scopeParam" as="xs:string" select="$intScopeString"/>
                    </xsl:call-template>
                </sentenceGroup>
            </xml>
        </xsl:result-document>


        <!--**************** RATIONAL NUMBERS SCOPE *********************************************-->
        <xsl:result-document method="xml" href="rational_nums/rationalNestedOutput.xml">
            <xml>
                <xsl:comment>####################################</xsl:comment>
                <xsl:comment>Formal Process Branch </xsl:comment>
                <xsl:comment>####################################</xsl:comment>


                <xsl:comment>####################################</xsl:comment>
                <xsl:comment>RATIONAL NUMBERS: Formal Process + Process Predicate</xsl:comment>
                <xsl:comment>####################################</xsl:comment>

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

                <sentenceGroup xml:id="rational">
                    <xsl:call-template name="sentenceWriter">
                        <xsl:with-param name="param1" as="element()+" select="$FP_rational"/>
                        <xsl:with-param name="param2" as="element()+" select="$PrPred_rational"/>
                        <xsl:with-param name="scopeParam" as="xs:string"
                            select="$rationalScopeString"/>
                    </xsl:call-template>
                </sentenceGroup>



                <xsl:comment>####################################</xsl:comment>
                <xsl:comment>RATIONAL NUMBERS: Formal Process + Math Operation + Quant Object</xsl:comment>
                <xsl:comment>####################################</xsl:comment>

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

                <sentenceGroup xml:id="rational">
                    <xsl:call-template name="sentenceWriter">
                        <xsl:with-param name="param1" as="element()+" select="$FP_rational"/>
                        <xsl:with-param name="param2" as="element()+" select="$MathOP_rational"/>
                        <xsl:with-param name="param3" as="element()+" select="$QO_rational"/>
                        <xsl:with-param name="scopeParam" as="xs:string"
                            select="$rationalScopeString"/>
                    </xsl:call-template>
                </sentenceGroup>


                <xsl:comment>####################################</xsl:comment>
                <xsl:comment>Knowledge Process Branch </xsl:comment>
                <xsl:comment>####################################</xsl:comment>


                <xsl:comment>####################################</xsl:comment>
                <xsl:comment>RATIONAL NUMBERS: Knowledge Process + Process Pred</xsl:comment>
                <xsl:comment>####################################</xsl:comment>

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
                <sentenceGroup xml:id="rational">
                    <xsl:call-template name="sentenceWriter">
                        <xsl:with-param name="param1" as="element()+" select="$KP_rational"/>
                        <xsl:with-param name="param2" as="element()+" select="$PrPred_rational"/>
                        <xsl:with-param name="scopeParam" as="xs:string"
                            select="$rationalScopeString"/>
                    </xsl:call-template>
                </sentenceGroup>


                <xsl:comment>####################################</xsl:comment>
                <xsl:comment>RATIONAL NUMBERS: Knowledge Process + Math Operation + Quant Object</xsl:comment>
                <xsl:comment>####################################</xsl:comment>

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

                <sentenceGroup xml:id="rational">
                    <xsl:call-template name="sentenceWriter">
                        <xsl:with-param name="param1" as="element()+" select="$KP_rational"/>
                        <xsl:with-param name="param2" as="element()+" select="$MathOP_rational"/>
                        <xsl:with-param name="param3" as="element()+" select="$QO_rational"/>
                        <xsl:with-param name="scopeParam" as="xs:string"
                            select="$rationalScopeString"/>
                    </xsl:call-template>
                </sentenceGroup>

            </xml>
        </xsl:result-document>


        <!--**************** ALGEBRAIC EXPRESSIONS SCOPE *********************************************-->
        <xsl:result-document method="xml" href="algebra_exp/algebraExpNestedOutput.xml">
            <xml>
                <xsl:comment>####################################</xsl:comment>
                <xsl:comment>Formal Process Branch </xsl:comment>
                <xsl:comment>####################################</xsl:comment>


                <xsl:comment>####################################</xsl:comment>
                <xsl:comment>ALGEBRAIC EXPRESSIONS: Formal Process + Process Predicate</xsl:comment>
                <xsl:comment>####################################</xsl:comment>

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

                <sentenceGroup xml:id="algexp">
                    <xsl:call-template name="sentenceWriter">
                        <xsl:with-param name="param1" as="element()+" select="$FP_algexp"/>
                        <xsl:with-param name="param2" as="element()+" select="$PrPred_algexp"/>
                        <xsl:with-param name="scopeParam" as="xs:string" select="$algexpScopeString"
                        />
                    </xsl:call-template>
                </sentenceGroup>



                <xsl:comment>####################################</xsl:comment>
                <xsl:comment>ALGEBRAIC EXPRESSIONS: Formal Process + Math Operation + Quant Object</xsl:comment>
                <xsl:comment>####################################</xsl:comment>

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

                <sentenceGroup xml:id="algexp">
                    <xsl:call-template name="sentenceWriter">
                        <xsl:with-param name="param1" as="element()+" select="$FP_algexp"/>
                        <xsl:with-param name="param2" as="element()+" select="$MathOP_algexp"/>
                        <xsl:with-param name="param3" as="element()+" select="$QO_algexp"/>
                        <xsl:with-param name="scopeParam" as="xs:string" select="$algexpScopeString"
                        />
                    </xsl:call-template>
                </sentenceGroup>


                <xsl:comment>####################################</xsl:comment>
                <xsl:comment>Knowledge Process Branch </xsl:comment>
                <xsl:comment>####################################</xsl:comment>


                <xsl:comment>####################################</xsl:comment>
                <xsl:comment>ALGEBRAIC EXPRESSIONS: Knowledge Process + Process Pred</xsl:comment>
                <xsl:comment>####################################</xsl:comment>

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
                <sentenceGroup xml:id="algexp">
                    <xsl:call-template name="sentenceWriter">
                        <xsl:with-param name="param1" as="element()+" select="$KP_algexp"/>
                        <xsl:with-param name="param2" as="element()+" select="$PrPred_algexp"/>
                        <xsl:with-param name="scopeParam" as="xs:string" select="$algexpScopeString"
                        />
                    </xsl:call-template>
                </sentenceGroup>



                <xsl:comment>####################################</xsl:comment>
                <xsl:comment>ALGEBRAIC EXPRESSIONS: Knowledge Process + Math Operation + Quant Object</xsl:comment>
                <xsl:comment>####################################</xsl:comment>

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

                <sentenceGroup xml:id="algexp">
                    <xsl:call-template name="sentenceWriter">
                        <xsl:with-param name="param1" as="element()+" select="$KP_algexp"/>
                        <xsl:with-param name="param2" as="element()+" select="$MathOP_algexp"/>
                        <xsl:with-param name="param3" as="element()+" select="$QO_algexp"/>
                        <xsl:with-param name="scopeParam" as="xs:string" select="$algexpScopeString"
                        />
                    </xsl:call-template>
                </sentenceGroup>
            </xml>
        </xsl:result-document>



        <!--**************** NUMERICAL EXPRESSIONS SCOPE *********************************************-->
        <xsl:result-document method="xml" href="numeric_exp/numericExpNestedOutput.xml">
            <xml>
                <xsl:comment>####################################</xsl:comment>
                <xsl:comment>Formal Process Branch </xsl:comment>
                <xsl:comment>####################################</xsl:comment>
                
                
                <xsl:comment>####################################</xsl:comment>
                <xsl:comment>NUMERICAL EXPRESSIONS: Formal Process + Process Predicate</xsl:comment>
                <xsl:comment>####################################</xsl:comment>
                
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
                
                <sentenceGroup xml:id="numexp">
                    <xsl:call-template name="sentenceWriter">
                        <xsl:with-param name="param1" as="element()+" select="$FP_numexp"/>
                        <xsl:with-param name="param2" as="element()+" select="$PrPred_numexp"/>
                        <xsl:with-param name="scopeParam" as="xs:string" select="$numexpScopeString"
                        />
                    </xsl:call-template>
                </sentenceGroup>
                
                
                
                <xsl:comment>####################################</xsl:comment>
                <xsl:comment>NUMERICAL EXPRESSIONS: Formal Process + Math Operation + Quant Object</xsl:comment>
                <xsl:comment>####################################</xsl:comment>
                
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
                
                <sentenceGroup xml:id="numexp">
                    <xsl:call-template name="sentenceWriter">
                        <xsl:with-param name="param1" as="element()+" select="$FP_numexp"/>
                        <xsl:with-param name="param2" as="element()+" select="$MathOP_numexp"/>
                        <xsl:with-param name="param3" as="element()+" select="$QO_numexp"/>
                        <xsl:with-param name="scopeParam" as="xs:string" select="$numexpScopeString"
                        />
                    </xsl:call-template>
                </sentenceGroup>
                
                
                <xsl:comment>####################################</xsl:comment>
                <xsl:comment>Knowledge Process Branch </xsl:comment>
                <xsl:comment>####################################</xsl:comment>
                
                
                <xsl:comment>####################################</xsl:comment>
                <xsl:comment>NUMERICAL EXPRESSIONS: Knowledge Process + Process Pred</xsl:comment>
                <xsl:comment>####################################</xsl:comment>
                
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
                <sentenceGroup xml:id="numexp">
                    <xsl:call-template name="sentenceWriter">
                        <xsl:with-param name="param1" as="element()+" select="$KP_numexp"/>
                        <xsl:with-param name="param2" as="element()+" select="$PrPred_numexp"/>
                        <xsl:with-param name="scopeParam" as="xs:string" select="$numexpScopeString"
                        />
                    </xsl:call-template>
                </sentenceGroup>
                
                
                
                <xsl:comment>####################################</xsl:comment>
                <xsl:comment>NUMERICAL EXPRESSIONS: Knowledge Process + Math Operation + Quant Object</xsl:comment>
                <xsl:comment>####################################</xsl:comment>
                
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
                
                <sentenceGroup xml:id="numexp">
                    <xsl:call-template name="sentenceWriter">
                        <xsl:with-param name="param1" as="element()+" select="$KP_numexp"/>
                        <xsl:with-param name="param2" as="element()+" select="$MathOP_numexp"/>
                        <xsl:with-param name="param3" as="element()+" select="$QO_numexp"/>
                        <xsl:with-param name="scopeParam" as="xs:string" select="$numexpScopeString"
                        />
                    </xsl:call-template>
                </sentenceGroup>
            </xml>
        </xsl:result-document>


    </xsl:template>

</xsl:stylesheet>
