<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="3.0">

    <!-- 
        DEMO WHOLENUM INPUT FILE:
        DEMOwholenumsFormatted.xml
    -->
    <!-- 
        DEMO WHOLENUM OUTPUT FILE:
        DEMOwholenumsComps.json
       -->
    
    <!-- output method set to "text", but by adding .json file ext at end of file when setting the output,
            it automagically outputs as JSON-->
    <xsl:output method="text"/>
    
    
    <xsl:template match="/">
        [
        <xsl:apply-templates select="//group/parentCompColl/competency" mode="top"/><!-- TOP-LEVEL parent competencies -->
        <xsl:apply-templates select="//group/compColl/competency" mode="low1"/> <!-- 1st tier low-level competencies -->
        <xsl:apply-templates select="//group/subgroup[@type='no']/parentCompColl/competency" mode="NOmid"/><!-- NOsub MID-LEVEL parent competencies -->
        <xsl:apply-templates select="//group/subgroup[@type='sp']/parentCompColl/competency" mode="SPmid"/><!-- SPsub MID-LEVEL parent competencies -->
        <xsl:apply-templates select="//group/subgroup[@type='no']/compColl/competency" mode="NOlow2"/> <!-- NOsub 2nd tier lowest-level competencies -->
        <xsl:apply-templates select="//group/subgroup[@type='sp']/compColl/competency" mode="SPlow2"/> <!-- SPsub 2nd tier lowest-level competencies -->
        ]
    </xsl:template>
    
    
    <!-- TOP LEVEL PARENT COMPS -->
    <xsl:template match="competency" mode="top">
        <!-- no tID variable is necessary for top-level parent comps, because their tID was generated
        fully in the previous conversion stage.-->
        
       
        <!--<xsl:variable name="tIDtop" select="count(preceding::competency[parent::parentCompColl[@lvl = '1']])"/>-->
      
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
    
    
    
    <!-- LEVEL 2 COMPS - NOTATION OBJECT SUBGROUP PARENTS -->
    <xsl:template match="competency" mode="NOmid">
        <!-- set a variable for calculating each 2nd-lvl parent comp's tID by 
            finding its top-level parent comp, capturing its tID, and concatenating it onto 
            the current comp's tID that was processed in the previous stage of conversion.-->
        <xsl:variable name="tIDcurrent" select="./tID/text()"/>
        <xsl:variable name="tIDparent" select="ancestor::group/parentCompColl[@lvl = '1']/competency[Token/text() = current()/Token/text() ! substring-before(., '-in-')]/tID/text()"/>
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
    
    
    <!-- LEVEL 2 COMPS - KNOWLEDGE SUBPROCESS SUBGROUP PARENTS -->
    <xsl:template match="competency" mode="SPmid">
        <xsl:variable name="tIDcurrent" select="./tID/text()"/>
        <xsl:variable name="tIDparent" select="ancestor::group/parentCompColl[@lvl = '1']/competency[Token/text() = current()/Token/text() ! substring-before(., '-by-')]/tID/text()"/>
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
    
    
    
    <!-- 1st tier low-level specific comps (direct children of top-lvl parent comps) -->
    <xsl:template match="competency" mode="low1">
        <xsl:variable name="tIDcurrent" select="./tID/text()"/>
        <xsl:variable name="tIDparent" select="ancestor::group/parentCompColl[@lvl = '1']/competency[Token/text() = current()/Token/text() ! substring-before(., '-involving-')]/tID/text()"/>
       
        <xsl:variable name="tIDiter" select="concat($tIDparent, '-', $tIDcurrent)"/>
 
                        {
                        "Token": "<xsl:apply-templates select="Token"/>",
                        "ssID": "<xsl:apply-templates select="ssID"/>",
                        "ssExtends": "<xsl:apply-templates select="ssExtends"/>",
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
    
    
    
    
    
    <!-- 2nd tier LOWEST LEVEL COMPS - NOTATION OBJ -->
    <xsl:template match="competency" mode="NOlow2">
       <!-- lowest-level competencies (direct children of 2nd-level parent comps) need 3 variables to create the
       full tID: the current comp's tID, their direct parent's tID, and their top-level ancestor competency's tID.-->
        <xsl:variable name="tIDcurrent" select="./tID/text()"/>
        <xsl:variable name="tIDparent" select="ancestor::subgroup/parentCompColl[@lvl = '2']/competency[Token/text() = current()/Token/text() ! replace(., '(.+?)-involving.+', '$1')]/tID/text()"/>
        <xsl:variable name="tIDtop" select="ancestor::subgroup/parent::group/parentCompColl[@lvl = '1']/competency[Token/text() = current()/Token/text() ! substring-before(., '-in-')]/tID/text()"/>
    
        <!-- tID of the current lowest-level comp -->
        <xsl:variable name="tIDiter" select="concat($tIDtop, '.', $tIDparent, '-', $tIDcurrent)"/>
        <!-- tID of the subgroup parent comp -->
        <xsl:variable name="tIDiterMidParent" select="concat($tIDtop, '.', $tIDparent)"/> 
<!--        <xsl:variable name="tIDlevel" select="concat($tIDparent, '-', $tIDcurrent)"/> -->
        
                        {
                        "Token": "<xsl:apply-templates select="Token"/>",
                        "ssID": "<xsl:apply-templates select="ssID"/>",
                        "ssExtends": "<xsl:apply-templates select="ssExtends"/>",
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
                  
    </xsl:template>
    
    
    
    <!-- 2nd tier LOWEST LEVEL COMPS - KNOWLEDGE SUBPROCESS OBJ -->
    <xsl:template match="competency" mode="SPlow2">
        <xsl:variable name="tIDcurrent" select="./tID/text()"/>
        <xsl:variable name="tIDparent" select="ancestor::subgroup/parentCompColl[@lvl = '2']/competency[Token/text() = current()/Token/text() ! replace(., '(.+?)-involving.+?(-by-.+?)', '$1$2')]/tID/text()"/>
        <xsl:variable name="tIDtop" select="ancestor::subgroup/parent::group/parentCompColl[@lvl = '1']/competency[Token/text() = current()/Token/text() ! substring-before(., '-involving-')]/tID/text()"/>
      
        <!-- tID of the current low-lvl comp -->
        <xsl:variable name="tIDiter" select="concat($tIDtop, '.', $tIDparent, '-', $tIDcurrent)"/>
        <!-- tID of the subgroup parent comp -->
        <xsl:variable name="tIDiterMidParent" select="concat($tIDtop, '.', $tIDparent)"/> 
        <!--<xsl:variable name="tIDlevel" select="concat($tIDparent, '-', $tIDcurrent)"/> -->

<!-- since this is the last set of competencies to be generated in the file, we need an xsl:choose
        to tell the XSLT not to place a comma at the end of the JSON competency object when it encounters
        the very last competency.-->
        <xsl:choose>
            <xsl:when test="count(following-sibling::competency) > 0 or count(parent::*/following-sibling::*) > 0 or count(ancestor::group/following-sibling::group) > 0">
                {
                "Token": "<xsl:apply-templates select="Token"/>",
                "ssID": "<xsl:apply-templates select="ssID"/>",
                "ssExtends": "<xsl:apply-templates select="ssExtends"/>",
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
                "ssID": "<xsl:apply-templates select="ssID"/>",
                "ssExtends": "<xsl:apply-templates select="ssExtends"/>",
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
        
    </xsl:template>
    
</xsl:stylesheet>