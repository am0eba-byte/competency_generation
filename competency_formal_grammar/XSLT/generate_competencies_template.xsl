<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="3.0">
    
    
    <xsl:output method="xml" indent="yes"/>
    
    
    <!-- modified_competency = 
        ( ([ formal_process ] | [ knowledge_process, [ “by” knowledge_subprocess ] ]), ((math_operation,  object) | specific_object ), [ notation_object ] ) | math_practice_competency ;
 -->
    
    
    
    
    <xsl:template match="//compParts">
        <xml>
            <!--<process></process>
           <object_choice>-->
               <xsl:apply-templates select="child::object_choice"/>
           <!--</object_choice>
            <notation_object></notation_object>-->
        </xml>
    </xsl:template>
 

    <xsl:template match="object_choice">
        <xsl:param name="mathOP" select="./mathOP_object ! name()" tunnel="yes"/>
        <xsl:param name="specOP" select="./specific_object ! name()" tunnel="yes"/>
        <!--
       <MATHOP> -->
           <xsl:apply-templates select="mathOP_object">
               <xsl:with-param name="mathOP" select="$mathOP" as="xs:string"></xsl:with-param>
           </xsl:apply-templates>
       <!--</MATHOP>-->
        
       
       <!-- <SPECIFIC>-->
            <xsl:apply-templates select="specific_object">
                <xsl:with-param name="specOP" select="$specOP" as="xs:string"></xsl:with-param>
            </xsl:apply-templates>
        <!--</SPECIFIC>-->
    </xsl:template>
    
    
    
    <xsl:template match="mathOP_object">
        <xsl:param name="mathOP"/>
        <math_operation>
            <xsl:apply-templates select="descendant::math_operation/string">
               
                <xsl:with-param name="mathOP" select="$mathOP" as="xs:string"/>
            </xsl:apply-templates>
        </math_operation>
        <!--<object>
            <xsl:apply-templates select="descendant::object/string">
                <xsl:with-param name="mathOP" select="$mathOP" as="xs:string"/>
            </xsl:apply-templates>
        </object>-->
    </xsl:template>
    
    
    
    
    
    <!-- SPECIAL OBJECT HANDLING -->
    
    <xsl:template match="specific_object">
        <xsl:param name="specOP"></xsl:param>
        <specific_object>
            <xsl:apply-templates select="string">
                <xsl:with-param name="specOP" select="$specOP" as="xs:string"/>
            </xsl:apply-templates>
        </specific_object>
    </xsl:template>
    
    
    <xsl:template match="special_object/string">
        <xsl:param name="specOP"/>
        
       
            <xsl:element name="{$specOP}">
                <xsl:apply-templates/>
            </xsl:element>
        
        
    </xsl:template>
    
    
    
    <!-- MATHOP OBJECT SEQUENCE HANDLING -->
    
    <xsl:template match="math_operation/string">
      <xsl:param name="mathOP"/>
        <xsl:param name="objectString" as="xs:string" select="current() ! normalize-space()" tunnel="yes"/>
        
              <!-- specOP is not being delivered here. we need special handling for this -->
        
                
               <xsl:comment>
                   This is the <xsl:value-of select="$objectString"/>
               </xsl:comment>
                    
                        
                        <xsl:apply-templates select="following-sibling::object/string" mode="mathopmode">
                            <xsl:with-param name="objectString" select="$objectString" as="xs:string"/>
                            <xsl:with-param name="mathOP" select="$mathOP" as="xs:string"/>
                        </xsl:apply-templates>
        
                    
                
                
          
            
        
    </xsl:template>
    
    
    
    
    <xsl:template match="object/string" mode="mathopmode">
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
    
    
    
</xsl:stylesheet>