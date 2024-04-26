program ej_7;
  const
    valorAlto = 9999;
  type
    rAve = record
      cod: integer;
      nombre: string;
      familia: string;
      desc: string;
      zona: string;
    end;

    ArchivoAves = file of rAve;

  procedure leerAve(var ave: rAve);
  begin
    with ave do begin
      writeln('Ingrese el codigo de ave a borrar... 500000 para finalizar');
      readln(cod);
    end;
  end;

  procedure leer(var aves: ArchivoAves; var a:rAve);
  begin
    if not (eof(aves)) then
      read(aves, a);
    else
      a.codigo := valorAlto;
  end;

  procedure bajaLogica(var aves: ArchivoAves; ave: rAve);
  var
    a: rAve;
  begin
    reset(aves);
    leer(aves, a);
    // Busco el registro a borrar
    while (a.codigo <> valorAlto) and (a.codigo <> ave.codigo) do
      leer(aves, a);
    // Si encuentro lo marco
    if (a.codigo = ave.codigo) then begin
      a.codigo := -(a.codigo);
      seek(aves, filepos(aves)-1);
      write(aves, a);
    end
    else
      writeln('No se encontro el cod de ave a borrar');
    close(aves);
  end;

  procedure borrarRegistros(var aves: ArchivoAves);
  var
    ave: rAve;
  begin
    leerAve(ave);
    while (ave.codigo <> 500000) do begin
      bajaLogica(aves,ave);
      leerAve(ave);
    end;
    close(aves);
  end;

  procedure compactar(var aves: ArchivoAves);
  var
    a: rAve;
    pos: integer;
  begin
    reset(aves);
    leer(aves, a);
    while (a.cod <> valorAlto) do begin
      // Busco los marcados
      if (a.codigo < 0) then begin
        pos := filepos(aves)-1;
        // Busco el ultimo disponible
        seek(aves, filesize(aves)-1);
        read(aves, a);
        while(a.codigo < 0) do begin
          seek(aves, filesize(aves)-1);
          truncate(aves);
          seek(aves, filesize(aves)-1);
          read(aves, a);
        end;
        // Cuando encuentro un registro disponible
        seek(aves, pos);
        write(aves, a);
        // Borro el ultimo para que no quede doble
        seek(aves, filesize(aves)-1);
        truncate(aves);
        // Vuelvo a la pos para seguir recorriendo
        seek(aves, pos);
      end;
      leer(aves, a);
    end;
    close(aves);
  end;

  var
    aves: ArchivoAves;
  begin
    Assign(aves, 'aves.txt');
    // crearArchivo() se dispone
    borrarRegistros(aves);
    compactar(aves);
  end.
  
