program ej_13;
  const
    valorAlto = 9999;
  type
    rLog = record
      nro_usuario: integer;
      nombreUsuario: string;
      nombre: string;
      apellido: string;
      cantMailEnviados: integer;
    end;

    rCorreo = record
      nro_usuario:integer;
      cuentaDestino: string;
      cuerpoMensaje: string;
    end;

    ArchivoMaestro = file of rLog;
    ArchivoDetalle = file of rCorreo;

  procedure leerDetalle(var detalle: ArchivoDetalle; var regd: rCorreo);
  begin
    if not (eof(detalle)) then
      read(detalle, regd);
    else
      regd.nro_usuario := valorAlto;
  end;

  procedure acutalizar(var maestro: ArchivoMaestro; var detalle: ArchivoDetalle);
  var
    regm: rLog;
    regd: rCorreo;
    totalMails: integer;
    nroActual: integer;
  begin
    reset(maestro);
    reset(detalle);
    leerDetalle(detalle, regd);
    read(maestro, regm);
    while (regd.nro_usuario <> valorAlto) do begin
      nroActual := regd.nro_usuario;
      totalMails := 0;
      // Busco el regm correspondiente a actualizar
      while (nroActual <> regm.nro_usuario) do begin
        read(maestro, regm);
      end;
      // Actualizo la cant
      while (nroActual = regd.nro_usuario) do begin
        totalMails += 1;
        leerDetalle(detalle, regd);
      end;
      // Actualizo el archivo maestro
      seek(maestro, filepos(maestro)-1);
      regm.cantMailEnviados += totalMails;
      write(maestro, regm);
    end;
    close(maestro);
    close(detalle);
  end;

  procedure generarReporte(var detalle: ArchivoDetalle);
  var
    archTxt: Text;
    regd: rCorreo;
  begin
    Assign(archTxt, 'reporte.dat');
    reset(detalle);
    rewrite(archTxt);
    while not (eof(detalle)) do begin
      read(detalle, regd);
      with regd do begin
        writeln(archTxt, nro_usuario, ' ', cantMailEnviados);
      end;
    end;
    close(detalle);
    close(archTxt);
  end;

  var
    maestro: ArchivoMaestro;
    detalle: ArchivoDetalle;
  begin
    Assign(maestro, 'logmail.dat');
    Assign(detalle, 'detalle_dia_1.dat');
    acutalizar(maestro,detalle);
    generarReporte(detalle);
  end.
  