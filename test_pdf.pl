#!/usr/bin/env perl

# test using pdf 

use PDF::WebKit;


PDF::WebKit->configure(sub {
	# default `which wkhtmltopdf`
	$_->wkhtmltopdf('/usr/local/bin/wkhtmltopdf');

	# default 'pdf-webkit-'
	
	# GLOBAL OPTIONS
#	$_->meta_tag_prefix('my-prefix-');
#	$_->default_options->{' --lowquality'} = '0';  
	$_->default_options->{'--orientation'} = 'Portrait';
#	$_->default_options->{'--margin-bottom'} = '1mm'; 
#	$_->default_options->{'--margin-left'} = '1mm'; 
#	$_->default_options->{'--margin-right'} = '1mm'; 
#	$_->default_options->{'--margin-top'} = '1mm'; 
	
	# OUTLINE OPTIONS
	$_->default_options->{'--page-size'} = 'A4';
	
	# PAGE OPTIONS 
=begin comment
	     --allow <path>                  Allow the file or files from the specified
                                      folder to be loaded (repeatable)
      --background                    Do print background (default)
      --no-background                 Do not print background
      --cache-dir <path>              Web cache directory
      --checkbox-checked-svg <path>   Use this SVG file when rendering checked
                                      checkboxes
      --checkbox-svg <path>           Use this SVG file when rendering unchecked
                                      checkboxes
      --cookie <name> <value>         Set an additional cookie (repeatable),
                                      value should be url encoded.
      --custom-header <name> <value>  Set an additional HTTP header (repeatable)
      --custom-header-propagation     Add HTTP headers specified by
                                      --custom-header for each resource request.
      --no-custom-header-propagation  Do not add HTTP headers specified by
                                      --custom-header for each resource request.
      --debug-javascript              Show javascript debugging output
      --no-debug-javascript           Do not show javascript debugging output
                                      (default)
      --default-header                Add a default header, with the name of the
                                      page to the left, and the page number to
                                      the right, this is short for:
                                      --header-left='[webpage]'
                                      --header-right='[page]/[toPage]' --top 2cm
                                      --header-line
      --encoding <encoding>           Set the default text encoding, for input
      --disable-external-links        Do not make links to remote web pages
      --enable-external-links         Make links to remote web pages (default)
      --disable-forms                 Do not turn HTML form fields into pdf form
                                      fields (default)
      --enable-forms                  Turn HTML form fields into pdf form fields
      --images                        Do load or print images (default)
      --no-images                     Do not load or print images
      --disable-internal-links        Do not make local links
      --enable-internal-links         Make local links (default)
  -n, --disable-javascript            Do not allow web pages to run javascript
      --enable-javascript             Do allow web pages to run javascript
                                      (default)
      --javascript-delay <msec>       Wait some milliseconds for javascript
                                      finish (default 200)
      --load-error-handling <handler> Specify how to handle pages that fail to
                                      load: abort, ignore or skip (default
                                      abort)
      --load-media-error-handling <handler> Specify how to handle media files
                                      that fail to load: abort, ignore or skip
                                      (default ignore)
      --disable-local-file-access     Do not allowed conversion of a local file
                                      to read in other local files, unless
                                      explicitly allowed with --allow
      --enable-local-file-access      Allowed conversion of a local file to read
                                      in other local files. (default)
      --minimum-font-size <int>       Minimum font size
      --exclude-from-outline          Do not include the page in the table of
                                      contents and outlines
      --include-in-outline            Include the page in the table of contents
                                      and outlines (default)
      --page-offset <offset>          Set the starting page number (default 0)
      --password <password>           HTTP Authentication password
      --disable-plugins               Disable installed plugins (default)
      --enable-plugins                Enable installed plugins (plugins will
                                      likely not work)
      --post <name> <value>           Add an additional post field (repeatable)
      --post-file <name> <path>       Post an additional file (repeatable)
      --print-media-type              Use print media-type instead of screen
      --no-print-media-type           Do not use print media-type instead of
                                      screen (default)
  -p, --proxy <proxy>                 Use a proxy
      --radiobutton-checked-svg <path> Use this SVG file when rendering checked
                                      radiobuttons
      --radiobutton-svg <path>        Use this SVG file when rendering unchecked
                                      radiobuttons
      --run-script <js>               Run this additional javascript after the
                                      page is done loading (repeatable)
      --disable-smart-shrinking       Disable the intelligent shrinking strategy
                                      used by WebKit that makes the pixel/dpi
                                      ratio none constant
      --enable-smart-shrinking        Enable the intelligent shrinking strategy
                                      used by WebKit that makes the pixel/dpi
                                      ratio none constant (default)
      --stop-slow-scripts             Stop slow running javascripts (default)
      --no-stop-slow-scripts          Do not Stop slow running javascripts
      --disable-toc-back-links        Do not link from section header to toc
                                      (default)
      --enable-toc-back-links         Link from section header to toc
      --user-style-sheet <url>        Specify a user style sheet, to load with
                                      every page
      --username <username>           HTTP Authentication username
      --viewport-size <>              Set viewport size if you have custom
                                      scrollbars or css attribute overflow to
                                      emulate window size
      --window-status <windowStatus>  Wait until window.status is equal to this
                                      string before rendering page
      --zoom <float>                  Use this zoom factor (default 1)
	 

=end comment
=cut 
});
 
 
# PDF::WebKit->new takes the HTML and any options for wkhtmltopdf
# run `wkhtmltopdf --extended-help` for a full list of options
#my $kit = PDF::WebKit->new(\$html, page_size => 'A4');
#push @{ $kit->stylesheets }, "/Users/bertrand/MY_GITHUB/diapos-lite/diapos.css";
 


# PDF::WebKit can optionally accept a URL or a File
# Stylesheets cannot be added when source is provided as a URL or File.
my $kit = PDF::WebKit->new('http://localhost:3000/showbox/11');
#my $kit = PDF::WebKit->new('/path/to/html');

($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
$year += 1900;
$mon++;

my $DATE_STRING = $year."-".$mon."-".$mday."-".$hour."-".$min."-".$sec;
my $filename = "/Users/bertrand/MY_GITHUB/diapos-lite/PRINTS/".$DATE_STRING.".pdf";

print $filename,"\n";

#my $filename = "/Users/bertrand/MY_GITHUB/diapos-lite/PRINTS/test.pdf";
 
# save the PDF to a file
#my $file = $kit->to_file('/Users/bertrand/MY_GITHUB/diapos-lite/PRINTS/test.pdf');
my $file = $kit->to_file($filename);
# Get an inline PDF
#my $pdf = $kit->to_pdf;
   
 
# Add any kind of option through meta tags
#my $kit = PDF::WebKit->new(\'<html><head><meta name="pdfkit-page_size" content="Letter"...');