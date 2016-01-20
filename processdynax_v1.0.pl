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

my $nb_jpg = 0;
my $nb_images = 0;

# SUBS

sub process_images {

	my $new_filename;
	my $file_name;
	my $dir;
	my $ext;
	
    if ( (-f $File::Find::name) &&(mimetype($File::Find::name) eq 'image/jpeg') ){
			my ($file_name,$dir,$ext) = fileparse($File::Find::name, qr/\.[^.]*/);
			my $output_filename  = $file_name . ".jpg";
			print $dir,"\t",$output_filename,"\n";
	}
}

sub count_file {
	if (( -f $File::Find::name ) && ( mimetype($File::Find::name) eq 'image/jpeg' ) ) {
			$nb_jpg++;
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
	find(\&count_file, @inputs);
	find(\&process_images, @inputs);

}
if ($nb_images != 0 ) {
	print "Succès : ",$nb_jpg, " images traitées","\n";
} else {
	print "Aucune image trouvée","\n";
} 
