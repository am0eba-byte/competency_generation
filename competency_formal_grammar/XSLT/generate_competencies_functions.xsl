<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="3.0">
 <!--2021-12-04 ebb: Refactoring this stylesheet to work with functions to generate "sentences". 
 GOAL: a human-readable and easily edited stylesheet. This reads an XML document that expresses competency relationships 
 in a simple tree structure.
 -->
    
    <xsl:output method="xml" indent="yes"/>
      
    <!-- modified_competency = 
        ( ([ formal_process ] | [ knowledge_process, [ “by” knowledge_subprocess ] ]), ((math_operation,  object) | specific_object ), [ notation_object ] ) | math_practice_competency ;
 -->
     
    
   
    
    
    
    <!-- THIS IS THE SENTENCE OUTPUT -->
    
    <!-- mode="mathopmode" -->
    <xsl:template match="object/string" >
        <xsl:param name="mathOP"/>
        <xsl:param name="objectString"/>
        <componentSentence>
        
            <mathOP_object>
                <mathopString>
              <xsl:value-of select="$objectString"/>
                </mathopString>
               
              <object> <xsl:apply-templates/> </object>              
           </mathOP_object>
            
        </componentSentence>
  
    </xsl:template>
    
    
    
    <!-- END!! MATHOPS WITHOUT SPECIAL NOTATION -->
    
    
    
    
    <!-- START!! POSSIBILITIES WITH NOTATIONS BELOW -->
    
  
    
    <!--ebb: THREE FORKS: 
    mathOP_object with no notation
    mathOP object with notation
    specific object
    -->
    <xsl:template match="object_choice"  mode="mathOPnotation">
        <xsl:param name="mathOP" select="./mathOP_object ! name()" tunnel="yes"/>
        <xsl:param name="specOP" select="./specific_object ! name()" tunnel="yes"/>
        

        <!--
       <MATHOP> -->
        
        <xsl:apply-templates select="mathOP_object">
            <xsl:with-param name="mathOP" select="$mathOP" as="xs:string"></xsl:with-param>
        </xsl:apply-templates>
        
        <xsl:apply-templates select="mathOP_object" mode="mathOPnotation">
            <xsl:with-param name="mathOP" select="$mathOP" as="xs:string"></xsl:with-param>
        </xsl:apply-templates>
        
        <!--</MATHOP>-->
        
        <!-- <SPECIFIC>-->
        <xsl:apply-templates select="specific_object">
            <xsl:with-param name="specOP" select="$specOP" as="xs:string"></xsl:with-param>
        </xsl:apply-templates>
        <!--</SPECIFIC>-->
    </xsl:template>
    
    
    
   
    
    <!-- NOTATION OBJECT SENTENCE -->
    <xsl:template match="notation_object/string" mode="mathOPnotation">
        <xsl:param name="mathOP"/>
        <xsl:param name="objectString"/>
        <xsl:param name="objString"/>
        <componentSentence>
            <mathOP_object>
                <mathopString>
                    <xsl:value-of select="$objectString"/>
                </mathopString>
                <object>
                    <xsl:value-of select="$objString"/>
                </object>
            </mathOP_object>
            <notation>
                <xsl:apply-templates/>
            </notation>
        </componentSentence>
    </xsl:template>
    
    
    
</xsl:stylesheet>