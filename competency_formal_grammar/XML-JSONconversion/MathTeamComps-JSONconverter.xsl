<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="3.0">
    
    
    <!-- 
        formatted math team comps INPUT FILE:
        gradeKCompsFormatted.xml
    -->
    <!-- 
        math team comps OUTPUT FILE:
        gradeKComps.json
       -->
    
    <xsl:output method="text"/>
    
    
    <xsl:template match="/">
        [
        <xsl:apply-templates select="//group[@lvl='1']/parentCompColl[@lvl='1']/competency" mode="top"/><!-- TOP-LEVEL domain parent competencies -->
        <xsl:apply-templates select="//subgroup[@type='subD']/parentCompColl[@lvl='2']/competency" mode="subD"/> <!-- 2nd-LEVEL subdomain comps -->
        <xsl:apply-templates select="//subgroup[@type='minorD']/parentCompColl[@lvl='3']/competency" mode="minD"/><!-- 3rd-LEVEL minor domain comps -->
        <xsl:apply-templates select="//children[@type='comps']/competency[child::ssID]" mode="compsSSID"/> <!-- lowest-lvl comps WITH SSIDS -->
        <xsl:apply-templates select="//children[@type='comps']/competency[child::Notes]" mode="compsNOTES"/> <!-- lowest-lvl comps WITH NOTES -->
        <xsl:apply-templates select="//children[@type='comps']/competency[not(child::Notes) and not(child::ssID)]" mode="comps"/><!-- LOWEST-LEVEL competencies (no Notes nor ssID) -->
        ]
    </xsl:template>
    
    
    <!-- TOP LEVEL DOMAIN COMPS -->
    <xsl:template match="competency" mode="top">
        <xsl:variable name="tIDtop" select="count(preceding::competency[parent::parentCompColl[@lvl = '1']])"/>
      
                        {
                        "Token": "<xsl:apply-templates select="Token"/>",
                        "tID": "<xsl:apply-templates select="tID/text()"/>",
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
                  
    </xsl:template>
    
    
    
    <!-- LEVEL 2 SUBDOMAIN COMPS -->
    <xsl:template match="competency" mode="subD">
        <xsl:variable name="tIDcurrent" select="./tID/text()"/> <!-- grab the current comp's tID -->
        <xsl:variable name="tIDparent" select="ancestor::group[@lvl='1']/parentCompColl[@lvl = '1']/competency/tID/text()"/> <!-- grab the parent's tID from that same group -->
        
        <!-- put them together to create the comp's tID -->
        <xsl:variable name="tIDiter" select="concat($tIDparent, '.', $tIDcurrent)"/>
        {
        "Token": "<xsl:apply-templates select="Token"/>",
        "tID": "<xsl:apply-templates select="$tIDiter"/>",
        "tFrom": "<xsl:apply-templates select="$tIDparent"/>",
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
        
    </xsl:template>
    
    
    <!-- LEVEL 3 MINOR DOMAIN COMPS -->
    <xsl:template match="competency" mode="minD">
        <xsl:variable name="tIDcurrent" select="./tID/text()"/> <!-- grab current comp's tID -->
        <xsl:variable name="tIDparent" select="ancestor::subgroup[@type='subD']/parentCompColl[@lvl = '2']/competency/tID/text()"/> <!-- grab the subdomain parent's tID -->
        <xsl:variable name="tIDdom" select="ancestor::group[@lvl='1']/parentCompColl[@lvl='1']/competency/tID/text()"/> <!-- grab top-level parent's tID -->
        <xsl:variable name="tIDiter" select="concat($tIDdom,'.', $tIDparent, '.', $tIDcurrent)"/> <!-- put 'em together -->
        <xsl:variable name="tIDiterParent" select="concat($tIDdom, '.', $tIDparent)"/> <!-- create tID of parent from pieces -->

                        {
                        "Token": "<xsl:apply-templates select="Token"/>",
                        "tID": "<xsl:apply-templates select="$tIDiter"/>",
                        "tFrom": "<xsl:apply-templates select="$tIDiterParent"/>",
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
                 
    </xsl:template>
    
    <!-- LOWEST-LEVEL COMPS (with Notes) -->
    <xsl:template match="competency[child::Notes]" mode="compsNOTES">
        <xsl:variable name="tIDcurrent" select="./tID/text()"/>
        <xsl:variable name="tIDparent" select="ancestor::subgroup[@type='minorD']/parentCompColl[@lvl = '3']/competency/tID/text()"/> <!-- grab minor domain parent's tID -->
        <xsl:variable name="tIDsubD" select="ancestor::subgroup[@type='subD']/parentCompColl[@lvl='2']/competency/tID/text()"/> <!-- grab subdomain ancestor's tID -->
        <xsl:variable name="tIDdom" select="ancestor::group[@lvl='1']/parentCompColl[@lvl='1']/competency/tID/text()"/> <!-- grab top-level parent's tID -->
       
        <xsl:variable name="tIDiter" select="concat($tIDdom, '.', $tIDsubD, '.', $tIDparent, '-', $tIDcurrent)"/> <!-- put em' together -->
        <xsl:variable name="tIDiterParent" select="concat($tIDdom, '.', $tIDsubD, '.', $tIDparent)"/> <!-- create tID of parent from pieces -->
                        {
                        "Token": "<xsl:apply-templates select="Token"/>",
                        "tID": "<xsl:apply-templates select="$tIDiter"/>",
                        "tFrom": "<xsl:apply-templates select="$tIDiterParent"/>",
                        "Creator": "<xsl:apply-templates select="Creator"/>",
                        "Title": [{
                        "lang": "<xsl:apply-templates select="child::Title/lang"/>",
                        "text": "<xsl:apply-templates select="child::Title/text => normalize-space()"/>"
                        }],
                        "Definition": [{
                        "lang": "<xsl:apply-templates select="child::Definition/lang"/>",
                        "text": "<xsl:apply-templates select="child::Definition/text => normalize-space()"/>"
                        }],
                        "Notes": [{
                            "text": "<xsl:apply-templates select="child::Notes/text => normalize-space()"/>",
                            "UserID": "<xsl:apply-templates select="child::Notes/UserID"/>"
                        }]
                        },
    </xsl:template>
    
    
    
    
    <!-- LOWEST-LEVEL COMPS (with ssID) -->
    <xsl:template match="competency[child::ssID]" mode="compsSSID">
        <xsl:variable name="tIDcurrent" select="./tID/text()"/>
        <xsl:variable name="tIDparent" select="ancestor::subgroup[@type='minorD']/parentCompColl[@lvl = '3']/competency/tID/text()"/> <!-- grab minor domain parent's tID -->
        <xsl:variable name="tIDsubD" select="ancestor::subgroup[@type='subD']/parentCompColl[@lvl='2']/competency/tID/text()"/> <!-- grab subdomain ancestor's tID -->
        <xsl:variable name="tIDdom" select="ancestor::group[@lvl='1']/parentCompColl[@lvl='1']/competency/tID/text()"/> <!-- grab top-level parent's tID -->
        
        <xsl:variable name="tIDiter" select="concat($tIDdom, '.', $tIDsubD, '.', $tIDparent, '-', $tIDcurrent)"/> <!-- put em' together -->
        <xsl:variable name="tIDiterParent" select="concat($tIDdom, '.', $tIDsubD, '.', $tIDparent)"/> <!-- create tID of parent from pieces -->
        {
        "Token": "<xsl:apply-templates select="Token"/>",
        "ssID": "<xsl:apply-templates select="ssID"/>",
        "ssExtends": "<xsl:apply-templates select="ssExtends"/>",
        "tID": "<xsl:apply-templates select="$tIDiter"/>",
        "tFrom": "<xsl:apply-templates select="$tIDiterParent"/>",
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
        
    </xsl:template>
    
    
    
    
    
    <!-- LOWEST-LEVEL COMPS (no ssID nor Notes) -->
    <xsl:template match="competency[not(child::Notes) and not(child::ssID)]" mode="comps">
        <xsl:variable name="tIDcurrent" select="./tID/text()"/>
        <xsl:variable name="tIDparent" select="ancestor::subgroup[@type='minorD']/parentCompColl[@lvl = '3']/competency/tID/text()"/> <!-- grab minor domain parent's tID -->
        <xsl:variable name="tIDsubD" select="ancestor::subgroup[@type='subD']/parentCompColl[@lvl='2']/competency/tID/text()"/> <!-- grab subdomain ancestor's tID -->
        <xsl:variable name="tIDdom" select="ancestor::group[@lvl='1']/parentCompColl[@lvl='1']/competency/tID/text()"/> <!-- grab top-level parent's tID -->
        
        <xsl:variable name="tIDiter" select="concat($tIDdom, '.', $tIDsubD, '.', $tIDparent, '-', $tIDcurrent)"/> <!-- put em' together -->
        <xsl:variable name="tIDiterParent" select="concat($tIDdom, '.', $tIDsubD, '.', $tIDparent)"/> <!-- create tID of parent from pieces -->
        <xsl:choose>
            <xsl:when test="count(following-sibling::competency) > 0 or count(ancestor::subgroup[@type='minorD']/following-sibling::subgroup) > 0 or count(ancestor::subgroup[@type='subD']/following-sibling::subgroup) > 0 or count(ancestor::group/following-sibling::group) > 0">
                {
                "Token": "<xsl:apply-templates select="Token"/>",
                "tID": "<xsl:apply-templates select="$tIDiter"/>",
                "tFrom": "<xsl:apply-templates select="$tIDiterParent"/>",
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
                "tID": "<xsl:apply-templates select="$tIDiter"/>",
                "tFrom": "<xsl:apply-templates select="$tIDiterParent"/>",
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
        
        
        
    </xsl:template>
    
</xsl:stylesheet>