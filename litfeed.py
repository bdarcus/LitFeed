#! /usr/bin/env python

import StringIO
from rdflib import ConjunctiveGraph
from lxml import etree
import simplejson as json

def feed_transform(feed, stylesheet):
    """
    Transform a journal feed into clean BIBO RDF.
    """
    doc = etree.parse(feed)
    xslt_tree = etree.parse('xsl/' + stylesheet)
    result = doc.xslt(xslt_tree)
    return(str(result))

def update():
    """
    Update the library with new articles.
    """
    graph = ConjunctiveGraph()
    # load the existing graph
    library = 'data/articles.rdf'
    graph.load(library)

    feeds = {
        "http://www3.interscience.wiley.com/rss/journal/118485807": "wiley.xsl",
        "http://phg.sagepub.com/rss/current.xml": "sage.xsl",
        "http://www.informaworld.com/ampp/rss~content=t713446924": "infoworld.xsl",
        "http://www.informaworld.com/ampp/rss~content=t788352614": "infoworld.xsl",
        "http://www.envplan.com/rss.cgi?journal=D": "envplan.xsl",
        "http://www.envplan.com/rss.cgi?journal=A": "envplan.xsl",
        "http://cgj.sagepub.com/rss/current.xml": "sage.xsl"
        }

    for feed, stylesheet in feeds.iteritems():
        # grab the feed and transform it
        print "grabbing ", feed
        new = feed_transform(feed, stylesheet)
        # merge the new triples into the graph
        graph.parse(StringIO.StringIO(new))

    graph.serialize(library, format='pretty-xml')


def main():
    update()

if __name__ == "__main__":
    main()




