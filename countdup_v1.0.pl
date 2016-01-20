#!/usr/local/bin/perl -w
#!/usr/bin/perl -w

# FONCTIONNE !!


use File::MimeInfo::Magic qw(mimetype extensions);
use Image::Magick;
use File::Compare;
use File::Basename;
use File::Path;
use File::Spec;
use File::Copy;
use File::Find;

my $nb_tiff = 0;
my $nb_jpg = 0;
my $nb_dup = 0;

# SUBS


sub count_dup {
	 if ( (-f $File::Find::name ) && ( mimetype($File::Find::name) eq 'image/tiff') ) {
	 	$nb_tiff++;
    	my ($jpg_filename,$dir,$ext) = fileparse($File::Find::name, qr/\.[^.]*/);
			$jpg_filename  = $jpg_filename . ".jpg";

			$jpg_filename = File::Spec->catfile( $dir, $jpg_filename );  
		if ( -e $jpg_filename ) {
			$nb_dup++;
    	}
	}
}

sub count_jpg {
	if ( -f $File::Find::name ) {
		if ( mimetype($File::Find::name) eq 'image/jpeg' ) {
			$nb_jpg++;
		}	
    	else  {
#      		print $File::Find::name,"is not an image\n";  	 
		}
    }
    else  {
#      	print $File::Find::name,"is not a file\n";  	 
	}
}

# MAIN

my @inputs;

for my $arg (0 .. $#ARGV) {
	print $ARGV[$arg],"\t";
	if (-e $ARGV[$arg]) { push @inputs, $ARGV[$arg]; }
}	

if ( $#inputs != -1) {
	

#my $ABS_INPUT_DIR = "/Volumes/photo/IMAGES/MINOLTA/TEST/";

	find(\&count_dup, @inputs);

}

print "Found  : ",$nb_dup,"/",$nb_tiff , " dup / tiff","\n";
 
