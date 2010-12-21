#!/usr/bin/perl

use strict;
use warnings;

use Data::Dumper 'Dumper';

opendir(CURR, $ENV{PWD}) or die "Failed to open: $!";
my $dirs = [ grep{ -d "$ENV{PWD}/$_" && $_ !~ m{^\.} } readdir(CURR) ];
closedir(CURR);

my $tail = join("", <DATA>);
foreach my $subdir (@$dirs) {
    opendir(NEW, "$ENV{PWD}/$subdir") or die "Failed to open $subdir: $!";
    my $image_files = [ grep{ $_ =~ m{.jpg$} } readdir(NEW) ];
    closedir(NEW);

    open(CONFIG, ">$ENV{PWD}/$subdir/config.plist") or die "Failed: $!";
    print CONFIG <<'EOD';
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>backgrounds</key>
		<dict>
EOD

    foreach my $image_file (@$image_files) {
        next if $image_file eq 'flag.jpg';
        print CONFIG qq#		<key><![CDATA[$image_file]]></key>\n#;
        print CONFIG qq#		<array>\n#;
        print CONFIG qq#			<string>1,124.0,160.0,65.0</string>\n#;
        print CONFIG qq#			<string>0,300.0,160.0,265.0</string>\n#;
        print CONFIG qq#		</array>\n#;
    }
    print CONFIG $tail;
    print "Wrote $ENV{PWD}/$subdir/config.plist\n";
}

__DATA__
	</dict>
	<key>services</key>
	<dict>
		<key>babelfish</key>
		<string>en</string>
		<key>google-translate</key>
		<string>en</string>
		<key>yahoo-translate</key>
		<string>en</string>
	</dict>
</dict>
</plist>
