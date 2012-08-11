function styleSwitcher(){
    
  var browser=navigator.appName;
  var b_version=navigator.appVersion;
  var version=parseFloat(b_version);
  
  var width = 1024;
  var width = screen.availWidth;
  //alert(width);
  
  if (width < 1200){
    var theDiv = document.getElementById('document');
    if (theDiv != null) theDiv.style.marginLeft = "0%";
    var theDiv = document.getElementById('topmenu1');
    if (theDiv != null) theDiv.style.left = "1%";
    var theDiv = document.getElementById('title');
    if (theDiv != null) theDiv.style.paddingLeft = "0%";
    var theDiv = document.getElementById('title');
    if (theDiv != null) theDiv.style.marginLeft = "0%";
    var theDiv = document.getElementById('ad');
    if (theDiv != null) theDiv.style.left = "240px";
    var theDiv = document.getElementById('midupperad');
    if (theDiv != null) theDiv.style.left = "420px";
    var theDiv = document.getElementById('middlemenu');
    if (theDiv != null) theDiv.style.left = "420px";
    var theDiv = document.getElementById('adrightside');
    if (theDiv != null) theDiv.style.left = "540px";
    var theDiv = document.getElementById('rightmiddle');
    if (theDiv != null) theDiv.style.left = "540px";
    var theDiv = document.getElementById('recentcomments');
    if (theDiv != null) theDiv.style.left = "540px";
    var theDiv = document.getElementById('ingcheck');
    if (theDiv != null) theDiv.style.left = "540px";
    var theDiv = document.getElementById('commentsmatchingyou');
    if (theDiv != null) theDiv.style.left = "540px";    
    var theDiv = document.getElementById('btyperesad');
    if (theDiv != null) theDiv.style.left = "400px";
    var theDiv = document.getElementById('login-link');
    if (theDiv != null) theDiv.style.right = "5%";
    var theDiv = document.getElementById('facebookimport');
    if (theDiv != null) theDiv.style.left = "640px";

    // IE related hacks
     if (browser == "Microsoft Internet Explorer") {
       var theDiv = document.getElementById('midupperad');
       if (theDiv != null) theDiv.style.left = "440px";       
       var theDiv = document.getElementById('middlemenu');
       if (theDiv != null) theDiv.style.left = "430px";       
       var theDiv = document.getElementById('facebookimport');
       if (theDiv != null) {
         theDiv.style.left = "650px";
         // only for friends page, do the stuff below
         var theDiv = document.getElementById('adrightside');
         if (theDiv != null) theDiv.style.left = "580px";
       }
       var theDiv = document.getElementById('login-link');
       if (theDiv != null) theDiv.style.right = "3%";
       var theDiv = document.getElementById('ingcheck');
       if (theDiv != null) theDiv.style.left = "560px";      
       if (theDiv != null) theDiv.style.paddingLeft = "100px";
     }
    
  }  
}
