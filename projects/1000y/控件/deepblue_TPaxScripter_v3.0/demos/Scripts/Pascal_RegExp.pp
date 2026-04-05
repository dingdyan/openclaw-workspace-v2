var r = /[_a-zA-Z\d\-\.]+@[_a-zA-Z\d\-]+(\.[_a-zA-Z\d\-]+)+/g;
    s = 'My e-mails are ab@cable.netlux.org and ppusr154@ints.net';
repeat
 if r.exec(s).length = 0 then
   Break
 else
 begin
   writeln(r[0]);
   writeln(r.MatchPos[0]);
   writeln(r.MatchLen[0]);
   writeln(r.LastIndex);
 end;
until false;

