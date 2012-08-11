var bdays = new Array();
var names = new Array();
var pics = new Array();
var page = 0;
var pageSize = 30;

$(document).ready(function() {
    $("#loading").hide();
    get_friends();
    $('#friends #next').click(function(){
	$("#loading").show();  
	page += 1;
	get_friends();
    });    
    $('#friends #prev').click(function(){
	$("#loading").show();  
	if (page > 0) {
	  page -= 1;
	  get_friends();
	}
    }); 
    
});

function convertSpiller(spiller) {
  if (spiller == 'Aquarius') return 'Less Spotlight';
  if (spiller == 'Aries') return 'Me First';
  if (spiller == 'Cancer') return 'Ex-Manager';
  if (spiller == 'Capricorn') return 'Responsible One';
  if (spiller == 'Gemini') return 'Can Be Wrong';
  if (spiller == 'Leo') return 'Center Stage';
  if (spiller == 'Libra') return 'Diplomat';
  if (spiller == 'Pisces') return 'No Need For Perfection';
  if (spiller == 'Sagittarius') return 'Just Do It';
  if (spiller == 'Scorpio') return 'Comfort Zone';
  if (spiller == 'Taurus') return 'Independent';
  if (spiller == 'Virgo') return 'Not A Victim';
  return spiller;
}

function get_friends() {
  FB_RequireFeatures(["XFBML"], function()
  {
    FB.Facebook.init("08967340e09c1e0f30a7ccbb4e6cf4ce", "xd_receiver.htm");
    FB.Facebook.get_sessionState().waitUntilReady(function()
    {
      $("#loading").show();
      re = /\d\d\d\d/; // date must have 4 digit year 
      var uid = FB.Facebook.apiClient.get_session().uid ;
      var sql = "SELECT name, birthday, pic_square FROM user WHERE uid IN " +
      "(SELECT uid2 FROM friend WHERE uid1 = "+uid+")";
      bdays = new Array();
      names = new Array();
      pics = new Array();
      FB.Facebook.apiClient.fql_query(sql, function(result, ex) {
	  from = page*pageSize;
	  to = (page+1)*pageSize;
	  for (var i=from;i<to;i++){
	    if (re.exec(result[i]['birthday']) != null) {
	      names.push(result[i]['name']);
	      bdays.push(result[i]['birthday'].replace(",",""));
	      pics.push(result[i]['pic_square']);
	    }
	  }    
  	  call_server_display(bdays);
	  $("#loading").hide();	      
       });       
     });
   });  
}

function call_server_display(bdays){
  $.getJSON('/get_reading_ajax_multi', {'bdays': [bdays]},
   function(res){
     $('#friendsList #row:gt(0)').remove();
     for (var i=0;i<res.length;i++){
         var newEntryRow = $('#friendsList #row:eq(0)').clone();
         newEntryRow.find('.image img').attr("src", pics[i]);
         newEntryRow.find('.name a').text(names[i]);   
	 newEntryRow.find('.name a').attr('href', '/reading?d='+res[i]['bday']);
	 newEntryRow.find('.name a').attr("target", "_new");
         newEntryRow.find('.chinese a').text(res[i]["chinese"]);
	 newEntryRow.find('.chinese a').attr('href', '/detail?item='+res[i]['chinese']+"&type=chinese");
	 newEntryRow.find('.chinese a').attr("target", "_new");
         newEntryRow.find('.spiller a').text(convertSpiller(res[i]["spiller"]));
	 newEntryRow.find('.spiller a').attr('href', '/detail?item='+res[i]['spiller']+"&type=spiller");
	 newEntryRow.find('.spiller a').attr("target", "_new");
         newEntryRow.find('#millman1').text(res[i]["millman"][0]);   
	 newEntryRow.find('#millman1').attr('href', '/detail?item='+res[i]['millman'][0]+"&type=millman");
	 newEntryRow.find('#millman1').attr("target", "_new");
         newEntryRow.find('#millman2').text(res[i]["millman"][1]);   
	 newEntryRow.find('#millman2').attr('href', '/detail?item='+res[i]['millman'][1]+"&type=millman");
	 newEntryRow.find('#millman2').attr("target", "_new");
         newEntryRow.find('#millman3').text(res[i]["millman"][2]);   
	 newEntryRow.find('#millman3').attr('href', '/detail?item='+res[i]['millman'][2]+"&type=millman");
	 newEntryRow.find('#millman3').attr("target", "_new");
	 newEntryRow.find('#millman4').text(res[i]["millman"][3]);   
	 newEntryRow.find('#millman4').attr('href', '/detail?item='+res[i]['millman'][3]+"&type=millman");
	 newEntryRow.find('#millman4').attr("target", "_new");
         newEntryRow.find('.lewi a').text(res[i]["lewis"][0]);   
	 newEntryRow.find('.lewi a').attr('href', '/detail?item='+res[i]['lewis'][0]+"&type=lewi");
	 newEntryRow.find('.lewi a').attr("target", "_new");
         newEntryRow.find('.cycle a').text(res[i]["cycle"]);   
	 newEntryRow.find('.cycle a').attr('href', "/mweb/millman/nineyearcycle.html");
	 newEntryRow.find('.cycle a').attr("target", "_new");
         newEntryRow.find('#mbti1').text(res[i]["mb"][0]);   
	 newEntryRow.find('#mbti1').attr('href', "/mweb/mbti/"+res[i]["mb"][0].toLowerCase()+".html");
	 newEntryRow.find('#mbti1').attr("target", "_new");
         newEntryRow.find('#mbti2').text(res[i]["mb"][1]);   
	 newEntryRow.find('#mbti2').attr('href', "/mweb/mbti/"+res[i]["mb"][1].toLowerCase()+".html");
	 newEntryRow.find('#mbti2').attr("target", "_new");
         newEntryRow.appendTo('#friendsList');		     
     } 
     $('#friendsList #row:eq(0)').remove(); // remove 0th item, it is emtpy	 	 
   });
  
}
