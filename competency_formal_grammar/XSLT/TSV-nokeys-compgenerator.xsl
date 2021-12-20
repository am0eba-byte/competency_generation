<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="3.0">
    
    
   <!-- <xsl:output method="xml" indent="yes"/>-->
    
    
    <!-- ebb: Here we have defined a series of global parameters that are just strings of text designed to match element names in the source document. Parameters are very similar to variables in XSLT, but have a little more flexibility.They could be received into this XSLT as input, so imagine these as INPUT PARAMETERS to this XSLT. -->
    
    <xsl:param name="formal_process" as="xs:string" select="'formal_process'"/>
    <xsl:param name="knowledge_process" as="xs:string" select="'knowledge_process'"/>
    
    <xsl:param name="processPred" as="xs:string" select="'processPred'"/>
    
    <xsl:param name="specific_object" as="xs:string" select="'specific_object'"/>
    
    <xsl:param name="math_operation" as="xs:string" select="'math_operation'"/>
    <xsl:param name="quant_object" as="xs:string" select="'quant'"/>
   
   <!-- SCOPE PARAMS -->
    <xsl:param name="complex" as="xs:string" select="'complex'"/>
    <xsl:param name="imag" as="xs:string" select="'imag'"/>
    
    <!-- KEYS -->
    <!-- SCOPE KEYS -->
    <xsl:key name="scopes" match="string" use="@class ! tokenize(., '\s+')"/>
    
    <!-- KEYS: all components -->
    <xsl:key name="elements" match="compParts" use="descendant::*"/>
    
    
    <!-- SENTENCE WRITER -->
    <xsl:template name="sentenceWriter" as="xs:string+">
        <xsl:param name="param1" as="xs:string+" required="yes"/>
        <xsl:param name="param2" as="xs:string+" required="yes"/>
        <xsl:param name="param3" as="xs:string*"/>
        
        <!-- MAX NUM OF PARAMS FOR ALL OTHER SCOPES: 3 -->
        
        <!-- MAX NUMBER OF COMPONENT PARAMS (whole numbers scope only): 5
            knowledge process + subprocess + math operation + object -->
        
        <!-- YES WE DO NEED VARIABLES. JUST NOT THESE VARIABLES> 
            TAKE THE NODES, CONVERT THEM TO STRINGS FOR SENTENCE CONSTRUCTION.
            -->
        <xsl:variable name="var1" as="xs:string+" select="//*[name() = $param1]/string ! normalize-space()"/>
        <xsl:variable name="var2" as="xs:string+" select="//*[name() = $param2]/string ! normalize-space()"/>
        <xsl:variable name="var3" as="xs:string*" select="//*[name() = $param3]/string ! normalize-space()"/>
        
        <xsl:for-each select="$var1 ! normalize-space()">
            <xsl:variable name="currLevel1" as="xs:string" select="current()"/>
            
            <xsl:for-each select="$var2 ! normalize-space()">
                <xsl:variable name="currLevel2" as="xs:string?" select="current()"/>
                
                <xsl:choose><!-- CHOICE 1 -->
                    <xsl:when test="$param3">
                        <xsl:for-each select="$var3 ! normalize-space()">
                            <xsl:variable name="currLevel3" as="xs:string?" select="current()"/>
                            <xsl:sequence select="concat($currLevel1, '&#x9;', $currLevel2, '&#x9;', $currLevel3,'&#10;')"/>
                        
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="concat($currLevel1, '&#x9;', $currLevel2, '&#10;')"/>
                    
                    </xsl:otherwise>
                </xsl:choose>
                
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    
    
    <xsl:template match="/">
       <!-- <xml>
            <xsl:comment>####################################</xsl:comment>
            <xsl:comment>Formal Process Branch </xsl:comment>
            <xsl:comment>####################################</xsl:comment>
            
            
            <xsl:comment>####################################</xsl:comment>
            <xsl:comment>Formal Process + Process Predicate</xsl:comment>
            <xsl:comment>####################################</xsl:comment>-->
       <xsl:result-document method="text" href="unfiltered-output/TSV/fp-Pp.tsv">
           <!-- <sentenceGroup xml:id="fp-Pp">-->
                <xsl:call-template name="sentenceWriter">
                    <xsl:with-param name="param1" as="xs:string+" select="$formal_process"/>
                    <xsl:with-param name="param2" as="xs:string+" select="$processPred"/>
                </xsl:call-template>
            <!--</sentenceGroup>-->
       </xsl:result-document>
            <!--<xsl:comment>####################################</xsl:comment>
            <xsl:comment>Formal Process + Specific Object</xsl:comment>
            <xsl:comment>####################################</xsl:comment>-->
            <xsl:result-document method="text" href="unfiltered-output/TSV/fp-so.tsv">
            <!--<sentenceGroup xml:id="fp-so">-->
                <xsl:call-template name="sentenceWriter">
                    <xsl:with-param name="param1" as="xs:string+" select="$formal_process"/>
                    <xsl:with-param name="param2" as="xs:string+" select="$specific_object"/>
                </xsl:call-template>
            <!--</sentenceGroup>-->
        </xsl:result-document>
            <!--<xsl:comment>####################################</xsl:comment>
            <xsl:comment>Formal Process + Math Operation + Quant Object</xsl:comment>
            <xsl:comment>####################################</xsl:comment>-->
  
            <xsl:result-document method="text" href="unfiltered-output/TSV/fp-mathop.tsv">
            <!--<sentenceGroup xml:id="fp-mathop">-->
                <xsl:call-template name="sentenceWriter">
                    <xsl:with-param name="param1" as="xs:string+" select="$formal_process"/>
                    <xsl:with-param name="param2" as="xs:string+" select="$math_operation"/>
                    <xsl:with-param name="param3" as="xs:string+" select="$quant_object"/>
                </xsl:call-template>
            <!--</sentenceGroup>-->
            </xsl:result-document>
            
            <!--<xsl:comment>####################################</xsl:comment>
            <xsl:comment>Knowledge Process Branch </xsl:comment>
            <xsl:comment>####################################</xsl:comment>
            
            
            <xsl:comment>####################################</xsl:comment>
            <xsl:comment>Knowledge Process + Process Pred</xsl:comment>
            <xsl:comment>####################################</xsl:comment>-->
      <xsl:result-document method="text" href="unfiltered-output/TSV/kp-Pp.tsv">
           <!-- <sentenceGroup xml:id="kp-Pp">-->
                <xsl:call-template name="sentenceWriter">
                    <xsl:with-param name="param1" as="xs:string+" select="$knowledge_process"/>
                    <xsl:with-param name="param2" as="xs:string+" select="$processPred"/>
                </xsl:call-template>
            <!--</sentenceGroup>-->
            </xsl:result-document>
           <!-- <xsl:comment>####################################</xsl:comment>
            <xsl:comment>Knowledge Process + Specific Object</xsl:comment>
            <xsl:comment>####################################</xsl:comment>-->
       <xsl:result-document method="text" href="unfiltered-output/TSV/kp-so.tsv">
          <!--  <sentenceGroup xml:id="kp-so">-->
                <xsl:call-template name="sentenceWriter">
                    <xsl:with-param name="param1" as="xs:string+" select="$knowledge_process"/>
                    <xsl:with-param name="param2" as="xs:string+" select="$specific_object"/>
                </xsl:call-template>
            <!--</sentenceGroup>-->
            </xsl:result-document>
         <!--   <xsl:comment>####################################</xsl:comment>
            <xsl:comment>Knowledge Process + Math Operation + Quant Object</xsl:comment>
            <xsl:comment>####################################</xsl:comment>-->
          
           <xsl:result-document method="text" href="unfiltered-output/TSV/kp-mathop.tsv"> 
            <sentenceGroup xml:id="kp-mathop">
                <xsl:call-template name="sentenceWriter">
                    <xsl:with-param name="param1" as="xs:string+" select="$knowledge_process"/>
                    <xsl:with-param name="param2" as="xs:string+" select="$math_operation"/>
                    <xsl:with-param name="param3" as="xs:string+" select="$quant_object"/>
                </xsl:call-template>
            </sentenceGroup>
            </xsl:result-document>
            
        <!--</xml>-->
    </xsl:template>
    
</xsl:stylesheet>