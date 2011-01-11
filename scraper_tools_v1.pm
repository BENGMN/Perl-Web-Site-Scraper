#!/usr/bin/perl

package scraper_tools_v1;

use strict;
use warnings;
use WWW::Curl::Easy;

# Script produced by Benjamin Crudo on December 28, 2010.
# Feel free to use it and learn from it without me suing you.

# Note this function expects a single parameter which should be in the form of a URL
# Here is an example of a valid call to this function:
# my $web_page = &getWebPage("http://www.google.com");

sub getWebPage($)
{
  # Setting up the Curl parameters
  my $curl = WWW::Curl::Easy->new; # create a variable to store the curl object
  my $target_url = $_[0];

#print "scraper --> Target URL is: ".$target_url."\n";

  # A parameter set to 1 tells the library to include the header in the body output.
  # This is only relevant for protocols that actually have headers preceding the data (like HTTP).
  $curl->setopt(CURLOPT_HEADER, 1);

  # Setting the target URL to retrieve with the passed parameter
  $curl->setopt(CURLOPT_URL, $target_url);

  # Declaring a variable to store the response from the Curl request
  my $response_body = '';

  # Creating a file handle for CURL to output to, then redirecting our output to the $response_body variable
  open(my $fileb, ">",\$response_body) or die $!;
  $curl->setopt(CURLOPT_WRITEDATA, $fileb);

# This is Blank still print "Reponse Body:\n".$response_body."\n";#.$fileb."\n";

  # getting the return code from the header to see if the GET was successful
  my $return_code = $curl->perform;

#print "Return code is: ".$return_code."\n";
#print "Response body:\n".$response_body."\n";

  # capturing the response code from the GET request in the HTTP header, i.e... 200, 404, 500, etc...
  # 200 is success
  my $response_code = $curl->getinfo(CURLINFO_HTTP_CODE);  

#print "Reponse code from Header: ".$response_code."\n";

  # if the return code is zero than the request was a success
  if ($return_code == 0)
  {    
    # A little debug output to keep you informed
    print ("Success ". $response_code.": ".$target_url."\n");

    # return whatever was contained on the web page that we just got using a GET
    return $response_body;
  }

  else
  {
    print ("Failure ".$response_code.": ".$target_url."\n");
  }
  close($fileb); # close the file-handle
}

1;
