program ej_2_v2;
  const
    valorAlto = 9999;
  type
    rAlumno = record
      cod: integer;
      apellido: string;
      nombre: string;
      cursadasSinFinal: integer;
      aprobadasConFinal: integer;
    end;

    rAlumnoDetalle = record
      cod: integer;
      aproboFinal: boolean;
    end;

    ArchivoMaestro = file of rAlumno;
    ArchivoDetalle = file of rAlumnoDetalle;

  procedure leerDetalle(var detalle: ArchivoDetalle; var regd: rAlumnoDetalle);
  begin
    if not (eof(detalle)) then
      read(detalle, regd);
    else
      regd.cod := valorAlto;
  end;

  procedure merge(var maestro: ArchivoMaestro; var detalle: ArchivoDetalle);
  var
    regd: rAlumnoDetalle;
    regm: rAlumno;
    codAct: integer;
    totFinal, totCursadas: integer;
  begin
    reset(maestro);
    reset(detalle);
    leerDetalle(detalle,regd);
    while (regd.cod <> valorAlto) do begin
      codAct := regd.cod;
      totFinal := 0;
      totCursadas := 0;
      // Hago la sumatoria
      while (regd.cod = codAct) do begin
        if (regd.aproboFinal) then
          totFinal := totFinal + regd.aprobadasConFinal;
        else
          totCursadas := totCursadas + regd.cursadasSinFinal;
        leerDetalle(detalle, regd);
      end;
      // Busco el registro maestro correspondiente, asumo que existe.
      read(maestro, regm);
      while (regm.cod <> codAct) do begin
        read(maestro, regm);
      end;
      // Actualizo el maestro
      regm.cursadasSinFinal := regm.cursadasSinFinal + totCursadas;
      regm.aprobadasConFinal := regm.aprobadasConFinal + totFinal;
      seek(maestro, filepos(maestro)-1);
      write(maestro, regm);
    end;
    close(maestro);
    close(detalle);
  end;

  procedure listarMasDeCuatroSinFinal(var maestro: ArchivoMaestro);
  var
    regm: rAlumno;
    texto: Text;
  begin
    Assign(texto, 'texto.txt');
    rewrite(texto);
    reset(maestro);
    while not (eof(maestro)) do begin
      read(maestro, regm);
      if (regm.cursadasSinFinal > 4) then begin
        with regm do begin
          writeln(texto, cod, ' ', apellido, ' ', nombre, ' ', cursadasSinFinal, ' ', aprobadasConFinal);
        end;
      end;
    end;
    close(texto);
    close(maestro);
  end;

  var
    maestro: ArchivoMaestro;
    detalle: ArchivoDetalle;
  begin
    Assign(maestro, 'maestro.dat');
    Assign(detalle, 'detalle.dat');
    // Se dispone creacion de detalle
    // Se dispone creacion de maestro
    merge(maestro, detalle);
    listarMasDeCuatroSinFinal(maestro);
  end.