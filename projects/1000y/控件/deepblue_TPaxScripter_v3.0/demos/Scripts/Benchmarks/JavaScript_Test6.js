starttime = new Date();
    S = 0.0;
    P = 1.0;
    function d() {
      for (j=1; j<=10; j++) {
        P = P / 4.0;
        S = S + P;
      }
    }
    for (i=1; i<=100000; i++) {
      d();
    }
elapsedtime = new Date() - starttime;
alert(elapsedtime);

