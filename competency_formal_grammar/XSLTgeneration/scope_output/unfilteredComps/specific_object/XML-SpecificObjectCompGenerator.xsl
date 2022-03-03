<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="3.0">
    
    
    <!-- THIS XSLT Generator is for producing XML files of 
        unfiltered Specific Object competencies (no scope relation) -->
    
    
    <xsl:output method="xml" indent="yes"/>
    
    
    <!-- ebb: Here we have defined a series of global parameters that are just strings of text designed to match element names in the source document. Parameters are very similar to variables in XSLT, but have a little more flexibility.They could be received into this XSLT as input, so imagine these as INPUT PARAMETERS to this XSLT. -->
    
    <xsl:param name="formal_process" as="xs:string" select="'formalProcess'"/>
    <xsl:param name="knowledge_process" as="xs:string" select="'knowledgeProcess'"/>
    <xsl:param name="specific_object" as="xs:string" select="'specificObject'"/>
   
    
    
    <!-- SENTENCE WRITER -->
    <xsl:template name="sentenceWriter" as="element()+">
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
        <!-- select=  //*[name() = $param3]/string ! normalize-space() -->
        <!-- $param1/parent::* ! name() -->
        
        
        <xsl:for-each select="$var1 ! normalize-space()">
            <xsl:variable name="currLevel1" as="xs:string" select="current()"/>
            
            <xsl:for-each select="$var2 ! normalize-space()">
                <xsl:variable name="currLevel2" as="xs:string?" select="current()"/>
                
                        <componentSentence>
                            <xsl:element name="{$param1}">
                                <xsl:sequence select="$currLevel1"/>
                            </xsl:element>
                            <xsl:element name="{$param2}">
                                <xsl:sequence select="$currLevel2"/>
                            </xsl:element>
                        </componentSentence>

            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    
    
    <xsl:template match="/">
      <xml>
            <xsl:comment>####################################</xsl:comment>
            <xsl:comment>Formal Process + Specific Object</xsl:comment>
            <xsl:comment>####################################</xsl:comment>
           
            <sentenceGroup xml:id="fp-so">
                <xsl:call-template name="sentenceWriter">
                    <xsl:with-param name="param1" as="xs:string+" select="$formal_process"/>
                    <xsl:with-param name="param2" as="xs:string+" select="$specific_object"/>
                </xsl:call-template>
            </sentenceGroup>
          

           <xsl:comment>####################################</xsl:comment>
            <xsl:comment>Knowledge Process + Specific Object</xsl:comment>
            <xsl:comment>####################################</xsl:comment>
       
          <sentenceGroup xml:id="kp-so">
                <xsl:call-template name="sentenceWriter">
                    <xsl:with-param name="param1" as="xs:string+" select="$knowledge_process"/>
                    <xsl:with-param name="param2" as="xs:string+" select="$specific_object"/>
                </xsl:call-template>
            </sentenceGroup>
    </xml>
    </xsl:template>
    
</xsl:stylesheet>