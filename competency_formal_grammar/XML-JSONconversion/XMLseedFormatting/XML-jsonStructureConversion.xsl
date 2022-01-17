<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="3.0">
    
    <!-- TEST INPUT FILE: TESTnumericExpNestedInput.xml -->
    <!-- TEST OUTPUT FILE: testFormattedOutput.xml -->
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:template match="/">
        <compColl>
            
                <xsl:apply-templates select="//componentSentence"/>
            
        </compColl>
    </xsl:template>
    
    <xsl:template match="componentSentence">
      <xsl:for-each select=".">
        <competency>
            <Token><!-- \W?\s+       [,?\s+] -->
                <xsl:choose>
                    <xsl:when test="descendant::*/text()[contains(., ',')]">
                        <xsl:apply-templates select="string-join(descendant::*/tokenize(translate(lower-case(text()), '[a-z0-9_]+?,', '[a-z0-9_]'), '\s+'), '-')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="string-join(descendant::*/tokenize(lower-case(text()), '\s+'), '-')"/>
                    </xsl:otherwise>
                </xsl:choose>
                
            </Token>
            <Creator>Big Ideas Learning</Creator>
            <Title id="{generate-id(.)}">
                <lang>en-us</lang>
                <text><xsl:apply-templates select="string-join(descendant::*/text(), ' ')"/></text>
                <!--<id><xsl:apply-templates select="generate-id(current())"/></id>-->
            </Title>
            <Definition id="{generate-id(.)}">
                <lang>en-us</lang>
                <text><xsl:apply-templates select="string-join(descendant::*/text(), ' ')"/></text>
                <!--<id><xsl:apply-templates select="generate-id(current())"/></id>-->
            </Definition>
        </competency>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>