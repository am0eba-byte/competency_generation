<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="3.0">
    
    <!-- wholenums input: wholenumsSSIDNestedComps-delSG.xml -->
    <!-- wholenums output: wholenumsSSIDFormatted.xml -->
    
    <xsl:output method="xml" indent="yes"/>
    
    
    <xsl:template match="/">
 
        <compColl>
             <xsl:apply-templates select="//componentSentence"/>  
        </compColl>
    </xsl:template>
    

    
    
    <xsl:template match="//componentSentence">
       
            <xsl:variable name="ssid" select="@id"/>
            <xsl:variable name="pos">
                   
              <xsl:value-of select="count(preceding-sibling::componentSentence[@id = current()/@id])"/>
  
            </xsl:variable>
            <xsl:variable name="ssIDiter" select="concat($ssid, '-', $pos)"/>
            
            <xsl:variable name="extID" select="@extends"/>
            <xsl:variable name="extIDiter" select="concat($extID, '-', $pos)"/>
            <competency>
                <ssID>
                    <xsl:apply-templates select="$ssIDiter"/>
                </ssID>
                <ssExtends>
                   <xsl:choose> 
                       <xsl:when test="@extends = 'null'">
                           <xsl:apply-templates select="$extID"/>
                       </xsl:when>
                      <xsl:otherwise> 
                          <xsl:apply-templates select="$extIDiter"/>
                      </xsl:otherwise>
                   </xsl:choose>
                </ssExtends>
                
                <Token>
                    
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
                    
                </Title>
                <Definition>
                    <lang>en-us</lang>
                    <text>
                        <xsl:apply-templates select="string-join(descendant::*/text(), ' ')"
                        />
                    </text>
                    
                </Definition>
            </competency>
      
    </xsl:template>
    
    
    
</xsl:stylesheet>