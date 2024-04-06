program ej_7;
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

  // Suponiendo que en el arhivo productos.txt se guardaron como: cod, nombre, precio, stockAct, stockMin;
  procedure crearArchivoMaestro(var maestro: ArchivoMaestro; var productosTxt: Text);
  var
    prod: rProducto;
  begin
    Assign(maestro, 'productos.dat');
    rewrite(maestro);
    reset(productosTxt);
    while not (eof(productosTxt)) do begin
      with prod do begin
        readln(productosTxt, cod, nombre);
        readln(productosTxt, precio, stockAct, stockMin);
      end;
      write(maestro, prod);
    end;
    close(maestro);
    close(productosTxt);
  end;

  // Un producto por linea
  procedure generarReporte(var maestro: ArchivoMaestro);
  var
    reporteTxt: Text;
    prod: rProducto;
  begin
    reset(maestro);
    Assign(reporteTxt, 'reporte.txt');
    rewrite(reporteTxt);
    while not (eof(maestro)) do begin
      read(maestro, prod);
      with prod do begin
        writeln(reporteTxt, cod,' ',precio,' ', stockAct,' ', stockMin,' ', nombre);
      end;
    end;
    close(reporteTxt);
    close(maestro);
  end;

  procedure crearArchivoDetalle(var detalle: ArchivoDetalle; var ventasTxt: Text);
  var
    venta: rVenta;
  begin
    Assign(detalle, 'ventas.dat');
    rewrite(detalle);
    reset(ventasTxt);
    while not (eof(ventasTxt)) do begin
      with venta do begin
        readln(ventasTxt, cod, cant);
      end;
      write(detalle, venta);
    end;
    close(detalle);
    close(ventasTxt);
  end;

  procedure listarArchivoDetalle(var detalle: ArchivoDetalle);
  var
    venta: rVenta;
  begin
    reset(detalle);
    while not (eof(detalle)) do begin
      read(detalle, venta);
      writeln('Cod: ', venta.cod);
      writeln('Cantidad vendida: ', venta.cant);
      writeln('----------');
    end;
    close(detalle);
  end;

  procedure actualizarMaestro(var maestro: ArchivoMaestro; var detalle: ArchivoDetalle);
  var
    regm: rProducto;
    regd: rVenta;
    codAct: integer;
  begin
    reset(maestro);
    reset(detalle);
    read(maestro, regm);
    while not (eof(detalle)) do begin
      read(detalle, regd);
      codAct := regd.cod;
      // Busco el regm que corresponde
      while (regm.cod <> codAct) do begin
        read(maestro, regm);
      end;
      // Actualizo el regm con los regd correspondientes
      while (regd.cod = codAct) do begin
        regm.stockAct := regm.stockAct - regd.cant;
        read(detalle, regd);
      end;
      // Actualizo el arch maestro
      seek(maestro, filepos(maestro)-1);
      write(maestro, regm);
    end;
    close(maestro);
    close(detalle);
  end;

  procedure generarReporteStockMin(var maestro: ArchivoMaestro);
  var
    prod: rProducto;
    archTxt: Text;
  begin
    Assign(archTxt, 'stock_minimo.txt');
    rewrite(archTxt);
    reset(maestro);
    while not (eof(maestro)) do begin
      read(maestro, prod);
      with prod do begin
        if (stockAct < stockMin) then begin
          writeln(archTxt, cod, ' ', precio, ' ', stockAct, ' ', stockMin, ' ', nombre);
        end;
      end;
    end;
    close(maestro);
    close(archTxt);
  end;
  
  var
    maestro: ArchivoMaestro;
    detalle: ArchivoDetalle;
    productosTxt: Text;
    ventasTxt: Text;
    opcion: char;
  begin
    Assign(productosTxt, 'productos.txt');
    Assign(ventasTxt, 'ventas.txt');
    writeln('Elija una opcion del menu: ');
    writeln('a. Crear el archivo maestro a partir de "productos.txt"');
    writeln('b. Listar el contenido del archivo maestro en "reporte.txt"');
    writeln('c. Crear archivo detalle a partir de "ventas.txt"');
    writeln('d. Listar el contenido del archivo detalle');
    writeln('e. Actualizar el archivo maestro con el archivo detalle');
    writeln('f. Listar en "stock_minimo.txt" los productos con menor stock que el stock minimo');
    writeln('t. Terminar');
    readln(opcion);
    case opcion of
      'a': crearArchivoMaestro(maestro,productosTxt);
      'b': generarReporte(maestro);
      'c': crearArchivoDetalle(detalle, ventasTxt);
      'd': listarArchivoDetalle(detalle);
      'e': actualizarMaestro(maestro, detalle);
      'f': generarReporteStockMin(maestro);
    end;
  end.
