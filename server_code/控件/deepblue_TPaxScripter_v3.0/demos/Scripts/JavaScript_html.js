<?pax

num_tries, num_to_guess = 40, Message = "";

if (HasProperty("number_tries"))
  num_tries = number_tries + 1;
else
  num_tries = 0;

if (!HasProperty("guess"))
  Message = "Welcome to the guessing machine !";
else if (toInteger(guess) > num_to_guess)
  Message = guess + " is to big. Try a smaller number";
else if (toInteger(guess) < num_to_guess)
  Message = guess + " is too small. Try a large number";
else
  Message = "Well done!";
?>

<html>
<body>
\%s=Message
<br>
Guess number: <?pax print num_tries; ?>

<form action="<?pax print PAX_SELF; ?>" method="POST">
Type your guess here: <input type="text" name="guess">
<input type="hidden" name="number_tries" value="<?pax print num_tries; ?>">
</form>
</body>
</html>

