program ej_3_v3;
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
      cant: integer;
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

  procedure merge(var maestro: ArchivoMaestro; var detalle: ArchivoDetalle);
  var
    regd: rVenta;
    regm: rProducto;
    codAct: integer;
    cantTotal: integer;
  begin
    reset(maestro);
    reset(detalle);
    read(maestro, regm);
    leerDetalle(detalle, regd);
    while (regd.cod <> valorAlto) do begin
      // Sumo todos los detalles correspondientes al mismo prod
      codAct := regd.cod;
      cantTotal := 0;
      while (regd.cod = codAct) do begin
        cantTotal := cantTotal + regd.cant;
        leerDetalle(regd);
      end;
      // Busco en el maestro el reg correspondiente a actualizar, se asume que existe.
      while (regm.cod <> codAct) do begin
        read(maestro, regm);
      end;
      // Actualizo maestro
      regm.stockAct := regm.stockAct - cantTotal;
      seek(maestro, filepos(maestro)-1);
      write(maestro, regm);
    end;
    close(maestro);
    close(detalle);
  end;

  procedure listarStockActMenorQueMin(var maestro: ArchivoMaestro);
  var
    regm: rProducto;
    texto: Text;
  begin
    reset(maestro);
    Assign(texto, 'stock_minimo.txt');
    rewrite(texto);
    while not (eof(maestro)) do begin
      read(maestro, regm);
      if (regm.stockAct < regm.stockMin) then begin
        with regm do begin
          writeln(texto, cod, ' ', nombre, ' ', precio, ' ', stockAct, ' ', stockMin);
        end;
      end;
    end;
    close(maestro);
  end;

  var
    maestro: ArchivoMaestro;
    detalle: ArchivoDetalle;
  begin
    Assign(maestro, 'maestro.txt');
    Assign(detalle, 'detalle.txt');
    // Se dispone creacion de maestro y detalle
    merge(maestro, detalle);
    listarStockActMenorQueMin(maestro);
  end.