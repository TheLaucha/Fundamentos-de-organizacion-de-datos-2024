program ej_9;
  const
    valorAlto = 9999;
  type
    rProducto = record
      cod: integer;
      nombre: string;
      precio: real;
      stockAct: integer;
      stockMin: integer;
    end;
    
    rVenta = record
      cod: integer;
      cant_vendidas: integer;
    end;

    ArchivoMaestro = file of rProducto;
    ArchivoDetalle = file of rVenta;

  procedure leerDetalle(var detalle: ArchivoDetalle; var regd: rVenta);
  begin
    if not (eof(detalle)) then
      read(detalle, regd)
    else
      regd.cod := valorAlto;
  end;

  // ?? Preguntar si esto esta correcto, sobre todo la aparte de abrir y cerrar siempre el maestro, una alternativa seria
  // Utilizar seek para volver a la pos 0.
  procedure actualizar(var maestro: ArchivoMaestro; var detalle: ArchivoDetalle);
  var
    regm: rProducto;
    regd: rVenta;
  begin
    reset(detalle);
    leerDetalle(detalle, regd);
    while (regd.cod <> valorAlto) do begin
      // Buscar el maestro que corresponde con el detalle, empezando de cero xq no esta ordenado.
      reset(maestro);
      read(maestro, regm);
      while not (eof(maestro)) and (regm.cod <> regd.cod) do begin
        read(maestro, regm);
      end;
      // Si es igual, actualizo ese regm.
      if(regm.cod = regd.cod) then begin
        regm.stockDisp := regm.stockDisp - regd.cant_vendidas;
        seek(maestro, filepos(maestro)-1);
        write(regm);
      end;
      close(maestro);
      // Avanzar con el siguiente detalle
      leerDetalle(detalle, regd);
    end;
    close(detalle);
  end;

  var
    maestro: ArchivoMaestro;
    detalle: ArchivoDetalle;
  begin
    Assign(maestro, 'maestro.txt');
    Assign(detalle, 'detalle.txt');
    // Creacion de los archivos, se dispone.
    actualizar(maestro, detalle);
  end.