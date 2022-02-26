<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="3.0">


    <xsl:output method="xml" indent="yes"/>


    <!-- ebb: Here we have defined a series of global parameters that are just strings of text designed to match element names in the source document. Parameters are very similar to variables in XSLT, but have a little more flexibility.They could be received into this XSLT as input, so imagine these as INPUT PARAMETERS to this XSLT. -->

    <xsl:param name="formal_process" as="xs:string" select="'formalProcess'"/>
    <xsl:param name="knowledge_process" as="xs:string" select="'knowledgeProcess'"/>
    <xsl:param name="knowledge_subprocess" as="xs:string" select="'knowledgeSubprocess'"/>
    <xsl:param name="processPred" as="xs:string" select="'processPred'"/>
    <xsl:param name="math_operation" as="xs:string" select="'mathOperation'"/>
    <xsl:param name="object" as="xs:string" select="'quant'"/>
    <xsl:param name="notationObject" as="xs:string" select="'notationObject'"/>
    <!--<xsl:param name="subScope" as="xs:string" select="'subScope'"/>-->


    <!-- SCOPE KEY -->
    <xsl:key name="scopes" match="string" use="@class ! tokenize(., '\s+')"/>
    <!-- WHOLE NUMBERS SCOPE PARAM -->
    <xsl:param name="wholenum" as="xs:string" select="'wholenum'"/>

    <!-- SUBSCOPE TYPE KEY -->
    <xsl:key name="subType" match="string" use="@scopeClass ! tokenize(., '\s+')"/>
    <!-- SUBSCOPE TYPE PARAMS -->
    <xsl:param name="sing" as="xs:string" select="'sing'"/>
    <!-- 0, 1 -->
    <xsl:param name="to" as="xs:string" select="'to'"/>
    <!-- to 2, to 3, to 4, to 5 -->
    <xsl:param name="within" as="xs:string" select="'within'"/>
    <!-- within 10, within 20, within 100, etc. -->

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
    
    <!-- Mathop + Knowledge Process filtering key -->
    <xsl:key name="MathOpProcessFilter" match="string" use="@mathop ! normalize-space()"/>
    <xsl:param name="KPMathOp" as="xs:string" select="'true'"/>
    


    <!-- KEYS: all components -->
    <xsl:key name="elements" match="compParts" use="descendant::*"/>


    <!-- LOW-LVL COMP WRITER -->
    <xsl:template name="sentenceWriter" as="element()+">
        <xsl:param name="param1" as="element()+" required="yes"/>
        <xsl:param name="param2" as="element()+" required="yes"/>
        <xsl:param name="param3" as="element()*"/>
        <xsl:param name="param4" as="element()*"/>
        <xsl:param name="scopeParam" as="xs:string?"/>
        <xsl:param name="subScopeParam" as="element()*"/>
        <xsl:param name="subProcessParam" as="element()*"/>

        <!-- MAX NUM OF PARAMS FOR ALL OTHER SCOPES: 3 -->

        <!-- MAX NUMBER OF COMPONENT PARAMS (whole numbers scope only): 5
            knowledge process + subprocess + math operation + object -->

        <!-- Purpose of the variables:
            TAKE THE NODES, CONVERT THEM TO STRINGS and set them as component element names.
            -->
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
                                                <xsl:variable name="varExtends" as="xs:string*" select="//subScope/string[./text() = current()/text()]/@extends"/>
                                                <xsl:choose>
                                                  <xsl:when test="$subProcessParam">
                                                  <xsl:for-each select="$subProcessParam">
                                                  <xsl:variable name="subProcessInsert"
                                                  as="xs:string" select="current()"/>
                                                      <componentSentence id="{$varSubScope}" extends="{$varExtends}">

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
                                                  <xsl:element name="{$varSubProcess}">
                                                  <xsl:sequence select="$subProcessInsert"/>
                                                  </xsl:element>

                                                  </componentSentence>

                                                  </xsl:for-each>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                      <componentSentence id="{$varSubScope}" extends="{$varExtends}">

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
                                            <xsl:variable name="varExtends" as="xs:string*" select="//subScope/string[./text() = current()/text()]/@extends"/>
                                            <xsl:choose>
                                                <xsl:when test="$subProcessParam">
                                                  <xsl:for-each select="$subProcessParam">
                                                  <xsl:variable name="subProcessInsert"
                                                  as="xs:string" select="current()"/>
                                                      <componentSentence id="{$varSubScope}" extends="{$varExtends}">

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
                                                    <!-- <xsl:attribute name="id">
                                                        <xsl:value-of select="$varSubScope"/>
                                                    </xsl:attribute>-->
                                                     <xsl:sequence select="$subscopeInsert"/>
                                                  </xsl:element>
                                                  <xsl:element name="{$varSubProcess}">
                                                     <xsl:sequence select="$subProcessInsert"/>
                                                  </xsl:element>

                                                  </componentSentence>
                                                  </xsl:for-each>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <componentSentence id="{$varSubScope}" extends="{$varExtends}">

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
                                <xsl:variable name="varExtends" as="xs:string*" select="//subScope/string[./text() = current()/text()]/@extends"/>
                                <xsl:choose>
                                    <xsl:when test="$subProcessParam">
                                        <xsl:for-each select="$subProcessParam">
                                            <xsl:variable name="subProcessInsert" as="xs:string"
                                                select="current()"/>
                                            <componentSentence id="{$varSubScope}" extends="{$varExtends}">

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
                                                  <!--<xsl:attribute name="id">
                                                  <xsl:value-of select="$varSubScope"/>
                                                  </xsl:attribute>-->
                                                  <xsl:sequence select="$subscopeInsert"/>
                                                </xsl:element>
                                                <xsl:element name="{$varSubProcess}">
                                                  <xsl:sequence select="$subProcessInsert"/>
                                                </xsl:element>

                                            </componentSentence>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <componentSentence id="{$varSubScope}" extends="{$varExtends}">

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
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>


<xsl:template name="parentWriter" as="element()+">
    <xsl:param name="param1" as="element()+" required="yes"/>
    <xsl:param name="param2" as="element()+" required="yes"/>
    <xsl:param name="param3" as="element()*"/>
    <xsl:param name="param4" as="element()*"/>
    
    <xsl:variable name="var1" as="xs:string+" select="$param1/parent::* ! name()"/>
    <xsl:variable name="var2" as="xs:string+" select="$param2/parent::* ! name()"/>
    <xsl:variable name="var3" as="xs:string*" select="$param3/parent::* ! name()"/>
    <xsl:variable name="var4" as="xs:string*" select="$param4/parent::* ! name()"/>
    
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
                    </componentSentence>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:for-each>
    
    
</xsl:template>


    <xsl:template match="/">
        <xml>

            <!-- *******************FORMAL PROCESS BRANCH******************************************* -->

            
            <xsl:comment>####################################</xsl:comment>
            <xsl:comment> Formal Process(keyed to NoNot subclass) + Process Predicate</xsl:comment>
            <xsl:comment>####################################</xsl:comment>
            
            <xsl:variable name="FP_noNot" as="element()+">
                <xsl:for-each select="key('scopes', $wholenum)">
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
            <parent group="fp-pp">
                <parentGroup match="fp-pp" lvl="1">
                    <xsl:call-template name="parentWriter">
                        <xsl:with-param name="param1" as="element()+" select="$FP_noNot"/>
                        <xsl:with-param name="param2" as="element()+" select="$PrPred"/>
                    </xsl:call-template>
                </parentGroup>
            <compGroup id="fp-pp">
                <xsl:call-template name="sentenceWriter">
                    <xsl:with-param name="param1" as="element()+" select="$FP_noNot"/>
                    <xsl:with-param name="param2" as="element()+" select="$PrPred"/>
                    <xsl:with-param name="scopeParam" as="xs:string" select="$wholenumScopeString"/>
                    <xsl:with-param name="subScopeParam" as="element()+" select="$subScopeString"/>
                </xsl:call-template>
            </compGroup>
            
      
            <xsl:comment>####################################</xsl:comment>
            <xsl:comment> Formal Process(keyed to Notation subclass) + Process Predicate + Notation Obj</xsl:comment>
            <xsl:comment>####################################</xsl:comment>

            <xsl:variable name="FP_notation" as="element()+">
                <xsl:for-each select="key('notationKey', $notation) intersect key('scopes', $wholenum)">
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
                
            <notationParent>
                <parentGroup match="fp-pp-no" lvl="2">
                    <xsl:call-template name="parentWriter">
                    <xsl:with-param name="param1" as="element()+" select="$FP_notation"/>
                    <xsl:with-param name="param2" as="element()+" select="$PrPred"/>
                    <xsl:with-param name="param3" as="element()+" select="$NO"/>
                    </xsl:call-template>
                </parentGroup>
            <compGroup id="fp-pp-no">
                <xsl:call-template name="sentenceWriter">
                    <xsl:with-param name="param1" as="element()+" select="$FP_notation"/>
                    <xsl:with-param name="param2" as="element()+" select="$PrPred"/>
                    <xsl:with-param name="param3" as="element()+" select="$NO"/>
                    <xsl:with-param name="scopeParam" as="xs:string" select="$wholenumScopeString"/>
                    <xsl:with-param name="subScopeParam" as="element()+" select="$subScopeString"/>
                </xsl:call-template>
            </compGroup>
            </notationParent>
            
            </parent>


            <xsl:comment>####################################</xsl:comment>
            <xsl:comment>Formal Process(keyed to noNot subclass) + Math Operation + Quant Object </xsl:comment>
            <xsl:comment>####################################</xsl:comment>
            
            <xsl:variable name="FP_noNot" as="element()+">
                <xsl:for-each select="key('scopes', $wholenum)">
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
            <parent group="fp-mathop">
            <parentGroup match="fp-mathop" lvl="1">
                <xsl:call-template name="parentWriter">
                    <xsl:with-param name="param1" as="element()+" select="$FP_noNot"/>
                    <xsl:with-param name="param2" as="element()+" select="$MathOp"/>
                    <xsl:with-param name="param3" as="element()+" select="$QO"/>
                </xsl:call-template>
            </parentGroup>
            <compGroup id="fp-mathop">
                <xsl:call-template name="sentenceWriter">
                    <xsl:with-param name="param1" as="element()+" select="$FP_noNot"/>
                    <xsl:with-param name="param2" as="element()+" select="$MathOp"/>
                    <xsl:with-param name="param3" as="element()+" select="$QO"/>
                    <xsl:with-param name="scopeParam" as="xs:string" select="$wholenumScopeString"/>
                    <xsl:with-param name="subScopeParam" as="element()+" select="$subScopeString"/>
                </xsl:call-template>
            </compGroup>
            
            


            <xsl:comment>####################################</xsl:comment>
            <xsl:comment>Formal Process(keyed to Notation subclass) + Math Operation + Quant Object + Notation Obj</xsl:comment>
            <xsl:comment>####################################</xsl:comment>

            <xsl:variable name="FP_notation" as="element()+">
                <xsl:for-each select="key('notationKey', $notation) intersect key('scopes', $wholenum)">
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
<notationParent>
    <parentGroup match="fp-mathop-no" lvl="2">
        <xsl:call-template name="parentWriter">
            <xsl:with-param name="param1" as="element()+" select="$FP_notation"/>
            <xsl:with-param name="param2" as="element()+" select="$MathOp"/>
            <xsl:with-param name="param3" as="element()+" select="$QO"/>
            <xsl:with-param name="param4" as="element()+" select="$NO"/>
        </xsl:call-template>
    </parentGroup>
            <compGroup id="fp-mathop-no">
                <xsl:call-template name="sentenceWriter">
                    <xsl:with-param name="param1" as="element()+" select="$FP_notation"/>
                    <xsl:with-param name="param2" as="element()+" select="$MathOp"/>
                    <xsl:with-param name="param3" as="element()+" select="$QO"/>
                    <xsl:with-param name="param4" as="element()+" select="$NO"/>
                    <xsl:with-param name="scopeParam" as="xs:string" select="$wholenumScopeString"/>
                    <xsl:with-param name="subScopeParam" as="element()+" select="$subScopeString"/>
                </xsl:call-template>
            </compGroup>
</notationParent>
</parent>

     
            <xsl:comment>*********Knowledge Process Branch************** </xsl:comment>
    


            <xsl:comment>########################################</xsl:comment>
            <xsl:comment>Knowledge Process + Process Pred</xsl:comment>
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
            
            <parent group="kp-pp">
                <parentGroup match="kp-pp" lvl="1">
                    <xsl:call-template name="parentWriter">
                        <xsl:with-param name="param1" as="element()+" select="$KP"/>
                        <xsl:with-param name="param2" as="element()+" select="$PrPred"/>
                    </xsl:call-template>
                </parentGroup>
            <compGroup id="kp-pp">
                <xsl:call-template name="sentenceWriter">
                    <xsl:with-param name="param1" as="element()+" select="$KP"/>
                    <xsl:with-param name="param2" as="element()+" select="$PrPred"/>
                    <xsl:with-param name="scopeParam" as="xs:string" select="$wholenumScopeString"/>
                    <xsl:with-param name="subScopeParam" as="element()+" select="$subScopeString"/>
                </xsl:call-template>
            </compGroup>
            

            <xsl:comment>#########################################</xsl:comment>
            <xsl:comment>Knowledge Process + Process Pred + Knowledge Subprocess</xsl:comment>
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
                
                <subParent>
                    <parentGroup id="kp-pp-sp" lvl="2">
                        <xsl:call-template name="parentWriter">
                            <xsl:with-param name="param1" as="element()+" select="$KP"/>
                            <xsl:with-param name="param2" as="element()+" select="$PrPred"/>
                            <xsl:with-param name="param3" as="element()+" select="$KSP"/>
                        </xsl:call-template>
                    </parentGroup>
            <compGroup id="kp-pp-sp">
                <xsl:call-template name="sentenceWriter">
                    <xsl:with-param name="param1" as="element()+" select="$KP"/>
                    <xsl:with-param name="param2" as="element()+" select="$PrPred"/>
                    <xsl:with-param name="scopeParam" as="xs:string" select="$wholenumScopeString"/>
                    <xsl:with-param name="subScopeParam" as="element()+" select="$subScopeString"/>
                    <xsl:with-param name="subProcessParam" as="element()+" select="$KSP"/>
                </xsl:call-template>
            </compGroup>
                </subParent>
            </parent>
            




            <xsl:comment>####################################</xsl:comment>
            <xsl:comment>Knowledge Process + Math Operation + Quant Object</xsl:comment>
            <xsl:comment>####################################</xsl:comment>

            <xsl:variable name="KP" as="element()+">
                <xsl:for-each select="key('scopes', $wholenum) intersect key('MathOpProcessFilter', $KPMathOp)">
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
            
            <parent group="kp-mathop">
                <parentGroup match="kp-mathop" lvl="1">
                    <xsl:call-template name="parentWriter">
                        <xsl:with-param name="param1" as="element()+" select="$KP"/>
                        <xsl:with-param name="param2" as="element()+" select="$MathOp"/>
                        <xsl:with-param name="param3" as="element()+" select="$QO"/>
                    </xsl:call-template>
                </parentGroup>
            <compGroup id="kp-mathop">
                <xsl:call-template name="sentenceWriter">
                    <xsl:with-param name="param1" as="element()+" select="$KP"/>
                    <xsl:with-param name="param2" as="element()+" select="$MathOp"/>
                    <xsl:with-param name="param3" as="element()+" select="$QO"/>
                    <xsl:with-param name="scopeParam" as="xs:string" select="$wholenumScopeString"/>
                    <xsl:with-param name="subScopeParam" as="element()+" select="$subScopeString"/>
                </xsl:call-template>
            </compGroup>


            <xsl:comment>####################################</xsl:comment>
            <xsl:comment>Knowledge Process + Math Operation + Quant Object + Knowledge Subprocess</xsl:comment>
            <xsl:comment>####################################</xsl:comment>
            
                <xsl:variable name="KP" as="element()+">
                    <xsl:for-each select="key('scopes', $wholenum) intersect key('MathOpProcessFilter', $KPMathOp)">
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
                
                <subParent>
                    <parentGroup match="fp-mathop-sp" lvl="2">
                        <xsl:call-template name="parentWriter">
                            <xsl:with-param name="param1" as="element()+" select="$KP"/>
                            <xsl:with-param name="param2" as="element()+" select="$MathOp"/>
                            <xsl:with-param name="param3" as="element()+" select="$QO"/>
                            <xsl:with-param name="param4" as="element()+" select="$KSP"/>
                        </xsl:call-template>
                    </parentGroup>
                <compGroup id="kp-mathop-sp">
                    <xsl:call-template name="sentenceWriter">
                        <xsl:with-param name="param1" as="element()+" select="$KP"/>
                        <xsl:with-param name="param2" as="element()+" select="$MathOp"/>
                        <xsl:with-param name="param3" as="element()+" select="$QO"/>
                        <xsl:with-param name="scopeParam" as="xs:string"
                            select="$wholenumScopeString"/>
                        <xsl:with-param name="subScopeParam" as="element()+" select="$subScopeString"/>
                        <xsl:with-param name="subProcessParam" as="element()+" select="$KSP"/>
                    </xsl:call-template>
                </compGroup>
                </subParent>
            </parent>
        </xml>

    </xsl:template>

</xsl:stylesheet>
