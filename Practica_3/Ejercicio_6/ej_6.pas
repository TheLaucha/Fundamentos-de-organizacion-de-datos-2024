program ej_6;
  const
    valorAlto = 9999;
  type
    rPrenda = record
      cod:integer;
      desc: string;
      colores: string;
      tipo: string;
      stock: integer;
      precio: real;
    end;

    ArchivoMaestro = file of rPrenda;
    ArchivoDetalle = file of integer;
  
  procedure leerDetalle(var detalle: ArchivoDetalle; var regd: integer);
  begin
    if not (eof(detalle)) then
      read(detalle, regd)
    else
      regd := valorAlto;
  end;

  procedure leerMaestro(var maestro: ArchivoMaestro; var regm: rPrenda);
  begin
    if not (eof(maestro)) then
      read(maestro, regm)
    else
      regm.cod := valorAlto;
  end;

  procedure bajaLogica(var maestro: ArchivoMaestro; regd:integer);
  var
    regm: rPrenda;
  begin
    reset(maestro);
    leerMaestro(maestro, regm);
    // Busco el registro a borrar
    while (regm.cod <> valorAlto) and (regm.cod <> regd) do
      leerMaestro(maestro, regm);
    // Si encontre borro
    if (regm.cod = regd) then begin
      regm.stock := -(regm.stock)
      seek(maestro, filepos(maestro)-1);
      write(maestro, regm);
    end
    else
      writeln('No encontre la prenda a borrar');
    close(maestro);
  end;

  procedure actualizar(var maestro: ArchivoMaestro; var detalle: ArchivoDetalle);
  var
    regd: integer;
  begin
    reset(detalle);
    leerDetalle(detalle, regd);
    while(regd <> valorAlto) do begin
      bajaLogica(maestro,regd);
      leerDetalle(detalle, regd);
    end;
    close(detalle);
  end;

  procedure compactar(var maestro: ArchivoMaestro; var maestro_compacto: ArchivoMaestro);
  var
    regm: rPrenda;
  begin
    reset(maestro);
    rewrite(maestro_compacto);
    leerMaestro(maestro,regm);
    while (regm.cod <> valorAlto) do begin
      if(regm.stock >= 0) then begin
        write(maestro_compacto, regm);
      end;
      leerMaestro(maestro, regm);
    end;
    close(maestro);
    close(maestro_compacto);
  end;

  var
    maestro, maestro_compacto: ArchivoMaestro;
    detalle: ArchivoDetalle;
  begin
    Assign(maestro, 'maestro.txt');
    Assign(maestro_compacto, 'maestro_compacto.txt');
    Assign(detalle, 'detalle.txt');
    actualizar(maestro,detalle);
    compactar(maestro,maestro_compacto);
    erase(maestro); // Borra el archivo fisico
    rename(maestro_compacto, 'maestro.txt'); 
  end.