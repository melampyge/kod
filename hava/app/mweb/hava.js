var jQT = new $.jQTouch({
    icon: '',
    startupScreen: '',
    statusBar: 'black'
});

cities = ['ADANA','ADIYAMAN','AFYONKARAHISAR','AGRI','AKSARAY','AMASYA','ANKARA','ANTALYA','ARDAHAN','ARTVIN','AYDIN','BALIKESIR','BARTIN','BATMAN','BAYBURT','BILECIK','BINGOL','BITLIS','BOLU','BURDUR','BURSA','CANAKKALE','CANKIRI','CORUM','DENIZLI','DIYARBAKIR','DUZCEEDIRNE','ELAZIG','ERZINCAN','ERZURUM','ESKISEHIR','GAZIANTEP','GIRESUN','GUMUSHANE','HAKKARI','HATAY','IGDIR','ISPARTA','ISTANBUL','IZMIR','K.MARAS','KARABUK','KARAMAN','KARS','KASTAMONU','KAYSERI','KIRIKKALE','KIRKLARELI','KIRSEHIR','KILIS','KOCAELI','KONYA','KUTAHYA','MALATYA','MANISA','MARDIN','MERSIN','MUGLA','MUS','NEVSEHIR','NIGDE','ORDU','OSMANIYE','RIZE','SAKARYA','SAMSUN','SIIRT','SINOP','SIVAS','SANLIURFA','SIRNAK','TEKIRDAG','TOKAT','TRABZON','TUNCELI','USAK','VAN','YALOVA','YOZGAT','ZONGULDAK'];

$(document).ready(function() {  
   if ($.cookie("sehir") == null) {
     $.cookie("sehir", "istanbul");
   } else {
     // rewrite cookie on itself so it goes on forever.
     $.cookie("sehir", $.cookie("sehir"), { expires: 100 });     
   }
   $("#home small").html($.cookie("sehir"));
   $("#more small").text($.cookie("sehir"));
   $("#city").val($.cookie("sehir"));
   $('#set_city').click(function(){
       for (var i=0;i<cities.length;i++){
	 if (cities[i].toLowerCase() == $("#city").val().toLowerCase()) {
	   $.cookie("sehir", $("#city").val().toLowerCase(), { expires: 100 });
	   $("#home small").text($.cookie("sehir"));
	   $("#more small").text($.cookie("sehir"));
	   $("#city_set_message").html("<font color='green'>New city is set</font>");
	   show_data();
	 }
       }
   });  
   $("#backButton").click(function(){
       $("#city_set_message").html(""); 
   });
   show_data();
});

function show_data() {
  $.getJSON('/get_data', { sehir: $.cookie("sehir") },
       function (res) {
	 $('#home #metal1 li:gt(0)').remove();
	 for (var i=0; i < res['mins'].length; i++) {
	   var newEntryRow = $('#home  #metal1 li:eq(0)').clone();
	   newEntryRow.removeAttr('id');
	   newEntryRow.removeAttr('style');
	   newEntryRow.data('entryId', i);
	   newEntryRow.find('.gun').text(res['gun'][i]);  	   
	   newEntryRow.find('.mins').text(res['mins'][i] );
	   newEntryRow.find('.maxs').text(res['maxs'][i] );
	   newEntryRow.find('.hadise img').attr("src", res['hadise'][i]);
	   newEntryRow.appendTo('#home #metal1');
	 }
	 $('#home #metal1 li:eq(0)').remove();
	 
	 $('#more #metal2 li:gt(0)').remove();
	 for (var i=0; i < res['minn'].length; i++) {
	   var newEntryRow = $('#more #metal2 li:eq(0)').clone();
	   newEntryRow.removeAttr('id');
	   newEntryRow.removeAttr('style');
	   newEntryRow.data('entryId', i);
	   newEntryRow.find('.gun').text(res['gun'][i]);  	   
	   newEntryRow.find('.minn').text(res['minn'][i]);  	   
	   newEntryRow.find('.maxn').text(res['maxn'][i]);  	   
	   newEntryRow.find('.hiz').text(res['hiz'][i]);
	   newEntryRow.find('.yon img').attr("src", res['yon'][i]);
	   newEntryRow.appendTo('#more #metal2');
	 }
	 $('#more #metal2 li:eq(0)').remove(); 	 	 
	 
       }
  );  
}
