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

  <xsl:include href="feed2bibo.xsl"/>

  <xsl:param name="issue-link">
    <xsl:value-of select="//rss1:channel/@rdf:about"/>
  </xsl:param>

  <xsl:template match="/">
    <rdf:RDF>
      <xsl:apply-templates select="//rss1:channel"/>
      <xsl:apply-templates select="//atom:entry|//rss1:item[prism:section='Papers']|//item"/>
    </rdf:RDF>
  </xsl:template>

  <xsl:template match="rss1:channel">
    <bibo:Issue rdf:about="{$issue-link}">
      <xsl:apply-templates
        select="rss1:title|prism:volume|prism:number|prism:issn|prism:eIssn|dc:date"/>
    </bibo:Issue>
  </xsl:template>

  <xsl:template match="prism:number">
    <bibo:issue>
      <xsl:value-of select="substring(., 5, 1)"/>
    </bibo:issue>
  </xsl:template>

</xsl:stylesheet>
