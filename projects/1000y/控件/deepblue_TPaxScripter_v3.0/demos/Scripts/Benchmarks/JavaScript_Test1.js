d = new Date();
S = 0.0;
P = 1.0;
for (i=1; i<=100000; i++) {
  for (j=1; j<=10; j++) {
    P = P / 4.0;
    S = S + P;
  }
}
d1 = new Date();
alert(d1.getTime() - d.getTime());
println d1 - d;
