<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
  xpath-default-namespace="http://relaxng.org/ns/structure/1.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
  version="3.0">
  <xsl:output method="xhtml" html-version="5" omit-xml-declaration="no" indent="yes"
    include-content-type="no"/>
  <xsl:strip-space elements="*"/>
  <!-- ================================================================== -->
  <!-- rng.test                                                           -->
  <!-- last modified 2021-12-05 djb                                       -->
  <!--                                                                    -->
  <!-- To use: transform production.rng, a Relax NG expression of XXX     -->
  <!--   (modified_competency subset)                                     -->
  <!--                                                                    -->
  <!-- Synopsis:                                                          -->
  <!--   Generate all possible (non-recursive) output from rng            -->
  <!--   In case of recursion in schema, flag and stop descending         -->
  <!--   Recursion may be immediate (knowledge_subproccess) or indirect   -->
  <!--                                                                    -->
  <!-- Assumes following element types:                                   -->
  <!--   choice                                                           -->
  <!--   define  (has @name)                                              -->
  <!--   element (has @name)                                              -->
  <!--   grammar                                                          -->
  <!--   group                                                            -->
  <!--   optional                                                         -->
  <!--   ref (has @name)                                                  -->
  <!--   start                                                            -->
  <!--   value                                                            -->
  <!--                                                                    -->
  <!-- Ignore: grammar, define                                            -->
  <!-- Initial: start                                                     -->
  <!-- Terminal: value                                                    -->
  <!--                                                                    -->
  <!-- Notes:                                                             -->
  <!--                                                                    -->
  <!-- Every <element> is wrapped in a <define> with which it shares a    -->
  <!--   unique @name value. Ignore <define> and work directly with       -->
  <!--   <element>.                                                       -->
  <!-- <element> and <group> are processed with sibling recursion         -->
  <!-- ================================================================== -->
  <!-- Key                                                                -->
  <!-- ================================================================== -->
  <xsl:key name="elementByName" match="element" use="@name"/>

  <!--                                                                    -->
  <!-- ================================================================== -->
  <!-- Main                                                               -->
  <!-- ================================================================== -->
  <xsl:template match="/">
    <html>
      <head>
        <title>Sample competencies</title>
      </head>
      <body>
        <xsl:apply-templates select="//start">
          <xsl:with-param name="output" as="xs:string?"/>
        </xsl:apply-templates>
      </body>
    </html>
  </xsl:template>
  <!--                                                                    -->
  <!-- ================================================================== -->
  <!-- Role: housekeeping                                                 -->
  <!-- Element types: <start>                                             -->
  <!-- ================================================================== -->
  <xsl:template match="start">
    <!-- ================================================================ -->
    <!-- start                                                            -->
    <!-- Assumes content is exactly one <ref>                             -->
    <!-- ================================================================ -->
    <xsl:param name="output" as="xs:string?" required="yes"/>
    <xsl:apply-templates select="key('elementByName', ref/@name)">
      <xsl:with-param name="output" as="xs:string?"/>
    </xsl:apply-templates>
  </xsl:template>
  <!--                                                                    -->
  <!-- ================================================================== -->
  <!-- Role: non-terminal                                                 -->
  <!-- Element types: <element>, <choice>, <group>, <ref>, <optional>     -->
  <!-- ================================================================== -->
  <xsl:template match="element">
    <!-- ================================================================ -->
    <!-- element                                                          -->
    <!-- Children: choice, ref, value                                     -->
    <!-- ================================================================ -->
    <xsl:param name="output" as="xs:string?" required="yes"/>
    <xsl:apply-templates select="*[1]" mode="sibling">
      <xsl:with-param name="output" select="
          string-join(($output,
          if (starts-with(@name, 'terminal-')) then
            ''
          else
            @name), ' ')"/>
    </xsl:apply-templates>
  </xsl:template>
  <xsl:template match="element[self::end]">
    <xsl:param name="output" as="xs:string" required="yes"/>
    <p>
      <xsl:value-of select="$output"/>
    </p>
  </xsl:template>
  <xsl:template match="choice">
    <!-- ================================================================ -->
    <!-- choice                                                           -->
    <!-- Children: group, ref                                             -->
    <!-- Pass along $output to each child                                 -->
    <!-- ================================================================ -->
    <xsl:param name="output" as="xs:string" required="yes"/>
    <xsl:for-each select="*">
      <xsl:apply-templates>
        <xsl:with-param name="output" as="xs:string" select="$output"/>
      </xsl:apply-templates>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="group">
    <!-- ================================================================ -->
    <!-- group                                                            -->
    <!-- Children: optional, ref, choice                                  -->
    <!-- Process with sibling recursion                                   -->
    <!-- ================================================================ -->
    <xsl:param name="output" as="xs:string" required="yes"/>
    <xsl:apply-templates select="*[1]" mode="sibling">
      <xsl:with-param name="output" as="xs:string" select="$output"/>
    </xsl:apply-templates>
  </xsl:template>
  <xsl:template match="ref">
    <!-- ================================================================ -->
    <!-- <ref>                                                            -->
    <!-- No children, obligatory @name, which points to <element>         -->
    <!-- ================================================================ -->
    <xsl:param name="output" as="xs:string" required="yes"/>
    <xsl:apply-templates select="key('elementByName', @name)">
      <xsl:with-param name="output" select="
          string-join(($output,
          if (starts-with(@name, 'terminal-')) then
            ''
          else
            @name), ' ')"/>
    </xsl:apply-templates>
  </xsl:template>
  <xsl:template match="optional">
    <!-- ================================================================ -->
    <!-- optional                                                         -->
    <!-- Children: ref, choice                                            -->
    <!-- Process with sibling recursion, like group, but with and without -->
    <!--   optional item, like choice                                     -->
    <!-- ================================================================ -->
    <xsl:param name="output" as="xs:string" required="yes"/>
    <!--    <xsl:apply-templates select="*[1]" mode="sibling">
      <xsl:with-param name="output" as="xs:string" select="$output"/>
    </xsl:apply-templates>
-->
  </xsl:template>

  <!-- ================================================================== -->
  <!-- Role: terminal                                                     -->
  <!-- Element types: <value>                                             -->
  <!-- ================================================================== -->
  <xsl:template match="value">
    <!-- ================================================================ -->
    <!-- <value>                                                          -->
    <!-- Append value                                                     -->
    <!-- ================================================================ -->
    <xsl:param name="output" as="xs:string" required="yes"/>
    <xsl:sequence select="string-join(($output, .), ' ')"/>
  </xsl:template>

  <!-- ================================================================== -->
  <!-- Mode: sibling                                                      -->
  <!-- Use sibling recursion for children of <group> and <element>        -->
  <!-- ================================================================== -->
  <xsl:template match="*" mode="sibling">
    <xsl:param name="output" as="xs:string" required="yes"/>
    <xsl:apply-templates select=".">
      <!-- Expand current in place with unmoded template -->
      <xsl:with-param name="output" select="
          string-join(($output,
          if (starts-with(@name, 'terminal-')) then
            ''
          else
            @name), ' ')"/>
    </xsl:apply-templates>
    <!-- Proceed through siblings -->
    <xsl:apply-templates select="following-sibling::*[1]" mode="sibling">
      <xsl:with-param name="output" select="
          string-join(($output,
          if (starts-with(@name, 'terminal-')) then
            ''
          else
            @name), ' ')"/>
    </xsl:apply-templates>
  </xsl:template>
</xsl:stylesheet>
