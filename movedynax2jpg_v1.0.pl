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
my $nb_moved = 0;

# SUBS

sub move2jpeg {
	my $new_filename;
	if ( (-f $File::Find::name ) && ( mimetype($File::Find::name) eq 'image/jpeg') ) {
		$nb_jpg++;
    	my ($filename,$dir,$ext) = fileparse($File::Find::name, qr/\.[^.]*/);
		my @dirs = split('/',$dir);	
#		my @dirs = split('/',$File::Find::name);
		$new_filename = splice(@dirs,$#dirs,1)."-".$filename.$ext;
#		print $new_filename,"\n";
		$new_filename = splice(@dirs,$#dirs,1)."-".$new_filename;
#		print $new_filename,"\n";
		$new_filename = splice(@dirs,$#dirs,1)."-".$new_filename;
#		print $new_filename,"\n";
		splice(@dirs,$#dirs,1,'JPG');
		my $new_dir = join('/',@dirs);
#		print $new_dir,"\n";
		if ( !( -e $new_dir) ) {
			mkpath $new_dir;
		}	
		$new_filename = File::Spec->catfile( $new_dir, $new_filename); 
		print $new_filename,"\n"; 
		if ( !(-e $new_filename) ){ 
			copy($File::Find::name,$new_filename);
			$nb_moved++;
		}	 
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

	find(\&move2jpeg, @inputs);

}

print "Processed : ",$nb_moved," / ",$nb_jpg , " copied / jpg","\n";
 
