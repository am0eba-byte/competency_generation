<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="3.0">



    <!-- INCLUDED COMPETENCIES in this XSLT generator: 
        Whole Numbers
    -->

    <!-- input file: MERGEDcompetency-components.xml -->
    <!-- output file: wholenumsNestedSeedCompsSSID.xml -->

    <xsl:output method="xml" indent="yes"/>


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
    <!-- scopes not filtered yet -->
    <xsl:param name="real" as="xs:string" select="'real'"/>
    <xsl:param name="unit" as="xs:string" select="'unit'"/>
    <xsl:param name="vector" as="xs:string" select="'vector'"/>
    <xsl:param name="matrix" as="xs:string" select="'matrix'"/>
    <xsl:param name="infinite" as="xs:string" select="'infinite'"/>
    <xsl:param name="random" as="xs:string" select="'random'"/>
    <xsl:param name="expect" as="xs:string" select="'expect'"/>
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


    <!-- WHOLE NUMBERS SENTENCE WRITER -->

    <xsl:template name="wholenumSentenceWriter" as="element()+">
        <xsl:param name="param1" as="element()+" required="yes"/>
        <xsl:param name="param2" as="element()+" required="yes"/>
        <xsl:param name="param3" as="element()*"/>
        <xsl:param name="param4" as="element()*"/>
        <xsl:param name="scopeParam" as="xs:string?"/>
        <xsl:param name="subScopeParam" as="element()*"/>
        <xsl:param name="subScopeCountParam" as="xs:string*"/>
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
                    <!-- CHOICE 1 -->
                    <xsl:when test="$param3">
                        <xsl:for-each select="$param3 ! normalize-space()">
                            <xsl:variable name="currLevel3" as="xs:string?" select="current()"/>
                            <xsl:choose>
                                <xsl:when test="$param4">
                                    <xsl:for-each select="$param4 ! normalize-space()">
                                        <xsl:variable name="currLevel4" as="xs:string?"
                                            select="current()"/>
                                        <!-- FOUR PARAMETER SENTENCES -->
                                        <xsl:for-each select="$scopeParam">
                                            <xsl:variable name="scopeInsert" as="xs:string"
                                                select="current()"/>
                                            <xsl:for-each select="$subScopeParam">
                                                <xsl:variable name="subscopeInsert" as="xs:string"
                                                  select="current()"/>
                                                <xsl:variable name="varSubScope" as="xs:string*"
                                                  select="//subScope/string[./text() = current()/text()]/@id"/>
                                               <!-- <xsl:variable name="varSubCount" as="xs:string*">
                                                    <!-\- <xsl:for-each select="//subScope/string[./@id/text() = current()/@id/text()]"> -\->
                                                    <xsl:for-each select="$subScopeCountParam">
                                                        <xsl:value-of select="//subScope/string[./text() = current()/text()]/@id[. = $varSubScope]/position() + 1"/>
                                                    </xsl:for-each>
                                                    <!-\-<xsl:value-of select="count(//subScope/string[./text() = current()/text()]/@id[./text() = @id] + 1)"/>-\->
                                                </xsl:variable>-->
                                                <xsl:variable name="varExtends" as="xs:string*"
                                                  select="//subScope/string[./text() = current()/text()]/@extends"/>
                                                <xsl:choose>
                                                  <xsl:when test="$subProcessParam">
                                                  <xsl:for-each select="$subProcessParam">
                                                  <xsl:variable name="subProcessInsert"
                                                  as="xs:string" select="current()"/>
                                                      
                                                      <!-- COUNT EACH SUBSCOPE COMP:concat($varSubScope, count(current(.) +1)
                                                                concat($varSubScope, '-', $varSubCount-->
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
                                                  <!--<xsl:attribute name="id">
                                                  <xsl:value-of select="$varSubScope"/>
                                                  </xsl:attribute>-->
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
                                    <!-- THREE PARAM SENTENCE -->
                                    <xsl:for-each select="$scopeParam">
                                        <xsl:variable name="scopeInsert" as="xs:string"
                                            select="current()"/>
                                        <xsl:for-each select="$subScopeParam">
                                            <xsl:variable name="subscopeInsert" as="xs:string"
                                                select="current()"/>
                                            <xsl:variable name="varSubScope" as="xs:string*"
                                                select="//subScope/string[./text() = current()/text()]/@id"/>
                                            <!--<xsl:variable name="varSubCount" as="xs:string*">
                                                <!-\- <xsl:for-each select="//subScope/string[./@id/text() = current()/@id/text()]"> -\->
                                                <xsl:for-each select="$subScopeParam/current()">
                                                   <xsl:value-of select="position() + 1"/>
                                                </xsl:for-each>
                                                <!-\-<xsl:value-of select="count(//subScope/string[./text() = current()/text()]/@id[./text() = @id] + 1)"/>-\->
                                            </xsl:variable>-->
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
                        <!-- TWO PARAMETER SENTENCE -->
                        <xsl:for-each select="$scopeParam">
                            <xsl:variable name="scopeInsert" as="xs:string" select="current()"/>
                            <xsl:for-each select="$subScopeParam">
                                <xsl:variable name="subscopeInsert" as="xs:string"
                                    select="current()"/>
                                <xsl:variable name="varSubScope" as="xs:string*"
                                    select="//subScope/string[./text() = current()/text()]/@id"/>
                               <!-- <xsl:variable name="varSubCount" as="xs:string*">
                                    <!-\- <xsl:for-each select="//subScope/string[./@id/text() = current()/@id/text()]"> -\->
                                    <xsl:for-each select="$subScopeParam">
                                        <xsl:value-of select="position() + 1"/>
                                    </xsl:for-each>
                                    <!-\-<xsl:value-of select="count(//subScope/string[./text() = current()/text()]/@id[./text() = @id] + 1)"/>-\->
                                </xsl:variable>-->
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




    <xsl:template match="/">
        <xml>

         
            <xsl:comment>****************************************************</xsl:comment>
            <xsl:comment>*************** WHOLE NUMBERS SCOPE *****************</xsl:comment>
            <xsl:comment>****************************************************</xsl:comment>

            <scopeGroup id="wholenum">
                <!-- *******************FORMAL PROCESS BRANCH******************************************* -->

                <!--****************WITH NOTATIONS************************************************ -->
                <xsl:comment>####################################</xsl:comment>
                <xsl:comment>WHOLE NUMS: Formal Process(keyed to Notation subclass) + Process Predicate + Notation Obj</xsl:comment>
                <xsl:comment>####################################</xsl:comment>

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
                <xsl:variable name="subScopeString" as="element()+">
                    <xsl:for-each select="key('scopes', $wholenum)">
                        <xsl:sequence select=".[parent::* ! name() = 'subScope']"/>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="subScopeCountvar" as="text()+">
                    <xsl:for-each select="key('scopes', $wholenum)[parent::* ! name() = 'subScope']/@id">
                        <xsl:sequence><xsl:value-of select="./position() + 1"/></xsl:sequence>
                    </xsl:for-each>
                </xsl:variable>
                
                <sentenceGroup id="fp-pp-no">
                    <xsl:call-template name="wholenumSentenceWriter">
                        <xsl:with-param name="param1" as="element()+" select="$FP_notation"/>
                        <xsl:with-param name="param2" as="element()+" select="$PrPred"/>
                        <xsl:with-param name="param3" as="element()+" select="$NO"/>
                        <xsl:with-param name="scopeParam" as="xs:string"
                            select="$wholenumScopeString"/>
                        <xsl:with-param name="subScopeParam" as="element()+"
                            select="$subScopeString"/>
                        <!--<xsl:with-param name="subScopeCountParam" as="text()+" select="$subScopeCountvar"/>-->
                    </xsl:call-template>
                </sentenceGroup>

                <xsl:comment>####################################</xsl:comment>
                <xsl:comment>WHOLE NUMS: Formal Process(keyed to Notation subclass) + Math Operation + Quant Object + Notation Obj</xsl:comment>
                <xsl:comment>####################################</xsl:comment>

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
                <xsl:variable name="subScopeString" as="element()+">
                    <xsl:for-each select="key('scopes', $wholenum)">
                        <xsl:sequence select=".[parent::* ! name() = 'subScope']"/>
                    </xsl:for-each>
                </xsl:variable>

                <sentenceGroup id="fp-mathop-no">
                    <xsl:call-template name="wholenumSentenceWriter">
                        <xsl:with-param name="param1" as="element()+" select="$FP_notation"/>
                        <xsl:with-param name="param2" as="element()+" select="$MathOp"/>
                        <xsl:with-param name="param3" as="element()+" select="$QO"/>
                        <xsl:with-param name="param4" as="element()+" select="$NO"/>
                        <xsl:with-param name="scopeParam" as="xs:string"
                            select="$wholenumScopeString"/>
                        <xsl:with-param name="subScopeParam" as="element()+"
                            select="$subScopeString"/>
                        <!--<xsl:with-param name="subScopeCountParam" as="text()+" select="$subScopeCountvar"/>-->
                    </xsl:call-template>
                </sentenceGroup>


                <!--****************WITHOUT NOTATIONS************************************************ -->

                <xsl:comment>####################################</xsl:comment>
                <xsl:comment>WHOLE NUMS: Formal Process(keyed to NoNot subclass) + Process Predicate</xsl:comment>
                <xsl:comment>####################################</xsl:comment>

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
                <xsl:variable name="subScopeString" as="element()+">
                    <xsl:for-each select="key('scopes', $wholenum)">
                        <xsl:sequence select=".[parent::* ! name() = 'subScope']"/>
                    </xsl:for-each>
                </xsl:variable>
                <sentenceGroup id="fp-pp">
                    <xsl:call-template name="wholenumSentenceWriter">
                        <xsl:with-param name="param1" as="element()+" select="$FP_noNot"/>
                        <xsl:with-param name="param2" as="element()+" select="$PrPred"/>
                        <xsl:with-param name="scopeParam" as="xs:string"
                            select="$wholenumScopeString"/>
                        <xsl:with-param name="subScopeParam" as="element()+"
                            select="$subScopeString"/>
                        <!--<xsl:with-param name="subScopeCountParam" as="text()+" select="$subScopeCountvar"/>-->
                    </xsl:call-template>
                </sentenceGroup>

                <xsl:comment>####################################</xsl:comment>
                <xsl:comment>WHOLE NUMS: Formal Process(keyed to noNot subclass) + Math Operation + Quant Object </xsl:comment>
                <xsl:comment>####################################</xsl:comment>

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
                <xsl:variable name="subScopeString" as="element()+">
                    <xsl:for-each select="key('scopes', $wholenum)">
                        <xsl:sequence select=".[parent::* ! name() = 'subScope']"/>
                    </xsl:for-each>
                </xsl:variable>
                <sentenceGroup id="fp-mathop">
                    <xsl:call-template name="wholenumSentenceWriter">
                        <xsl:with-param name="param1" as="element()+" select="$FP_noNot"/>
                        <xsl:with-param name="param2" as="element()+" select="$MathOp"/>
                        <xsl:with-param name="param3" as="element()+" select="$QO"/>
                        <xsl:with-param name="scopeParam" as="xs:string"
                            select="$wholenumScopeString"/>
                        <xsl:with-param name="subScopeParam" as="element()+"
                            select="$subScopeString"/>
                       <!-- <xsl:with-param name="subScopeCountParam" as="text()+" select="$subScopeCountvar"/>-->
                    </xsl:call-template>
                </sentenceGroup>

                <xsl:comment>####################################</xsl:comment>
                <xsl:comment>Knowledge Process Branch </xsl:comment>
                <xsl:comment>####################################</xsl:comment>

                <!-- ************** WITHOUT SUBPROCESS ************************************************* -->
                <xsl:comment>########################################</xsl:comment>
                <xsl:comment>WHOLE NUMS: Knowledge Process + Process Pred</xsl:comment>
                <xsl:comment>####################################</xsl:comment>

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
                <xsl:variable name="subScopeString" as="element()+">
                    <xsl:for-each select="key('scopes', $wholenum)">
                        <xsl:sequence select=".[parent::* ! name() = 'subScope']"/>
                    </xsl:for-each>
                </xsl:variable>
                <sentenceGroup id="kp-pp">
                    <xsl:call-template name="wholenumSentenceWriter">
                        <xsl:with-param name="param1" as="element()+" select="$KP"/>
                        <xsl:with-param name="param2" as="element()+" select="$PrPred"/>
                        <xsl:with-param name="scopeParam" as="xs:string"
                            select="$wholenumScopeString"/>
                        <xsl:with-param name="subScopeParam" as="element()+"
                            select="$subScopeString"/>
                        <!--<xsl:with-param name="subScopeCountParam" as="text()+" select="$subScopeCountvar"/>-->
                    </xsl:call-template>
                </sentenceGroup>

                <xsl:comment>####################################</xsl:comment>
                <xsl:comment>WHOLE NUMS: Knowledge Process + Math Operation + Quant Object</xsl:comment>
                <xsl:comment>####################################</xsl:comment>

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
                <xsl:variable name="subScopeString" as="element()+">
                    <xsl:for-each select="key('scopes', $wholenum)">
                        <xsl:sequence select=".[parent::* ! name() = 'subScope']"/>
                    </xsl:for-each>
                </xsl:variable>
                <sentenceGroup id="kp-mathop">
                    <xsl:call-template name="wholenumSentenceWriter">
                        <xsl:with-param name="param1" as="element()+" select="$KP"/>
                        <xsl:with-param name="param2" as="element()+" select="$MathOp"/>
                        <xsl:with-param name="param3" as="element()+" select="$QO"/>
                        <xsl:with-param name="scopeParam" as="xs:string"
                            select="$wholenumScopeString"/>
                        <xsl:with-param name="subScopeParam" as="element()+"
                            select="$subScopeString"/>
                        <!--<xsl:with-param name="subScopeCountParam" as="text()+" select="$subScopeCountvar"/>-->
                    </xsl:call-template>
                </sentenceGroup>

                <!-- ************************* WITH SUBPROCESS *********************************************** -->

                <xsl:comment>#########################################</xsl:comment>
                <xsl:comment>WHOLE NUMS: Knowledge Process + Process Pred + Knowledge Subprocess</xsl:comment>
                <xsl:comment>####################################</xsl:comment>

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
                <xsl:variable name="subScopeString" as="element()+">
                    <xsl:for-each select="key('scopes', $wholenum)">
                        <xsl:sequence select=".[parent::* ! name() = 'subScope']"/>
                    </xsl:for-each>
                </xsl:variable>
                <sentenceGroup id="kp-pp-sp">
                    <xsl:call-template name="wholenumSentenceWriter">
                        <xsl:with-param name="param1" as="element()+" select="$KP"/>
                        <xsl:with-param name="param2" as="element()+" select="$PrPred"/>
                        <xsl:with-param name="scopeParam" as="xs:string"
                            select="$wholenumScopeString"/>
                        <xsl:with-param name="subScopeParam" as="element()+"
                            select="$subScopeString"/>
                        <xsl:with-param name="subProcessParam" as="element()+" select="$KSP"/>
                        <!--<xsl:with-param name="subScopeCountParam" as="text()+" select="$subScopeCountvar"/>-->
                    </xsl:call-template>
                </sentenceGroup>

                <xsl:comment>####################################</xsl:comment>
                <xsl:comment>WHOLE NUMS: Knowledge Process + Math Operation + Quant Object + Knowledge Subprocess</xsl:comment>
                <xsl:comment>####################################</xsl:comment>

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
                <xsl:variable name="subScopeString" as="element()+">
                    <xsl:for-each select="key('scopes', $wholenum)">
                        <xsl:sequence select=".[parent::* ! name() = 'subScope']"/>
                    </xsl:for-each>
                </xsl:variable>
                <sentenceGroup id="kp-mathop-sp">
                    <xsl:call-template name="wholenumSentenceWriter">
                        <xsl:with-param name="param1" as="element()+" select="$KP"/>
                        <xsl:with-param name="param2" as="element()+" select="$MathOp"/>
                        <xsl:with-param name="param3" as="element()+" select="$QO"/>
                        <xsl:with-param name="scopeParam" as="xs:string"
                            select="$wholenumScopeString"/>
                        <xsl:with-param name="subScopeParam" as="element()+"
                            select="$subScopeString"/>
                        <xsl:with-param name="subProcessParam" as="element()+" select="$KSP"/>
                        <!--<xsl:with-param name="subScopeCountParam" as="text()+" select="$subScopeCountvar"/>-->
                    </xsl:call-template>
                </sentenceGroup>
            </scopeGroup>
            
            
        </xml>
    </xsl:template>

</xsl:stylesheet>
