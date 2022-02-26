<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="3.0">
    
    <!-- wholenums input: wholenumsSSIDNestedComps-delSG.xml -->
    <!-- wholenums output: wholenumsSSIDFormatted.xml -->
    
    <!-- USE THIS XSLT TO CONVERT WHOLENUMS COMPS ONLY -->
    
    <xsl:output method="xml" indent="yes"/>
    
    
    <xsl:template match="/">
 <scope>
     <group type="fp-pp">
                 <xsl:apply-templates select="//parent[@group='fp-pp']" mode="notationSub"/>
     </group>
     <group type="fp-mathop"> 
                 <xsl:apply-templates select="//parent[@group='fp-mathop']" mode="notationSub"/>
     </group>
     <group type="kp-pp">
           <xsl:apply-templates select="//parent[@group='kp-pp']" mode="KPsub"/>
     </group>
     <group type="kp-mathop">
         <xsl:apply-templates select="//parent[@group='kp-mathop']" mode="KPsub"/>
     </group>
        </scope>
    </xsl:template>
    
<xsl:template match="parent[child::notationParent]" mode="notationSub">
    <parentCompColl lvl="1">
        <xsl:apply-templates select="parentGroup/componentSentence" mode="top"/>
    </parentCompColl>
    <compColl>
        
        <xsl:apply-templates select="compGroup/componentSentence" mode="low"/>
        
    </compColl>
            <subgroup type="no">
                <parentCompColl lvl="2">
                    <xsl:apply-templates select="notationParent/parentGroup/componentSentence" mode="mid"/>
                </parentCompColl>
                <compColl>
                    <xsl:apply-templates select="notationParent/compGroup/componentSentence" mode="low"/>
                </compColl>
            </subgroup>
</xsl:template>
    
    <xsl:template match="parent[child::subParent]" mode="KPsub">
        <parentCompColl lvl="1">
            <xsl:apply-templates select="parentGroup/componentSentence" mode="top"/>
        </parentCompColl>
        <compColl>
            
            <xsl:apply-templates select="compGroup/componentSentence" mode="low"/>
            
        </compColl>
        <subgroup type="sp">
            <parentCompColl lvl="2">
                <xsl:apply-templates select="subParent/parentGroup/componentSentence" mode="mid"/>
            </parentCompColl>
            <compColl>
                <xsl:apply-templates select="subParent/compGroup/componentSentence" mode="low"/>
            </compColl>
        </subgroup>
    </xsl:template>
    
    
    
    
    <xsl:template match="componentSentence" mode="top">
       
            <xsl:variable name="ssid" select="@id"/>
            <xsl:variable name="pos">
                   
              <xsl:value-of select="count(preceding::componentSentence[@id = current()/@id])"/>
  
            </xsl:variable>
            <xsl:variable name="ssIDiter" select="concat($ssid, '-', $pos)"/>
            
            <xsl:variable name="extID" select="@extends"/>
            <xsl:variable name="extIDiter" select="concat($extID, '-', $pos)"/>
            <competency>
              <!--  <ssID>
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
                </ssExtends>-->
                
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
                <tID>
                    <xsl:apply-templates select="count(preceding::componentSentence[parent::parentGroup[@lvl = 1]])"/>
                </tID>
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
    
    
    
    <xsl:template match="componentSentence" mode="mid">
        
        <xsl:variable name="ssid" select="@id"/>
        <xsl:variable name="pos">
            
            <xsl:value-of select="count(preceding::componentSentence[@id = current()/@id])"/>
            
        </xsl:variable>
        <xsl:variable name="ssIDiter" select="concat($ssid, '-', $pos)"/>
        
        <xsl:variable name="extID" select="@extends"/>
        <xsl:variable name="extIDiter" select="concat($extID, '-', $pos)"/>
        <competency>
         <!--   <ssID>
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
            -->
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
            <tID>
                <xsl:apply-templates select="count(preceding::componentSentence[parent::parentGroup[@lvl = 2]])"/>
            </tID>
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
    
    
    
    <xsl:template match="componentSentence" mode="low">
        
        <xsl:variable name="ssid" select="@id"/>
        <xsl:variable name="pos">
            
            <xsl:value-of select="count(preceding::componentSentence[@id = current()/@id])"/>
            
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
            <tID>
                <xsl:apply-templates select="count(preceding::componentSentence[parent::compGroup])"/>
            </tID>
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