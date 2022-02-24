<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="3.0">

    <!-- TEST INPUT FILE: integersNestedParentOutput.xml -->
    <!-- TEST OUTPUT FILE: transIDFormatted.xml -->
    
    
    <!-- ************* DO NOT USE THIS XSLT TO CONVERT WHOLENUMS COMPS ****************** -->

    <xsl:output method="xml" indent="yes"/>

<xsl:template match="/">
    <scope>
        <group type="fp-pp">
            <xsl:choose>
                <xsl:when test="//parent[@group='fp-pp']/notationParent">
                    <xsl:apply-templates select="//parent[@group='fp-pp']" mode="subgroup"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="//parent[@group='fp-pp']" mode="nosub"/>
                </xsl:otherwise>
            </xsl:choose>
            
        </group>
        <group type="fp-mathop"> 
            <xsl:choose>
                <xsl:when test="//parent[@group='fp-mathop']/notationParent">
                    <xsl:apply-templates select="//parent[@group='fp-mathop']" mode="subgroup"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="//parent[@group='fp-mathop']" mode="nosub"/>
                </xsl:otherwise>
            </xsl:choose>
          
        </group>
        <group type="kp-pp">
            <xsl:apply-templates select="//parent[@group='kp-pp']" mode="nosub"/>
        </group>
        <group type="kp-mathop">
            <xsl:apply-templates select="//parent[@group='kp-mathop']" mode="nosub"/>
        </group>
      <!-- <group type="fp"> 
           <xsl:apply-templates select="//parent[child::notationParent]"/>
           <!-\-<xsl:apply-templates select="//parent[@group='fp-mathop']"/>-\->
       </group>
        <group type="kp">
            <xsl:apply-templates select="//parent[not(child::notationParent)]"/>
         <!-\-   <xsl:apply-templates select="//parent[@group='kp-mathop']"/>-\->
        </group>-->
    </scope>
</xsl:template>

    <xsl:template match="parent[child::notationParent]" mode="subgroup">
      
        <parentCompColl lvl="1">
            <xsl:apply-templates select="parentGroup/componentSentence" mode="top"/>
        </parentCompColl>
        <compColl>

            <xsl:apply-templates select="compGroup/componentSentence" mode="low"/>

        </compColl>
<xsl:choose>        
        <xsl:when test="child::notationParent">
         <subgroup type="no">
        <parentCompColl lvl="2">
            <xsl:apply-templates select="notationParent/parentGroup/componentSentence" mode="mid"/>
            </parentCompColl>
            <compColl>
                <xsl:apply-templates select="notationParent/compGroup/componentSentence" mode="low"/>
            </compColl>
       </subgroup>
        </xsl:when>
    <xsl:otherwise>
        
    </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    
    
    <xsl:template match="parent[not(child::notationParent)]" mode="nosub">
        <parentCompColl lvl="1">
            <xsl:apply-templates select="parentGroup/componentSentence" mode="top"/>
        </parentCompColl>
        <compColl>
            
            <xsl:apply-templates select="compGroup/componentSentence" mode="low"/>
            
        </compColl>
        
        
    </xsl:template>
    
    
    <xsl:template match="componentSentence" mode="top">
        
        <competency>
            <Token>
                <!-- \W?\s+       [,?\s+] -->
                <xsl:choose>
                    <xsl:when test="descendant::*/text()[contains(., ',')]">
                        <xsl:apply-templates
                            select="string-join(descendant::*/tokenize(translate(lower-case(text()), '[a-z0-9_]+?,', '[a-z0-9_]'), '\s+'), '-')"
                        />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates
                            select="string-join(descendant::*/tokenize(lower-case(text()), '\s+'), '-')"
                        />
                    </xsl:otherwise>
                </xsl:choose>
            </Token>
            <tID>
                <xsl:apply-templates select="count(preceding::componentSentence[parent::parentGroup[@lvl = 1]])"/>
            </tID>
            <Creator>Big Ideas Learning</Creator>
            <Title>
                <lang>en-us</lang>
                <text>
                    <xsl:apply-templates select="string-join(descendant::*/text(), ' ')"
                    />
                </text>
                <!--<id><xsl:apply-templates select="generate-id(current())"/></id>-->
            </Title>
            <Definition>
                <lang>en-us</lang>
                <text>
                    <xsl:apply-templates select="string-join(descendant::*/text(), ' ')"
                    />
                </text>
                <!--<id><xsl:apply-templates select="generate-id(current())"/></id>-->
            </Definition>
        </competency>
        
    </xsl:template>
    
    
    
    <xsl:template match="componentSentence" mode="mid">
        
        <competency>
            <Token>
                <!-- \W?\s+       [,?\s+] -->
                <xsl:choose>
                    <xsl:when test="descendant::*/text()[contains(., ',')]">
                        <xsl:apply-templates
                            select="string-join(descendant::*/tokenize(translate(lower-case(text()), '[a-z0-9_]+?,', '[a-z0-9_]'), '\s+'), '-')"
                        />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates
                            select="string-join(descendant::*/tokenize(lower-case(text()), '\s+'), '-')"
                        />
                    </xsl:otherwise>
                </xsl:choose>
            </Token>
            <tID>
                <xsl:apply-templates select="count(preceding::componentSentence[parent::parentGroup[@lvl = 2]])"/>
            </tID>
          <!--  <tFrom>
                <xsl:apply-templates select=""
            </tFrom>-->
            <Creator>Big Ideas Learning</Creator>
            <Title>
                <lang>en-us</lang>
                <text>
                    <xsl:apply-templates select="string-join(descendant::*/text(), ' ')"
                    />
                </text>
                <!--<id><xsl:apply-templates select="generate-id(current())"/></id>-->
            </Title>
            <Definition>
                <lang>en-us</lang>
                <text>
                    <xsl:apply-templates select="string-join(descendant::*/text(), ' ')"
                    />
                </text>
                <!--<id><xsl:apply-templates select="generate-id(current())"/></id>-->
            </Definition>
        </competency>
        
    </xsl:template>
    
    
    <xsl:template match="componentSentence" mode="low">
        <!--  type="parent" lvl="{parent::parentGroup/@lvl}" -->
        <competency>
            <Token>
                <!-- \W?\s+       [,?\s+] -->
                <xsl:choose>
                    <xsl:when test="descendant::*/text()[contains(., ',')]">
                        <xsl:apply-templates
                            select="string-join(descendant::*/tokenize(translate(lower-case(text()), '[a-z0-9_]+?,', '[a-z0-9_]'), '\s+'), '-')"
                        />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates
                            select="string-join(descendant::*/tokenize(lower-case(text()), '\s+'), '-')"
                        />
                    </xsl:otherwise>
                </xsl:choose>
            </Token>
            <tID>
                <xsl:apply-templates select="count(preceding::componentSentence[parent::compGroup])"/>
            </tID>
            <Creator>Big Ideas Learning</Creator>
            <Title>
                <lang>en-us</lang>
                <text>
                    <xsl:apply-templates select="string-join(descendant::*/text(), ' ')"
                    />
                </text>
                <!--<id><xsl:apply-templates select="generate-id(current())"/></id>-->
            </Title>
            <Definition>
                <lang>en-us</lang>
                <text>
                    <xsl:apply-templates select="string-join(descendant::*/text(), ' ')"
                    />
                </text>
                <!--<id><xsl:apply-templates select="generate-id(current())"/></id>-->
            </Definition>
        </competency>
    </xsl:template>
<!--
    <xsl:template match="//componentSentence">
    
        <competency type="child">
                        <Token>
                            <!-\- \W?\s+       [,?\s+] -\->
                            <xsl:choose>
                                <xsl:when test="descendant::*/text()[contains(., ',')]">
                                    <xsl:apply-templates
                                        select="string-join(descendant::*/tokenize(translate(lower-case(text()), '[a-z0-9_]+?,', '[a-z0-9_]'), '\s+'), '-')"
                                    />
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:apply-templates
                                        select="string-join(descendant::*/tokenize(lower-case(text()), '\s+'), '-')"
                                    />
                                </xsl:otherwise>
                            </xsl:choose>
                        </Token>
                        <Creator>Big Ideas Learning</Creator>
                        <Title>
                            <lang>en-us</lang>
                            <text>
                                <xsl:apply-templates select="string-join(descendant::*/text(), ' ')"
                                />
                            </text>
                            <!-\-<id><xsl:apply-templates select="generate-id(current())"/></id>-\->
                        </Title>
                        <Definition>
                            <lang>en-us</lang>
                            <text>
                                <xsl:apply-templates select="string-join(descendant::*/text(), ' ')"
                                />
                            </text>
                            <!-\-<id><xsl:apply-templates select="generate-id(current())"/></id>-\->
                        </Definition>
                    </competency>
            
    </xsl:template>
-->
    <!-- to generate random ids:  id="{generate-id(.)}" -->

   <!-- <xsl:template match="@id">
        <xsl:apply-templates/><!-\-\-<xsl:value-of select="./position() + 1"/>-\->
    </xsl:template>

    <xsl:template match="@extends">
        <xsl:apply-templates/><!-\-\-<xsl:value-of select="./position() + 1"/>-\->
    </xsl:template>-->

</xsl:stylesheet>
