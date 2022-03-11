<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="3.0">
    
    <!-- demo wholenums input: DEMOwholenumsNestedParentOutput.xml -->
    <!-- demo wholenums output: DEMOwholenumsFormatted.xml -->
    
    <!-- USE THIS XSLT TO CONVERT WHOLENUMS COMPS ONLY -->
    
    <xsl:output method="xml" indent="yes"/>
    
    <!-- This converter is also the first step in creating transitive relationship IDs, to be used in creating
                    edge nodes that connect a competency to its parent(s) or child(ren) in the final graph implementation. -->
    
    <xsl:template match="/">
 <scope>
     <group type="fp-pp"> <!-- the apply-templates MODE tells the XSLT which type of processing template to send each group to. -->
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
    
    
    <!-- group-processor for groups with a NOTATION object sub-group -->
<xsl:template match="parent[child::notationParent]" mode="notationSub">
    <parentCompColl lvl="1">
        <xsl:apply-templates select="parentGroup/componentSentence" mode="top"/> <!-- top-level parent comps -->
    </parentCompColl>
    <compColl>
        
        <xsl:apply-templates select="compGroup/componentSentence" mode="low"/> <!-- direct children of top-level parent comps -->
        
    </compColl>
            <subgroup type="no">
                <parentCompColl lvl="2">
                    <xsl:apply-templates select="notationParent/parentGroup/componentSentence" mode="mid"/> <!-- 2nd-level Parent comps -->
                </parentCompColl>
                <compColl>
                    <xsl:apply-templates select="notationParent/compGroup/componentSentence" mode="low"/> <!-- direct children of 2nd-level parent comps -->
                </compColl>
            </subgroup>
</xsl:template>
    
    <!-- group-processor for groups with a KNOWLEDGE SUBPROCESS object sub-group -->
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
    
    
    <!-- GRANULAR COMPETENCY ELEMENT TEMPLATES: the below templates take each componentSentence input and
            reformat them into a structure that reflects the competency graph model's proper JSON properties.-->
    
    <!-- TOP-LEVEL Parent Competency template -->
    <xsl:template match="componentSentence" mode="top">
       
            <competency>
                <Token>
                    <!-- this xsl:choose tells the XSLT to process competency text differently
                            when a componentSentence element's text contains a comma. -->
                    <xsl:choose> 
                        <xsl:when test="descendant::*/text()[contains(., ',')]">
                            <xsl:apply-templates
                                select="string-join(descendant::*/tokenize(translate(lower-case(text()), '[a-z0-9_]+?,', '[a-z0-9_]'), '\s+'), '-')"
                            />
                        </xsl:when>
                        <xsl:otherwise>
            <!-- lower-case the text, tokenize it on whitespaces, then join the strings together with "-" -->
                            <xsl:apply-templates
                                select="string-join(descendant::*/tokenize(lower-case(text()), '\s+'), '-')"
                            />
                        </xsl:otherwise>
                    </xsl:choose>
                    
                </Token>
        <!-- This is the first step in processing a competencies transitive ID, creating the first portion of
        the current node's transitive ID by counting all of the preceding competecies from the same tree-level: -->
                <tID>
                    <xsl:apply-templates select="count(preceding::componentSentence[parent::parentGroup[@lvl = 1]])"/>
                </tID>
   <!-- The `tID` numbers generated in this structure converter will be used in the next stage of processing to create 
          the complete `tID`s of 2nd, 3rd, and 4th-level competencies by concatenating the `tID`s of the
                 current comp's parents onto the beginning of the existing `tID`.  -->
         <!-- the `tFrom` generators, matching a comeptency's parent `tID`, will also be generated in the next stage. -->
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
    
    
    <!-- 2nd-LEVEL sub-Parent Competecies -->
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
    
    
    <!-- LOW-LEVEL specific comeptency template -->
    <xsl:template match="componentSentence" mode="low">
        
        <!-- Only the low-level competencies who have progressive relationships to each other will have ssIDs generated
            using the following variables.-->
        <xsl:variable name="ssid" select="@id"/> 
        <xsl:variable name="pos">
            <!-- find the positiion of current comp by counting preceding comps whose @ids are the same (same sub-scope) -->
            <xsl:value-of select="count(preceding::componentSentence[@id = current()/@id])"/> 
            
        </xsl:variable>
        <!-- put together the sub-scope ID and the position variable to create the complete unique progressive ID. -->
        <xsl:variable name="ssIDiter" select="concat($ssid, '-', $pos)"/> 
        
        <!-- progressive parent ID constructor -->
        <xsl:variable name="extID" select="@extends"/>
        <xsl:variable name="extIDiter" select="concat($extID, '-', $pos)"/>
        <competency>
               <ssID>
                <xsl:apply-templates select="$ssIDiter"/>
            </ssID>
            <ssExtends>
                <!-- this xsl:choose tells the XSLT to output only the value of the @extends ID when it is null.
                        There is no need to add a unique position identifier when a competency does not have any
                            preceding competency relationships. (for sub-scopes 0 and 1)-->
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