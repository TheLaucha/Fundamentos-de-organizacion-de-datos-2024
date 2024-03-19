program ej_6;
  type
    rCelular = record
      cod: integer;
      nombre: string[20];
      descripcion: string;
      marca: string[20];
      precio: integer;
      stockMin: integer;
      stockDisponible: integer;
    end;
    ArchivoCelulares = file of rCelular;
  
  Procedure crearArchivo(var celulares: ArchivoCelulares; var carga: Text);
    var
      cel: rCelular;
    begin
      rewrite(celulares);
      reset(carga);
      while not (eof(carga)) do begin
        with cel do begin
          readln(carga, cod, precio, marca);
          readln(carga, stockDisponible, stockMin, descripcion);
          readln(carga, nombre);
        end;
        write(celulares,cel);
      end;
      writeln('archivo cargado...');
      close(celulares);
      close(carga);
    end;

  Procedure imprimirCelular(cel: rCelular);
  begin
    with cel do begin
      writeln('Cod: ', cod);
      writeln('Nombre: ', nombre);
      writeln('Descripcion: ', descripcion);
      writeln('Marca: ', marca);
      writeln('Precio: ', precio);
      writeln('Stock minimo: ', stockMin);
      writeln('Stock disponible: ', stockDisponible);
      writeln('=====');
    end;
  end;

  Procedure listarStockMenorAlMinimo(var celulares: ArchivoCelulares);
    var
      cel: rCelular;
    begin
      reset(celulares);
      while not (eof(celulares)) do begin
        read(celulares, cel);
        if (cel.stockDisponible < cel.stockMin) then begin
          imprimirCelular(cel);
        end;
      end;
      close(celulares);
    end;

  Procedure buscarCelularesPorDescripcion(var celulares: ArchivoCelulares);
    var
      str: string;
      cel: rCelular;
      encontre: boolean;
    begin
      encontre := false;
      writeln('Ingrese descripcion a buscar: ');
      readln(str);
      str := ' ' + str; // Cuando leo una cadena del txt le agrega un espacio al inicio.
      reset(celulares);
      while not (eof(celulares)) and not (encontre) do begin
        read(celulares, cel);
        writeln(cel.descripcion);
        if(cel.descripcion = str) then begin
          imprimirCelular(cel);
          encontre := true;
        end;
      end;
      close(celulares);
    end;

  Procedure exportarArchivo(var celulares: ArchivoCelulares; var carga: Text);
    var
      cel: rCelular;
    begin
      rewrite(carga);
      reset(celulares);
      while not (eof(celulares)) do begin
        read(celulares, cel);
        with cel do begin
          writeln(carga,' ', cod,' ', precio,' ', marca);
          writeln(carga,' ', stockDisponible,' ', stockMin,' ', descripcion);
          writeln(carga,' ', nombre);
        end;
      end;
      close(celulares);
      close(carga);
    end;

  Procedure leerCelular(var cel: rCelular);
    begin
      with cel do begin
        writeln('Ingrese codigo de celular, 0 para finalizar: ');
        readln(cod);
        if(cod <> 0) then begin
          writeln('Ingrese nombre de celulares: ');
          readln(nombre);
          writeln('Ingrese descripcion: ');
          readln(descripcion);
          writeln('Ingrese marca: ');
          readln(marca);
          writeln('Ingrese precio: ');
          readln(precio);
          writeln('Ingrese stock minimo: ');
          readln(stockMin);
          writeln('Ingrese stock disponible: ');
          readln(stockDisponible);
        end;
      end;
    end;

  Procedure aniadirCelulares(var celulares: ArchivoCelulares);
    var
      cel: rCelular;
    begin
      reset(celulares);
      seek(celulares, filesize(celulares));
      leerCelular(cel);
      while (cel.cod <> 0 ) do begin
        write(celulares,cel);
        leerCelular(cel);
      end;
      close(celulares);
    end;

  Procedure modificarStock(var celulares: ArchivoCelulares);
    var
      str: string;
      cel: rCelular;
      encontre : boolean;
    begin
      writeln('Escriba el nombre del celular a modificar stock: ');
      readln(str);
      str := ' ' + str;
      encontre := false;
      reset(celulares);
      while not (eof(celulares)) and not (encontre) do begin
        read(celulares,cel);
        if (cel.nombre = str) then begin
          writeln('Ingrese el stock disponible del celular: ', str);
          readln(cel.stockDisponible);
          seek(celulares, filepos(celulares)-1);
          write(celulares, cel);
          encontre := true;
        end;
      end;
      if (encontre) then
        writeln('Se modifico el stock correctamente...')
      else
        writeln('No se encontro celular con ese nombre...');
      close(celulares);
    end;

  Procedure exportarSinStock(var celulares: ArchivoCelulares);
    var
      archivo_txt: Text;
      cel: rCelular;
    begin
      Assign(archivo_txt, 'SinStock.txt');
      rewrite(archivo_txt);
      reset(celulares);
      while not (eof(celulares)) do begin
        read(celulares, cel);
        with cel do begin
          if (stockDisponible = 0) then begin
            writeln(archivo_txt,' ', cod,' ', precio,' ', marca);
            writeln(archivo_txt,' ', stockDisponible,' ', stockMin,' ', descripcion);
            writeln(archivo_txt,' ', nombre);
          end;
        end;
      end;
      close(celulares);
      close(archivo_txt);
    end;

  Procedure mostrarMenu(var celulares: ArchivoCelulares; var carga: Text; nombre_archivo_celulares:string);
    var
      opcion: integer;
    begin
      writeln('Ingrese la accion que desea realizar con el archivo: ', nombre_archivo_celulares);
      writeln('1. Crear un archivo binario cargandolo desde celulares.txt');
      writeln('2. Listar en pantalla celulares con un stock menor al stock minimo');
      writeln('3. Buscar celulares por descripcion');
      writeln('4. Exportar archivo creado a celulares.txt');
      writeln('5. Aniadir celulares: ');
      writeln('6. Modificar stock de un celular: ');
      writeln('7. Exportar a un archivo de texto llamado SinStock.txt los celulares que tengan stock 0: ');
      readln(opcion);
      if (opcion = 1) then begin
        crearArchivo(celulares,carga);
      end
      else if (opcion = 2) then begin
        listarStockMenorAlMinimo(celulares);
      end
      else if (opcion = 3) then begin
        buscarCelularesPorDescripcion(celulares);
      end
      else if (opcion = 4) then begin
        exportarArchivo(celulares,carga);
      end
      else if (opcion = 5) then begin
        aniadirCelulares(celulares);
      end
      else if (opcion = 6) then begin
        modificarStock(celulares);
      end
      else if (opcion = 7) then begin
        exportarSinStock(celulares);
      end
      else begin
        writeln('La opcion ingresada es incorrecta...');
      end;
    end;

  var
    celulares : ArchivoCelulares;
    nombre_archivo_celulares : string[20];
    carga: Text;
    cortar: char;
  begin
    cortar := 'g';
    writeln('Ingrese el nombre del archivo a crear: ');
    readln(nombre_archivo_celulares);
    Assign(celulares,nombre_archivo_celulares);
    Assign(carga, 'celulares.txt');
    while(cortar <> '0') do begin
      mostrarMenu(celulares,carga, nombre_archivo_celulares);
      writeln('Escriba cualquier tecla para volver a mostrar el menu, ingrese 0 para finalizar.');
      readln(cortar);
    end;
  end.
