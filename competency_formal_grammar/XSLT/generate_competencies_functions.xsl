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
        
        
        
        <xsl:comment>
                This is the notation object output for mathoperation-objects!
            </xsl:comment>
        
        
        
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
    
    
    
    
    
    <!-- MATHOPS WITHOUT SPECIAL NOTATION -->
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
    
    
    <xsl:template match="specific_object/string">
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
                    
        <!-- mode="mathopmode" -->
                        <xsl:apply-templates select="following-sibling::object/string" >
                            <xsl:with-param name="objectString" select="$objectString" as="xs:string"/>
                            <xsl:with-param name="mathOP" select="$mathOP" as="xs:string"/>
                        </xsl:apply-templates>
        
    </xsl:template>
    
    
    
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
    
    
    
    
    
   
    <xsl:template match="mathOP_object"  mode="mathOPnotation">
        <xsl:param name="mathOP"/>
        <math_operation>
            <xsl:apply-templates  mode="mathOPnotation" select="descendant::math_operation/string">
                
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
    
    <xsl:template match="specific_object"  mode="mathOPnotation">
        <xsl:param name="specOP"></xsl:param>
        <specific_object>
            <xsl:apply-templates  mode="mathOPnotation" select="string">
                <xsl:with-param name="specOP" select="$specOP" as="xs:string"/>
            </xsl:apply-templates>
        </specific_object>
    </xsl:template>
    
    
    <xsl:template mode="mathOPnotation" match="specific_object/string">
        <xsl:param name="specOP"/>
        
        
        
        <xsl:element name="{$specOP}">
            <xsl:apply-templates mode="mathOPnotation"/>
        </xsl:element>
        
        
    </xsl:template>
    
    
    
    <!-- MATHOP OBJECT SEQUENCE HANDLING -->
    
    <xsl:template match="math_operation/string"  mode="mathOPnotation">
        <xsl:param name="mathOP"/>
        <xsl:param name="objectString" as="xs:string" select="current() ! normalize-space()" tunnel="yes"/>
        
        
        
        
        <xsl:comment>
                   This is the <xsl:value-of select="$objectString"/>
               </xsl:comment>
        
        <!-- mode="mathopmode" -->
        <xsl:apply-templates mode="mathOPnotation" select="following-sibling::object/string" >
            <xsl:with-param name="objectString" select="$objectString" as="xs:string"/>
            <xsl:with-param name="mathOP" select="$mathOP" as="xs:string"/>
        </xsl:apply-templates>
        
    </xsl:template>
    
    
   
    
    <!-- mode="mathopmode" -->
    <xsl:template match="object/string"  mode="mathOPnotation" >
        <xsl:param name="mathOP"/>
        <xsl:param name="objectString"/>
        <xsl:param name="objString" as="xs:string" select="current() ! normalize-space()" tunnel="yes"/>
        
      
            
                
        <xsl:apply-templates select="//notation_object" mode="mathOPnotation">
                   <xsl:with-param name="mathOP" select="$mathOP" as="xs:string"/>
                   <xsl:with-param name="objectString" select="$objectString" as="xs:string"/>
                   <xsl:with-param name="objString" select="$objString" as="xs:string"/>
               </xsl:apply-templates>               
            
        
        
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