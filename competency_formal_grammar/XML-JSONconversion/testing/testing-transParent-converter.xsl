<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="3.0">
    
    
    
    
    <!-- TEST INPUT FILE:  
        transitiveIDFormatted.xml
    -->
    <!-- TEST OUTPUT FILE: 
        testTransID.json
       -->
  
    
    <xsl:output method="text"/>
    
    
    <xsl:template match="/">
        [
        <xsl:apply-templates select="//group/parentCompColl/competency" mode="top"/><!-- TOP-LEVEL parent competencies -->
        <xsl:apply-templates select="//group/compColl/competency" mode="low1"/> <!-- 1st tier low-level competencies -->
        <xsl:apply-templates select="//group/subgroup/parentCompColl/competency" mode="mid"/><!-- MID-LEVEL parent competencies -->
        <xsl:apply-templates select="//group/subgroup/compColl/competency" mode="low2"/> <!-- 2nd tier lowest-level competencies -->
        ]
    </xsl:template>
    
    
    <!-- TOP LEVEL COMPS -->
    <xsl:template match="competency" mode="top">
        <xsl:variable name="tIDtop" select="count(preceding::competency[parent::parentCompColl[@lvl = '1']])"/>
       <!-- <xsl:variable name="tIDparent">
            
            <xsl:value-of select="parent::parentCompColl/competency[./tID/text() = current()/tID/text()]"/>
            
        </xsl:variable>
        <xsl:variable name="tIDiter" select="concat($tIDparent, '.', $tIDcurrent)"/>-->
        <xsl:choose>
            
            <xsl:when test="child::ssID">
                <xsl:choose>
                    <xsl:when test="count(following-sibling::competency) > 0 or count(parent::*/following-sibling::*) > 0 or count(ancestor::group/following-sibling::group) > 0">
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
                <!--<xsl:choose>
                    <xsl:when test="count(following-sibling::competency) > 0 or count(parent::*/following-sibling::*) > 0 or count(ancestor::group/following-sibling::group) > 0">-->
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
                   <!-- </xsl:when>
                    <xsl:otherwise>
                        {
                        "Token": "<xsl:apply-templates select="Token"/>",
                        "tID": "<xsl:apply-templates select="$tIDtop"/>",
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
                </xsl:choose>-->
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    
    <!-- LEVEL 2 COMPS -->
    <xsl:template match="competency" mode="mid">
        <xsl:variable name="tIDcurrent" select="./tID/text()"/>
        <xsl:variable name="tIDparent" select="ancestor::group/parentCompColl[@lvl = '1']/competency[Token/text() = current()/Token/text() ! substring-before(., '-in-')]/tID/text()"/>
            
         <!--   <xsl:value-of select="ancestor::group/parentCompColl[@lvl = '1']/competency[count(preceding-sibling::competency) = count(current()/preceding-sibling::competency)]/tID/text()"/>-->

        <xsl:variable name="tIDiter" select="concat($tIDparent, '.', $tIDcurrent)"/>
        <xsl:choose>
            
            <xsl:when test="child::ssID">
                <xsl:choose>
                    <xsl:when test="count(following-sibling::competency) > 0 or count(parent::*/following-sibling::*) > 0 or count(ancestor::group/following-sibling::group) > 0">
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
               <!-- <xsl:choose>
                    <xsl:when test="count(following-sibling::competency) > 0 or count(parent::*/following-sibling::*) > 0 or count(ancestor::group/following-sibling::group) > 0">
     -->                   {
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
                  <!--  </xsl:when>
                    <xsl:otherwise>
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
                        }
                    </xsl:otherwise>
                </xsl:choose>-->
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- 1st tier LOWEST LEVEL COMPS -->
    <xsl:template match="competency" mode="low1">
        <xsl:variable name="tIDcurrent" select="./tID/text()"/>
        <xsl:variable name="tIDparent" select="ancestor::group/parentCompColl[@lvl = '1']/competency[count(preceding-sibling::competency) = count(current()/preceding-sibling::competency)]/tID/text()"/>
        
       <!-- <xsl:variable name="tIDparent">
            
            <xsl:value-of select="ancestor::group/parentCompColl[@lvl = 1]/competency[count(preceding-sibling::competency) = count(current()/preceding-sibling::competency)]/tID/text()"/>
            
        </xsl:variable>-->
        <xsl:variable name="tIDiter" select="concat($tIDparent, '-', $tIDcurrent)"/>
        
    <!--    <xsl:variable name="extID" select="@extends"/>
        <xsl:variable name="extIDiter" select="concat($extID, '-', $pos)"/>-->
        
        <xsl:choose>
          
            <xsl:when test="child::ssID">
                <xsl:choose>
                    <xsl:when test="count(following-sibling::competency) > 0 or count(parent::*/following-sibling::*) > 0 or count(ancestor::group/following-sibling::group) > 0">
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
               <!-- <xsl:choose><!-\-  or count(parent::*/following-sibling::*) > 0 or count(ancestor::group/following-sibling::group) > 0 -\->
                    <xsl:when test="count(following-sibling::competency) > 0">-->
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
            <!--</xsl:when>
            <xsl:otherwise>
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
                }
            </xsl:otherwise>
        </xsl:choose>-->
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    
    
    
    <!-- 2nd tier LOWEST LEVEL COMPS -->
    <xsl:template match="competency" mode="low2">
        <xsl:variable name="tIDcurrent" select="./tID/text()"/>
        <xsl:variable name="tIDparent" select="ancestor::subgroup/parentCompColl[@lvl = '2']/competency[Token/text() = current()/Token/text() ! replace(., '-involving-integers', '')]/tID/text()"/>
        <!--  [count(preceding-sibling::competency) = count(current()/preceding-sibling::competency)]   -->
       <!-- <xsl:variable name="tIDparent">
            
            <xsl:value-of select="ancestor::subgroup/parentCompColl[@lvl = 2]/competency[count(preceding-sibling::competency) = count(current()/preceding-sibling::competency)]/tID/text()"/>
            
        </xsl:variable>-->
        <xsl:variable name="tIDtop" select="ancestor::subgroup/parent::group/parentCompColl[@lvl = '1']/competency[Token/text() = current()/Token/text() ! substring-before(., '-involving-')]/tID/text()"/>
           <!-- <xsl:value-of select="ancestor::subgroup/parent::group/parentCompColl[@lvl = 1]/competency[count(preceding-sibling::competency) = count(current()/preceding-sibling::competency)]/tID/text()"/>
        </xsl:variable>-->
        <xsl:variable name="tIDiter" select="concat($tIDtop, '.', $tIDparent, '-', $tIDcurrent)"/>
        <xsl:variable name="tIDiterMidParent" select="concat($tIDtop, '.', $tIDparent)"/> <!-- tID of the parent's parent comp -->
        <xsl:variable name="tIDlevel" select="concat($tIDparent, '-', $tIDcurrent)"/> <!-- tID of the current low-lvl comp -->
        
        <!--    <xsl:variable name="extID" select="@extends"/>
        <xsl:variable name="extIDiter" select="concat($extID, '-', $pos)"/>-->
        
        <xsl:choose>
            
            <xsl:when test="child::ssID">
                <xsl:choose>
                    <xsl:when test="count(following-sibling::competency) > 0 or count(parent::*/following-sibling::*) > 0 or count(ancestor::group/following-sibling::group) > 0">
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
                <xsl:choose> <!--  or count(parent::*/following-sibling::*) > 0 or count(ancestor::group/following-sibling::group) > 0 -->
                    <xsl:when test="count(following-sibling::competency) > 0 or ancestor::group/following-sibling::group[@type='fp-mathop']">
                        {
                        "Token": "<xsl:apply-templates select="Token"/>",
                        "tID": "<xsl:apply-templates select="$tIDiter"/>",
                        "tFrom": "<xsl:apply-templates select="$tIDiterMidParent"/>",
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
                        "tFrom": "<xsl:apply-templates select="$tIDiterMidParent"/>",
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