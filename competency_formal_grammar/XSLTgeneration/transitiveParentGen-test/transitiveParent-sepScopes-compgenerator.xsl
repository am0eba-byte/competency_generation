<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="3.0">



    <!-- INCLUDED COMPETENCIES in this XSLT generator: 
        all K-5,  (not wholenums)
        Complex Nums, 
        Imaginary Nums, 
        Plane, 
        Space,
        Real Nums,
        Expected Values,
        Unit Fractions,
        Vectors,
        Specific Object Comps
        Math Practice Competencies
    -->

    <!-- input file: MERGEDcompetency-components.xml -->
    <!-- output file: mergedNestedSeedComps.xml -->

    <!-- <xsl:output method="xml" indent="yes"/>-->


    <!-- ebb: Here we have defined a series of global parameters that are just strings of text designed to match element names in the source document. Parameters are very similar to variables in XSLT, but have a little more flexibility.They could be received into this XSLT as input, so imagine these as INPUT PARAMETERS to this XSLT. -->

    <xsl:param name="formal_process" as="xs:string" select="'formalProcess'"/>
    <xsl:param name="knowledge_process" as="xs:string" select="'knowledgeProcess'"/>
    <xsl:param name="knowledge_subprocess" as="xs:string" select="'knowledgeSubprocess'"/>
    <xsl:param name="processPred" as="xs:string" select="'processPred'"/>
    <xsl:param name="specific_object" as="xs:string" select="'specificObject'"/>
    <xsl:param name="math_operation" as="xs:string" select="'mathOperation'"/>
    <xsl:param name="object" as="xs:string" select="'quant'"/>
    <xsl:param name="notationObject" as="xs:string" select="'notationObject'"/>
    <xsl:param name="mathPractComp" as="xs:string" select="'mathPractComp'"/>

    <!-- SCOPE PARAMS -->
    <!-- K-5 -->
    <xsl:param name="int" as="xs:string" select="'int'"/>
    <xsl:param name="rational" as="xs:string" select="'rational'"/>
    <xsl:param name="algexp" as="xs:string" select="'algexp'"/>
    <xsl:param name="numexp" as="xs:string" select="'numexp'"/>
    <!-- whole numbers -->
    <xsl:param name="wholenum" as="xs:string" select="'wholenum'"/>
    <!-- Other scopes -->
    <xsl:param name="complex" as="xs:string" select="'complex'"/>
    <xsl:param name="imag" as="xs:string" select="'imag'"/>
    <xsl:param name="plane" as="xs:string" select="'plane'"/>
    <xsl:param name="space" as="xs:string" select="'space'"/>

    <xsl:param name="expect" as="xs:string" select="'expect'"/>
    <xsl:param name="real" as="xs:string" select="'real'"/>
    <xsl:param name="unit" as="xs:string" select="'unit'"/>
    <xsl:param name="vector" as="xs:string" select="'vector'"/>
    <!-- scopes in progress -->

    <!-- scopes not filtered yet -->
    <xsl:param name="matrix" as="xs:string" select="'matrix'"/>
    <xsl:param name="infinite" as="xs:string" select="'infinite'"/>
    <xsl:param name="random" as="xs:string" select="'random'"/>
    <xsl:param name="prob" as="xs:string" select="'prob'"/>


    <!-- KEYS -->
    <!-- SCOPE KEYS -->
    <xsl:key name="scopes" match="string" use="@class ! tokenize(., '\s+')"/>

    <!-- NOTATION STRING KEY -->
    <xsl:key name="notationKey" match="string" use="@subclass ! normalize-space()"/>
    <!-- SUBCLASS NOTATION PARAMS -->
    <xsl:param name="notation" as="xs:string" select="'notation'"/>
    <xsl:param name="noNot" as="xs:string" select="'noNot'"/>

    <!-- SPECIFIC OBJECT COMPETENCY KEY -->
    <xsl:key name="specificKey" match="string" use="@specObj ! normalize-space()"/>
    <xsl:param name="specObj" as="xs:string" select="'true'"/>

    <!-- MATH PRACTICE COMPETENCIES KEY (no params - flat strings) -->
    <xsl:key name="mathPractCompKey" match="string" use="@MPC ! normalize-space()"/>
    <xsl:param name="mathPractString" as="xs:string" select="'true'"/>

    <!-- Mathop + Knowledge Process filtering key -->
    <xsl:key name="MathOpProcessFilter" match="string" use="@mathop ! normalize-space()"/>
    <xsl:param name="KPMathOp" as="xs:string" select="'true'"/>


    <!-- NON-WHOLE NUMBERS SENTENCE WRITER -->

    <xsl:template name="sentenceWriter" as="element()+">
        <xsl:param name="param1" as="element()*"/><!--  required="yes" -->
        <xsl:param name="param2" as="element()*"/>
        <xsl:param name="param3" as="element()*"/>
        <xsl:param name="param4" as="element()*"/>
        <xsl:param name="scopeParam" as="xs:string*"/>
        <xsl:param name="NOparam3" as="element()*"/>

        <!-- Purpose of the variables:
            TAKE THE NODES, CONVERT THEM TO STRINGS FOR SENTENCE CONSTRUCTION.
            -->
        <xsl:variable name="var1" as="xs:string+" select="$param1/parent::* ! name()"/>
        <xsl:variable name="var2" as="xs:string+" select="$param2/parent::* ! name()"/>
        <xsl:variable name="var3" as="xs:string*" select="$param3/parent::* ! name()"/>
        <xsl:variable name="var4" as="xs:string*" select="$param4/parent::* ! name()"/>
        <xsl:variable name="varNO" as="xs:string*" select="'notationObject'"/>
        <!-- add new variable(?) to insert scope string @ end of sentence -->
        <!--<xsl:variable name="scopeName" as="xs:string*" select="key('scopes', current())"/>-->

        <xsl:for-each select="$param1 ! normalize-space()">
            <xsl:variable name="currLevel1" as="xs:string" select="current()"/>
            <xsl:choose>
                <xsl:when test="$param2">
                    <xsl:for-each select="$param2 ! normalize-space()">

                        <xsl:variable name="currLevel2" as="xs:string?" select="current()"/>

                        <xsl:choose>

                            <xsl:when test="$param3">
                                <xsl:for-each select="$param3 ! normalize-space()">
                                    <xsl:variable name="currLevel3" as="xs:string?"
                                        select="current()"/>
                                    <xsl:choose>
                                        <xsl:when test="$param4">
                                            <!-- 4 param branch: always have notation objects -->
                                            <xsl:for-each select="$param4 ! normalize-space()">
                                                <xsl:variable name="currLevel4" as="xs:string?"
                                                  select="current()"/>
                                                <xsl:choose>
                                                  <xsl:when test="$scopeParam">
                                                  <xsl:for-each select="$scopeParam">
                                                  <xsl:variable name="scopeInsert" as="xs:string"
                                                  select="current()"/>
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
                                                  <xsl:sequence
                                                  select="concat('involving ', $scopeInsert)"/>
                                                  </xsl:element>
                                                  <xsl:element name="{$var4}">
                                                  <xsl:sequence select="$currLevel4"/>
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
                                        <xsl:otherwise>
                                            <!-- 3 param branch: without notation object -->
                                            <xsl:choose>
                                                <xsl:when test="$scopeParam">
                                                  <xsl:for-each select="$scopeParam">
                                                  <xsl:variable name="scopeInsert" as="xs:string"
                                                  select="current()"/>
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
                                                  <xsl:sequence
                                                  select="concat('involving ', $scopeInsert)"/>
                                                  </xsl:element>
                                                  </componentSentence>
                                                  </xsl:for-each>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <!-- 3-PARAM PARENT COMP (no scope string) -->
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
                                <xsl:choose>
                                    <xsl:when test="$NOparam3">
                                        <xsl:for-each select="$NOparam3">
                                            <!-- 3 param branch: with notation object -->
                                            <xsl:variable name="NO" as="xs:string?"
                                                select="current()"/>
                                            <xsl:for-each select="$scopeParam">
                                                <xsl:variable name="scopeInsert" as="xs:string"
                                                  select="current()"/>
                                                <componentSentence>
                                                  <xsl:element name="{$var1}">
                                                  <xsl:sequence select="$currLevel1"/>
                                                  </xsl:element>
                                                  <xsl:element name="{$var2}">
                                                  <xsl:sequence select="$currLevel2"/>
                                                  </xsl:element>
                                                  <xsl:element name="scopeName">
                                                  <xsl:sequence
                                                  select="concat('involving ', $scopeInsert)"/>
                                                  </xsl:element>
                                                  <xsl:element name="{$varNO}">
                                                  <xsl:sequence select="$NO"/>
                                                  </xsl:element>
                                                </componentSentence>

                                            </xsl:for-each>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <!-- 2 param branch: never have notation objects -->
                                        <xsl:choose>
                                            <xsl:when test="$scopeParam">
                                                <xsl:for-each select="$scopeParam">
                                                  <xsl:variable name="scopeInsert" as="xs:string"
                                                  select="current()"/>
                                                  <componentSentence>
                                                  <xsl:element name="{$var1}">
                                                  <xsl:sequence select="$currLevel1"/>
                                                  </xsl:element>
                                                  <xsl:element name="{$var2}">
                                                  <xsl:sequence select="$currLevel2"/>
                                                  </xsl:element>
                                                  <xsl:element name="scopeName">
                                                  <xsl:sequence
                                                  select="concat('involving ', $scopeInsert)"/>
                                                  </xsl:element>
                                                  </componentSentence>
                                                </xsl:for-each>
                                            </xsl:when>
                                            <xsl:otherwise>

                                                <!-- Specific Object Comp Path OR Parent Comp (no scopename) -->
                                                <componentSentence>
                                                  <xsl:element name="{$var1}">
                                                  <xsl:sequence select="$currLevel1"/>
                                                  </xsl:element>
                                                  <xsl:element name="{$var2}">
                                                  <xsl:sequence select="$currLevel2"/>
                                                  </xsl:element>
                                                </componentSentence>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <!-- Math Practice Competencies - flat strings -->
                    <componentSentence>
                        <xsl:element name="{$var1}">
                            <xsl:sequence select="$currLevel1"/>
                        </xsl:element>
                    </componentSentence>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>



    <xsl:template match="/">
        <!-- <xml>-->

        <!-- UNFILTERED (no scope keys) COMPETENCIES -->
        <!--       
        <xsl:result-document method="xml" indent="yes"
            href="unfilteredComps/mathPractSpecObjNestedOutput.xml">
            <xml>
                <xsl:comment>####################################</xsl:comment>
                <xsl:comment>Math Practice (unfiltered) Competencies</xsl:comment>
                <xsl:comment>####################################</xsl:comment>

                <compGroup id="mathPractice">
                    <xsl:variable name="mathPract" as="element()+">
                        <xsl:for-each select="key('mathPractCompKey', $mathPractString)">
                            <xsl:sequence select=".[parent::* ! name() = $mathPractComp]"/>
                        </xsl:for-each>
                    </xsl:variable>

                    <sentenceGroup id="flat-strings">
                        <xsl:call-template name="sentenceWriter">
                            <xsl:with-param name="param1" as="element()+" select="$mathPract"/>
                        </xsl:call-template>
                    </sentenceGroup>
                </compGroup>


                <xsl:comment>####################################</xsl:comment>
                <xsl:comment>Specific Object Competencies</xsl:comment>
                <xsl:comment>####################################</xsl:comment>

                <compGroup id="specificObject">
                    <xsl:comment>####################################</xsl:comment>
                    <xsl:comment>Formal Process + Specific Object</xsl:comment>
                    <xsl:comment>####################################</xsl:comment>
                    <xsl:variable name="FP" as="element()+">
                        <xsl:for-each select="key('specificKey', $specObj)">
                            <xsl:sequence select=".[parent::* ! name() = $formal_process]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="SP" as="element()+">
                        <xsl:for-each select="key('specificKey', $specObj)">
                            <xsl:sequence select=".[parent::* ! name() = $specific_object]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <sentenceGroup id="fp-sp">
                        <xsl:call-template name="sentenceWriter">
                            <xsl:with-param name="param1" as="element()+" select="$FP"/>
                            <xsl:with-param name="param2" as="element()+" select="$SP"/>
                        </xsl:call-template>
                    </sentenceGroup>


                    <xsl:comment>####################################</xsl:comment>
                    <xsl:comment>Knowledge Process + Specific Object</xsl:comment>
                    <xsl:comment>####################################</xsl:comment>
                    <xsl:variable name="KP" as="element()+">
                        <xsl:for-each select="key('specificKey', $specObj)">
                            <xsl:sequence select=".[parent::* ! name() = $knowledge_process]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="SP" as="element()+">
                        <xsl:for-each select="key('specificKey', $specObj)">
                            <xsl:sequence select=".[parent::* ! name() = $specific_object]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <sentenceGroup id="kp-sp">
                        <xsl:call-template name="sentenceWriter">
                            <xsl:with-param name="param1" as="element()+" select="$KP"/>
                            <xsl:with-param name="param2" as="element()+" select="$SP"/>
                        </xsl:call-template>
                    </sentenceGroup>
                </compGroup>
            </xml>
        </xsl:result-document>
-->

        <!-- ************************* K-5 COMPETENCIES ******************************* -->

        <xsl:result-document method="xml" indent="yes" href="integers/integersNestedOutput-TP.xml">
            <xml>
                <xsl:comment>****************************************************</xsl:comment>
                <xsl:comment>*************** INTEGERS SCOPE *****************</xsl:comment>
                <xsl:comment>****************************************************</xsl:comment>

                <scopeGroup id="integers">
                    <parent group="fp-pp">
                        <xsl:comment>INTEGERS: Formal Process(noNotObj) + Process Predicate</xsl:comment>

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
                        <parentGroup match="fp-pp" lvl="1">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$FPint"/>
                                <xsl:with-param name="param2" as="element()+" select="$PrPredint"/>
                            </xsl:call-template>
                        </parentGroup>
                        <compGroup id="fp-pp">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$FPint"/>
                                <xsl:with-param name="param2" as="element()+" select="$PrPredint"/>
                                <xsl:with-param name="scopeParam" as="xs:string"
                                    select="$intScopeString"/>
                            </xsl:call-template>
                        </compGroup>


                        <xsl:comment>####################################</xsl:comment>
                        <xsl:comment>INTEGERS: Formal Process (keyed to notation) + Process Predicate + Notation Object</xsl:comment>
                        <xsl:comment>####################################</xsl:comment>

                        <xsl:variable name="FPint" as="element()+">

                            <xsl:for-each
                                select="key('scopes', $int) intersect key('notationKey', $notation)">
                                <xsl:sequence select=".[parent::* ! name() = $formal_process]"/>
                            </xsl:for-each>
                        </xsl:variable>
                        <xsl:variable name="PrPredint" as="element()+">
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

                        <notationParent>
                            <parentGroup match="fp-pp-no" lvl="2">
                                <xsl:call-template name="sentenceWriter">
                                    <xsl:with-param name="param1" as="element()+" select="$FPint"/>
                                    <xsl:with-param name="param2" as="element()+"
                                        select="$PrPredint"/>
                                    <xsl:with-param name="param3" as="element()+" select="$NO_int"/>
                                </xsl:call-template>
                            </parentGroup>
                            <compGroup id="fp-pp-no">
                                <xsl:call-template name="sentenceWriter">
                                    <xsl:with-param name="param1" as="element()+" select="$FPint"/>
                                    <xsl:with-param name="param2" as="element()+"
                                        select="$PrPredint"/>
                                    <xsl:with-param name="NOparam3" as="element()+" select="$NO_int"/>
                                    <xsl:with-param name="scopeParam" as="xs:string"
                                        select="$intScopeString"/>
                                </xsl:call-template>
                            </compGroup>

                        </notationParent>

                    </parent>

                    <parent group="fp-mathop">
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


                        <parentGroup match="fp-mathop" lvl="1">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$FPint"/>
                                <xsl:with-param name="param2" as="element()+" select="$MathOpint"/>
                                <xsl:with-param name="param3" as="element()+" select="$QOint"/>
                            </xsl:call-template>
                        </parentGroup>
                        <compGroup id="fp-mathop">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$FPint"/>
                                <xsl:with-param name="param2" as="element()+" select="$MathOpint"/>
                                <xsl:with-param name="param3" as="element()+" select="$QOint"/>
                                <xsl:with-param name="scopeParam" as="xs:string"
                                    select="$intScopeString"/>
                            </xsl:call-template>
                        </compGroup>


                        <xsl:comment>####################################</xsl:comment>
                        <xsl:comment>INTEGERS: Formal Process (keyed to notation) + Math Operation + Quant Object + Notation Object</xsl:comment>
                        <xsl:comment>####################################</xsl:comment>

                        <xsl:variable name="FPint" as="element()+">
                            <xsl:for-each
                                select="key('scopes', $int) intersect key('notationKey', $notation)">
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
                        <xsl:variable name="NO_int" as="element()+">
                            <xsl:for-each select="key('scopes', $int)">
                                <xsl:sequence select=".[parent::* ! name() = $notationObject]"/>
                            </xsl:for-each>
                        </xsl:variable>
                        <xsl:variable name="intScopeString" select="'Integers'"/>
                        <notationParent>
                            <parentGroup match="fp-mathop-no" lvl="2">
                                <xsl:call-template name="sentenceWriter">
                                    <xsl:with-param name="param1" as="element()+" select="$FPint"/>
                                    <xsl:with-param name="param2" as="element()+"
                                        select="$MathOpint"/>
                                    <xsl:with-param name="param3" as="element()+" select="$QOint"/>
                                    <xsl:with-param name="param4" as="element()+" select="$NO_int"/>
                                </xsl:call-template>
                            </parentGroup>
                            <compGroup id="fp-mathop-no">
                                <xsl:call-template name="sentenceWriter">
                                    <xsl:with-param name="param1" as="element()+" select="$FPint"/>
                                    <xsl:with-param name="param2" as="element()+"
                                        select="$MathOpint"/>
                                    <xsl:with-param name="param3" as="element()+" select="$QOint"/>
                                    <xsl:with-param name="param4" as="element()+" select="$NO_int"/>
                                    <xsl:with-param name="scopeParam" as="xs:string"
                                        select="$intScopeString"/>
                                </xsl:call-template>
                            </compGroup>
                        </notationParent>
                    </parent>

                    <xsl:comment>####################################</xsl:comment>
                    <xsl:comment>INTEGERS: Knowledge Process + Process Pred</xsl:comment>
                    <xsl:comment>####################################</xsl:comment>

                    <xsl:variable name="KP_int" as="element()+">
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

                    <parent group="kp-pp">
                        <parentGroup match="kp-pp" lvl="1">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$KP_int"/>
                                <xsl:with-param name="param2" as="element()+" select="$PrPredint"/>

                            </xsl:call-template>
                        </parentGroup>
                        <compGroup id="kp-pp">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$KP_int"/>
                                <xsl:with-param name="param2" as="element()+" select="$PrPredint"/>
                                <xsl:with-param name="scopeParam" as="xs:string"
                                    select="$intScopeString"/>
                            </xsl:call-template>
                        </compGroup>
                    </parent>
                    <xsl:comment>####################################</xsl:comment>
                    <xsl:comment>INTEGERS: Knowledge Process + Math Operation + Quant Object</xsl:comment>
                    <xsl:comment>####################################</xsl:comment>

                    <xsl:variable name="KP_int" as="element()+">
                        <xsl:for-each
                            select="key('scopes', $int) intersect key('MathOpProcessFilter', $KPMathOp)">
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

                    <parent group="kp-mathop">
                        <parentGroup match="kp-mathop" lvl="1">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$KP_int"/>
                                <xsl:with-param name="param2" as="element()+" select="$MathOpint"/>
                                <xsl:with-param name="param3" as="element()+" select="$QOint"/>
                            </xsl:call-template>
                        </parentGroup>
                        <compGroup id="kp-mathop">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$KP_int"/>
                                <xsl:with-param name="param2" as="element()+" select="$MathOpint"/>
                                <xsl:with-param name="param3" as="element()+" select="$QOint"/>
                                <xsl:with-param name="scopeParam" as="xs:string"
                                    select="$intScopeString"/>
                            </xsl:call-template>
                        </compGroup>
                    </parent>
                </scopeGroup>
            </xml>
        </xsl:result-document>


        <xsl:result-document method="xml" indent="yes" href="rational_nums/rationalNestedOutput-TP.xml">
            <xml>
                <xsl:comment>********************************************************</xsl:comment>
                <xsl:comment>************** RATIONAL NUMBERS SCOPE ******************</xsl:comment>
                <xsl:comment>********************************************************</xsl:comment>
                <scopeGroup id="rational">

                    <xsl:comment>####################################</xsl:comment>
                    <xsl:comment>RATIONAL NUMBERS: Formal Process(noNotObj) + Process Predicate</xsl:comment>
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
                    <parent group="fp-pp">
                        <parentGroup match="fp-pp" lvl="1">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$FP_rational"/>
                                <xsl:with-param name="param2" as="element()+"
                                    select="$PrPred_rational"/>
                            </xsl:call-template>
                        </parentGroup>
                        <compGroup id="fp-pp">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$FP_rational"/>
                                <xsl:with-param name="param2" as="element()+"
                                    select="$PrPred_rational"/>
                                <xsl:with-param name="scopeParam" as="xs:string"
                                    select="$rationalScopeString"/>
                            </xsl:call-template>
                        </compGroup>


                        <xsl:comment>####################################</xsl:comment>
                        <xsl:comment>RATIONAL NUMBERS: Formal Process (keyed to notation) + Process Predicate + Notation Object</xsl:comment>
                        <xsl:comment>####################################</xsl:comment>

                        <xsl:variable name="FP_rational" as="element()+">
                            <xsl:for-each
                                select="key('scopes', $rational) intersect key('notationKey', $notation)">
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
                        <notationParent>
                            <parentGroup match="fp-pp-no" lvl="2">
                                <xsl:call-template name="sentenceWriter">
                                    <xsl:with-param name="param1" as="element()+"
                                        select="$FP_rational"/>
                                    <xsl:with-param name="param2" as="element()+"
                                        select="$PrPred_rational"/>
                                    <xsl:with-param name="param3" as="element()+"
                                        select="$NO_rational"/>
                                </xsl:call-template>
                            </parentGroup>
                            <compGroup id="fp-pp-no">
                                <xsl:call-template name="sentenceWriter">
                                    <xsl:with-param name="param1" as="element()+"
                                        select="$FP_rational"/>
                                    <xsl:with-param name="param2" as="element()+"
                                        select="$PrPred_rational"/>
                                    <xsl:with-param name="NOparam3" as="element()+"
                                        select="$NO_rational"/>
                                    <xsl:with-param name="scopeParam" as="xs:string"
                                        select="$rationalScopeString"/>
                                </xsl:call-template>
                            </compGroup>
                        </notationParent>
                    </parent>

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
                    <parent group="fp-mathop">
                        <parentGroup match="fp-mathop" lvl="1">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$FP_rational"/>
                                <xsl:with-param name="param2" as="element()+"
                                    select="$MathOP_rational"/>
                                <xsl:with-param name="param3" as="element()+" select="$QO_rational"
                                />
                            </xsl:call-template>
                        </parentGroup>
                        <compGroup id="fp-mathop">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$FP_rational"/>
                                <xsl:with-param name="param2" as="element()+"
                                    select="$MathOP_rational"/>
                                <xsl:with-param name="param3" as="element()+" select="$QO_rational"/>
                                <xsl:with-param name="scopeParam" as="xs:string"
                                    select="$rationalScopeString"/>
                            </xsl:call-template>
                        </compGroup>



                        <xsl:comment>####################################</xsl:comment>
                        <xsl:comment>RATIONAL NUMBERS: Formal Process (keyed to notation) + Math Operation + Quant Object + Notation Object</xsl:comment>
                        <xsl:comment>####################################</xsl:comment>

                        <xsl:variable name="FP_rational" as="element()+">
                            <xsl:for-each
                                select="key('scopes', $rational) intersect key('notationKey', $notation)">
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
                        <notationParent>
                            <parentGroup match="fp-mathop-no" lvl="2">
                                <xsl:call-template name="sentenceWriter">
                                    <xsl:with-param name="param1" as="element()+"
                                        select="$FP_rational"/>
                                    <xsl:with-param name="param2" as="element()+"
                                        select="$MathOP_rational"/>
                                    <xsl:with-param name="param3" as="element()+"
                                        select="$QO_rational"/>
                                    <xsl:with-param name="param4" as="element()+"
                                        select="$NO_rational"/>
                                </xsl:call-template>
                            </parentGroup>
                            <compGroup id="fp-mathop-no">
                                <xsl:call-template name="sentenceWriter">
                                    <xsl:with-param name="param1" as="element()+"
                                        select="$FP_rational"/>
                                    <xsl:with-param name="param2" as="element()+"
                                        select="$MathOP_rational"/>
                                    <xsl:with-param name="param3" as="element()+"
                                        select="$QO_rational"/>
                                    <xsl:with-param name="param4" as="element()+"
                                        select="$NO_rational"/>
                                    <xsl:with-param name="scopeParam" as="xs:string"
                                        select="$rationalScopeString"/>
                                </xsl:call-template>
                            </compGroup>
                        </notationParent>
                    </parent>




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
                    <parent group="kp-pp">
                        <parentGroup match="kp-pp" lvl="1">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$KP_rational"/>
                                <xsl:with-param name="param2" as="element()+"
                                    select="$PrPred_rational"/>
                            </xsl:call-template>
                        </parentGroup>
                        <compGroup id="kp-pp">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$KP_rational"/>
                                <xsl:with-param name="param2" as="element()+"
                                    select="$PrPred_rational"/>
                                <xsl:with-param name="scopeParam" as="xs:string"
                                    select="$rationalScopeString"/>
                            </xsl:call-template>
                        </compGroup>
                    </parent>

                    <xsl:comment>####################################</xsl:comment>
                    <xsl:comment>RATIONAL NUMBERS: Knowledge Process + Math Operation + Quant Object</xsl:comment>
                    <xsl:comment>####################################</xsl:comment>

                    <xsl:variable name="KP_rational" as="element()+">
                        <xsl:for-each
                            select="key('scopes', $rational) intersect key('MathOpProcessFilter', $KPMathOp)">
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
                    <parent group="kp-mathop">
                        <parentGroup match="kp-mathop" lvl="1">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$KP_rational"/>
                                <xsl:with-param name="param2" as="element()+"
                                    select="$MathOP_rational"/>
                                <xsl:with-param name="param3" as="element()+" select="$QO_rational"
                                />
                            </xsl:call-template>
                        </parentGroup>
                        <compGroup id="kp-mathop">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$KP_rational"/>
                                <xsl:with-param name="param2" as="element()+"
                                    select="$MathOP_rational"/>
                                <xsl:with-param name="param3" as="element()+" select="$QO_rational"/>
                                <xsl:with-param name="scopeParam" as="xs:string"
                                    select="$rationalScopeString"/>
                            </xsl:call-template>
                        </compGroup>
                    </parent>
                </scopeGroup>
            </xml>
        </xsl:result-document>


        <xsl:result-document method="xml" indent="yes" href="algebra_exp/algebraExpNestedOutput-TP.xml">
            <xml>
                <xsl:comment>**************************************************************</xsl:comment>
                <xsl:comment>**************** ALGEBRAIC EXPRESSIONS SCOPE ***********</xsl:comment>
                <xsl:comment>**************************************************************</xsl:comment>
                <scopeGroup id="algexp">
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
                    <parent group="fp-pp">
                        <parentGroup match="fp-pp" lvl="1">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$FP_algexp"/>
                                <xsl:with-param name="param2" as="element()+"
                                    select="$PrPred_algexp"/>
                            </xsl:call-template>
                        </parentGroup>
                        <compGroup id="fp-pp">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$FP_algexp"/>
                                <xsl:with-param name="param2" as="element()+"
                                    select="$PrPred_algexp"/>
                                <xsl:with-param name="scopeParam" as="xs:string"
                                    select="$algexpScopeString"/>
                            </xsl:call-template>
                        </compGroup>
                    </parent>
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
                    <parent group="fp-mathop">
                        <parentGroup match="fp-mathop" lvl="1">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$FP_algexp"/>
                                <xsl:with-param name="param2" as="element()+"
                                    select="$MathOP_algexp"/>
                                <xsl:with-param name="param3" as="element()+" select="$QO_algexp"/>
                            </xsl:call-template>
                        </parentGroup>
                        <compGroup id="fp-mathop">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$FP_algexp"/>
                                <xsl:with-param name="param2" as="element()+"
                                    select="$MathOP_algexp"/>
                                <xsl:with-param name="param3" as="element()+" select="$QO_algexp"/>
                                <xsl:with-param name="scopeParam" as="xs:string"
                                    select="$algexpScopeString"/>
                            </xsl:call-template>
                        </compGroup>
                    </parent>
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
                    <parent group="kp-pp">
                        <parentGroup match="kp-pp" lvl="1">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$KP_algexp"/>
                                <xsl:with-param name="param2" as="element()+"
                                    select="$PrPred_algexp"/>
                            </xsl:call-template>
                        </parentGroup>
                        <compGroup id="kp-pp">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$KP_algexp"/>
                                <xsl:with-param name="param2" as="element()+"
                                    select="$PrPred_algexp"/>
                                <xsl:with-param name="scopeParam" as="xs:string"
                                    select="$algexpScopeString"/>
                            </xsl:call-template>
                        </compGroup>
                    </parent>
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
                    <parent group="kp-mathop">
                        <parentGroup match="kp-mathop" lvl="1">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$KP_algexp"/>
                                <xsl:with-param name="param2" as="element()+"
                                    select="$MathOP_algexp"/>
                                <xsl:with-param name="param3" as="element()+" select="$QO_algexp"/>
                            </xsl:call-template>
                        </parentGroup>
                        <compGroup id="kp-mathop">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$KP_algexp"/>
                                <xsl:with-param name="param2" as="element()+"
                                    select="$MathOP_algexp"/>
                                <xsl:with-param name="param3" as="element()+" select="$QO_algexp"/>
                                <xsl:with-param name="scopeParam" as="xs:string"
                                    select="$algexpScopeString"/>
                            </xsl:call-template>
                        </compGroup>
                    </parent>
                </scopeGroup>
            </xml>
        </xsl:result-document>



        <xsl:result-document method="xml" indent="yes" href="numeric_exp/numericExpNestedOutput-TP.xml">
            <xml>
                <xsl:comment>*************************************************************************</xsl:comment>
                <xsl:comment>**************** NUMERICAL EXPRESSIONS SCOPE ***************</xsl:comment>
                <xsl:comment>*************************************************************************</xsl:comment>
                <scopeGroup id="numexp">
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
                    <parent group="fp-pp">
                        <parentGroup match="fp-pp" lvl="1">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$FP_numexp"/>
                                <xsl:with-param name="param2" as="element()+"
                                    select="$PrPred_numexp"/>
                            </xsl:call-template>
                        </parentGroup>
                        <compGroup id="fp-pp">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$FP_numexp"/>
                                <xsl:with-param name="param2" as="element()+"
                                    select="$PrPred_numexp"/>
                                <xsl:with-param name="scopeParam" as="xs:string"
                                    select="$numexpScopeString"/>
                            </xsl:call-template>
                        </compGroup>

                    </parent>
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
                    <parent group="fp-mathop">
                        <parentGroup match="fp-mathop" lvl="1">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$FP_numexp"/>
                                <xsl:with-param name="param2" as="element()+"
                                    select="$MathOP_numexp"/>
                                <xsl:with-param name="param3" as="element()+" select="$QO_numexp"/>
                            </xsl:call-template>
                        </parentGroup>
                        <compGroup id="fp-mathop">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$FP_numexp"/>
                                <xsl:with-param name="param2" as="element()+"
                                    select="$MathOP_numexp"/>
                                <xsl:with-param name="param3" as="element()+" select="$QO_numexp"/>
                                <xsl:with-param name="scopeParam" as="xs:string"
                                    select="$numexpScopeString"/>
                            </xsl:call-template>
                        </compGroup>
                    </parent>
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
                    <parent group="kp-pp">
                        <parentGroup match="kp-pp" lvl="1">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$KP_numexp"/>
                                <xsl:with-param name="param2" as="element()+"
                                    select="$PrPred_numexp"/>
                            </xsl:call-template>
                        </parentGroup>
                        <compGroup id="kp-pp">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$KP_numexp"/>
                                <xsl:with-param name="param2" as="element()+"
                                    select="$PrPred_numexp"/>
                                <xsl:with-param name="scopeParam" as="xs:string"
                                    select="$numexpScopeString"/>
                            </xsl:call-template>
                        </compGroup>
                    </parent>


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
                    <parent group="kp-mathop">
                        <parentGroup match="kp-mathop" lvl="1">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$KP_numexp"/>
                                <xsl:with-param name="param2" as="element()+"
                                    select="$MathOP_numexp"/>
                                <xsl:with-param name="param3" as="element()+" select="$QO_numexp"/>
                            </xsl:call-template>
                        </parentGroup>
                        <compGroup id="kp-mathop">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$KP_numexp"/>
                                <xsl:with-param name="param2" as="element()+"
                                    select="$MathOP_numexp"/>
                                <xsl:with-param name="param3" as="element()+" select="$QO_numexp"/>
                                <xsl:with-param name="scopeParam" as="xs:string"
                                    select="$numexpScopeString"/>
                            </xsl:call-template>
                        </compGroup>
                    </parent>
                </scopeGroup>
            </xml>
        </xsl:result-document>


        <!-- **************** ALL OTHER SCOPES (NOT K-5) *********************************** -->

        <!--   <xsl:comment>~~~~~~~~~~~~~~~~~~~~~~~~~ NON-K5 SCOPES~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~</xsl:comment>-->

        <xsl:result-document method="xml" indent="yes" href="complex_nums/complexNestedOutput-TP.xml">
            <xml>
                <xsl:comment>*******************************************************</xsl:comment>
                <xsl:comment>**************** COMPLEX NUMBERS SCOPE **************************</xsl:comment>
                <xsl:comment>*******************************************************************</xsl:comment>
                <scopeGroup id="complex">

                    <xsl:comment>####################################</xsl:comment>
                    <xsl:comment>COMPLEX NUMBERS: Formal Process + Process Predicate</xsl:comment>
                    <xsl:comment>####################################</xsl:comment>
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
                    <parent group="fp-pp">
                        <parentGroup match="fp-pp" lvl="1">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$FPcomplex"/>
                                <xsl:with-param name="param2" as="element()+"
                                    select="$PrPredcomplex"/>
                            </xsl:call-template>
                        </parentGroup>
                        <compGroup id="fp-pp">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$FPcomplex"/>
                                <xsl:with-param name="param2" as="element()+"
                                    select="$PrPredcomplex"/>
                                <xsl:with-param name="scopeParam" as="xs:string"
                                    select="$complexScopeString"/>
                            </xsl:call-template>
                        </compGroup>
                    </parent>
                    <xsl:comment>####################################</xsl:comment>
                    <xsl:comment>COMPLEX NUMBERS: Formal Process + Math Operation + Quant Object</xsl:comment>
                    <xsl:comment>####################################</xsl:comment>
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
                    <parent group="fp-mathop">
                        <parentGroup match="fp-mathop" lvl="1">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$FPcomplex"/>
                                <xsl:with-param name="param2" as="element()+"
                                    select="$MathOpcomplex"/>
                                <xsl:with-param name="param3" as="element()+" select="$QOcomplex"/>
                            </xsl:call-template>
                        </parentGroup>
                        <compGroup id="fp-mathop">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$FPcomplex"/>
                                <xsl:with-param name="param2" as="element()+"
                                    select="$MathOpcomplex"/>
                                <xsl:with-param name="param3" as="element()+" select="$QOcomplex"/>
                                <xsl:with-param name="scopeParam" as="xs:string"
                                    select="$complexScopeString"/>
                            </xsl:call-template>
                        </compGroup>
                    </parent>

                    <xsl:comment>####################################</xsl:comment>
                    <xsl:comment>COMPLEX NUMBERS: Knowledge Process + Process Pred</xsl:comment>
                    <xsl:comment>####################################</xsl:comment>
                    <xsl:variable name="KP_complex" as="element()+">
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
                    <parent group="kp-pp">
                        <parentGroup match="kp-pp" lvl="1">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$KP_complex"/>
                                <xsl:with-param name="param2" as="element()+"
                                    select="$PrPredcomplex"/>
                            </xsl:call-template>
                        </parentGroup>
                        <compGroup id="kp-pp">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$KP_complex"/>
                                <xsl:with-param name="param2" as="element()+"
                                    select="$PrPredcomplex"/>
                                <xsl:with-param name="scopeParam" as="xs:string"
                                    select="$complexScopeString"/>
                            </xsl:call-template>
                        </compGroup>
                    </parent>
                    <xsl:comment>####################################</xsl:comment>
                    <xsl:comment>COMPLEX NUMBERS: Knowledge Process + Math Operation + Quant Object</xsl:comment>
                    <xsl:comment>####################################</xsl:comment>
                    <xsl:variable name="KP_complex" as="element()+">
                        <xsl:for-each
                            select="key('scopes', $complex) intersect key('MathOpProcessFilter', $KPMathOp)">
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

                    <parent group="kp-mathop">
                        <parentGroup match="kp-mathop" lvl="1">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$KP_complex"/>
                                <xsl:with-param name="param2" as="element()+"
                                    select="$MathOpcomplex"/>
                                <xsl:with-param name="param3" as="element()+" select="$QOcomplex"/>
                            </xsl:call-template>
                        </parentGroup>
                        <compGroup id="kp-mathop">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$KP_complex"/>
                                <xsl:with-param name="param2" as="element()+"
                                    select="$MathOpcomplex"/>
                                <xsl:with-param name="param3" as="element()+" select="$QOcomplex"/>
                                <xsl:with-param name="scopeParam" as="xs:string"
                                    select="$complexScopeString"/>
                            </xsl:call-template>
                        </compGroup>
                    </parent>
                </scopeGroup>
            </xml>
        </xsl:result-document>


        <xsl:result-document method="xml" indent="yes" href="imaginary_nums/imaginaryNestedOutput-TP.xml">
            <xml>
                <xsl:comment>****************************************************************</xsl:comment>
                <xsl:comment>************** IMAGINARY NUMBERS SCOPE *****************</xsl:comment>
                <xsl:comment>*****************************************************************</xsl:comment>
                <scopeGroup id="imaginary">

                    <xsl:comment>####################################</xsl:comment>
                    <xsl:comment>IMAGINARY NUMBERS: Formal Process + Process Predicate</xsl:comment>
                    <xsl:comment>####################################</xsl:comment>

                    <xsl:variable name="FPimag" as="element()+">
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
<parent group="fp-pp">
                    <parentGroup match="fp-pp" lvl="1">
                        <xsl:call-template name="sentenceWriter">
                            <xsl:with-param name="param1" as="element()+" select="$FPimag"/>
                            <xsl:with-param name="param2" as="element()+" select="$PrPredimag"/>
                        </xsl:call-template>
                    </parentGroup>
                    <compGroup id="fp-pp">
                        <xsl:call-template name="sentenceWriter">
                            <xsl:with-param name="param1" as="element()+" select="$FPimag"/>
                            <xsl:with-param name="param2" as="element()+" select="$PrPredimag"/>
                            <xsl:with-param name="scopeParam" as="xs:string"
                                select="$imagScopeString"/>
                        </xsl:call-template>
                    </compGroup>
                    </parent>
                    <xsl:comment>####################################</xsl:comment>
                    <xsl:comment>IMAGINARY NUMBERS: Formal Process + Math Operation + Quant Object </xsl:comment>
                    <xsl:comment>####################################</xsl:comment>

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
<parent group="fp-mathop">
                    <parentGroup match="fp-mathop" lvl="1">
                        <xsl:call-template name="sentenceWriter">
                            <xsl:with-param name="param1" as="element()+" select="$FPimag"/>
                            <xsl:with-param name="param2" as="element()+" select="$MathOpimag"/>
                            <xsl:with-param name="param3" as="element()+" select="$QOimag"/>
                        </xsl:call-template>
                    </parentGroup>
                    <compGroup id="fp-mathop">
                        <xsl:call-template name="sentenceWriter">
                            <xsl:with-param name="param1" as="element()+" select="$FPimag"/>
                            <xsl:with-param name="param2" as="element()+" select="$MathOpimag"/>
                            <xsl:with-param name="param3" as="element()+" select="$QOimag"/>
                            <xsl:with-param name="scopeParam" as="xs:string"
                                select="$imagScopeString"/>
                        </xsl:call-template>
                    </compGroup>
</parent>
                    <xsl:comment>####################################</xsl:comment>
                    <xsl:comment>IMAGINARY NUMBERS: Knowledge Process + Process Pred</xsl:comment>
                    <xsl:comment>####################################</xsl:comment>

                    <xsl:variable name="KP_imag" as="element()+">
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
                    <parent group="kp-pp">
                    <parentGroup match="kp-pp" lvl="1">
                        <xsl:call-template name="sentenceWriter">
                            <xsl:with-param name="param1" as="element()+" select="$KP_imag"/>
                            <xsl:with-param name="param2" as="element()+" select="$PrPredimag"/>
                        </xsl:call-template>
                    </parentGroup>
                    <compGroup id="kp-pp">
                        <xsl:call-template name="sentenceWriter">
                            <xsl:with-param name="param1" as="element()+" select="$KP_imag"/>
                            <xsl:with-param name="param2" as="element()+" select="$PrPredimag"/>
                            <xsl:with-param name="scopeParam" as="xs:string"
                                select="$imagScopeString"/>
                        </xsl:call-template>
                    </compGroup>
                    </parent>
                    <xsl:comment>####################################</xsl:comment>
                    <xsl:comment>IMAGINARY NUMBERS: Knowledge Process + Math Operation + Quant Object </xsl:comment>
                    <xsl:comment>####################################</xsl:comment>

                    <xsl:variable name="KP_imag" as="element()+">
                        <xsl:for-each
                            select="key('scopes', $imag) intersect key('MathOpProcessFilter', $KPMathOp)">
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
<parent group="kp-mathop">
                    <parentGroup match="kp-mathop" lvl="1">
                        <xsl:call-template name="sentenceWriter">
                            <xsl:with-param name="param1" as="element()+" select="$KP_imag"/>
                            <xsl:with-param name="param2" as="element()+" select="$MathOpimag"/>
                            <xsl:with-param name="param3" as="element()+" select="$QOimag"/>
                        </xsl:call-template>
                    </parentGroup>
                    <compGroup id="kp-mathop">
                        <xsl:call-template name="sentenceWriter">
                            <xsl:with-param name="param1" as="element()+" select="$KP_imag"/>
                            <xsl:with-param name="param2" as="element()+" select="$MathOpimag"/>
                            <xsl:with-param name="param3" as="element()+" select="$QOimag"/>
                            <xsl:with-param name="scopeParam" as="xs:string"
                                select="$imagScopeString"/>
                        </xsl:call-template>
                    </compGroup>
</parent>
                </scopeGroup>
            </xml>
        </xsl:result-document>


        <xsl:result-document method="xml" indent="yes" href="space/spaceNestedOutput-TP.xml">
            <xml>
                <xsl:comment>**************************************************************</xsl:comment>
                <xsl:comment>**************** SPACE SCOPE **************************</xsl:comment>
                <xsl:comment>***************************************************************</xsl:comment>

                <scopeGroup id="space">
                    <xsl:comment>####################################</xsl:comment>
                    <xsl:comment>SPACE: Formal Process + Process Predicate</xsl:comment>
                    <xsl:comment>####################################</xsl:comment>

                    <xsl:variable name="FP_space" as="element()+">

                        <xsl:for-each select="key('scopes', $space)">
                            <xsl:sequence select=".[parent::* ! name() = $formal_process]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="PrPred_space" as="element()+">
                        <xsl:for-each select="key('scopes', $space)">
                            <xsl:sequence select=".[parent::* ! name() = $processPred]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="spaceScopeString" select="'Space'"/>
<parent group="fp-pp">
                    <parentGroup match="fp-pp" lvl="1">
                        <xsl:call-template name="sentenceWriter">
                            <xsl:with-param name="param1" as="element()+" select="$FP_space"/>
                            <xsl:with-param name="param2" as="element()+" select="$PrPred_space"/>
                        </xsl:call-template>
                    </parentGroup>
                    <compGroup id="fp-pp">
                        <xsl:call-template name="sentenceWriter">
                            <xsl:with-param name="param1" as="element()+" select="$FP_space"/>
                            <xsl:with-param name="param2" as="element()+" select="$PrPred_space"/>
                            <xsl:with-param name="scopeParam" as="xs:string"
                                select="$spaceScopeString"/>
                        </xsl:call-template>
                    </compGroup>
</parent>


                    <xsl:comment>####################################</xsl:comment>
                    <xsl:comment>SPACE: Formal Process + Math Operation + Quant Object</xsl:comment>
                    <xsl:comment>####################################</xsl:comment>

                    <xsl:variable name="FP_space" as="element()+">
                        <xsl:for-each select="key('scopes', $space)">
                            <xsl:sequence select=".[parent::* ! name() = $formal_process]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="MathOP_space" as="element()+">
                        <xsl:for-each select="key('scopes', $space)">
                            <xsl:sequence select=".[parent::* ! name() = $math_operation]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="QO_space" as="element()+">
                        <xsl:for-each select="key('scopes', $space)">
                            <xsl:sequence select=".[parent::* ! name() = $object]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="spaceScopeString" select="'Space'"/>
<parent group="fp-mathop">
                    <parentGroup match="fp-mathop" lvl="1">
                        <xsl:call-template name="sentenceWriter">
                            <xsl:with-param name="param1" as="element()+" select="$FP_space"/>
                            <xsl:with-param name="param2" as="element()+" select="$MathOP_space"/>
                            <xsl:with-param name="param3" as="element()+" select="$QO_space"/>
                        </xsl:call-template>
                    </parentGroup>
                    <compGroup id="fp-mathop">
                        <xsl:call-template name="sentenceWriter">
                            <xsl:with-param name="param1" as="element()+" select="$FP_space"/>
                            <xsl:with-param name="param2" as="element()+" select="$MathOP_space"/>
                            <xsl:with-param name="param3" as="element()+" select="$QO_space"/>
                            <xsl:with-param name="scopeParam" as="xs:string"
                                select="$spaceScopeString"/>
                        </xsl:call-template>
                    </compGroup>
</parent>
                    <xsl:comment>####################################</xsl:comment>
                    <xsl:comment>SPACE: Knowledge Process + Process Pred</xsl:comment>
                    <xsl:comment>####################################</xsl:comment>

                    <xsl:variable name="KP_space" as="element()+">
                        <xsl:for-each select="key('scopes', $space)">
                            <xsl:sequence select=".[parent::* ! name() = $knowledge_process]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="PrPred_space" as="element()+">
                        <xsl:for-each select="key('scopes', $space)">
                            <xsl:sequence select=".[parent::* ! name() = $processPred]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="spaceScopeString" select="'Space'"/>
                    <parent group="kp-pp">
                    <parentGroup match="kp-pp" lvl="1">
                        <xsl:call-template name="sentenceWriter">
                            <xsl:with-param name="param1" as="element()+" select="$KP_space"/>
                            <xsl:with-param name="param2" as="element()+" select="$PrPred_space"/>
                        </xsl:call-template>
                    </parentGroup>
                    <compGroup id="kp-pp">
                        <xsl:call-template name="sentenceWriter">
                            <xsl:with-param name="param1" as="element()+" select="$KP_space"/>
                            <xsl:with-param name="param2" as="element()+" select="$PrPred_space"/>
                            <xsl:with-param name="scopeParam" as="xs:string"
                                select="$spaceScopeString"/>
                        </xsl:call-template>
                    </compGroup>
</parent>


                    <xsl:comment>####################################</xsl:comment>
                    <xsl:comment>SPACE: Knowledge Process + Math Operation + Quant Object </xsl:comment>
                    <xsl:comment>####################################</xsl:comment>

                    <xsl:variable name="KP_space" as="element()+">
                        <xsl:for-each
                            select="key('scopes', $space) intersect key('MathOpProcessFilter', $KPMathOp)">
                            <xsl:sequence select=".[parent::* ! name() = $knowledge_process]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="MathOP_space" as="element()+">
                        <xsl:for-each select="key('scopes', $space)">
                            <xsl:sequence select=".[parent::* ! name() = $math_operation]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="QO_space" as="element()+">
                        <xsl:for-each select="key('scopes', $space)">
                            <xsl:sequence select=".[parent::* ! name() = $object]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="spaceScopeString" select="'Space'"/>
<parent group="kp-mathop">
                    <parentGroup match="kp-mathop" lvl="1">
                        <xsl:call-template name="sentenceWriter">
                            <xsl:with-param name="param1" as="element()+" select="$KP_space"/>
                            <xsl:with-param name="param2" as="element()+" select="$MathOP_space"/>
                            <xsl:with-param name="param3" as="element()+" select="$QO_space"/>
                        </xsl:call-template>
                    </parentGroup>
                    <compGroup id="kp-mathop">
                        <xsl:call-template name="sentenceWriter">
                            <xsl:with-param name="param1" as="element()+" select="$KP_space"/>
                            <xsl:with-param name="param2" as="element()+" select="$MathOP_space"/>
                            <xsl:with-param name="param3" as="element()+" select="$QO_space"/>
                            <xsl:with-param name="scopeParam" as="xs:string"
                                select="$spaceScopeString"/>
                        </xsl:call-template>
                    </compGroup>
                    </parent>
                </scopeGroup>
            </xml>
        </xsl:result-document>


        <xsl:result-document method="xml" indent="yes" href="plane/planeNestedOutput-TP.xml">
            <xml>
                <xsl:comment>*************************************************************</xsl:comment>
                <xsl:comment>**************** PLANE SCOPE **************************</xsl:comment>
                <xsl:comment>*****************************************************************</xsl:comment>

                <scopeGroup id="plane">
                    <xsl:comment>####################################</xsl:comment>
                    <xsl:comment>PLANE: Formal Process + Process Predicate</xsl:comment>
                    <xsl:comment>####################################</xsl:comment>

                    <xsl:variable name="FP_plane" as="element()+">

                        <xsl:for-each select="key('scopes', $plane)">
                            <xsl:sequence select=".[parent::* ! name() = $formal_process]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="PrPred_plane" as="element()+">
                        <xsl:for-each select="key('scopes', $plane)">
                            <xsl:sequence select=".[parent::* ! name() = $processPred]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="planeScopeString" select="'the Plane'"/>
<parent group="fp-pp">
                    <parentGroup match="fp-pp" lvl="1">
                        <xsl:call-template name="sentenceWriter">
                            <xsl:with-param name="param1" as="element()+" select="$FP_plane"/>
                            <xsl:with-param name="param2" as="element()+" select="$PrPred_plane"/>
                        </xsl:call-template>
                    </parentGroup>
                    <compGroup id="fp-pp">
                        <xsl:call-template name="sentenceWriter">
                            <xsl:with-param name="param1" as="element()+" select="$FP_plane"/>
                            <xsl:with-param name="param2" as="element()+" select="$PrPred_plane"/>
                            <xsl:with-param name="scopeParam" as="xs:string"
                                select="$planeScopeString"/>
                        </xsl:call-template>
                    </compGroup>
</parent>


                    <xsl:comment>####################################</xsl:comment>
                    <xsl:comment>PLANE: Formal Process + Math Operation + Quant Object</xsl:comment>
                    <xsl:comment>####################################</xsl:comment>

                    <xsl:variable name="FP_plane" as="element()+">
                        <xsl:for-each select="key('scopes', $plane)">
                            <xsl:sequence select=".[parent::* ! name() = $formal_process]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="MathOP_plane" as="element()+">
                        <xsl:for-each select="key('scopes', $plane)">
                            <xsl:sequence select=".[parent::* ! name() = $math_operation]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="QO_plane" as="element()+">
                        <xsl:for-each select="key('scopes', $plane)">
                            <xsl:sequence select=".[parent::* ! name() = $object]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="planeScopeString" select="'the Plane'"/>
<parent group="fp-mathop">
                    <parentGroup match="fp-mathop" lvl="1">
                        <xsl:call-template name="sentenceWriter">
                            <xsl:with-param name="param1" as="element()+" select="$FP_plane"/>
                            <xsl:with-param name="param2" as="element()+" select="$MathOP_plane"/>
                            <xsl:with-param name="param3" as="element()+" select="$QO_plane"/>
                        </xsl:call-template>
                    </parentGroup>
                    <compGroup id="fp-mathop">
                        <xsl:call-template name="sentenceWriter">
                            <xsl:with-param name="param1" as="element()+" select="$FP_plane"/>
                            <xsl:with-param name="param2" as="element()+" select="$MathOP_plane"/>
                            <xsl:with-param name="param3" as="element()+" select="$QO_plane"/>
                            <xsl:with-param name="scopeParam" as="xs:string"
                                select="$planeScopeString"/>
                        </xsl:call-template>
                    </compGroup>
</parent>
                    <xsl:comment>####################################</xsl:comment>
                    <xsl:comment>PLANE: Knowledge Process + Process Pred</xsl:comment>
                    <xsl:comment>####################################</xsl:comment>

                    <xsl:variable name="KP_plane" as="element()+">
                        <xsl:for-each select="key('scopes', $plane)">
                            <xsl:sequence select=".[parent::* ! name() = $knowledge_process]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="PrPred_plane" as="element()+">
                        <xsl:for-each select="key('scopes', $plane)">
                            <xsl:sequence select=".[parent::* ! name() = $processPred]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="planeScopeString" select="'the Plane'"/>
                    <parent group="kp-pp">
                    <parentGroup match="kp-pp" lvl="1">
                        <xsl:call-template name="sentenceWriter">
                            <xsl:with-param name="param1" as="element()+" select="$KP_plane"/>
                            <xsl:with-param name="param2" as="element()+" select="$PrPred_plane"/>
                        </xsl:call-template>
                    </parentGroup>
                    <compGroup id="kp-pp">
                        <xsl:call-template name="sentenceWriter">
                            <xsl:with-param name="param1" as="element()+" select="$KP_plane"/>
                            <xsl:with-param name="param2" as="element()+" select="$PrPred_plane"/>
                            <xsl:with-param name="scopeParam" as="xs:string"
                                select="$planeScopeString"/>
                        </xsl:call-template>
                    </compGroup>
</parent>


                    <xsl:comment>####################################</xsl:comment>
                    <xsl:comment>PLANE: Knowledge Process + Math Operation + Quant Object</xsl:comment>
                    <xsl:comment>####################################</xsl:comment>

                    <xsl:variable name="KP_plane" as="element()+">
                        <xsl:for-each
                            select="key('scopes', $plane) intersect key('MathOpProcessFilter', $KPMathOp)">
                            <xsl:sequence select=".[parent::* ! name() = $knowledge_process]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="MathOP_plane" as="element()+">
                        <xsl:for-each select="key('scopes', $plane)">
                            <xsl:sequence select=".[parent::* ! name() = $math_operation]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="QO_plane" as="element()+">
                        <xsl:for-each select="key('scopes', $plane)">
                            <xsl:sequence select=".[parent::* ! name() = $object]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="planeScopeString" select="'the Plane'"/>
<parent group="kp-mathop">
                    <parentGroup match="kp-mathop" lvl="1">
                        <xsl:call-template name="sentenceWriter">
                            <xsl:with-param name="param1" as="element()+" select="$KP_plane"/>
                            <xsl:with-param name="param2" as="element()+" select="$MathOP_plane"/>
                            <xsl:with-param name="param3" as="element()+" select="$QO_plane"/>
                        </xsl:call-template>
                    </parentGroup>
                    <compGroup id="kp-mathop">
                        <xsl:call-template name="sentenceWriter">
                            <xsl:with-param name="param1" as="element()+" select="$KP_plane"/>
                            <xsl:with-param name="param2" as="element()+" select="$MathOP_plane"/>
                            <xsl:with-param name="param3" as="element()+" select="$QO_plane"/>
                            <xsl:with-param name="scopeParam" as="xs:string"
                                select="$planeScopeString"/>
                        </xsl:call-template>
                    </compGroup>
</parent>
                </scopeGroup>
            </xml>
        </xsl:result-document>



        <xsl:result-document method="xml" indent="yes" href="real_nums/realNestedOutput-TP.xml">
            <xml>
                <xsl:comment>****************************************************</xsl:comment>
                <xsl:comment>*************** REAL NUMBERS SCOPE *****************</xsl:comment>
                <xsl:comment>****************************************************</xsl:comment>

                <scopeGroup id="realNums">
                    <xsl:comment>REAL NUMBERS: Formal Process(noNotObj) + Process Predicate</xsl:comment>

                    <xsl:variable name="FPreal" as="element()+">
                        <xsl:for-each select="key('scopes', $real)">
                            <xsl:sequence select=".[parent::* ! name() = $formal_process]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="PrPredreal" as="element()+">
                        <xsl:for-each select="key('scopes', $real)">
                            <xsl:sequence select=".[parent::* ! name() = $processPred]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="realScopeString" select="'Real Numbers'"/>
                    <parent group="fp-pp">
                        <parentGroup match="fp-pp" lvl="1">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$FPreal"/>
                                <xsl:with-param name="param2" as="element()+" select="$PrPredreal"/>
                            </xsl:call-template>
                        </parentGroup>
                        <compGroup id="fp-pp">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$FPreal"/>
                                <xsl:with-param name="param2" as="element()+" select="$PrPredreal"/>
                                <xsl:with-param name="scopeParam" as="xs:string"
                                    select="$realScopeString"/>
                            </xsl:call-template>
                        </compGroup>


                        <xsl:comment>####################################</xsl:comment>
                        <xsl:comment>REAL NUMBERS: Formal Process (keyed to notation) + Process Predicate + Notation Object</xsl:comment>
                        <xsl:comment>####################################</xsl:comment>

                        <xsl:variable name="FPreal" as="element()+">

                            <xsl:for-each
                                select="key('scopes', $real) intersect key('notationKey', $notation)">
                                <xsl:sequence select=".[parent::* ! name() = $formal_process]"/>
                            </xsl:for-each>
                        </xsl:variable>
                        <xsl:variable name="PrPredreal" as="element()+">
                            <xsl:for-each select="key('scopes', $real)">
                                <xsl:sequence select=".[parent::* ! name() = $processPred]"/>
                            </xsl:for-each>
                        </xsl:variable>
                        <xsl:variable name="NO_real" as="element()+">
                            <xsl:for-each select="key('scopes', $real)">
                                <xsl:sequence select=".[parent::* ! name() = $notationObject]"/>
                            </xsl:for-each>
                        </xsl:variable>
                        <xsl:variable name="realScopeString" select="'Real Numbers'"/>

                        <notationParent>
                            <parentGroup match="fp-pp-no" lvl="2">
                                <xsl:call-template name="sentenceWriter">
                                    <xsl:with-param name="param1" as="element()+" select="$FPreal"/>
                                    <xsl:with-param name="param2" as="element()+"
                                        select="$PrPredreal"/>
                                    <xsl:with-param name="param3" as="element()+"
                                        select="$NO_real"/>
                                </xsl:call-template>
                            </parentGroup>
                            <compGroup id="fp-pp-no">
                                <xsl:call-template name="sentenceWriter">
                                    <xsl:with-param name="param1" as="element()+" select="$FPreal"/>
                                    <xsl:with-param name="param2" as="element()+"
                                        select="$PrPredreal"/>
                                    <xsl:with-param name="NOparam3" as="element()+"
                                        select="$NO_real"/>
                                    <xsl:with-param name="scopeParam" as="xs:string"
                                        select="$realScopeString"/>
                                </xsl:call-template>
                            </compGroup>
                        </notationParent>
                    </parent>

                    <xsl:comment>####################################</xsl:comment>
                    <xsl:comment>REAL NUMBERS: Formal Process + Math Operation + Quant Object</xsl:comment>
                    <xsl:comment>####################################</xsl:comment>

                    <xsl:variable name="FPreal" as="element()+">
                        <xsl:for-each select="key('scopes', $real)">
                            <xsl:sequence select=".[parent::* ! name() = $formal_process]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="MathOpreal" as="element()+">
                        <xsl:for-each select="key('scopes', $real)">
                            <xsl:sequence select=".[parent::* ! name() = $math_operation]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="QOreal" as="element()+">
                        <xsl:for-each select="key('scopes', $real)">
                            <xsl:sequence select=".[parent::* ! name() = $object]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="realScopeString" select="'Real Numbers'"/>
                    <parent group="fp-mathop">
                        <parentGroup match="fp-mathop" lvl="1">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$FPreal"/>
                                <xsl:with-param name="param2" as="element()+" select="$MathOpreal"/>
                                <xsl:with-param name="param3" as="element()+" select="$QOreal"/>
                            </xsl:call-template>
                        </parentGroup>
                        <compGroup id="fp-mathop">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$FPreal"/>
                                <xsl:with-param name="param2" as="element()+" select="$MathOpreal"/>
                                <xsl:with-param name="param3" as="element()+" select="$QOreal"/>
                                <xsl:with-param name="scopeParam" as="xs:string"
                                    select="$realScopeString"/>
                            </xsl:call-template>
                        </compGroup>


                        <xsl:comment>####################################</xsl:comment>
                        <xsl:comment>REAL NUMBERS: Formal Process (keyed to notation) + Math Operation + Quant Object + Notation Object</xsl:comment>
                        <xsl:comment>####################################</xsl:comment>

                        <xsl:variable name="FPreal" as="element()+">
                            <xsl:for-each
                                select="key('scopes', $real) intersect key('notationKey', $notation)">
                                <xsl:sequence select=".[parent::* ! name() = $formal_process]"/>
                            </xsl:for-each>
                        </xsl:variable>
                        <xsl:variable name="MathOpreal" as="element()+">
                            <xsl:for-each select="key('scopes', $real)">
                                <xsl:sequence select=".[parent::* ! name() = $math_operation]"/>
                            </xsl:for-each>
                        </xsl:variable>
                        <xsl:variable name="QOreal" as="element()+">
                            <xsl:for-each select="key('scopes', $real)">
                                <xsl:sequence select=".[parent::* ! name() = $object]"/>
                            </xsl:for-each>
                        </xsl:variable>
                        <xsl:variable name="NO_real" as="element()+">
                            <xsl:for-each select="key('scopes', $real)">
                                <xsl:sequence select=".[parent::* ! name() = $notationObject]"/>
                            </xsl:for-each>
                        </xsl:variable>
                        <xsl:variable name="realScopeString" select="'Real Numbers'"/>
                        <notationParent>
                            <parentGroup match="fp-mathop-no" lvl="2">
                                <xsl:call-template name="sentenceWriter">
                                    <xsl:with-param name="param1" as="element()+" select="$FPreal"/>
                                    <xsl:with-param name="param2" as="element()+"
                                        select="$MathOpreal"/>
                                    <xsl:with-param name="param3" as="element()+" select="$QOreal"/>
                                    <xsl:with-param name="param4" as="element()+" select="$NO_real"
                                    />
                                </xsl:call-template>
                            </parentGroup>
                            <compGroup id="fp-mathop-no">
                                <xsl:call-template name="sentenceWriter">
                                    <xsl:with-param name="param1" as="element()+" select="$FPreal"/>
                                    <xsl:with-param name="param2" as="element()+"
                                        select="$MathOpreal"/>
                                    <xsl:with-param name="param3" as="element()+" select="$QOreal"/>
                                    <xsl:with-param name="param4" as="element()+" select="$NO_real"/>
                                    <xsl:with-param name="scopeParam" as="xs:string"
                                        select="$realScopeString"/>
                                </xsl:call-template>
                            </compGroup>
                        </notationParent>
                    </parent>

                    <xsl:comment>####################################</xsl:comment>
                    <xsl:comment>REAL NUMBERS: Knowledge Process + Process Pred</xsl:comment>
                    <xsl:comment>####################################</xsl:comment>

                    <xsl:variable name="KP_real" as="element()+">
                        <xsl:for-each select="key('scopes', $real)">
                            <xsl:sequence select=".[parent::* ! name() = $knowledge_process]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="PrPredreal" as="element()+">
                        <xsl:for-each select="key('scopes', $real)">
                            <xsl:sequence select=".[parent::* ! name() = $processPred]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="realScopeString" select="'Real Numbers'"/>
                    <parent group="kp-pp">
                        <parentGroup match="kp-pp" lvl="1">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$KP_real"/>
                                <xsl:with-param name="param2" as="element()+" select="$PrPredreal"/>
                            </xsl:call-template>
                        </parentGroup>
                        <compGroup id="kp-pp">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$KP_real"/>
                                <xsl:with-param name="param2" as="element()+" select="$PrPredreal"/>
                                <xsl:with-param name="scopeParam" as="xs:string"
                                    select="$realScopeString"/>
                            </xsl:call-template>
                        </compGroup>
                    </parent>
                    <xsl:comment>####################################</xsl:comment>
                    <xsl:comment>REAL NUMBERS: Knowledge Process + Math Operation + Quant Object</xsl:comment>
                    <xsl:comment>####################################</xsl:comment>

                    <xsl:variable name="KP_real" as="element()+">
                        <xsl:for-each
                            select="key('scopes', $real) intersect key('MathOpProcessFilter', $KPMathOp)">
                            <xsl:sequence select=".[parent::* ! name() = $knowledge_process]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="MathOpreal" as="element()+">
                        <xsl:for-each select="key('scopes', $real)">
                            <xsl:sequence select=".[parent::* ! name() = $math_operation]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="QOreal" as="element()+">
                        <xsl:for-each select="key('scopes', $real)">
                            <xsl:sequence select=".[parent::* ! name() = $object]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="realScopeString" select="'Real Numbers'"/>
                    <parent group="kp-mathop">
                        <parentGroup match="kp-mathop" lvl="1">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$KP_real"/>
                                <xsl:with-param name="param2" as="element()+" select="$MathOpreal"/>
                                <xsl:with-param name="param3" as="element()+" select="$QOreal"/>
                            </xsl:call-template>
                        </parentGroup>
                        <compGroup id="kp-mathop">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$KP_real"/>
                                <xsl:with-param name="param2" as="element()+" select="$MathOpreal"/>
                                <xsl:with-param name="param3" as="element()+" select="$QOreal"/>
                                <xsl:with-param name="scopeParam" as="xs:string"
                                    select="$realScopeString"/>
                            </xsl:call-template>
                        </compGroup>
                    </parent>
                </scopeGroup>
            </xml>
        </xsl:result-document>


        <xsl:result-document method="xml" indent="yes" href="expect_vals/expectValNestedOutput-TP.xml">
            <xml>
                <xsl:comment>*************************************************************</xsl:comment>
                <xsl:comment>**************** EXPECTED VALUES SCOPE **************************</xsl:comment>
                <xsl:comment>*****************************************************************</xsl:comment>

                <scopeGroup id="expect">
                    <xsl:comment>####################################</xsl:comment>
                    <xsl:comment>EXPECTED VALUES: Formal Process + Process Predicate</xsl:comment>
                    <xsl:comment>####################################</xsl:comment>

                    <xsl:variable name="FP_expect" as="element()+">

                        <xsl:for-each select="key('scopes', $expect)">
                            <xsl:sequence select=".[parent::* ! name() = $formal_process]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="PrPred_expect" as="element()+">
                        <xsl:for-each select="key('scopes', $expect)">
                            <xsl:sequence select=".[parent::* ! name() = $processPred]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="expectScopeString" select="'Expected Values'"/>
                    <parent group="fp-pp">
                        <parentGroup match="fp-pp" lvl="1">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$FP_expect"/>
                                <xsl:with-param name="param2" as="element()+"
                                    select="$PrPred_expect"/>
                            </xsl:call-template>
                        </parentGroup>
                        <compGroup id="fp-pp">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$FP_expect"/>
                                <xsl:with-param name="param2" as="element()+"
                                    select="$PrPred_expect"/>
                                <xsl:with-param name="scopeParam" as="xs:string"
                                    select="$expectScopeString"/>
                            </xsl:call-template>
                        </compGroup>
                    </parent>


                    <xsl:comment>####################################</xsl:comment>
                    <xsl:comment>EXPECTED VALUES: Formal Process + Math Operation + Quant Object</xsl:comment>
                    <xsl:comment>####################################</xsl:comment>

                    <xsl:variable name="FP_expect" as="element()+">
                        <xsl:for-each select="key('scopes', $expect)">
                            <xsl:sequence select=".[parent::* ! name() = $formal_process]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="MathOP_expect" as="element()+">
                        <xsl:for-each select="key('scopes', $expect)">
                            <xsl:sequence select=".[parent::* ! name() = $math_operation]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="QO_expect" as="element()+">
                        <xsl:for-each select="key('scopes', $expect)">
                            <xsl:sequence select=".[parent::* ! name() = $object]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="expectScopeString" select="'Expected Values'"/>
                    <parent group="fp-mathop">
                        <parentGroup match="fp-mathop" lvl="1">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$FP_expect"/>
                                <xsl:with-param name="param2" as="element()+"
                                    select="$MathOP_expect"/>
                                <xsl:with-param name="param3" as="element()+" select="$QO_expect"/>
                            </xsl:call-template>
                        </parentGroup>
                        <compGroup id="fp-mathop">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$FP_expect"/>
                                <xsl:with-param name="param2" as="element()+"
                                    select="$MathOP_expect"/>
                                <xsl:with-param name="param3" as="element()+" select="$QO_expect"/>
                                <xsl:with-param name="scopeParam" as="xs:string"
                                    select="$expectScopeString"/>
                            </xsl:call-template>
                        </compGroup>
                    </parent>
                    <xsl:comment>####################################</xsl:comment>
                    <xsl:comment>EXPECTED VALUES: Knowledge Process + Process Pred</xsl:comment>
                    <xsl:comment>####################################</xsl:comment>

                    <xsl:variable name="KP_expect" as="element()+">
                        <xsl:for-each select="key('scopes', $expect)">
                            <xsl:sequence select=".[parent::* ! name() = $knowledge_process]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="PrPred_expect" as="element()+">
                        <xsl:for-each select="key('scopes', $expect)">
                            <xsl:sequence select=".[parent::* ! name() = $processPred]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="expectScopeString" select="'Expected Values'"/>
                    <parent group="kp-pp">
                        <parentGroup match="kp-pp" lvl="1">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$KP_expect"/>
                                <xsl:with-param name="param2" as="element()+"
                                    select="$PrPred_expect"/>
                            </xsl:call-template>
                        </parentGroup>
                        <compGroup id="kp-pp">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$KP_expect"/>
                                <xsl:with-param name="param2" as="element()+"
                                    select="$PrPred_expect"/>
                                <xsl:with-param name="scopeParam" as="xs:string"
                                    select="$expectScopeString"/>
                            </xsl:call-template>
                        </compGroup>
                    </parent>


                    <xsl:comment>####################################</xsl:comment>
                    <xsl:comment>EXPECTED VALUES: Knowledge Process + Math Operation + Quant Object</xsl:comment>
                    <xsl:comment>####################################</xsl:comment>

                    <xsl:variable name="KP_expect" as="element()+">
                        <xsl:for-each
                            select="key('scopes', $expect) intersect key('MathOpProcessFilter', $KPMathOp)">
                            <xsl:sequence select=".[parent::* ! name() = $knowledge_process]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="MathOP_expect" as="element()+">
                        <xsl:for-each select="key('scopes', $expect)">
                            <xsl:sequence select=".[parent::* ! name() = $math_operation]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="QO_expect" as="element()+">
                        <xsl:for-each select="key('scopes', $expect)">
                            <xsl:sequence select=".[parent::* ! name() = $object]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="expectScopeString" select="'Expected Values'"/>
                    <parent group="kp-mathop">
                        <parentGroup match="kp-mathop" lvl="1">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$KP_expect"/>
                                <xsl:with-param name="param2" as="element()+"
                                    select="$MathOP_expect"/>
                                <xsl:with-param name="param3" as="element()+" select="$QO_expect"/>
                            </xsl:call-template>
                        </parentGroup>
                        <compGroup id="kp-mathop">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$KP_expect"/>
                                <xsl:with-param name="param2" as="element()+"
                                    select="$MathOP_expect"/>
                                <xsl:with-param name="param3" as="element()+" select="$QO_expect"/>
                                <xsl:with-param name="scopeParam" as="xs:string"
                                    select="$expectScopeString"/>
                            </xsl:call-template>
                        </compGroup>
                    </parent>
                </scopeGroup>
            </xml>
        </xsl:result-document>


        <xsl:result-document method="xml" indent="yes" href="unit_fract/unitFractNestedOutput-TP.xml">
            <xml>
                <xsl:comment>**************************************************************</xsl:comment>
                <xsl:comment>**************** UNIT FRACTIONS SCOPE **************************</xsl:comment>
                <xsl:comment>***************************************************************</xsl:comment>

                <scopeGroup id="unit">
                    <xsl:comment>####################################</xsl:comment>
                    <xsl:comment>UNIT FRACTIONS: Formal Process + Process Predicate</xsl:comment>
                    <xsl:comment>####################################</xsl:comment>

                    <xsl:variable name="FP_unit" as="element()+">

                        <xsl:for-each select="key('scopes', $unit)">
                            <xsl:sequence select=".[parent::* ! name() = $formal_process]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="PrPred_unit" as="element()+">
                        <xsl:for-each select="key('scopes', $unit)">
                            <xsl:sequence select=".[parent::* ! name() = $processPred]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="unitScopeString" select="'Unit Fractions'"/>
                    <parent group="fp-pp">
                        <parentGroup match="fp-pp" lvl="1">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$FP_unit"/>
                                <xsl:with-param name="param2" as="element()+" select="$PrPred_unit"
                                />
                            </xsl:call-template>
                        </parentGroup>
                        <compGroup id="fp-pp">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$FP_unit"/>
                                <xsl:with-param name="param2" as="element()+" select="$PrPred_unit"/>
                                <xsl:with-param name="scopeParam" as="xs:string"
                                    select="$unitScopeString"/>
                            </xsl:call-template>
                        </compGroup>
                    </parent>


                    <xsl:comment>####################################</xsl:comment>
                    <xsl:comment>UNIT FRACTIONS: Formal Process + Math Operation + Quant Object</xsl:comment>
                    <xsl:comment>####################################</xsl:comment>

                    <xsl:variable name="FP_unit" as="element()+">
                        <xsl:for-each select="key('scopes', $unit)">
                            <xsl:sequence select=".[parent::* ! name() = $formal_process]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="MathOP_unit" as="element()+">
                        <xsl:for-each select="key('scopes', $unit)">
                            <xsl:sequence select=".[parent::* ! name() = $math_operation]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="QO_unit" as="element()+">
                        <xsl:for-each select="key('scopes', $unit)">
                            <xsl:sequence select=".[parent::* ! name() = $object]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="unitScopeString" select="'Unit Fractions'"/>
                    <parent group="fp-mathop">
                        <parentGroup match="fp-mathop" lvl="1">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$FP_unit"/>
                                <xsl:with-param name="param2" as="element()+" select="$MathOP_unit"/>
                                <xsl:with-param name="param3" as="element()+" select="$QO_unit"/>
                            </xsl:call-template>
                        </parentGroup>
                        <compGroup id="fp-mathop">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$FP_unit"/>
                                <xsl:with-param name="param2" as="element()+" select="$MathOP_unit"/>
                                <xsl:with-param name="param3" as="element()+" select="$QO_unit"/>
                                <xsl:with-param name="scopeParam" as="xs:string"
                                    select="$unitScopeString"/>
                            </xsl:call-template>
                        </compGroup>
                    </parent>
                    <xsl:comment>####################################</xsl:comment>
                    <xsl:comment>UNIT FRACTIONS: Knowledge Process + Process Pred</xsl:comment>
                    <xsl:comment>####################################</xsl:comment>

                    <xsl:variable name="KP_unit" as="element()+">
                        <xsl:for-each select="key('scopes', $unit)">
                            <xsl:sequence select=".[parent::* ! name() = $knowledge_process]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="PrPred_unit" as="element()+">
                        <xsl:for-each select="key('scopes', $unit)">
                            <xsl:sequence select=".[parent::* ! name() = $processPred]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="unitScopeString" select="'Unit Fractions'"/>
                    <parent group="kp-pp">
                        <parentGroup match="kp-pp" lvl="1">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$KP_unit"/>
                                <xsl:with-param name="param2" as="element()+" select="$PrPred_unit"
                                />
                            </xsl:call-template>
                        </parentGroup>
                        <compGroup id="kp-pp">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$KP_unit"/>
                                <xsl:with-param name="param2" as="element()+" select="$PrPred_unit"/>
                                <xsl:with-param name="scopeParam" as="xs:string"
                                    select="$unitScopeString"/>
                            </xsl:call-template>
                        </compGroup>
                    </parent>

                    <xsl:comment>####################################</xsl:comment>
                    <xsl:comment>UNIT FRACTIONS: Knowledge Process + Math Operation + Quant Object </xsl:comment>
                    <xsl:comment>####################################</xsl:comment>

                    <xsl:variable name="KP_unit" as="element()+">
                        <xsl:for-each
                            select="key('scopes', $unit) intersect key('MathOpProcessFilter', $KPMathOp)">
                            <xsl:sequence select=".[parent::* ! name() = $knowledge_process]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="MathOP_unit" as="element()+">
                        <xsl:for-each select="key('scopes', $unit)">
                            <xsl:sequence select=".[parent::* ! name() = $math_operation]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="QO_unit" as="element()+">
                        <xsl:for-each select="key('scopes', $unit)">
                            <xsl:sequence select=".[parent::* ! name() = $object]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="unitScopeString" select="'Unit Fractions'"/>
                    <parent group="kp-mathop">
                        <parentGroup match="kp-mathop" lvl="1">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$KP_unit"/>
                                <xsl:with-param name="param2" as="element()+" select="$MathOP_unit"/>
                                <xsl:with-param name="param3" as="element()+" select="$QO_unit"/>
                            </xsl:call-template>
                        </parentGroup>
                        <compGroup id="kp-mathop">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$KP_unit"/>
                                <xsl:with-param name="param2" as="element()+" select="$MathOP_unit"/>
                                <xsl:with-param name="param3" as="element()+" select="$QO_unit"/>
                                <xsl:with-param name="scopeParam" as="xs:string"
                                    select="$unitScopeString"/>
                            </xsl:call-template>
                        </compGroup>
                    </parent>
                </scopeGroup>
            </xml>
        </xsl:result-document>



        <xsl:result-document method="xml" indent="yes" href="vectors/vectorsNestedOutput-TP.xml">
            <xml>
                <xsl:comment>**************************************************************</xsl:comment>
                <xsl:comment>**************** VECTORS SCOPE **************************</xsl:comment>
                <xsl:comment>***************************************************************</xsl:comment>

                <scopeGroup id="vector">
                    <xsl:comment>####################################</xsl:comment>
                    <xsl:comment>VECTORS: Formal Process + Process Predicate</xsl:comment>
                    <xsl:comment>####################################</xsl:comment>

                    <xsl:variable name="FP_vector" as="element()+">

                        <xsl:for-each select="key('scopes', $vector)">
                            <xsl:sequence select=".[parent::* ! name() = $formal_process]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="PrPred_vector" as="element()+">
                        <xsl:for-each select="key('scopes', $vector)">
                            <xsl:sequence select=".[parent::* ! name() = $processPred]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="vectorScopeString" select="'Vectors'"/>
                    <parent group="fp-pp">
                        <parentGroup match="fp-pp" lvl="1">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$FP_vector"/>
                                <xsl:with-param name="param2" as="element()+"
                                    select="$PrPred_vector"/>
                            </xsl:call-template>
                        </parentGroup>
                        <compGroup id="fp-pp">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$FP_vector"/>
                                <xsl:with-param name="param2" as="element()+"
                                    select="$PrPred_vector"/>
                                <xsl:with-param name="scopeParam" as="xs:string"
                                    select="$vectorScopeString"/>
                            </xsl:call-template>
                        </compGroup>

                    </parent>

                    <xsl:comment>####################################</xsl:comment>
                    <xsl:comment>VECTORS: Formal Process + Math Operation + Quant Object</xsl:comment>
                    <xsl:comment>####################################</xsl:comment>

                    <xsl:variable name="FP_vector" as="element()+">
                        <xsl:for-each select="key('scopes', $vector)">
                            <xsl:sequence select=".[parent::* ! name() = $formal_process]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="MathOP_vector" as="element()+">
                        <xsl:for-each select="key('scopes', $vector)">
                            <xsl:sequence select=".[parent::* ! name() = $math_operation]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="QO_vector" as="element()+">
                        <xsl:for-each select="key('scopes', $vector)">
                            <xsl:sequence select=".[parent::* ! name() = $object]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="vectorScopeString" select="'Vectors'"/>
                    <parent group="fp-mathop">
                        <parentGroup match="fp-mathop" lvl="1">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$FP_vector"/>
                                <xsl:with-param name="param2" as="element()+"
                                    select="$MathOP_vector"/>
                                <xsl:with-param name="param3" as="element()+" select="$QO_vector"/>
                            </xsl:call-template>
                        </parentGroup>
                        <compGroup id="fp-mathop">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$FP_vector"/>
                                <xsl:with-param name="param2" as="element()+"
                                    select="$MathOP_vector"/>
                                <xsl:with-param name="param3" as="element()+" select="$QO_vector"/>
                                <xsl:with-param name="scopeParam" as="xs:string"
                                    select="$vectorScopeString"/>
                            </xsl:call-template>
                        </compGroup>
                    </parent>

                    <xsl:comment>####################################</xsl:comment>
                    <xsl:comment>VECTORS: Knowledge Process + Process Pred</xsl:comment>
                    <xsl:comment>####################################</xsl:comment>

                    <xsl:variable name="KP_vector" as="element()+">
                        <xsl:for-each select="key('scopes', $vector)">
                            <xsl:sequence select=".[parent::* ! name() = $knowledge_process]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="PrPred_vector" as="element()+">
                        <xsl:for-each select="key('scopes', $vector)">
                            <xsl:sequence select=".[parent::* ! name() = $processPred]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="vectorScopeString" select="'Vectors'"/>
                    <parent group="kp-pp">
                        <parentGroup match="kp-pp" lvl="1">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$KP_vector"/>
                                <xsl:with-param name="param2" as="element()+"
                                    select="$PrPred_vector"/>
                            </xsl:call-template>
                        </parentGroup>
                        <compGroup id="kp-pp">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$KP_vector"/>
                                <xsl:with-param name="param2" as="element()+"
                                    select="$PrPred_vector"/>
                                <xsl:with-param name="scopeParam" as="xs:string"
                                    select="$vectorScopeString"/>
                            </xsl:call-template>
                        </compGroup>
                    </parent>



                    <xsl:comment>####################################</xsl:comment>
                    <xsl:comment>VECTORS: Knowledge Process + Math Operation + Quant Object </xsl:comment>
                    <xsl:comment>####################################</xsl:comment>

                    <xsl:variable name="KP_vector" as="element()+">
                        <xsl:for-each
                            select="key('scopes', $vector) intersect key('MathOpProcessFilter', $KPMathOp)">
                            <xsl:sequence select=".[parent::* ! name() = $knowledge_process]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="MathOP_vector" as="element()+">
                        <xsl:for-each select="key('scopes', $vector)">
                            <xsl:sequence select=".[parent::* ! name() = $math_operation]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="QO_vector" as="element()+">
                        <xsl:for-each select="key('scopes', $vector)">
                            <xsl:sequence select=".[parent::* ! name() = $object]"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:variable name="vectorScopeString" select="'Vectors'"/>
                    <parent group="kp-mathop">
                        <parentGroup match="kp-mathop" lvl="1">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$KP_vector"/>
                                <xsl:with-param name="param2" as="element()+"
                                    select="$MathOP_vector"/>
                                <xsl:with-param name="param3" as="element()+" select="$QO_vector"/>
                            </xsl:call-template>
                        </parentGroup>
                        <compGroup id="kp-mathop">
                            <xsl:call-template name="sentenceWriter">
                                <xsl:with-param name="param1" as="element()+" select="$KP_vector"/>
                                <xsl:with-param name="param2" as="element()+"
                                    select="$MathOP_vector"/>
                                <xsl:with-param name="param3" as="element()+" select="$QO_vector"/>
                                <xsl:with-param name="scopeParam" as="xs:string"
                                    select="$vectorScopeString"/>
                            </xsl:call-template>
                        </compGroup>
                    </parent>
                </scopeGroup>

            </xml>
        </xsl:result-document>


        <!--   </xml>-->
    </xsl:template>










    <!-- WHOLE NUMBERS SENTENCE WRITER -->
    <!--     
            <xsl:template name="wholenumSentenceWriter" as="element()+">
                <xsl:param name="param1" as="element()+" required="yes"/>
                <xsl:param name="param2" as="element()+" required="yes"/>
                <xsl:param name="param3" as="element()*"/>
                <xsl:param name="param4" as="element()*"/>
                <xsl:param name="scopeParam" as="xs:string?"/>
                <xsl:param name="subScopeParam" as="element()*"/>
                <xsl:param name="subProcessParam" as="element()*"/>
                
                <xsl:variable name="var1" as="xs:string+" select="$param1/parent::* ! name()"/>
                <xsl:variable name="var2" as="xs:string+" select="$param2/parent::* ! name()"/>
                <xsl:variable name="var3" as="xs:string*" select="$param3/parent::* ! name()"/>
                <xsl:variable name="var4" as="xs:string*" select="$param4/parent::* ! name()"/>
                <xsl:variable name="varSubProcess" as="xs:string*"
                    select="$subProcessParam/parent::* ! name()"/>
                
                
                <xsl:for-each select="$param1 ! normalize-space()">
                    <xsl:variable name="currLevel1" as="xs:string" select="current()"/>
                    
                    <xsl:for-each select="$param2 ! normalize-space()">
                        <xsl:variable name="currLevel2" as="xs:string?" select="current()"/>
                        
                        <xsl:choose>
                            <!-\- CHOICE 1 -\->
                            <xsl:when test="$param3">
                                <xsl:for-each select="$param3 ! normalize-space()">
                                    <xsl:variable name="currLevel3" as="xs:string?" select="current()"/>
                                    <xsl:choose>
                                        <xsl:when test="$param4">
                                            <xsl:for-each select="$param4 ! normalize-space()">
                                                <xsl:variable name="currLevel4" as="xs:string?"
                                                    select="current()"/>
                                                <!-\- FOUR PARAMETER SENTENCES -\->
                                                <xsl:for-each select="$scopeParam">
                                                    <xsl:variable name="scopeInsert" as="xs:string"
                                                        select="current()"/>
                                                    <xsl:for-each select="$subScopeParam">
                                                        <xsl:variable name="subscopeInsert" as="xs:string"
                                                            select="current()"/>
                                                        <xsl:variable name="varSubScope" as="xs:string*"
                                                            select="//subScope/string[./text() = current()/text()]/@id"/>
                                                        
                                                        <xsl:variable name="varExtends" as="xs:string*"
                                                            select="//subScope/string[./text() = current()/text()]/@extends"/>
                                                        <xsl:choose>
                                                            <xsl:when test="$subProcessParam">
                                                                <xsl:for-each select="$subProcessParam">
                                                                    <xsl:variable name="subProcessInsert"
                                                                        as="xs:string" select="current()"/>
                                                                    
                                                                    <!-\- COUNT EACH SUBSCOPE COMP:concat($varSubScope, count(current(.) +1)
                                                            concat($varSubScope, '-', $varSubCount) -\->
                                                                    <componentSentence id="{$varSubScope}" 
                                                                        extends="{$varExtends}">
                                                                        
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
                                                                            <xsl:sequence select="$scopeInsert"/>
                                                                        </xsl:element>
                                                                        <xsl:element name="subScope">
                                                                            <xsl:sequence select="$subscopeInsert"/>
                                                                        </xsl:element>
                                                                        <xsl:element name="{$varSubProcess}">
                                                                            <xsl:sequence select="$subProcessInsert"/>
                                                                        </xsl:element>
                                                                        
                                                                    </componentSentence>
                                                                    
                                                                </xsl:for-each>
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <componentSentence id="{$varSubScope}"
                                                                    extends="{$varExtends}">
                                                                    
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
                                                                        <xsl:sequence select="$scopeInsert"/>
                                                                    </xsl:element>
                                                                    <xsl:element name="subScope">
                                                                        <!-\-<xsl:attribute name="id">
                                                  <xsl:value-of select="$varSubScope"/>
                                                  </xsl:attribute>-\->
                                                                        <xsl:sequence select="$subscopeInsert"/>
                                                                    </xsl:element>
                                                                    
                                                                </componentSentence>
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                    </xsl:for-each>
                                                </xsl:for-each>
                                            </xsl:for-each>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <!-\- THREE PARAM SENTENCE -\->
                                            <xsl:for-each select="$scopeParam">
                                                <xsl:variable name="scopeInsert" as="xs:string"
                                                    select="current()"/>
                                                <xsl:for-each select="$subScopeParam">
                                                    <xsl:variable name="subscopeInsert" as="xs:string"
                                                        select="current()"/>
                                                    <xsl:variable name="varSubScope" as="xs:string*"
                                                        select="//subScope/string[./text() = current()/text()]/@id"/>
                                                    
                                                    <xsl:variable name="varExtends" as="xs:string*"
                                                        select="//subScope/string[./text() = current()/text()]/@extends"/>
                                                    <xsl:choose>
                                                        <xsl:when test="$subProcessParam">
                                                            <xsl:for-each select="$subProcessParam">
                                                                <xsl:variable name="subProcessInsert"
                                                                    as="xs:string" select="current()"/>
                                                                
                                                                <componentSentence id="{$varSubScope}"
                                                                    extends="{$varExtends}">
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
                                                                        <xsl:sequence select="$scopeInsert"/>
                                                                    </xsl:element>
                                                                    <xsl:element name="subScope">
                                                                        <xsl:sequence select="$subscopeInsert"/>
                                                                    </xsl:element>
                                                                    <xsl:element name="{$varSubProcess}">
                                                                        <xsl:sequence select="$subProcessInsert"/>
                                                                    </xsl:element>
                                                                    
                                                                </componentSentence>
                                                            </xsl:for-each>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <componentSentence id="{$varSubScope}"
                                                                extends="{$varExtends}">
                                                                
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
                                                                    <xsl:sequence select="$scopeInsert"/>
                                                                </xsl:element>
                                                                <xsl:element name="subScope">
                                                                    <xsl:sequence select="$subscopeInsert"/>
                                                                </xsl:element>
                                                                
                                                            </componentSentence>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:for-each>
                                            </xsl:for-each>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-\- TWO PARAMETER SENTENCE -\->
                                <xsl:for-each select="$scopeParam">
                                    <xsl:variable name="scopeInsert" as="xs:string" select="current()"/>
                                    <xsl:for-each select="$subScopeParam">
                                        <xsl:variable name="subscopeInsert" as="xs:string"
                                            select="current()"/>
                                        <xsl:variable name="varSubScope" as="xs:string*"
                                            select="//subScope/string[./text() = current()/text()]/@id"/>
                                        
                                        <xsl:variable name="varExtends" as="xs:string*"
                                            select="//subScope/string[./text() = current()/text()]/@extends"/>
                                        <xsl:choose>
                                            <xsl:when test="$subProcessParam">
                                                <xsl:for-each select="$subProcessParam">
                                                    <xsl:variable name="subProcessInsert" as="xs:string"
                                                        select="current()"/>
                                                    <componentSentence id="{$varSubScope}"
                                                        extends="{$varExtends}">
                                                        
                                                        <xsl:element name="{$var1}">
                                                            <xsl:sequence select="$currLevel1"/>
                                                        </xsl:element>
                                                        <xsl:element name="{$var2}">
                                                            <xsl:sequence select="$currLevel2"/>
                                                        </xsl:element>
                                                        <xsl:element name="scopeName">
                                                            <xsl:sequence select="$scopeInsert"/>
                                                        </xsl:element>
                                                        <xsl:element name="subScope">
                                                            <xsl:sequence select="$subscopeInsert"/>
                                                        </xsl:element>
                                                        <xsl:element name="{$varSubProcess}">
                                                            <xsl:sequence select="$subProcessInsert"/>
                                                        </xsl:element>
                                                        
                                                    </componentSentence>
                                                </xsl:for-each>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <componentSentence id="{$varSubScope}"
                                                    extends="{$varExtends}">
                                                    
                                                    <xsl:element name="{$var1}">
                                                        <xsl:sequence select="$currLevel1"/>
                                                    </xsl:element>
                                                    <xsl:element name="{$var2}">
                                                        <xsl:sequence select="$currLevel2"/>
                                                    </xsl:element>
                                                    <xsl:element name="scopeName">
                                                        <xsl:sequence select="$scopeInsert"/>
                                                    </xsl:element>
                                                    <xsl:element name="subScope">
                                                        <xsl:sequence select="$subscopeInsert"/>
                                                    </xsl:element>
                                                    
                                                </componentSentence>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:for-each>
                                </xsl:for-each>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:template>
            
            
            -->






</xsl:stylesheet>
