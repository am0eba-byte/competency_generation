<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="3.0">

    <!-- TEST INPUT FILE: integersNestedParentOutput.xml -->
    <!-- TEST OUTPUT FILE: transIDFormatted.xml -->
    
    
    <!-- ************* DO NOT USE THIS XSLT TO CONVERT WHOLENUMS COMPS ****************** -->

    <xsl:output method="xml" indent="yes"/>

<xsl:template match="/">
    <scope>
        <group type="fp-pp">
            <xsl:choose>
                <xsl:when test="//parent[@group='fp-pp']/notationParent">
                    <xsl:apply-templates select="//parent[@group='fp-pp']" mode="subgroup"/> <!-- Notation Object -->
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="//parent[@group='fp-pp']" mode="nosub"/> <!-- No Notation Object -->
                </xsl:otherwise>
            </xsl:choose>
            
        </group>
        <group type="fp-mathop"> 
            <xsl:choose>
                <xsl:when test="//parent[@group='fp-mathop']/notationParent">
                    <xsl:apply-templates select="//parent[@group='fp-mathop']" mode="subgroup"/> <!-- Notation Object -->
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="//parent[@group='fp-mathop']" mode="nosub"/> <!-- No Notation Object -->
                </xsl:otherwise>
            </xsl:choose>
          
        </group>
        <group type="kp-pp">
            <xsl:apply-templates select="//parent[@group='kp-pp']" mode="nosub"/> <!-- Knowledge Process comps with No Subprocess -->
        </group>
        <group type="kp-mathop">
            <xsl:apply-templates select="//parent[@group='kp-mathop']" mode="nosub"/> <!-- Knowledge Process comps with Subprocess -->
        </group>

    </scope>
</xsl:template>

    <xsl:template match="parent[child::notationParent]" mode="subgroup">
      
        <parentCompColl lvl="1">
            <xsl:apply-templates select="parentGroup/componentSentence" mode="top"/> <!-- top-level parent comps -->
        </parentCompColl>
        <compColl>

            <xsl:apply-templates select="compGroup/componentSentence" mode="low"/> <!-- lower-level comps -->

        </compColl>
<xsl:choose>        
        <xsl:when test="child::notationParent">
         <subgroup type="no">
        <parentCompColl lvl="2">
            <xsl:apply-templates select="notationParent/parentGroup/componentSentence" mode="mid"/> <!-- 2nd level parent comps (parents with notation objects) -->
            </parentCompColl>
            <compColl>
                <xsl:apply-templates select="notationParent/compGroup/componentSentence" mode="low"/> <!-- lowest-level comps -->
            </compColl>
       </subgroup>
        </xsl:when>
    <xsl:otherwise>
        
    </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    
    
    <xsl:template match="parent[not(child::notationParent)]" mode="nosub"> <!-- -->
        <parentCompColl lvl="1">
            <xsl:apply-templates select="parentGroup/componentSentence" mode="top"/> <!-- top-level parent comps -->
        </parentCompColl>
        <compColl>
            
            <xsl:apply-templates select="compGroup/componentSentence" mode="low"/> <!-- lower-level comps without notation objects -->
            
        </compColl>
        
        
    </xsl:template>
    
    
    <xsl:template match="componentSentence" mode="top">
        
        <competency>
            <Token>
                <xsl:choose>
                    <xsl:when test="descendant::*/text()[contains(., ',')]">    <!-- transform the text into a token -->
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
            <tID>                                                        <!-- create the individual TID by counting from all preceding same-level comps -->
                <xsl:apply-templates select="count(preceding::componentSentence[parent::parentGroup[@lvl = 1]])"/>  
            </tID>                      <!-- the next XSLT script, the JSON converter, will string together values from matching parents to complete lower-level comp TIDs -->
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
        
        <competency>
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
        <competency>
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
