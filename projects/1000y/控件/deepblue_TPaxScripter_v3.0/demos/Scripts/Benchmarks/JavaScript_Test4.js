function Hanoi(N, X, Y, Z) {
  if (N > 0) {
    Hanoi(N - 1, X, Z, Y);
    Hanoi(N - 1, Z, Y, X);
  }
}
d = new Date();
Hanoi(20, 'A', 'B', 'C');
d1 = new Date();
alert(d1.getTime() - d.getTime());




