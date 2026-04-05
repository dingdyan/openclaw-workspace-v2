Dim r = /[_a-zA-Z\d\-\.]+@[_a-zA-Z\d\-]+(\.[_a-zA-Z\d\-]+)+/g
Dim s = "My e-mails are ab@cable.netlux.org and ppusr154@ints.net"
Do
 If r.exec(s).length = 0 Then
   Exit Do
 Else
   println r[0]
   println r.MatchPos[0]
   println r.MatchLen[0]
   println r.LastIndex
 End If
Loop Until False
