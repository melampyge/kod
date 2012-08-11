$(document).ready(function() {
    $('#eval').click(function(){
        evaluate();
    }); 
    //test_settings();
    $("#result").hide();
    
});

function test_settings() {
    // check arbitrary radio buttons automatically for testing
    input = [1, 1, 1, 0, 1, 0, 1, 1, 1, 0, 0, 1, 1, -1, 1, 0, -1, -1, 0, 1, 0, 1, 1, 1, 0, 0, 0, -1, 1, 0, 1, 0, -1, -1, -1, 1, -1, 1, -1, -1, 1, 1, 1, -1, 1, 1, -1, -1, 1, 1, 1, 1, -1, 1, 0, 1, 0, -1, -1, 1, -1, -1, 0, -1, 0, 0, 1, 0, 0, -1];

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

function evaluate() {
  for (var i=0;i<70;i++){
    var j = i+1;
    res = $("input[name='group"+j+"']:checked").val();
    if (res == undefined) {
	$('#error').html("Selection " + j + " is not selected");
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
       $('#error').html("");
       $('#result a').attr('href', '/mweb/mbti/' + response.toLowerCase() + ".html" + HACK);
       $('#result a').attr("target", "_new");
       $('#result a').text(response); 
       $("#result").show()       
     }
  );
}       




