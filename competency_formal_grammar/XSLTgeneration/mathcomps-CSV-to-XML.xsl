<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    
    <xsl:template match="/">
        <xml>
      
        <!-- for-each <line> with matching <domain> text -->
        <xsl:for-each select="//line[not(./Domain/text() = preceding::line/Domain/text())]">
            <group lvl="1" type="domain">
                <xsl:apply-templates select="./Domain"/>
                
                
            </group>
        </xsl:for-each> 
        </xml>
    </xsl:template>

    <xsl:template match="Domain">
        <Domain><xsl:apply-templates select="./text()"/></Domain>
        <!-- for each <line> with matching <domain> AND <subDomain> -->
        <xsl:for-each select="//line[not(./subDomain/text() = preceding::line/subDomain/text()) and ./Domain/text() = current()/text()]">
                <group lvl="2" type="subdomain">
                   <xsl:apply-templates select="./subDomain"/>
                </group>
         </xsl:for-each>
    </xsl:template>

    <xsl:template match="subDomain" mode="#default">
         <subDomain><xsl:apply-templates select="./text()"/></subDomain>
                    
                    <!-- for each <line> with matching <domain>, <subDomain>, and <minorDomain> -->
                    <xsl:for-each select="//line[not(./minorDomain/text() = preceding::line/minorDomain/text()) and ./subDomain/text() = current()/text()]">
                    <group lvl="3" type="minor">
                        <xsl:apply-templates select="./minorDomain"/>
                    </group>
                    </xsl:for-each>
    </xsl:template>

    <xsl:template match="minorDomain" mode="#default">
        <minorDomain><xsl:apply-templates select="./text()"/></minorDomain>
         <group lvl="4" type="comps">
    <!-- here, begin spitting out for-each on competencies (and note?) for each line matching the current minor domain  -->
                 <xsl:for-each select="//line[./minorDomain/text() = current()/text()]">
                           
                           <xsl:apply-templates select="./competency"/>      
            
                </xsl:for-each>
        </group>
    </xsl:template>


    <xsl:template match="competency" mode="#default">
        <competency><xsl:apply-templates select="./text()"/>
        <xsl:if test="following-sibling::note">
             <notes><xsl:apply-templates select="following-sibling::note/text()"/></notes>
        </xsl:if>
       
        </competency>
    </xsl:template>
    
    
</xsl:stylesheet>