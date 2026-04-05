unit filepgkclass;
{*.bmp

=>>> bmp.pgk
------------------
mapmini目录小地图图片
*.hdf
*.map
*.obj
*.til

 =>>> map.pgk
------------------
*.atz
*.sdb
*.atd
*.ini
*.txt
 =>>> sys.pgk
------------------
wav目录打包1个文件
=>>> wav.pgk
------------------
eft目录打包1个文件
=>>> eft.pgk
------------------
sprite目录打包1个文件
=>>> sprite.pgk
------------------
ect目录打包1个文件
=>>> ect.pgk
------------------}
interface
uses
    Windows, SysUtils, Classes, FfilePgk;

var
    pgkBmp: Tfilepgk;
    pgkmap: Tfilepgk;
    pgksys: Tfilepgk;
    //  pgkwav          :Tfilepgk;
    pgkeft: Tfilepgk;
    pgksprite: Tfilepgk;
    pgkect: Tfilepgk;

    pgkeft_W: Tfilepgk;

implementation

procedure tempPgk();
var
    filepgk: Tfilepgk;
begin
    if FileExists('.\temp.pgk') = FALSE then
    begin
        filepgk := tfilepgk.Create('.\temp.pgk', true, false);
        filepgk.Free;
    end;
end;
initialization

    begin
        pgkeft_W := tfilepgk.Create('.\eft_w.pgk', true, false);

        pgkBmp := Tfilepgk.Create('.\bmp.pgk');
        pgksys := Tfilepgk.Create('.\sys.pgk');
        tempPgk;
        if FileExists('map.pgk') = FALSE then
            pgkmap := Tfilepgk.Create('.\temp.pgk')
        else
            pgkmap := Tfilepgk.Create('.\map.pgk');

        if FileExists('eft.pgk') = FALSE then
            pgkeft := Tfilepgk.Create('.\temp.pgk')
        else
            pgkeft := Tfilepgk.Create('.\eft.pgk');
        if FileExists('sprite.pgk') = FALSE then
            pgksprite := Tfilepgk.Create('.\temp.pgk')
        else
            pgksprite := Tfilepgk.Create('.\sprite.pgk');
        if FileExists('ect.pgk') = FALSE then
            pgkect := Tfilepgk.Create('.\temp.pgk')
        else
            pgkect := Tfilepgk.Create('.\ect.pgk');

    end;

finalization
    begin
        pgkeft_W.Free;
        pgkBmp.Free;
        pgkmap.Free;
        pgksys.Free;
        // pgkwav.Free;
        pgkeft.Free;
        pgksprite.Free;
        pgkect.Free;
    end;

end.

