var jQT = new $.jQTouch({
    icon: '',
    startupScreen: '',
    statusBar: 'black'
});

var page = 0;

$(function(){ 
    $('#readingbutton').click(function(){
	get_reading();
      });
    $('#check_ing_button').click(function(){
	check_ingredient();
      });
    $('#forum #submit').click(function(){
	post_comment();
      });
    $('#forumlink').click(function(){
	read_comments();
      });
    $('#forumprev').click(function(){
	prev_page();
      });
    $('#forumnext').click(function(){
	next_page();
      });
    $('#resultsclose').click(function(){
	$('#results').hide();	
	$('#reading form').show();	
      });
    $('#mbtibutton').click(function(){
	evaluate_mbti();
      });    
    $('#quickmbti').change(function() {
	str = $('#quickmbti :selected').text();
	HACK = "#spiller";
	if (str == "TR") {
	  url = "/mweb/mbt_tr.html"; 
	} else {
	  url = "/mweb/mbti/" + str + ".html" + HACK;		  
	}
	window.open(url);
      });    
    $('#results').hide();
    $('#mbtiresult').hide(); 
    
    //test_settings();
});

function get_reading() {
  day = $('#day').val();
  month = $('#month').val();
  year = $('#year').val();
  if (year.length != 4) {
    $('#error').html("Year must have 4 digits");
    return;
  }
  if (day.length == 1) day = "0" + day;
  bday = year + month + day;        
  btype = document.getElementById('btype').value;
  $.getJSON('/get_reading_ajax', { 'bday': bday, 'btype': btype},
     function(response){
       $('#error').html(""); 
       $('#reading form').hide();
       $('#results').show();
       generate_results(response, btype);
     }
  );
}

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

function convertIfSpiller(spiller) {
  res = convertSpiller(spiller);
  if (res != '') return res;
  return spiller;
}

function generate_results(res, btype) {
   $('#results #chinese img').attr('src', 'img/'+res['chinese']+'.jpg');
   $('#results #chinese a').attr('href', 'chinese/'+res['chinese']+'.html');
   $('#results #chinese a').attr("target", "_new");
   $('#results #chinese a').text(res['chinese']);   
   $('#results #spiller img').attr('src', 'img/'+res['spiller']+'.jpg');
   $('#results #spiller a').attr('href', 'spiller/'+res['spiller']+'.html');
   $('#results #spiller a').attr("target", "_new");
   $('#results #spiller a').text(convertSpiller(res['spiller']));      
   $('#results #btype a').attr('href', 'btype/'+btype+'.html'); 
   $('#results #btype a').text(btype);
   $('#results #btype a').attr("target", "_new");      
   $('#lewiList div:gt(0)').remove();
   for (var i=0;i<res['lewis'].length;i++){
     var newEntryRow = $('#lewiList div:eq(0)').clone();
     newEntryRow.removeAttr('id');
     newEntryRow.removeAttr('style');
     newEntryRow.find('a').text(res['lewis'][i]);                        
     newEntryRow.find('a').attr('href', 'lewi/'+res['lewis'][i]+'.html');
     newEntryRow.find('a').attr("target", "_new");
     newEntryRow.appendTo('#lewiList');
   }
  $('#lewiList div:eq(0)').remove(); // remove 0th item, it is emtpy      
  $('#millmanList div:gt(0)').remove();
  for (var i=0;i<res['millman'].length;i++){
     var newEntryRow = $('#millmanList div:eq(0)').clone();
     newEntryRow.removeAttr('id');
     newEntryRow.removeAttr('style');
     if (i == 0) {
       // place a '/' character after two digits in the First
       // element so 303 becomes 30/3
       s = res['millman'][i][0] + res['millman'][i][1];
       s += "/";
       s += res['millman'][i].slice(2);
     } else {
       s = res['millman'][i];
     }
     newEntryRow.find('a').text(s);
     newEntryRow.find('a').attr('href', 'millman/'+res['millman'][i]+'.html');
     newEntryRow.find('a').attr("target", "_new");
     newEntryRow.appendTo('#millmanList');
   }
  $('#millmanList div:eq(0)').remove(); // remove 0th item, it is emtpy      
  mb1_lower = res['mb'].toLowerCase();
  mb1 = res['mb'];
  $('#mb_stat #mbStatList #stat1 a').attr('href', 'mbti/' + mb1_lower + '.html'); 
  $('#mb_stat #mbStatList #stat1 a').text(mb1);
  $('#mb_stat #mbStatList #stat1 a').attr("target", "_new");     
  $('#results #cycle a').text(res['cycle']);  
}

function check_ingredient() {
  food = $('#food_input #food').val();
  btype = $('#food_input #btype').val();
  $.getJSON('/check_food_btype', { 'btype': btype, 'food': food},
    function(res){
      out = "";
      for (var i=0;i<res.length;i++){	
	out += res[i][0] + ", " + res[i][1] + "<br/>";	
      }
      out += "<br/><small>For more details see Dr. Adamo's <a href='http://www.dadamo.com/typebase4/typeindexer.htm'>site</a></small>"
      $('#foodresults').html(out);
  });              
}      

function read_comments() {
   user_id = document.cookie;
   user_id = user_id.replace("cid=","");   
   $.get('/read_comments', 
      { 'page': page, 'user_id': user_id},
      function (response) {
        $('#messages').html(response);
      }
    );   
}

function post_comment() { 
    user_id = '';
    text = $('#text').val();
    if (text != '') {
      $.post('/post_comment', 
        { 'user_id': user_id, 'text': text},
        function(response){
          read_comments();            
        }
      ); 
    }
}       

function prev_page() {
  page++;
  read_comments();
}    

function next_page() {
  if (page > 0) page--;
  read_comments();
}             


function evaluate_mbti() {
  for (var i=0;i<70;i++){
    var j = i+1;
    res = $("input[name='group"+j+"']:checked").val();
    if (res == undefined) {
	$('#mbtierror').html("Question " + j + " is not answered");
	return;
      }
  }    
  var list = "";
  for (var i=0;i<70;i++){
    var j = i+1;
    res = $("input[name=group"+j+"]:checked").val();
    list += ":" + res;
  }  
  HACK="#spiller";    
  $.getJSON('/evaluate_mbti', { 'answers': list},
     function(response){
       $('#mbtierror').html("");
       $('#mbtiresult').attr('href', '/mweb/mbti/' + response.toLowerCase() + ".html" + HACK);
       $('#mbtiresult a').attr("target", "_new");
       $('#mbtiresult a').text(response); 
       $("#mbtiresult").show()       
     }
  );
}       

function test_settings() {
    // check arbitrary radio buttons automatically for testing
    input = [1, -1, -1, 1, 0, 0, 0, 1, 0, -1, 
	     0, 0, -1, -1, 1, -1, 0, 0, 1, 1, 
	     -1, 1, 1, 1, 0, 0, 0, -1, 1, 0, 
	     1, 1, 0, 0, 0, 0, 0, 1, -1, -1, 
	     1, 1, 1, 1, 1, 1, -1, 1, 1, 1, 
	     0, -1, -1, -1, -1, 1, 0, 0, 0, 0, 
	     -1, 0, 0, -1, 0, -1, -1, -1, 0, 0];
    
    for (var i=0;i<70;i++){
      var j = i+1;
      if (input[i] == -1)
	$('input[name=group'+j+']:eq(0)').attr('checked', 'checked');    
      if (input[i] == 0)
	$('input[name=group'+j+']:eq(1)').attr('checked', 'checked');    
      if (input[i] == 1)
	$('input[name=group'+j+']:eq(2)').attr('checked', 'checked');    
    }
  
}

