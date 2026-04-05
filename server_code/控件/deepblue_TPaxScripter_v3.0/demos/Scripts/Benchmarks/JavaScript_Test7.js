starttime = new Date();
 function doj(i) {
        for (j=1; j<=10; j++) {
            k = i > j ? i > 100 : j < 5;
        }
    }
    for (i=1; i<=100000; i++) {
        doj(i);
    }
elapsedtime = new Date() - starttime;
alert(elapsedtime);

