size = 8190;
sizepl = 8191;
var flags = new Array(sizepl);
var i, prime, k, count, iter;
starttime = new Date();
for (iter = 1; iter <= 10; iter++)
{   count = 0;
    for (i = 0; i <= size; i++)
	flags[i] = true;
    for (i = 0; i <= size; i++)
    {   if (flags[i])
	{   prime = i + i + 3;
	    k = i + prime;
	    while (k <= size)
	    {
		flags[k] = false;
		k += prime;
	    }
	    count += 1;
	}
    }
}
elapsedtime = new Date() - starttime;
alert(elapsedtime);
