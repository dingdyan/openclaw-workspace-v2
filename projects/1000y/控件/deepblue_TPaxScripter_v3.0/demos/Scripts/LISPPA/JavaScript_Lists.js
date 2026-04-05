println 'Create a list';
L = [100, [200, [300, null]]];
println L;

println 'Insert new item at the beginning';
L = [50, L];
println L;

println 'Add new item at the end';
P = & L; // Create alias of L
while (P != null) {P = & P[1]; }; // Find last item
P = [400, null]; // Add new item
println L;

println 'Insert new item at the middle';
P = & L[1];
P = & P[1]; // insert before 200
P = [150, P];
println L;

println 'Print list';
P = & L; // create alias of L
while (P != null) {
  println P[0];
  P = & P[1]; // go to the next item
}

println 'Delete the first item of the list';
reduced L = L[1];
println L;

println 'Delete the last item of the list';
P = & L; // Create alias of L
while (P[1] != null) { P = & P[1]; }// Find last item
reduced P = P[1];
println L;

println 'Delete item at the middle of the list';
P = & L;
P = & P[1];
reduced P = P[1];
println L;

println 'Delete all items from the list';
while (L != null) { reduced L = L[1]; };
println L;

println 'Create a cycled list';
L = [100, [200, [300, null]]];
L[1][1][1] = & L; // join head and tail of the list
println L;

delete L;

println 'Another way to create a cycled list';
L = [100, [200, [300, null]]];
P = & L; // Create alias of L
while (P != null) {P = & P[1]; }; // Find last item
* P = & L; // join head and tail of the list
println L;

println 'Print the cycled list';
P = & L;
I = 0;
do {
  println P[0];
  P = & P[1];
  I++;
}
while (I < 15);


