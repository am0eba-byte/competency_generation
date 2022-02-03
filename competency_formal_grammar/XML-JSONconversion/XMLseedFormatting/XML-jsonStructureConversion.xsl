<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="3.0">

    <!-- TEST INPUT FILE: mergedNestedSeedComps.xml -->
    <!-- TEST OUTPUT FILE: mergedDomainsFormatted.xml -->
    
    <!-- non-wholenums input: mergedNestedCompOutput-nonwholenum.xml -->
    <!-- non-wholenums output: allNon-WholeNumsDomainsFormatted.xml -->
    
    <!-- wholenums input: wholenumsSSIDNestedComps.xml -->
    <!-- wholenums output: wholenumsSSIDFormatted.xml -->

    <xsl:output method="xml" indent="yes"/>
    
    <!-- SSID variables -->
        <!-- turn these into key params instead? -->
    <xsl:variable name="thousand" select="//sentenceGroup[not(.[ends-with(@id, 'sp')])]/componentSentence[position() mod 11 = 0]"/>
    <xsl:variable name="zero" select="//sentenceGroup[not(.[ends-with(@id, 'sp')])]/componentSentence[position() mod 11 = 1]"/>
    <xsl:variable name="one" select="//sentenceGroup[not(.[ends-with(@id, 'sp')])]/componentSentence[position() mod 11 = 2]"/>
    <xsl:variable name="two" select="//sentenceGroup[not(.[ends-with(@id, 'sp')])]/componentSentence[position() mod 11 = 3]"/>
    <xsl:variable name="three" select="//sentenceGroup[not(.[ends-with(@id, 'sp')])]/componentSentence[position() mod 11 = 4]"/>
    <xsl:variable name="four" select="//sentenceGroup[not(.[ends-with(@id, 'sp')])]/componentSentence[position() mod 11 = 5]"/>
    <xsl:variable name="five" select="//sentenceGroup[not(.[ends-with(@id, 'sp')])]/componentSentence[position() mod 11 = 6]"/>
    <xsl:variable name="ten" select="//sentenceGroup[not(.[ends-with(@id, 'sp')])]/componentSentence[position() mod 11 = 7]"/>
    <xsl:variable name="twenty" select="//sentenceGroup[not(.[ends-with(@id, 'sp')])]/componentSentence[position() mod 11 = 8]"/>
    <xsl:variable name="hundred" select="//sentenceGroup[not(.[ends-with(@id, 'sp')])]/componentSentence[position() mod 11 = 9]"/>
    <xsl:variable name="oneTwenty" select="//sentenceGroup[not(.[ends-with(@id, 'sp')])]/componentSentence[position() mod 11 = 10]"/>
    <!-- template match for every SSID variable component sentece? -->

 <!-- TO GET THE POSITION OF THE CURRENT VARIABLE ITERATION (like $pos): 
            <xsl:value-of select="position()"/> -->

    <!-- START ITERATION FUNCTION -->

    <xsl:template name="iterateSSID">
        
    </xsl:template>
    
    <!-- END ITERATION FUNCTION -->


    <xsl:template match="/">
        <compColl>

            <xsl:apply-templates select="//componentSentence"/>

        </compColl>
    </xsl:template>

    <xsl:template match="componentSentence">
        <xsl:for-each select=".">

            <xsl:choose>

                <xsl:when test="./@* => count() > 0">
                    <competency>
                        <ssID>
                            <xsl:apply-templates select="@id"/>
                            <!---<xsl:value-of select="//@id/current()[. = @id]/position() + 1"/>-->
                        </ssID>
                        <ssExtends>
                            <xsl:apply-templates select="@extends"/>
                        </ssExtends>

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
                </xsl:when>
                <xsl:otherwise>
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
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <!-- to generate random ids:  id="{generate-id(.)}" -->

   <!-- <xsl:template match="@id">
        <xsl:apply-templates/><!-\-\-<xsl:value-of select="./position() + 1"/>-\->
    </xsl:template>

    <xsl:template match="@extends">
        <xsl:apply-templates/><!-\-\-<xsl:value-of select="./position() + 1"/>-\->
    </xsl:template>-->

</xsl:stylesheet>
