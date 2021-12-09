<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:map="http://www.w3.org/2005/xpath-functions/map"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math" xmlns:djb="http://www.obdurodon.org"
  xpath-default-namespace="http://relaxng.org/ns/structure/1.0" exclude-result-prefixes="#all"
  version="3.0">
  <!-- ================================================================== -->
  <!-- Pipeline step 1: inline-refs.xsl                                   -->
  <!--                                                                    -->
  <!-- Remove <define> elements, inline everything inside <start>         -->
  <!--                                                                    -->
  <!-- Input: productions.rng                                             -->
  <!-- Output: inline-refs.xml                                            -->
  <!--                                                                    -->
  <!-- NB: Works only with non-cyclic grammars                            -->
  <!-- ================================================================== -->
  <xsl:output method="xml" indent="yes"/>
  <xsl:key name="elementByName" match="element" use="@name"/>
  <xsl:mode on-no-match="shallow-copy"/>
  <xsl:template match="/">
    <xsl:apply-templates select="//start"/>
  </xsl:template>
  <xsl:template match="define">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="ref">
    <xsl:apply-templates select="key('elementByName', @name)"/>
  </xsl:template>
</xsl:stylesheet>
