d = new Date();
for (i=1; i<=100000; i++) {
  for (j=1; j<=10; j++) {
    k = i > j ? i > 100 : j < 5;
  }
}
d1 = new Date();
alert(d1.getTime() - d.getTime());
