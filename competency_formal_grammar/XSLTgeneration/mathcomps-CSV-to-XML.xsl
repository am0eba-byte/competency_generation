<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    
    <xsl:template match="/">
        <xml>
        <xsl:apply-templates select="/head"/>
        <!-- for-each <line> with matching <domain> text -->
        <xsl:for-each select="line[Domain/text() = current()/Domain/text()]">
            <group lvl="1" type="domain" cc="{}">
                <xsl:apply-templates select="Domain"/>
                
                <!-- for each <line> with matching <domain> AND <subDomain> -->
                <group lvl="2" type="subdomain">
                    <subDomain><!-- insert subdomain --></subDomain>
                    
                    <!-- for each <line> with matching <domain>, <subDomain>, and <minorDomain> -->
                    <group lvl="3" type="minor">
                        <minorDomain><!-- insert minorDomain --></minorDomain>
                        
                        <group lvl="4" type="competency">
                            <!-- here, begin spitting out for-each on competencies (and note?) for each line  -->
                            <competency><!--xsl:apply-templates --></competency>
                        </group>
                    </group>
                </group>
            </group>
        </xsl:for-each> 
        </xml>
    </xsl:template>
    
    
</xsl:stylesheet>