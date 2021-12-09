<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:map="http://www.w3.org/2005/xpath-functions/map"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math" xmlns:djb="http://www.obdurodon.org"
  xpath-default-namespace="http://relaxng.org/ns/structure/1.0" exclude-result-prefixes="#all"
  version="3.0">
  <xsl:output method="xml" indent="yes"/>
  <xsl:strip-space elements="*"/>
  <!-- ================================================================== -->
  <!-- Element types: start, element, choice, group, optional, value      -->
  <!-- Contents of <element>, <group>, and <optional> are sequential      -->
  <!-- Contents of <choice> are parallel, change modes                    -->
  <!-- Backtrack from element/value, which is terminal                    -->
  <!-- Create edges at target                                             -->
  <!-- Backtrack to first following sibling of first ancestor that        -->
  <!--   has a following sibling                                          -->
  <!-- NB: Exhaustive expansion assumes non-cyclic graph                  -->
  <!-- ================================================================== -->
  <!-- Main                                                               -->
  <!-- ================================================================== -->
  <xsl:template match="start">
    <edges>
      <xsl:apply-templates/>
    </edges>
  </xsl:template>
  <xsl:template match="start/element">
    <!-- ================================================================ -->
    <!-- Root <start> has exactly two children, of type <element>         -->
    <!--   1. The actual root element, which contains everything else     -->
    <!--   2. An "end" element, which we add to give our graph a terminus -->
    <!-- No in-edge, since not target of anything                         -->
    <!-- ================================================================ -->
    <xsl:apply-templates select="*[1]">
      <xsl:with-param name="source" as="xs:string" select="@name"/>
    </xsl:apply-templates>
  </xsl:template>
  <xsl:template match="element[value]">
    <!-- ================================================================ -->
    <!-- Ignore children, always go to sibling or backtrack               -->
    <!-- Must set separately for choice/element[value], since no sibling  -->
    <!-- ================================================================ -->
    <xsl:param name="source" as="xs:string" required="yes"/>
    <edge source="{$source}" target="{@name}"/>
    <xsl:apply-templates select="
        (
        following-sibling::*[1],
        ancestor::*[following-sibling::*][1]/following-sibling::*[1]
        )[1]">
      <xsl:with-param name="source" as="xs:string" select="@name"/>
    </xsl:apply-templates>
  </xsl:template>
  <xsl:template match="element">
    <!-- ================================================================ -->
    <!-- Children of <element> are sequential unless parent is <choice>   -->
    <!-- Next target is, in order of priority:                            -->
    <!--   following-sibling::*[1]                                        -->
    <!--   ancestor::*[following-sibling::*][1]         (backtrack)       -->
    <!-- ================================================================ -->
    <xsl:param name="source" as="xs:string" required="yes"/>
    <edge source="{$source}" target="{@name}"/>
    <xsl:apply-templates select="
        (
        *[1],
        following-sibling::*[1],
        ancestor::*[following-sibling::*][1]/following-sibling::*[1]
        )[1]">
      <xsl:with-param name="source" as="xs:string" select="@name"/>
    </xsl:apply-templates>
  </xsl:template>
  <xsl:template match="choice">
    <!-- ================================================================ -->
    <!-- Contents of <choice> are parallel                                -->
    <!-- Switch to mode choice for one step                               -->
    <!-- No edges; forward to all at once                                 -->
    <!-- ================================================================ -->
    <xsl:param name="source" as="xs:string" required="yes"/>
    <xsl:apply-templates mode="choice">
      <xsl:with-param name="source" as="xs:string" select="$source"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- ================================================================== -->
  <!-- mode choice                                                        -->
  <!-- No next-sibling; always backtrack                                  -->
  <!-- Children are element, value, and group                             -->
  <!-- change modes on <choice> just for one step                         -->
  <!-- ================================================================== -->
  <xsl:template match="element" mode="choice">
    <xsl:param name="source" as="xs:string" required="yes"/>
    <!-- ================================================================ -->
    <!-- <element> children of <choice> are options, so connect next not  -->
    <!--   to following-sibling, but to following-sibling of <choice>     -->
    <!-- ================================================================ -->
    <edge source="{$source}" target="{@name}"/>
    <xsl:apply-templates select="
        *[1],
        ancestor::*[following-sibling::*][1]/
        following-sibling::*[1]">
      <xsl:with-param name="source" select="@name"/>
    </xsl:apply-templates>
  </xsl:template>
  <xsl:template match="element[value]" mode="choice">
    <!-- ================================================================ -->
    <!-- Ignore children, always go to sibling or backtrack               -->
    <!-- Must set separately for choice/element[value], since no sibling  -->
    <!-- ================================================================ -->
    <xsl:param name="source" as="xs:string" required="yes"/>
    <edge source="{$source}" target="{@name}"/>
    <xsl:apply-templates select="
        (
        ../ancestor::*[following-sibling::*][1]/following-sibling::*[1]
        )[1]">
      <xsl:with-param name="source" as="xs:string" select="@name"/>
    </xsl:apply-templates>
  </xsl:template>

  <!--  <xsl:template match="group | optional">
    <!-\- ================================================================== -\->
    <!-\- Pass-through sequential elements: <group>, <optional>              -\->
    <!-\- No link; orward control to the first child (required)              -\->
    <!-\- TODO: current we treat <optional> as if it were (required) <group> -\->
    <!-\- ================================================================== -\->
    <xsl:param name="source" as="xs:string" required="yes"/>
    <xsl:apply-templates select="*[1]">
      <xsl:with-param name="source" as="xs:string" select="$source"/>
    </xsl:apply-templates>
  </xsl:template>-->
</xsl:stylesheet>
