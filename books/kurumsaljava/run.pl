$sessiz = "qwrtyplkjhgfdszxcvbnm���QWRTYPLKJHGFDSZXCVBNM���";
$sesli = "��ouea�i�IOUE�A���";
$tr = "�������������";

undef $/;

@words = (
	  "ba�layabilirsiniz",
	  "�ngilizce",
	  "ba�lad���m�z",
	  "al�nd�ktan",
	  "yap�lmaktad�r",
	  "�zelli�idir",
	  "olmu�tur",
	  "�al��maktad�r",
	  "sonu�lar�",
	  "eri�mesi",
	  "�a��r�labilen",
	  "haz�rlatm��t�k",
	  "yarat�lm��t�r",
	  "alan�na",
	  "tan�mlad���",
	  "ba�latt�rmam�z",
	  "�al��t�rma",
	  "al�nmam��sa",
	  "i�leyece�iz",
	  "se�imini",
	  "Kullanaca��m�z",
	  "sa�layabiliriz",
	  "k�t�phanesi",
	  "bitti�inde",
	  "�a�r�laca��ndan",
	  "�a�r�s�n�",
	  "farkl�l�klar�ndan",
	  "ge�irecektir",
	  "yap�lmamas�",
	  "se�ene�i",
	  "�ak��malar�",
	  "sat�rlarda",
	  "vazge�ilmez",
	  "in�aat",
	  "ka��n�p",
	  "kullanaca��m�z",
	  "s�ylemi�tik",
	  "u�ra�madan",
	  "eri�ti�inde",
	  "bak�larak",
	  "b�l�m�n�",
	  "ba�lan�lmamas�d�r",
	  "�artlar�nda",
	  "m�te�ekkirim",
	  "Derne�i",
	  "g�rd�k",
	  "b�l�mlerde",
	  "�nsanlar�n",
	  "haz�rlanm��",
	  "anla��lan",
	  "birle�tirim",
	  "POJO",
	  "art�k",
	  "yap�lmaz",
	  "tan�mlamaya",
	  "al��kanl���",
	  "��nk�",
	  "ba�lamadan",
	  "lerinizin",
	  "sekt�r�m�z",
	  "t�klan�nca",
	  "��z�ld�",
	  "yapt�r�lacaksa",
	  "tan�ml�yoruz",
	  "ba�lat�ld���",
	  "�rne�imizde",
	  "yap�lar�n�z�",
	  "i�lemlerinin",
	  "de�i�iklikler",
	  "s�kacak",
	  "ba�lant�s�",
	  "men�den",
	  "kar��la�t�rma",
	  "yaz�l�mlar",
	  "�abuklu�u",
	  "Sa�lay�c�s�",
	  "kat�l�mc�lardan",
	  "etti�imiz",
	  "yayg�nla�maya",
	  "programc�l���n",
	  "�a��ran",
	  "��renmekte",
	  "te�ekk�rler",
	  "��rendi�ini",
	  "ge�eceklerdir",
	  "tak�m�n�n",
	  "payla��lmal�",
	  "ba�layabilecekleri",
	  "��karmal�d�r",
	  "ba�layacakt�r",
	  "d���kl���",
	  "d���n�lm��",
	  "k�s�mdaki",
	  "ka��n�lmazd�r",
	  "�irketlerinden",
	  "programc�n�n",
	  "se�eneklerini",
	  "a��lamal�s�n�z",
	  "a�amas�ndayd�",
	  "y�k�lm��",
	  "b�t�elendirme",
	  "�al��an",
	  "�al��t���m�z",
	  "bak�m�ndan",
	  "yar��mas�nda",
	  "yap�lacakt�r",
	  "�a��r�labilecektir",
	  "g�rmedi�imizi",
	  "ger�ekle�tirmeye",
	  "ba�lam��t�r",
	  "d���n��",
	  "�al��mas�",
	  "yakla�t�rman�n",
	  "ger�ekle�tirdi�imiz",
	  "ama�lar�",
	  "ili�kisel",
	  "gelmi�lerdir",
	  "�emalar�n",
	  "se�eneklerinden",
	  "eri�iliyor",
	  "yaz�l�yormu�",
	  "de�i�tirmek",
	  "artt�rabilmeliyiz",
	  "yapt���m�z",
	  "i�lemini",
	  "yaz�lmas�n�",
	  "i�letebilmek",
	  "mant���n�",
	  "edece�imiz",
	  "�etrefillikte",
	  "i�indeki",
	  "ger�ekle�tirebiliriz",
	  "i�indeki",
	  "t�klamam�z",
	  "eri�ebilmesi",
	  "yaz�lm��t�r",
	  "ba�lanmaya",
	  "gere�inden",
	  "t�klayarak",
	  "kald�r�lmas�d�r",
	  "de�i�ebilecek",
	  "ba�lat�c�",
	  "t�klarsan�z",
	  "hakk�nda",
	  "��kabiliyor",
	  "g�venli�inin",
	  "t�klarsan�z",
	  "eri�ece�iniz",
	  "haz�rlanm��t�r",
	  "ba�lanacakt�r",
	  "se�ene�ini",
	  "geli�tiricisine",
	  "ba�lant�s�ndan",
	  "bak�lmaktad�r",
	  "de�i�kenine",
	  "da��t�m�n�",
	  "de�erine",
	  "D��ar�dan",
	  "b�rak�lmas�d�r",
	  "ba�lanacak",
	  "aras�nda",
	  "�al��abilece�i",
	  "t�kand���",
	  "ger�ekle�tirebilmek",
	  "i�lemesini",
	  "tan�mlayabiliyoruz",
	  "de�i�kene",
	  "tan�mlad���n�z",
	  "a�makt�r",
	  "d��mesine",
	  "e�itleyebildi�i",
	  "��rendi�imiz",
	  "de�i�meyen",
	  "taban�ndan",
	  "g�m�l�",
	  "ba�lant�lar",
	  "a��lmas�n�",
	  "Ba�land�ktan",
	  "de�i�kenlerinden",
	  "tekni�ini",
	  "b�l�mde",
	  "tan�mlanmas�",
	  "ba�lamal�y�z",
	  "edildi�ine",
	  "ka��n�rlar",
	  "yapt�rabiliriz",
	  "i�letilecektir",
	  "de�i�tirmemiz",
	  "ba�layal�m",
	  "de�i�tirmemiz",
	  "ba�layabiliriz",
	  "tan�mlad���m�z",
	  "yakla��m�n�",
	  "kald�rmak",
	  "d�nd�r�ld���nde",
	  "tan�mland�",
	  "at�lacakt�r",
	  "�evirmeye",
	  "a��lmam��sa",
	  "ili�kilendirilmi�",
	  "u�rat�lmaktad�r",
	  "�st�nde",
	  "g�rd���m�z",
	  "e�lenmektedir",
	  "i�letebilirsiniz",
	  "olu�turulmu�tur",
	  "alg�lanmamal�d�r",
	  "oldu�umuzu",
	  "tan�mlayal�m",
	  "i�leyici",
	  "b�l�m�nde",
	  "oldu�unu",
	  "g�z�k�yor",
	  "yap�labilmesidir",
	  "y�k�ml�d�r",
	  "ula�mas�n�",
	  "do�uruyor",
	  "�nbelle�i",
	  "�nsanlardan",
	  "gelmi�tir",
	  "ba�latabilen",
	  "de�erinin",
	  "de�i�ikli�i",
	  "s�n�rlamalard�r",
	  "tan�mlar�na",
	  "eri�ebilmenizi",
	  "i�letilmesini",
	  "yap�labilecek",
	  "konu�turaca��z",
	  "g�ncellemek",
	  "al��k�nd�rlar",
	  "k�sm�n�",
	  "i�lemlerdir",
	  "�imdilik",
	  "s�f�rdan",
	  "y�zden",
	  "oldu�udur",
	  "alt�nda",
	  "k�s�tlamay�",
	  "yakla��md�r",
	  "al��kanl�klar�",
	  "i�letirken",
	  "ki�inin",
	  "b�rakmaz",
	  "verdi�iniz",
	  "iyile�tirmeleri",
	  "iyile�tirmelerden",
	  "tan�mlanmal�d�r",
	  "ba�layarak",
	  "�artlarda",
	  "ger�ekle�tirilmi�tir",
	  "a��s�ndan",
	  "m�mk�nd�r",
	  "kullan�lm��t�r",
	  "se�mek",
	  "�nsanlardan",
	  "dan��abilirsiniz",
	  "g�z�kmektedir",
	  "�evirmesine",
	  "yakla��mda",
	  "yaz�lacak",
	  "sa�lanmas�d�r",
	  "g�rsel",
	  "ta��maktad�r");


foreach $f(<chap*.tex>) {
    open GIRDI, $f;    
    $_ = <GIRDI>;
    s/\\\$/\$/sg;
    
    foreach $word(@words) {
	$nn = tr_split($word);
	s/$word/$nn/sg;	
    }
    
    close GIRDI;
    open CIKTI, ">changed/$f";
    print CIKTI;
    close CIKTI;
}

#
#
sub tr_split {
    my $word = $_[0];
    my $new = "";
#    print "<< $word >>";
    $DASH = "\\-";
    $len = length($word);
    while ($len > 3) {
#	print "--";
	if (substr($word, 0, 7) =~ /[$sesli][$sessiz][$sessiz][$sesli][$sessiz][$sessiz]/) { # ilginc
#	    print "3.1\n";
	    $new = $new . substr($word, 0, 2) ;
	    $new = $new . $DASH;
	    $word = substr($word, 2, length($word));
	}
	if (substr($word, 0, 7) =~ /[$sessiz][$sesli][$sessiz][$sesli][$sessiz][$sesli][$sessiz]/) {
#	    print "3\n";
	    $new = $new . substr($word, 0, 2) ;
	    $new = $new . $DASH;
	    $word = substr($word, 2, length($word));
	}
	if (substr($word, 0, 6) =~ /[$sessiz][$sesli][$sessiz][$sessiz][$sesli][$sessiz]/) {
#	    print "5\n";
	    $new = $new . substr($word, 0, 3);
	    $new = $new . $DASH;
	    $word = substr($word, 3, length($word));
	}
	if (substr($word, 0, 5) =~ /[$sesli][$sessiz][$sessiz][$sessiz][$sesli]/) { # ustte
#	    print "-1\n";
	    $new = $new . substr($word, 0, 3) ;
	    $new = $new . $DASH;
	    $word = substr($word, 3, length($word));			
	}	
	if (substr($word, 0, 5) =~ /[$sesli][$sessiz][$sessiz][$sesli][$sessiz]/) { #islem
#	    print "2\n";
	    $new = $new . substr($word, 0, 2) ;
	    $new = $new . $DASH;
	    $word = substr($word, 2, length($word));
	}
	if (substr($word, 0, 5) =~ /[$sessiz][$sesli][$sessiz][$sesli][$sessiz]/) {
#	    print "4\n";
	    $new = $new . substr($word, 0, 2);
	    $new = $new . $DASH;
	    $word = substr($word, 2, length($word));
	}
	if (substr($word, 0, 5) =~  /[$sessiz][$sesli][$sessiz][$sessiz][$sesli]/) { #mikro
#	    print "7\n";
	    $new = $new . substr($word, 0, 3);
	    $new = $new . $DASH;
	    $word = substr($word, 3, length($word));
	}
	if (substr($word, 0, 4) =~ /[$sessiz][$sessiz][$sesli][$sessiz]/) { 
#	    print "0\n";
	    $new = $new . substr($word, 0, 4) ;
	    $new = $new . $DASH;
	    $word = substr($word, 4, length($word));			
	}	
	if (substr($word, 0, 4) =~ /[$sessiz][$sesli][$sessiz][$sesli]/) {
#	    print "6\n";
	    $new = $new . substr($word, 0, 2) ;
	    $new = $new . $DASH;
	    $word = substr($word, 2, length($word));
	}
	if (substr($word, 0, 4) =~ /[$sesli][$sessiz][$sessiz][$sesli]/) {
#	    print "6.2\n";
	    $new = $new . substr($word, 0, 2) ;
	    $new = $new . $DASH;
	    $word = substr($word, 2, length($word));
	}
	if (substr($word, 0, 4) =~ /[$sessiz][$sesli][$sessiz][$sessiz]/) {
#	    print "6.2\n";
	    $new = $new . substr($word, 0, 4) ;
	    $new = $new . $DASH;
	    $word = substr($word, 4, length($word));
	}
	if (substr($word, 0, 4) =~ /[$sessiz][$sesli][$sesli][$sessiz]/) {
#	    print "6.2\n";
	    $new = $new . substr($word, 0, 2) ;
	    $new = $new . $DASH;
	    $word = substr($word, 2, length($word));
	}
	if (substr($word, 0, 3) =~ /[$sesli][$sessiz][$sesli]/) {
#	    print "1\n";
	    $new = $new . substr($word, 0, 1) ;
	    $new = $new . $DASH;
	    $word = substr($word, 1, length($word));			
	}
	
	$len = length($word);

    }

    $new = $new . $word;
#    print "|| $new ||";
    return $new;
}
