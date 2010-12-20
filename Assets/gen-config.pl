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
	<key>background-images</key>
		<dict>
EOD

    foreach my $image_file (@$image_files) {
        next if $image_file eq 'flag.jpg';
        print CONFIG qq#		<key><![CDATA[$image_file]]></key>\n#;
        print CONFIG qq#		<string>0,124.0,160.0,65.0</string>\n#;
    }
    print CONFIG $tail;
    print "Wrote $ENV{PWD}/$subdir/config.plist\n";
}

__DATA__
	</dict>
	<key>input-language</key>
	<dict>
		<key>human-readable</key>
		<string>English (US)</string>
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
	<key>output-language</key>
	<dict>
		<key>human-readable</key>
		<string>Chinese (Simplified)</string>
		<key>services</key>
		<dict>
			<key>babelfish</key>
			<string>zh-CN</string>
			<key>google-translate</key>
			<string>zh-CN</string>
			<key>yahoo-translate</key>
			<string>zh-CN</string>
		</dict>
	</dict>
</dict>
</plist>
