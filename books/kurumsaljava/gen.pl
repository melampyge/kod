chdir("pub");
@ll = <slidepage*.jpg>;
$count = @ll;
print $count;
for ($i=1; $i <= $count ; $i++) {
    $newfile = "slidepage" . $i . ".xml";
    $image = "slidepage" . $i . ".jpg";
    $p = $i-1;
    $n = $i+1;
    $prev = "slidepage" . $p . ".html";
    $next = "slidepage" . $n . ".html";
    `cp ../template.xml $newfile`;
    system("perl -pi -e 's/__img__/$image/g' $newfile");
    if ($i == 1) {
	system("perl -pi -e 's/__prev__/#/g' $newfile");
    } else {
	system("perl -pi -e 's/__prev__/$prev/g' $newfile");
    }
    if ($i == $count) {
	system("perl -pi -e 's/__next__/#/g' $newfile");
    } else {	
	system("perl -pi -e 's/__next__/$next/g' $newfile");
    }
    $_ = `C:/devprogs/PDFBox-0.7.2/bin/ExtractText.exe -encoding UTF-8 -startPage $i -endPage $i -console ../kurumsaljava7.pdf`;
    s/S�/Ş/sg;
    s/�s/ş/sg;
    s/�c/ç/sg;
    s/\?g/ğ/sg;
    s/\�o/ö/sg;
    s/�u/ü/sg;
    s/\?/ı/sg;
    s/C¸/Ç/sg;
    s/\"/\s/sg;
    s/</\s/sg;
    s/\//\s/sg;
    s/�U/Ü/sg;
    s/�O/Ö/sg;
    s/�U/Ü/sg;
    s/C�/Ç/sg;
    s/ıI/İ/sg;

    @array = split('\n');
    $len = @array;
       
    for ($j=0;$j<$len;$j++) {
	$new = $new . "\n" . $array[ rand @array ];
    }

    system("perl -pi -e 's/__keywords__/$new/g' $newfile");

    $new = "";
    
    system("dos2unix $newfile");

    
}
