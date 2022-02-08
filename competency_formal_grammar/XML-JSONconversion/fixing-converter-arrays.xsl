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
    
    <!-- WHOLENUMS INPUT FILE:
                wholenumsSSIDFormatted.xml
        WHOLENUMS OUTPUT FILE:
                wholenumsCompetencies.json-->
    
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
                        "text": "<xsl:apply-templates select="child::Title/text => normalize-space()"/>"
                        }],
                        "Definition": [{
                        "lang": "<xsl:apply-templates select="child::Definition/lang"/>",
                        "text": "<xsl:apply-templates select="child::Definition/text => normalize-space()"/>"
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
                        "text": "<xsl:apply-templates select="child::Title/text => normalize-space()"/>"
                        }],
                        "Definition": [{
                        "lang": "<xsl:apply-templates select="child::Definition/lang"/>",
                        "text": "<xsl:apply-templates select="child::Definition/text => normalize-space()"/>"
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
                "text": "<xsl:apply-templates select="child::Title/text => normalize-space()"/>"
                }],
                "Definition": [{
                    "lang": "<xsl:apply-templates select="child::Definition/lang"/>",
                "text": "<xsl:apply-templates select="child::Definition/text => normalize-space()"/>"
                }]
                },
            </xsl:when>
            <xsl:otherwise>
               {
               "Token": "<xsl:apply-templates select="Token"/>",
                "Creator": "<xsl:apply-templates select="Creator"/>",
                "Title": [{
                "lang": "<xsl:apply-templates select="child::Title/lang"/>",
                "text": "<xsl:apply-templates select="child::Title/text => normalize-space()"/>"
                }],
                "Definition": [{
                "lang": "<xsl:apply-templates select="child::Definition/lang"/>",
                "text": "<xsl:apply-templates select="child::Definition/text => normalize-space()"/>"
                }]
                }
            </xsl:otherwise>
        </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    
</xsl:stylesheet>