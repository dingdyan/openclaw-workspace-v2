Dim I, L, P

println "Create a list"
L = [100, [200, [300, NULL]]]
println L

println "Insert new item at the beginning"
L = [50, L]
println L

println "Add new item at the end"
P = AddressOf L ' Create alias of L
Do Until P = NULL ' Find last item
 P = AddressOf P(1)
Loop
P = [400, NULL] 'Add new item
println L

println "Insert new item at the middle"
P = AddressOf L(1)
P = AddressOf P(1)  ' insert before 200
P = [150, P]
println L

println "Print list"
P = AddressOf L ' create alias of L
Do Until P = NULL
  println P(0)
  P = AddressOf P(1) ' go to the next item
Loop

println "Delete the first item of the list"
Reduced L = L(1)
println L

println "Delete the last item of the list"
P = AddressOf L ' Create alias of L
Do Until P(1) = NULL
  P = AddressOf P(1) ' Find last item
Loop
reduced P = P(1)
println L

println "Delete item at the middle of the list"
P = AddressOf L
P = AddressOf P(1)
reduced P = P(1)
println L

println "Delete all items from the list"
Do Until L = NULL
  Reduced L = L(1)
Loop
println L

println "Create a cycled list"
L = [100, [200, [300, NULL]]]
L[1][1][1] = AddressOf L
println L

delete L

println "Another way to create a cycled list"
L = [100, [200, [300, NULL]]]
P = AddressOf L ' Create alias of L
Do Until P = NULL ' Find last item
 P = AddressOf P(1)
Loop
TerminalOf P = AddressOf L ' join head and tail of the list
println L

println "Print the cycled list"
P = AddressOf L
I = 0
Do
  println P[0]
  P = AddressOf P[1]
  I += 1
Loop Until I = 15

