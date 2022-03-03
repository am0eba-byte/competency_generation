<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="3.0">

    <!-- TEST INPUT FILE: mergedNestedSeedComps.xml -->
    <!-- TEST OUTPUT FILE: mergedDomainsFormatted.xml -->
    
    <!-- non-wholenums input: mergedNestedCompOutput-nonwholenum.xml -->
    <!-- non-wholenums output: allNon-WholeNumsDomainsFormatted.xml -->
    
    <!-- wholenums input: wholenumsSSIDNestedComps.xml -->
    <!-- wholenums output: wholenumsSSIDFormatted.xml -->
    
    <!-- ************* DO NOT USE THIS XSLT TO CONVERT WHOLENUMS COMPS ****************** -->

    <xsl:output method="xml" indent="yes"/>


    <xsl:template match="/">
        <compColl>

            <xsl:apply-templates select="//componentSentence"/>

        </compColl>
    </xsl:template>

    <xsl:template match="componentSentence">
    
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

    <!-- to generate random ids:  id="{generate-id(.)}" -->

   <!-- <xsl:template match="@id">
        <xsl:apply-templates/><!-\-\-<xsl:value-of select="./position() + 1"/>-\->
    </xsl:template>

    <xsl:template match="@extends">
        <xsl:apply-templates/><!-\-\-<xsl:value-of select="./position() + 1"/>-\->
    </xsl:template>-->

</xsl:stylesheet>
