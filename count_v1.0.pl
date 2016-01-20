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
my $nb_optim = 0;

# SUBS


sub count_tiff {
	if ( -f $File::Find::name ) {
		if ( mimetype($File::Find::name) eq 'image/tiff' ) {
			$nb_tiff++;
		}	
    	else  {
#      		print $File::Find::name,"is not an image\n";  	 
		}
    }
    else  {
#      	print $File::Find::name,"is not a file\n";  	 
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

sub count_optim {
	if ( -f $File::Find::name ) {
		if ( ( mimetype($File::Find::name) eq 'image/jpeg' )&&( $File::Find::name =~ /optim.jpg$/) )  {
			$nb_optim++;
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
	find(\&count_tiff, @inputs);
	find(\&count_jpg, @inputs);
#	find(\&count_optim, @inputs);
}

print "Found  : ",$nb_tiff," / ",$nb_jpg," / ",$nb_optim ," images tiff / jpg / optim","\n";
 
