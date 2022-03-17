<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="3.0">


    <!-- 
        DEMO INPUT FILE PATH:
            \competency_formal_grammar\demo\generation\demo-input-components.xml
        DEMO OUTPUT FILE PATH:
            \competency_formal_grammar\demo\generation\output\DEMOwholenumsNestedParentOutput.xml 
    -->


    <xsl:output method="xml" indent="yes"/>


    <!--The below series of global parameters are just strings of text designed to 
        match element names of the "string buckets" in the source XML. 
        Parameters are very similar to variables in XSLT, but have a little more flexibility.
        
        They can be used to send a series of filtered sentence chunks as 
        input into the sentence writer function template.-->
    <xsl:param name="formal_process" as="xs:string" select="'formalProcess'"/>
    <xsl:param name="knowledge_process" as="xs:string" select="'knowledgeProcess'"/>
    <xsl:param name="knowledge_subprocess" as="xs:string" select="'knowledgeSubprocess'"/>
    <xsl:param name="processPred" as="xs:string" select="'processPred'"/>
    <xsl:param name="math_operation" as="xs:string" select="'mathOperation'"/>
    <xsl:param name="object" as="xs:string" select="'quant'"/>
    <xsl:param name="notationObject" as="xs:string" select="'notationObject'"/>


    <!-- SCOPE KEY -->
    <xsl:key name="scopes" match="string" use="@class ! tokenize(., '\s+')"/>
    
    <!-- SCOPE PARAMS -->
        <!--  called upon by the scope key^ to output only the chunks that have
                 an @class value that matches the given param -->
    
      <!-- whole numbers -->
         <xsl:param name="wholenum" as="xs:string" select="'wholenum'"/>
     <!-- K-5 -->
         <xsl:param name="int" as="xs:string" select="'int'"/>
          <xsl:param name="rational" as="xs:string" select="'rational'"/>
          <xsl:param name="algexp" as="xs:string" select="'algexp'"/>
          <xsl:param name="numexp" as="xs:string" select="'numexp'"/>
     <!-- Other scopes -->
         <xsl:param name="complex" as="xs:string" select="'complex'"/>
          <xsl:param name="imag" as="xs:string" select="'imag'"/>
         <xsl:param name="plane" as="xs:string" select="'plane'"/>
         <xsl:param name="space" as="xs:string" select="'space'"/>
         <xsl:param name="expect" as="xs:string" select="'expect'"/>
           <xsl:param name="real" as="xs:string" select="'real'"/>
         <xsl:param name="unit" as="xs:string" select="'unit'"/>
          <xsl:param name="vector" as="xs:string" select="'vector'"/>
     <!-- scopes not filtered yet -->
         <xsl:param name="matrix" as="xs:string" select="'matrix'"/>
         <xsl:param name="infinite" as="xs:string" select="'infinite'"/>
         <xsl:param name="random" as="xs:string" select="'random'"/>
         <xsl:param name="prob" as="xs:string" select="'prob'"/>
    


    <!-- NOTATION STRING KEY -->
    <xsl:key name="notationKey" match="string" use="@subclass ! normalize-space()"/>
    <!-- SUBCLASS NOTATION PARAMS -->
    <xsl:param name="notation" as="xs:string" select="'notation'"/>
    <xsl:param name="noNot" as="xs:string" select="'noNot'"/>


    <!-- SENTENCE CONSTRUCTOR TEMPLATES - this is where the input params are sent to, to be processed into full sentences. -->

    <!-- LOW-LVL COMP WRITER -->
    <xsl:template name="sentenceWriter" as="element()+">
        <!-- all competency sentences are composed of at least two input chunks. the rest are optional/conditional -->
        <xsl:param name="param1" as="element()+" required="yes"/>
        <xsl:param name="param2" as="element()+" required="yes"/>
        <xsl:param name="param3" as="element()*"/>
        <xsl:param name="param4" as="element()*"/>
        <xsl:param name="scopeParam" as="xs:string?"/>
        <xsl:param name="subScopeParam" as="element()*"/>
        <xsl:param name="subProcessParam" as="element()*"/>

        <!-- Purpose of the variables:
            take the bucket node names and set them as component element names 
                using the input params as reference to which string is being sent, and find 
                    which bucket that string belongs to.
            -->
        <xsl:variable name="var1" as="xs:string+" select="$param1/parent::* ! name()"/>
        <xsl:variable name="var2" as="xs:string+" select="$param2/parent::* ! name()"/>
        <xsl:variable name="var3" as="xs:string*" select="$param3/parent::* ! name()"/>
        <xsl:variable name="var4" as="xs:string*" select="$param4/parent::* ! name()"/>

        <xsl:variable name="varSubProcess" as="xs:string*"
            select="$subProcessParam/parent::* ! name()"/>

        <xsl:for-each select="$param1 ! normalize-space()">
            <!-- variable for the first sentence chunk (current() in this instance = $param1) -->
            <xsl:variable name="currLevel1" as="xs:string" select="current()"/>

            <xsl:for-each select="$param2 ! normalize-space()">
                <!-- variable for the 2nd sentence chunk (current() in this instance = $param2) -->
                <xsl:variable name="currLevel2" as="xs:string?" select="current()"/>

                <!-- this is where the sentenceWriter will either end the current sentence construction and move on
                        to the next sentence, or it will continue based on the presence or absence of a 3rd input param-->
                <xsl:choose>
                    <xsl:when test="$param3">
                        <xsl:for-each select="$param3 ! normalize-space()">
                            <!-- variable for the 3rd sentence chunk (current() in this instance = $param3) -->
                            <xsl:variable name="currLevel3" as="xs:string?" select="current()"/>
                            <xsl:choose>
                                <xsl:when test="$param4">
                      <!-- when there are 4 input parameters being sent by a template, the following is generated
                            (up until the end of this <xsl:when> -->
                                    <xsl:for-each select="$param4 ! normalize-space()">
                                        <!-- variable for the 4th sentence chunk (current() in this instance = $param4) -->
                                        <xsl:variable name="currLevel4" as="xs:string?"
                                            select="current()"/>
                                        
                  <!-- FOUR-PART SENTENCES -->
                                        <xsl:for-each select="$scopeParam">
                               <!-- this variable grabs the current scope string input param  -->
                                            <xsl:variable name="scopeInsert" as="xs:string"
                                                select="current()"/>
                                            <xsl:for-each select="$subScopeParam">
                                    <!-- this variable grabs the current subscope string input param to be used in the sentence -->
                                                <xsl:variable name="subscopeInsert" as="xs:string"
                                                  select="current()"/>
                                                
                                    <!-- this variable grabs the current subscope string's @id to be used as the ssID -->
                                                <xsl:variable name="varSubScope" as="xs:string*"
                                                  select="//subScope/string[./text() = current()/text()]/@id"/>
                                          <!-- this variable grabs the current subscope string's @extends to be used as 
                                                  the ssExtends (ID of the progressive parent) -->
                                                <xsl:variable name="varExtends" as="xs:string*"
                                                  select="//subScope/string[./text() = current()/text()]/@extends"/>
                                                
                                                <xsl:choose>
                                                  <!-- since the knowledge subprocess strings must be placed at the end of the competency sentence, 
                                                            it is the last possible option for sentence construction. -->
                                                  <xsl:when test="$subProcessParam">
                                                  <xsl:for-each select="$subProcessParam">
                                                  <!-- grabs the knowledge subprocess input for each subprocessInsert param -->
                                                  <xsl:variable name="subProcessInsert"
                                                  as="xs:string" select="current()"/>
                                                      
                                                      <!-- progressive IDs generated as attribute values -->
                                                  <componentSentence id="{$varSubScope}"
                                                  extends="{$varExtends}">

                                                    <xsl:element name="{$var1}"> <!-- 1st sentence chunk parent "bucket" element name -->
                                                        <xsl:sequence select="$currLevel1"/> <!-- 1st sentence chunk string-->
                                                     </xsl:element>
                                                     <xsl:element name="{$var2}"> <!-- 2nd sentence chunk parent "bucket" element name -->
                                                         <xsl:sequence select="$currLevel2"/>  <!-- 2nd sentence chunk string-->
                                                     </xsl:element>
                                                    <xsl:element name="{$var3}"> <!-- 3rd sentence chunk parent "bucket" element name -->
                                                        <xsl:sequence select="$currLevel3"/> <!-- 3rd sentence chunk string -->
                                                    </xsl:element>
                                                    <xsl:element name="{$var4}"> <!-- 4th sentence chunk parent "bucket" name -->
                                                        <xsl:sequence select="$currLevel4"/> <!-- 4th sentence chunk string -->
                                                    </xsl:element>
                                                    <xsl:element name="scopeName">
                                                        <xsl:sequence select="$scopeInsert"/> <!-- scope string insert (in this case: "involving Whole Numbers" -->
                                                    </xsl:element>
                                                    <xsl:element name="subScope">
                                                        <xsl:sequence select="$subscopeInsert"/> <!-- sub-scope string insert ("to 5", "to 10", "within 100", etc.) -->
                                                    </xsl:element>
                                                    <xsl:element name="{$varSubProcess}"> <!-- knowledge subprocess "bucket" element name -->
                                                        <xsl:sequence select="$subProcessInsert"/> <!-- knowledge subprocess string chunk -->
                                                    </xsl:element>

                                                  </componentSentence>

                                                  </xsl:for-each>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                      
                                                  <!-- no subprocess param input -->
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
                                                  </componentSentence>
                                                      
                                                  </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:for-each>
                                        </xsl:for-each>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:otherwise>
                                    <!-- THREE PARAM SENTENCE with subprocess -->
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
                                                  <!-- THREE-PARAM SENTENCE with no subprocess -->
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
                                <xsl:variable name="varExtends" as="xs:string*"
                                    select="//subScope/string[./text() = current()/text()]/@extends"/>
                                <xsl:choose>
                                    <xsl:when test="$subProcessParam">
                                        <xsl:for-each select="$subProcessParam">
                                            <xsl:variable name="subProcessInsert" as="xs:string"
                                                select="current()"/>
                                            <!-- two-param with subprocess -->
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
                                        <!-- two-param without subprocess -->
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



  <!-- 1st and 2nd-level PARENT COMP WRITER
        This template function does not process scope strings or subscope strings, 
            and therefore does not need the same kind of nested when/otherwise xsl:choose structure as low-level competencies.-->
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
                    <xsl:when test="$param3">
                        <xsl:for-each select="$param3 ! normalize-space()">
                            <xsl:variable name="currLevel3" as="xs:string?" select="current()"/>
                            <xsl:choose>
                                <xsl:when test="$param4">
                                    <xsl:for-each select="$param4 ! normalize-space()">
                                        <xsl:variable name="currLevel4" as="xs:string?"
                                            select="current()"/>
                                        <!--  FOUR-PART SENTENCE -->
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
                                    <!-- THREE-PART SENTENCE -->
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
                        <!-- TWO-PART SENTENCE -->
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



    <!-- this template match on the entire document "/" is where the string components from the input XML are filtered through and 
             captured, based on which scope is keyed, then sent up to the sentence writers as input params 
                    to be put together as a sentence. -->
           <!-- This template also formats the output document's structure hierarchy for the competencies based on groups of parent comps,
            their immediate low-level children comps, 2nd-level parents, and their immediate lowest-level children.-->
    <xsl:template match="/">
        <xml>

            <!-- *******************FORMAL PROCESS BRANCH******************************************* -->


            <xsl:comment>####################################</xsl:comment>
            <xsl:comment> Formal Process(keyed to NoNot subclass) + Process Predicate</xsl:comment>
            <xsl:comment>####################################</xsl:comment>
            
     <!-- the below variables are filtering through all of the string elements in the input, finding only those
                whose @class value matches the scope competency being generated, and then captures 
                    a sequence of those strings from one particular competency component bucket. -->
            
            <xsl:variable name="FP_noNot" as="element()+">
                <!-- SCOPE key being called, to capture only WHOLENUM strings -->
                <xsl:for-each select="key('scopes', $wholenum)"> 
                    <!-- sequence of wholenum strings from the FORMAL PROCESS bucket are captured -->
                    <xsl:sequence select=".[parent::* ! name() = $formal_process]"/> 
                </xsl:for-each>
            </xsl:variable>
            
            <xsl:variable name="PrPred" as="element()+">
                <xsl:for-each select="key('scopes', $wholenum)">
                    <!-- sequence of wholenum strings from the PROCESS PREDICATE bucket are captured -->
                    <xsl:sequence select=".[parent::* ! name() = $processPred]"/>
                </xsl:for-each>
            </xsl:variable>
            
            <!-- these last two variables are only sent to the input params for the low-level competencies,
                    because they are specific. Parent comps remain broad -->
            <xsl:variable name="wholenumScopeString" select="'involving Whole Numbers'"/>
            
            <xsl:variable name="subScopeString" as="element()+">
                <xsl:for-each select="key('scopes', $wholenum)">
                    <xsl:sequence select=".[parent::* ! name() = 'subScope']"/>
                </xsl:for-each>
            </xsl:variable>
            
            
            <parent group="fp-pp">
                <parentGroup match="fp-pp" lvl="1"> <!-- top-level parents, consisting of FP and PP strings -->
                    <xsl:call-template name="parentWriter">
                        <xsl:with-param name="param1" as="element()+" select="$FP_noNot"/>
                        <xsl:with-param name="param2" as="element()+" select="$PrPred"/>
                    </xsl:call-template>
                </parentGroup>
                <compGroup id="fp-pp"> <!-- direct competency children of the FP-PP top-level parent group  -->
                    <xsl:call-template name="sentenceWriter">
                        <xsl:with-param name="param1" as="element()+" select="$FP_noNot"/>
                        <xsl:with-param name="param2" as="element()+" select="$PrPred"/>
                        <xsl:with-param name="scopeParam" as="xs:string"
                            select="$wholenumScopeString"/>
                        <xsl:with-param name="subScopeParam" as="element()+"
                            select="$subScopeString"/>
                    </xsl:call-template>
                </compGroup>


                <xsl:comment>####################################</xsl:comment>
                <xsl:comment> Formal Process(keyed to Notation subclass) + Process Predicate + Notation Obj</xsl:comment>
                <xsl:comment>####################################</xsl:comment>

                <xsl:variable name="FP_notation" as="element()+">
        <!-- this Formal Process variable needs to capture ONLY the input strings that are
               allowed to occur in a competency that contains a Notation Object string.-->
                    <xsl:for-each
                        select="key('notationKey', $notation) intersect key('scopes', $wholenum)">
     <!-- so, we tell it to select only those FP strings who have 'notation' @subclass value 
             AND a 'wholenum' @class value, by intersecting the two keys.-->
                        <xsl:sequence select=".[parent::* ! name() = $formal_process]"/>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="NO" as="element()+"> <!-- grabs strings from the notationObject bucket -->
                    <xsl:for-each select="key('scopes', $wholenum)">
                        <xsl:sequence select=".[parent::* ! name() = $notationObject]"/>
                    </xsl:for-each>
                </xsl:variable>

                <notationParent>
                    <parentGroup match="fp-pp-no" lvl="2"> <!-- 2nd-level sub-parents, containing a FP, PP, AND a Notation Obj string -->
                        <xsl:call-template name="parentWriter">
                            <xsl:with-param name="param1" as="element()+" select="$FP_notation"/>
                            <xsl:with-param name="param2" as="element()+" select="$PrPred"/>
                            <xsl:with-param name="param3" as="element()+" select="$NO"/>
                        </xsl:call-template>
                    </parentGroup>
                    <compGroup id="fp-pp-no"> <!-- bottom-level competencies, containing all of the above ^^ plus a scope + sub-scope string -->
                        <xsl:call-template name="sentenceWriter">
                            <xsl:with-param name="param1" as="element()+" select="$FP_notation"/>
                            <xsl:with-param name="param2" as="element()+" select="$PrPred"/>
                            <xsl:with-param name="param3" as="element()+" select="$NO"/>
                            <xsl:with-param name="scopeParam" as="xs:string"
                                select="$wholenumScopeString"/>
                            <xsl:with-param name="subScopeParam" as="element()+"
                                select="$subScopeString"/>
                        </xsl:call-template>
                    </compGroup>
                </notationParent>

            </parent>


            <xsl:comment>####################################</xsl:comment>
            <xsl:comment>Formal Process(keyed to noNot subclass) + Math Operation + Quant Object </xsl:comment>
            <xsl:comment>####################################</xsl:comment>

            <xsl:variable name="MathOp" as="element()+">
                <xsl:for-each select="key('scopes', $wholenum)">
                    <!-- sequence of wholenum strings from the MATH OPERATION bucket are captured -->
                    <xsl:sequence select=".[parent::* ! name() = $math_operation]"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="QO" as="element()+">
                <xsl:for-each select="key('scopes', $wholenum)">
                    <!-- sequence of wholenum strings from the QUANTITIVE OBJECT bucket are captured -->
                    <xsl:sequence select=".[parent::* ! name() = $object]"/>
                </xsl:for-each>
            </xsl:variable>
     
            <parent group="fp-mathop">
                <parentGroup match="fp-mathop" lvl="1"> <!-- top-level parent comps, containing FP, Math Opertation, + Quantitive Object -->
                    <xsl:call-template name="parentWriter">
                        <xsl:with-param name="param1" as="element()+" select="$FP_noNot"/>
                        <xsl:with-param name="param2" as="element()+" select="$MathOp"/>
                        <xsl:with-param name="param3" as="element()+" select="$QO"/>
                    </xsl:call-template>
                </parentGroup>
                <compGroup id="fp-mathop"> <!-- direct children ^^ (added scope + subscope strings) -->
                    <xsl:call-template name="sentenceWriter">
                        <xsl:with-param name="param1" as="element()+" select="$FP_noNot"/>
                        <xsl:with-param name="param2" as="element()+" select="$MathOp"/>
                        <xsl:with-param name="param3" as="element()+" select="$QO"/>
                        <xsl:with-param name="scopeParam" as="xs:string"
                            select="$wholenumScopeString"/>
                        <xsl:with-param name="subScopeParam" as="element()+"
                            select="$subScopeString"/>
                    </xsl:call-template>
                </compGroup>




                <xsl:comment>####################################</xsl:comment>
                <xsl:comment>Formal Process(keyed to Notation subclass) + Math Operation + Quant Object + Notation Obj</xsl:comment>
                <xsl:comment>####################################</xsl:comment>

                <xsl:variable name="FP_notation" as="element()+">
                    <xsl:for-each
                        select="key('notationKey', $notation) intersect key('scopes', $wholenum)">
                        <xsl:sequence select=".[parent::* ! name() = $formal_process]"/>
                    </xsl:for-each>
                </xsl:variable>
         
                <xsl:variable name="NO" as="element()+">
                    <xsl:for-each select="key('scopes', $wholenum)">
                        <xsl:sequence select=".[parent::* ! name() = $notationObject]"/>
                    </xsl:for-each>
                </xsl:variable>
           
                
                <notationParent>
                    <parentGroup match="fp-mathop-no" lvl="2"> <!-- 2nd-level parent comps (FP-MathOp-QO-NO) -->
                        <xsl:call-template name="parentWriter">
                            <xsl:with-param name="param1" as="element()+" select="$FP_notation"/>
                            <xsl:with-param name="param2" as="element()+" select="$MathOp"/>
                            <xsl:with-param name="param3" as="element()+" select="$QO"/>
                            <xsl:with-param name="param4" as="element()+" select="$NO"/>
                        </xsl:call-template>
                    </parentGroup>
                    <compGroup id="fp-mathop-no"> <!-- lowest-level child comps of ^^ -->
                        <xsl:call-template name="sentenceWriter">
                            <xsl:with-param name="param1" as="element()+" select="$FP_notation"/>
                            <xsl:with-param name="param2" as="element()+" select="$MathOp"/>
                            <xsl:with-param name="param3" as="element()+" select="$QO"/>
                            <xsl:with-param name="param4" as="element()+" select="$NO"/>
                            <xsl:with-param name="scopeParam" as="xs:string"
                                select="$wholenumScopeString"/>
                            <xsl:with-param name="subScopeParam" as="element()+"
                                select="$subScopeString"/>
                        </xsl:call-template>
                    </compGroup>
                </notationParent>
            </parent>



            <!--    <xsl:comment>*********Knowledge Process Branch************** </xsl:comment>-->


            <xsl:comment>########################################</xsl:comment>
            <xsl:comment>Knowledge Process + Process Pred</xsl:comment>
            <xsl:comment>####################################</xsl:comment>

            <xsl:variable name="KP" as="element()+"> <!-- new Knowledge Process bucket string variable -->
                <xsl:for-each select="key('scopes', $wholenum)">
                    <xsl:sequence select=".[parent::* ! name() = $knowledge_process]"/>
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
                        <xsl:with-param name="scopeParam" as="xs:string"
                            select="$wholenumScopeString"/>
                        <xsl:with-param name="subScopeParam" as="element()+"
                            select="$subScopeString"/>
                    </xsl:call-template>
                </compGroup>


                <xsl:comment>#########################################</xsl:comment>
                <xsl:comment>Knowledge Process + Process Pred + Knowledge Subprocess</xsl:comment>
                <xsl:comment>####################################</xsl:comment>

                <!-- knowledge SUBPROCESS bucket string variable -->
                <xsl:variable name="KSP" as="element()+">
                    <xsl:for-each select="key('scopes', $wholenum)">
                        <xsl:sequence select=".[parent::* ! name() = $knowledge_subprocess]"/>
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
                            <xsl:with-param name="scopeParam" as="xs:string"
                                select="$wholenumScopeString"/>
                            <xsl:with-param name="subScopeParam" as="element()+"
                                select="$subScopeString"/>
                            <xsl:with-param name="subProcessParam" as="element()+" select="$KSP"/> <!-- KSP goes at the end of the sentece -->
                        </xsl:call-template>
                    </compGroup>
                </subParent>
            </parent>





            <xsl:comment>####################################</xsl:comment>
            <xsl:comment>Knowledge Process + Math Operation + Quant Object</xsl:comment>
            <xsl:comment>####################################</xsl:comment>


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
                        <xsl:with-param name="scopeParam" as="xs:string"
                            select="$wholenumScopeString"/>
                        <xsl:with-param name="subScopeParam" as="element()+"
                            select="$subScopeString"/>
                    </xsl:call-template>
                </compGroup>


                <xsl:comment>####################################</xsl:comment>
                <xsl:comment>Knowledge Process + Math Operation + Quant Object + Knowledge Subprocess</xsl:comment>
                <xsl:comment>####################################</xsl:comment>

                <xsl:variable name="KSP" as="element()+">
                    <xsl:for-each select="key('scopes', $wholenum)">
                        <xsl:sequence select=".[parent::* ! name() = $knowledge_subprocess]"/>
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
                            <xsl:with-param name="subScopeParam" as="element()+"
                                select="$subScopeString"/>
                            <xsl:with-param name="subProcessParam" as="element()+" select="$KSP"/>
                        </xsl:call-template>
                    </compGroup>
                </subParent>
            </parent>
        </xml>

    </xsl:template>

</xsl:stylesheet>
