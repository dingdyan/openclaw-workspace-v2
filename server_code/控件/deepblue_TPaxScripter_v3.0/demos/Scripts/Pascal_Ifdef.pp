{$define abc}

{$ifdef abc}

writeln(123);

{$else}

writeln(456);

{$endif}

{$undef abc}

{$ifdef abc}

writeln(123);

{$else}

writeln(456);

{$endif}





