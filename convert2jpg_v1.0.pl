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
my $nb_images = 0;

# SUBS

sub process_images {

	my $new_filename;
	my $file_name;
	my $dir;
	my $ext;
	
    if ( -f $File::Find::name ) {
		if ( mimetype($File::Find::name) eq 'image/tiff' ) {
			my ($file_name,$dir,$ext) = fileparse($File::Find::name, qr/\.[^.]*/);
			my $output_filename  = $file_name . ".jpg";

			$output_filename = File::Spec->catfile( $dir, $output_filename );  
			if ( !(-f $output_filename) ) { 		
				my $image = Image::Magick->new;
			
				open(INPUT_IMAGE, $File::Find::name);
  				$image->Read(file=>\*INPUT_IMAGE);
		
				my $tiff = $image->Read($File::Find::name);
				open(OUTPUT_IMAGE, ">$output_filename");
				
				my $jpg = $image->Write(file=>\*OUTPUT_IMAGE, filename=>$output_filename, magick=>'jpg');
				$nb_images++;
				print $nb_images,"/",$nb_tiff,"\n";
				close(OUTPUT_IMAGE);
				close(INPUT_IMAGE);
			
				@$tiff = ();
				@$jpg = ();
				undef $image;
    		}
    	}
    	else  {
#      		print $File::Find::name,"is not an image\n";  	 
		}
    }
    else  {
#      	print $File::Find::name,"is not a file\n";  	 
	}
}

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

# MAIN

my @inputs;

for my $arg (0 .. $#ARGV) {
#	print $ARGV[$arg],"\t";
	if (-e $ARGV[$arg]) { push @inputs, $ARGV[$arg]; }
}	

if ( $#inputs != -1) {
	

#my $ABS_INPUT_DIR = "/Volumes/photo/IMAGES/MINOLTA/TEST/";
	find(\&count_tiff, @inputs);
	find(\&process_images, @inputs);

}
if ($nb_images != 0 ) {
	print "Succès : ",$nb_images, " images traitées","\n";
} else {
	print "Aucune image trouvée","\n";
} 
