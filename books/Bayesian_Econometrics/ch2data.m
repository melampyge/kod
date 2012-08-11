<SCRIPT LANGUAGE="JavaScript">

<!-- Begin
function copyit(theField) {
var tempval=eval("document."+theField)
tempval.focus()
tempval.select()
therange=tempval.createTextRange()
therange.execCommand("Copy")
}
//  End -->
</script>




<form name="it">
<div align="center">
<input onclick="copyit('it.select1')" type="button" value="Press to Copy the Text" name="cpy">
<p>
<textarea name="select1" rows="15" cols="55">
%simulate artificial data for empirical illustration in chapter 2
n=50;
beta=2;
sigma=1;
error= sigma*randn(n,1);
x=rand(n,1);
y=beta*x+error;
data = [y x];
save ch2data.out data -ASCII;
</textarea>
</div>
</form>

  