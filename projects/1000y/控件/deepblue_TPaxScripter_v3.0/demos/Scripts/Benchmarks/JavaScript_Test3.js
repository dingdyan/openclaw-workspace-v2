d = new Date();
s = '';
for (i=0; i < 10000; i++) s += 'abc';
d1 = new Date();
alert(d1.getTime() - d.getTime());



