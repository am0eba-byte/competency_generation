<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:map="http://www.w3.org/2005/xpath-functions/map"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math" xmlns:djb="http://www.obdurodon.org"
  xpath-default-namespace="http://relaxng.org/ns/structure/1.0" exclude-result-prefixes="#all"
  version="3.0">
  <xsl:output method="xml" indent="yes"/>
  <xsl:strip-space elements="*"/>
  <!--
    Root <start> has exactly one child, of type <element>
    Element types: start, element, choice, group, optional, value
    Contents of <element>, <group>, and <optional> are sequential
    Contents of <choice> are parallel
    Create edges at target
  -->
  <xsl:template match="start/element">
    <!-- No edge, since not target of anything -->
    <xsl:apply-templates select="*[1]">
      <xsl:with-param name="source" as="xs:string" select="@name"/>
    </xsl:apply-templates>
  </xsl:template>
  <xsl:template match="element">
    <!-- Children of <element> are sequential -->
    <xsl:param name="source" as="xs:string" required="yes"/>
    <edge source="{$source}" target="{@name}"/>
    <xsl:apply-templates select="following-sibling::*[1]">
      <xsl:with-param name="source" as="xs:string" select="@name"/>
    </xsl:apply-templates>
  </xsl:template>
  <xsl:template match="group">
    <!-- Pass through <group> to first child -->
    <xsl:param name="source" as="xs:string" required="yes"/>
    <xsl:apply-templates select="*[1]">
      <xsl:with-param name="source" as="xs:string" select="$source"/>
    </xsl:apply-templates>
  </xsl:template>
  <xsl:template match="choice">
    <xsl:param name="source" as="xs:string" required="yes"/>
    <!-- -->
    <xsl:apply-templates/>
  </xsl:template>
</xsl:stylesheet>
