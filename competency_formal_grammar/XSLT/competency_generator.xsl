<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="3.0">

    <xsl:output method="html" encoding="utf-8" doctype-system="about:legacy-compat"
        omit-xml-declaration="yes"/>


    <!-- modified_competency = 
        ( ([ formal_process ] | [ knowledge_process, [ “by” knowledge_subprocess ] ]), ((math_operation,  object) | specific_object ), [ notation_object ] ) | math_practice_competency ;
 -->


<!--                TEMPLATE                           -->
    <xsl:template match="/">
        <html>
            <head>
                <title>Competency Data</title>
            </head>
            <body>
                <xsl:for-each select="descendant::scopes/string">
                    <div>
                        <h2><xsl:apply-templates select="./text()"/> Competency Dataset:</h2>
                        <xsl:apply-templates select="ancestor::xml/compParts"/>
                    </div>
                </xsl:for-each>
            </body>
        </html>
    </xsl:template>
    
    
    <xsl:template match="compParts">
        <xsl:for-each select="./*">
            <p>
            <xsl:apply-templates select="./node()[1]"/>
                <xsl:apply-templates select="./node()[2]"/>
                <xsl:apply-templates select="./node()[3]"/>
            </p>
           
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="process">
        <xsl:for-each select="child::process"><p>
            <xsl:apply-templates select="*/name()"/>
        </p></xsl:for-each>
    </xsl:template>
    
    <xsl:template match="object_choice">
        <xsl:for-each select="child::object_choice">
            <p>
            <xsl:apply-templates select="*/name()"/>
        </p>
        </xsl:for-each>
    </xsl:template>

    <!-- <xsl:template match="object">
         <xsl:for-each select="./string">
             <li> 
                 <xsl:apply-templates select="./text()"/>
             </li>
         </xsl:for-each>-->
      
   <!--</xsl:template>-->

</xsl:stylesheet>
