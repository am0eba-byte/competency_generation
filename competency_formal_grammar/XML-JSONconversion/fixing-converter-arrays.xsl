<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="3.0">
    
    
    
    
    <!-- TEST INPUT FILE:  
        testinput.xml
        testFormattedOutput.xml -->
    <!-- TEST OUTPUT FILE: 
        testOutput.json
        testFormattedSeedOutput.json -->
    
    <xsl:output method="text"/>
    
    
    <xsl:template match="/">
        [
        <xsl:apply-templates select="//competency"/>
        ]
    </xsl:template>
    
    <xsl:template match="competency">
        <xsl:choose>
          
            <xsl:when test="child::ssID">
                <xsl:choose>
                    <xsl:when test="count(following-sibling::competency) > 0">
                        {
                        "Token": "<xsl:apply-templates select="Token"/>",
                        "ssID": "<xsl:apply-templates select="ssID"/>",
                        "ssExtends": "<xsl:apply-templates select="ssExtends"/>",
                        "Creator": "<xsl:apply-templates select="Creator"/>",
                        "Title": [{
                        "lang": "<xsl:apply-templates select="child::Title/lang"/>",
                        "text": "<xsl:apply-templates select="child::Title/text"/>"
                        }],
                        "Definition": [{
                        "lang": "<xsl:apply-templates select="child::Definition/lang"/>",
                        "text": "<xsl:apply-templates select="child::Definition/text"/>"
                        }]
                        },
                    </xsl:when>
                    <xsl:otherwise>
                       {
                        "Token": "<xsl:apply-templates select="Token"/>",
                        "ssID": "<xsl:apply-templates select="ssID"/>",
                        "ssExtends": "<xsl:apply-templates select="ssExtends"/>",
                        "Creator": "<xsl:apply-templates select="Creator"/>",
                        "Title": [{
                        "lang": "<xsl:apply-templates select="child::Title/lang"/>",
                        "text": "<xsl:apply-templates select="child::Title/text"/>"
                        }],
                        "Definition": [{
                        "lang": "<xsl:apply-templates select="child::Definition/lang"/>",
                        "text": "<xsl:apply-templates select="child::Definition/text"/>"
                        }]
                        }
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
            <xsl:when test="count(following-sibling::competency) > 0">
               {
                "Token": "<xsl:apply-templates select="Token"/>",
                "Creator": "<xsl:apply-templates select="Creator"/>",
                "Title": [{
                    "lang": "<xsl:apply-templates select="child::Title/lang"/>",
                "text": "<xsl:apply-templates select="child::Title/text"/>"
                }],
                "Definition": [{
                    "lang": "<xsl:apply-templates select="child::Definition/lang"/>",
                "text": "<xsl:apply-templates select="child::Definition/text"/>"
                }]
                },
            </xsl:when>
            <xsl:otherwise>
               {
               "Token": "<xsl:apply-templates select="Token"/>",
                "Creator": "<xsl:apply-templates select="Creator"/>",
                "Title": [{
                "lang": "<xsl:apply-templates select="child::Title/lang"/>",
                "text": "<xsl:apply-templates select="child::Title/text"/>"
                }],
                "Definition": [{
                "lang": "<xsl:apply-templates select="child::Definition/lang"/>",
                "text": "<xsl:apply-templates select="child::Definition/text"/>"
                }]
                }
            </xsl:otherwise>
        </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    
    
    
    <!--
    <xsl:template match="/">{
        <xsl:apply-templates select="*"/>}
    </xsl:template>
    
    <!-\- Object or Element Property-\->
    <xsl:template match="*">
        "<xsl:value-of select="name()"/>" : <xsl:call-template name="Properties"/>
    </xsl:template>
    
    <!-\- Array Element -\->
    <xsl:template match="*" mode="ArrayElement">
        <xsl:call-template name="Properties"/>
    </xsl:template>
    
    <!-\- Object Properties -\->
    <xsl:template name="Properties">
        <xsl:variable name="childName" select="name(*[1])"/>
        <xsl:variable name="lang" select="name(*[name() = 'lang'])"/>
        <xsl:variable name="text" select="name(*[name() = 'text'])"/>
        <xsl:choose>
            <xsl:when test="not(*|@*)">"<xsl:value-of select="."/>"</xsl:when>
            <xsl:when test="*[not(child::text())]">{ "<xsl:value-of select="name(current())"/>" :[<xsl:apply-templates select="competency" mode="ArrayElement"/>] }</xsl:when>
            <xsl:otherwise>{
                <xsl:apply-templates select="@*"/>
                <xsl:apply-templates select="*"/>
                }</xsl:otherwise>
        </xsl:choose>
        <xsl:if test="following-sibling::*">,</xsl:if>
    </xsl:template>
    
    <!-\- Attribute Property -\->
    <xsl:template match="@*">"<xsl:value-of select="name()"/>" : "<xsl:value-of select="."/>",
    </xsl:template>
    -->
    
    
</xsl:stylesheet>