starttime = new Date();
  s = "";
    function d() { s += "asd" }
    for (i=1; i < 10000; i++) d();
elapsedtime = new Date() - starttime;
alert(elapsedtime);

