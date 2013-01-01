#!/usr/bin/perl
#
# KML to KML conversion. Resulting KML is simplified and can be uploaded to Google Maps
# Usage: perl kml2kml.pl file-in.kml > file-out.kml
# Tomasz Przechlewski 2012
#
use XML::LibXML;
use XML::LibXML::XPathContext;

binmode(STDOUT, ":utf8");
my $parser = XML::LibXML->new;

## Preamble is obligatory (or Google returns error):
print "<?xml version='1.0' encoding='UTF-8'?>\n";

print "<kml xmlns='http://www.opengis.net/kml/2.2' xmlns:gx='http://www.google.com/kml/ext/2.2'>\n";
##<Document><name/><description/>
print "<Document>\n";

my $file2parse = $ARGV[0] ; ##

my $doc = $parser->parse_file($file2parse);

print STDERR "*** Processing file: $file2parse ***\n";

# http://perl-xml.sourceforge.net/faq/#namespaces_xpath
my $xpc = XML::LibXML::XPathContext->new($doc->documentElement() );

$xpc->registerNs( 'kml', 'http://www.opengis.net/kml/2.2');

### ### ### Get all waypoints:

for my $w ( $xpc->findnodes("//kml:Folder[kml:name/text()='Waypoints']/kml:Placemark") ) {

  print "<Placemark>\n";

  my @name = $xpc->findnodes("kml:name", $w); 
  foreach my $node (@name) { print "<name>", $node->firstChild->data, "</name>\n"; }

  my @desc = $xpc->findnodes("kml:description", $w); 
  foreach my $node (@desc) {
    ## Convert to CDATA or Google returns error:
    $cdata = $node->firstChild->data ;
    $cdata =~ s/&lt;/</g;     $cdata =~ s/&gt;/>/g;  $cdata =~ s/&apos;/'/g;
    print "<description><![CDATA[", $cdata, "]]></description>\n"; 
  }

  my @coords = $xpc->findnodes("kml:Point/kml:coordinates", $w);
  foreach my $node (@coords) { print "<Point><coordinates>", $node->firstChild->data, "</coordinates></Point>\n"; }

  print "</Placemark>\n";

}

print "\n";

### ### ### All tracks:
my $path_no = 0;

for my $w ( $xpc->findnodes("//kml:Placemark//kml:LineString") ) {
  $path_no++;
  print "<Placemark><name>Path$path_no</name>\n<LineString>\n<tessellate>1</tessellate>\n<coordinates>\n";

  my @coords = $xpc->findnodes("kml:coordinates", $w);
  foreach my $node (@coords) { print $node->firstChild->data ; }

  print "</coordinates></LineString></Placemark>\n";

}

print "</Document></kml>\n";

### koniec/end ###
