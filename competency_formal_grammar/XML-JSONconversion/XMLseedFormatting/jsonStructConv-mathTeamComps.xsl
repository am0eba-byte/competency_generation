<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="3.0">

    <!-- handwritten comps input: gradeK-comps.xml -->
    <!-- handwritten comps output: gradeK-formatted.xml -->

    <!-- USE THIS XSLT TO CONVERT MATH TEAM'S HANDWRITTEN COMPS ONLY -->

    <xsl:output method="xml" indent="yes"/>


    <xsl:template match="/">
        <xml>
            <group lvl="1" cc="CC">
                <xsl:apply-templates select="//group[@cc = 'CC']" mode="LVL1"/>
            </group>
            <group lvl="1" cc="OA">
                <xsl:apply-templates select="//group[@cc = 'OA']" mode="LVL1"/>
            </group>
            <group lvl="1" cc="NBT">
                <xsl:apply-templates select="//group[@cc = 'NBT']" mode="LVL1"/>
            </group>
            <group lvl="1" cc="MD">
                <xsl:apply-templates select="//group[@cc = 'MD']" mode="LVL1"/>
            </group>
            <group lvl="1" cc="G">
                <xsl:apply-templates select="//group[@cc = 'G']" mode="LVL1"/>
            </group>
        </xml>
    </xsl:template>


    <!-- TOP-LEVEL grouping hierarchy -->
    <xsl:template match="group[@lvl = '1']" mode="LVL1">
       
        <parentCompColl lvl="1">
            <xsl:apply-templates select="Domain" mode="dom"/>
        </parentCompColl>
        <children type="subD" lvl="2">
            <xsl:apply-templates select="group[@lvl = '2']" mode="LVL2"/>
        </children>
        
    </xsl:template>

    <!-- 2nd LEVEL SUBDOMAIN grouping hierarchy -->
    <xsl:template match="group[@lvl = '2']" mode="LVL2">
<subgroup type="subD">
        <parentCompColl lvl="2">
            <xsl:apply-templates select="subDomain" mode="subD"/>
        </parentCompColl>
        <children type="minorD" lvl="3">
            <xsl:apply-templates select="group[@lvl = '3']" mode="LVL3"/>
        </children>
</subgroup>
    </xsl:template>

    <!-- 3rd LEVEL MINOR DOMAIN grouping hierarchy -->
    <xsl:template match="group[@lvl = '3']" mode="LVL3">
<subgroup type="minorD">
        <parentCompColl lvl="3">
            <xsl:apply-templates select="minorDomain" mode="minD"/>
        </parentCompColl>
        <children type="comps" lvl="4">
            <!-- LOWEST-LEVEL COMPETENCIES -->
            <xsl:apply-templates select="group[@lvl = '4']" mode="comps"/>
        </children>
</subgroup>
    </xsl:template>



    <!-- 1st lvl Parent DOMAIN Comps TEMPLATE -->
    <xsl:template match="Domain" mode="dom">

        <competency>
            <Token>
                <!-- prevent competencies with punctuation from malforming the token by removing them from text -->
                <xsl:choose>
                    <xsl:when test="./text()[contains(., ',') or contains(., '.')]">
                        <xsl:apply-templates
                            select=". ! string-join(tokenize(translate(lower-case(text()), '[.,]', ''), '\s+'), '-')"
                        />
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- lower-case the text, tokenize it on whitespaces, then join the strings together with "-" -->
                        <xsl:apply-templates
                            select=". ! string-join(tokenize(lower-case(text()), '\s+'), '-')"/>
                    </xsl:otherwise>
                </xsl:choose>

            </Token>
            <tID>
                <xsl:value-of select="count(preceding::Domain)"/>
            </tID>
            <Creator>Big Ideas Learning</Creator>
            <Title>
                <lang>en-us</lang>
                <text>
                    <xsl:apply-templates select="text()"/>
                </text>

            </Title>
            <Definition>
                <lang>en-us</lang>
                <text>
                    <xsl:apply-templates select="text()"/>
                </text>

            </Definition>
        </competency>

    </xsl:template>


    <!-- 2nd Level Subdomain Comps TEMPLATE  -->
    <xsl:template match="subDomain" mode="subD">

        <competency>
            <Token>
                <xsl:choose>
                    <!-- prevent competencies with punctuation from malforming the token by removing them from text -->
                    <xsl:when test="./text()[contains(., ',') or contains(., '.')]">
                        <xsl:apply-templates
                            select=". ! string-join(tokenize(translate(lower-case(text()), '[.,]', ''), '\s+'), '-')"
                        />
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- lower-case the text, tokenize it on whitespaces, then join the strings together with "-" -->
                        <xsl:apply-templates
                            select=". ! string-join(tokenize(lower-case(text()), '\s+'), '-')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </Token>
            <tID>
                <xsl:value-of select="count(preceding::subDomain[ancestor::group[@lvl = 1]])"
                />
            </tID>
            <!-- the tFrom value will be generated in the next stage of XSLT processing by capturing the tID of the corresponding parent -->
            <Creator>Big Ideas Learning</Creator>
            <Title>
                <lang>en-us</lang>
                <text>
                    <xsl:apply-templates select="text()"/>
                </text>

            </Title>
            <Definition>
                <lang>en-us</lang>
                <text>
                    <xsl:apply-templates select="text()"/>
                </text>

            </Definition>
        </competency>

    </xsl:template>


    <!-- 3rd LEVEL MINOR DOMAIN COMPS TEMPLATE  -->
    <xsl:template match="minorDomain" mode="minD">

        <competency>
            <Token>
                <xsl:choose>
                    <!-- prevent competencies with punctuation from malforming the token by removing them from text -->
                    <xsl:when test="./text()[contains(., ',') or contains(., '.')]">
                        <xsl:apply-templates
                            select=". ! string-join(tokenize(translate(lower-case(text()), '[.,]', ''), '\s+'), '-')"
                        />
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- lower-case the text, tokenize it on whitespaces, then join the strings together with "-" -->
                        <xsl:apply-templates
                            select=". ! string-join(tokenize(lower-case(text()), '\s+'), '-')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </Token>
            <tID>
                <xsl:value-of
                    select="count(preceding::minorDomain[ancestor::group[@lvl = 2]])"/>
            </tID>
            <!-- the tFrom value will be generated in the next stage of XSLT processing by capturing the tID of the corresponding parent -->
            <Creator>Big Ideas Learning</Creator>
            <Title>
                <lang>en-us</lang>
                <text>
                    <xsl:apply-templates select="text()"/>
                </text>

            </Title>
            <Definition>
                <lang>en-us</lang>
                <text>
                    <xsl:apply-templates select="text()"/>
                </text>

            </Definition>
        </competency>
    </xsl:template>


    <!-- LOWEST-LEVEL COMPETENCIES TEMPLATE  -->
    <xsl:template match="group[@lvl = '4']" mode="comps">

        <xsl:for-each select="competency">
            <xsl:choose>
                <xsl:when test="@id">
                    <xsl:choose>
                        <xsl:when test="./notes">
                            <!-- when the comp has NOTES and a PROGRESSIVE ID -->
                            <competency>
                                <ssID>
                                    <xsl:apply-templates select="./@id"/>
                                </ssID>
                                <ssExtends>
                                    <xsl:apply-templates select="./@extends"/>
                                </ssExtends>
                                <Token>
                                    <xsl:choose>
                                        <!-- prevent competencies with punctuation from malforming the token by removing them from text -->
                                        <xsl:when
                                            test="./text()[contains(., ',') or contains(., '.')]">
                                            <xsl:apply-templates
                                                select=". ! string-join(tokenize(translate(lower-case(text()), '[.,]', ''), '\s+'), '-')"
                                            />
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <!-- lower-case the text, tokenize it on whitespaces, then join the strings together with "-" -->
                                            <xsl:apply-templates
                                                select=". ! string-join(tokenize(lower-case(text()), '\s+'), '-')"
                                            />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </Token>
                                <tID>
                                    <xsl:value-of
                                        select="count(preceding::competency[parent::group[@lvl = '4']])"
                                    />
                                </tID>
                                <!-- tFrom transitive parent ID will be placed here in next stage of XSLT processing -->
                                <Creator>Big Ideas Learning</Creator>
                                <Title>
                                    <lang>en-us</lang>
                                    <text>
                                        <xsl:apply-templates select="text()"/>
                                    </text>
                                </Title>
                                <Definition>
                                    <lang>en-us</lang>
                                    <text>
                                        <xsl:apply-templates select="text()"/>
                                    </text>
                                </Definition>
                                <Notes>
                                    <Timestamp>
                                        <xsl:value-of select="current-dateTime()"/>
                                    </Timestamp>
                                    <text>
                                        <xsl:apply-templates select="./notes/text()"/>
                                    </text>
                                    <UserID/>
                                    <ID>
                                        <xsl:value-of select="generate-id()"/>
                                    </ID>
                                </Notes>
                            </competency>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- when the comp has a PROGRESSIVE ID and NO NOTES -->
                            <competency>
                                <ssID>
                                    <xsl:apply-templates select="./@id"/>
                                </ssID>
                                <ssExtends>
                                    <xsl:apply-templates select="./@extends"/>
                                </ssExtends>
                                <Token>
                                    <xsl:choose>
                                        <!-- prevent competencies with punctuation from malforming the token by removing them from text -->
                                        <xsl:when
                                            test="./text()[contains(., ',') or contains(., '.')]">
                                            <xsl:apply-templates
                                                select=". ! string-join(tokenize(translate(lower-case(text()), '[.,]', ''), '\s+'), '-')"
                                            />
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <!-- lower-case the text, tokenize it on whitespaces, then join the strings together with "-" -->
                                            <xsl:apply-templates
                                                select=". ! string-join(tokenize(lower-case(text()), '\s+'), '-')"
                                            />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </Token>
                                <tID>
                                    <xsl:value-of
                                        select="count(preceding::competency[parent::group[@lvl = '4']])"
                                    />
                                </tID>
                                <!-- tFrom transitive parent ID will be placed here in next stage of XSLT processing -->
                                <Creator>Big Ideas Learning</Creator>
                                <Title>
                                    <lang>en-us</lang>
                                    <text>
                                        <xsl:apply-templates select="text()"/>
                                    </text>
                                </Title>
                                <Definition>
                                    <lang>en-us</lang>
                                    <text>
                                        <xsl:apply-templates select="text()"/>
                                    </text>
                                </Definition>
                            </competency>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="./notes">
                            <!-- when the comp has NOTES and NO PROGRESSIVE ID -->
                            <competency>
                                <Token>
                                    <xsl:choose>
                                        <!-- prevent competencies with punctuation from malforming the token by removing them from text -->
                                        <xsl:when
                                            test="./text()[contains(., ',') or contains(., '.')]">
                                            <xsl:apply-templates
                                                select=". ! string-join(tokenize(translate(lower-case(text()), '[.,]', ''), '\s+'), '-')"
                                            />
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <!-- lower-case the text, tokenize it on whitespaces, then join the strings together with "-" -->
                                            <xsl:apply-templates
                                                select=". ! string-join(tokenize(lower-case(text()), '\s+'), '-')"
                                            />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </Token>
                                <tID>
                                    <xsl:value-of
                                        select="count(preceding::competency[parent::group[@lvl = '4']])"
                                    />
                                </tID>
                                <!-- tFrom transitive parent ID will be placed here in next stage of XSLT processing -->
                                <Creator>Big Ideas Learning</Creator>
                                <Title>
                                    <lang>en-us</lang>
                                    <text>
                                        <xsl:apply-templates select="text()"/>
                                    </text>
                                </Title>
                                <Definition>
                                    <lang>en-us</lang>
                                    <text>
                                        <xsl:apply-templates select="text()"/>
                                    </text>
                                </Definition>
                                <Notes>
                                    <Timestamp>
                                        <xsl:value-of select="current-dateTime()"/>
                                    </Timestamp>
                                    <text>
                                        <xsl:apply-templates select="./notes/text()"/>
                                    </text>
                                    <UserID/>
                                    <ID>
                                        <xsl:value-of select="generate-id()"/>
                                    </ID>
                                </Notes>
                            </competency>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- when the comp has NO PROGRESSIVE ID and NO NOTES -->
                            <competency>
                                <Token>
                                    <xsl:choose>
                                        <!-- prevent competencies with punctuation from malforming the token by removing them from text -->
                                        <xsl:when
                                            test="./text()[contains(., ',') or contains(., '.')]">
                                            <xsl:apply-templates
                                                select=". ! string-join(tokenize(translate(lower-case(text()), '[.,]', ''), '\s+'), '-')"
                                            />
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <!-- lower-case the text, tokenize it on whitespaces, then join the strings together with "-" -->
                                            <xsl:apply-templates
                                                select=". ! string-join(tokenize(lower-case(text()), '\s+'), '-')"
                                            />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </Token>
                                <tID>
                                    <xsl:value-of
                                        select="count(preceding::competency[parent::group[@lvl = '4']])"
                                    />
                                </tID>
                                <!-- tFrom transitive parent ID will be placed here in next stage of XSLT processing -->
                                <Creator>Big Ideas Learning</Creator>
                                <Title>
                                    <lang>en-us</lang>
                                    <text>
                                        <xsl:apply-templates select="text()"/>
                                    </text>
                                </Title>
                                <Definition>
                                    <lang>en-us</lang>
                                    <text>
                                        <xsl:apply-templates select="text()"/>
                                    </text>
                                </Definition>
                            </competency>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>

    </xsl:template>



</xsl:stylesheet>
