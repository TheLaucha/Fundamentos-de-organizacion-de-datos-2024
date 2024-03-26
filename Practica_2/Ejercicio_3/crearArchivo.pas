program crearArchivo;
  type
    rProducto = record
      cod: integer;
      nombre: string;
      desc: string;
      stockDisp: integer;
      stockMin: integer;
      precio: real;
    end;

    rPedido = record
      cod:integer;
      cant_vendida: integer;
    end;

    ArchivoMaestro = file of rProducto;
    ArchivoDetalle = file of rPedido;

  procedure leerProducto(var p: rProducto);
  begin
    with p do begin
      writeln('Escriba cod de producto: Ingrese 0 para finalizar');
      readln(cod);
      if (cod <> 0) then begin
        writeln('Escriba nombre de producto: ');
        readln(nombre);
        writeln('Escriba descripcion de producto: ');
        readln(desc);
        writeln('Escriba stock disponible de producto: ');
        readln(stockDisp);
        writeln('Escriba stock minimo de producto: ');
        readln(stockMin);
        writeln('Escriba precio de producto: ');
        readln(precio);
      end;
    end;
  end;

  procedure leerPedido(var p: rPedido);
  begin
    with p do begin
      writeln('Escriba cod de producto: Ingrese 0 para finalizar');
      readln(cod);
      if (cod <> 0) then begin
        writeln('Escriba cantidad pedida: ');
        readln(cant_vendida);
      end;
    end;
  end;

  procedure crearArchivoMaestro(var maestro: ArchivoMaestro);
  var
    str: string;
    p: rProducto;
  begin
    writeln('Escriba el nombre deseado para el archivo maestro: ');
    readln(str);
    Assign(maestro, str);
    rewrite(maestro);
    leerProducto(p);
    while (p.cod <> 0) do begin
      write(maestro,p);
      leerProducto(p);
    end;
    close(maestro);
  end;

  procedure crearArchivoDetalle(var detalle: ArchivoDetalle);
  var
    str: string;
    p: rPedido;
  begin
    writeln('Escriba el nombre deseado para el archivo detalle: ');
    readln(str);
    Assign(detalle, str);
    rewrite(detalle);
    leerPedido(p);
    while (p.cod <> 0) do begin
      write(detalle,p);
      leerPedido(p);
    end;
    close(detalle);
  end;
  
  var
    maestro: ArchivoMaestro;
    detalle: ArchivoDetalle;
    opcion: byte;
  begin
    writeln('Elija que tipo de archivo desea crear: ');
    writeln('1. Archivo maestro: ');
    writeln('2. Archivo detalle: ');
    readln(opcion);
    case opcion of
      1: crearArchivoMaestro(maestro);
      2: crearArchivoDetalle(detalle);
    end;
  end.
