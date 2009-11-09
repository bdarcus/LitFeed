<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:gr="http://www.google.com/schemas/reader/atom/" xmlns:atom="http://www.w3.org/2005/Atom"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dcterms="http://purl.org/dc/terms/"
  xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:foaf="http://xmlns.com/foaf/0.1/"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema#" xmlns:bibo="http://purl.org/ontology/bibo/"
  xmlns:str="http://exslt.org/strings" xmlns:prism="http://prismstandard.org/namespaces/1.2/basic/"
  xmlns:content="http://purl.org/rss/1.0/modules/content/"
  xmlns:entity="http://wiley.com/wispers/transformer/character-entity-translation"
  xmlns:html="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
  xmlns:rss1="http://purl.org/rss/1.0/" exclude-result-prefixes="str atom gr rss1 content entity"
  version="1.0">

  <xsl:output indent="yes" method="xml" encoding="UTF-8"/>
  <xsl:strip-space elements="*"/>

  <xsl:param name="contributor-map" select="document('contributors.rdf')"/>

  <xsl:param name="issue-link">
    <xsl:value-of select="//rss1:channel/@rdf:about"/>
  </xsl:param>

  <xsl:template match="/">
    <rdf:RDF>
      <xsl:apply-templates select="//rss1:channel"/>
      <xsl:apply-templates select="//atom:entry|//rss1:item|//item"/>
    </rdf:RDF>
  </xsl:template>

  <xsl:template match="rss1:channel">
    <bibo:Issue rdf:about="{$issue-link}">
      <xsl:apply-templates
        select="rss1:title|prism:volume|prism:number|prism:issn|prism:eIssn|dc:date"/>
    </bibo:Issue>
  </xsl:template>

  <xsl:template match="prism:issn">
    <bibo:issn>
      <xsl:value-of select="."/>
    </bibo:issn>
  </xsl:template>

  <xsl:template match="prism:eIssn">
    <bibo:eissn>
      <xsl:value-of select="."/>
    </bibo:eissn>
  </xsl:template>

  <xsl:template match="atom:entry|rss1:item|item">
    <bibo:AcademicArticle rdf:about="{rss1:link}">
      <xsl:apply-templates/>
      <dcterms:isPartOf rdf:resource="{$issue-link}"/>
    </bibo:AcademicArticle>
  </xsl:template>

  <xsl:template match="atom:title|rss1:title">
    <dc:title xml:lang="en">
      <xsl:value-of select="."/>
    </dc:title>
  </xsl:template>

  <xsl:template match="prism:volume">
    <bibo:volume>
      <xsl:value-of select="."/>
    </bibo:volume>
  </xsl:template>

  <xsl:template match="prism:number">
    <bibo:issue>
      <xsl:value-of select="substring(., 5, 1)"/>
    </bibo:issue>
  </xsl:template>

  <xsl:template match="prism:startingPage">
    <bibo:pageStart>
      <xsl:value-of select="."/>
    </bibo:pageStart>
  </xsl:template>

  <xsl:template match="prism:endingPage">
    <bibo:pageEnd>
      <xsl:value-of select="."/>
    </bibo:pageEnd>
  </xsl:template>

  <xsl:template match="dc:identifier">
    <bibo:doi>
      <xsl:value-of select="."/>
    </bibo:doi>
  </xsl:template>

  <xsl:template match="dc:creator">
    <dc:creator>
      <xsl:value-of select="."/>
    </dc:creator>
  </xsl:template>

  <xsl:template match="dc:publisher|dc:rights|prism:section|rss1:link"/>

  <xsl:template match="rss1:description">
    <bibo:abstract>
      <xsl:value-of select="."/>
    </bibo:abstract>
  </xsl:template>

  <xsl:template match="atom:published|pubDate|dc:date">
    <dcterms:issued rdf:datatype="http://www.w3.org/2001/XMLSchema#date">
      <xsl:choose>
        <xsl:when test="contains(., 'T')">
          <xsl:value-of select="substring-before(., 'T')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="."/>
        </xsl:otherwise>
      </xsl:choose>
    </dcterms:issued>
  </xsl:template>

</xsl:stylesheet>
