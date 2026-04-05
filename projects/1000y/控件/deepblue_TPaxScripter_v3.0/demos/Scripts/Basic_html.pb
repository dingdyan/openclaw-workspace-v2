<?pax
Dim num_tries, num_to_guess = 40, Message = ""

#define declare_off

If HasProperty("number_tries") Then
  num_tries = number_tries + 1
Else
  num_tries = 0
End If

If Not HasProperty("guess") Then
  Message = "Welcome to the guessing machine !"
ElseIf toInteger(guess) > num_to_guess then
  Message = guess + " is to big. Try a smaller number"
ElseIf toInteger(guess) < num_to_guess then
  Message = guess + " is too small. Try a large number"
Else
  Message = "Well done!"
End If

#define declare_on

?>

<html>
<body>
\%s=Message
<br>
Guess number: <?pax print num_tries: ?>

<form action="<?pax print PAX_SELF: ?>" method="POST">
Type your guess here: <input type="text" name="guess">
<input type="hidden" name="number_tries" value="<?pax print num_tries: ?>">
</form>
</body>
</html>

