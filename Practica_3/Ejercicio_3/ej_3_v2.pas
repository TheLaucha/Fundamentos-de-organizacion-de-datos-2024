program ej_3_v2;
  type
    rNovela = record
      cod: integer;
      genero: string;
      nombre: string;
      duracion: string;
      director: string;
      precio: real;
    end;

    ArchivoNovelas = file of rNovela;
  
  procedure cargarNovela(var nov: rNovela);
  begin
    writeln('Ingrese codigo de novela:  -1 para terminar.');
    readln(nov.cod);
    if (nov.cod <> -1) then begin
      writeln('Ingrese genero de novela: ');
      readln(nov.genero);
      writeln('Ingrese nombre de novela: ');
      readln(nov.nombre);
      writeln('Ingrese duracion de novela: ');
      readln(nov.duracion);
      writeln('Ingrese director de novela: ');
      readln(nov.director);
      writeln('Ingrese precio de novela: ');
      readln(nov.precio);
    end;
  end;

  procedure crearArchivo(var novelas: ArchivoNovelas);
  var
    nov: rNovela;
  begin
    rewrite(novelas);
    nov.cod := 0;
    write(novelas, nov);
    cargarNovela(nov);
    while (nov.cod <> -1) do begin
      write(novelas, nov);
      cargarNovela(nov);
    end;
    close(novelas);
  end;

  procedure alta(var novelas: ArchivoNovelas);
  var
    nov: rNovela;
    cab: rNovela;
  begin
    cargarNovela(nov);
    reset(novelas);
    read(novelas,cab);
    if (cab.cod <> 0) then begin
      seek(novelas, (cab.cod*-1));
      read(novelas, cab);
      seek(novelas, filepos(novelas)-1);
      write(novelas, nov);
      seek(novelas, 0);
      write(novelas, cab);
    end
    else begin
      writeln('No queda espacio libre en el archivo...');
    end;
    close(novelas);
  end;

  procedure modificar(var novelas: ArchivoNovelas);
  var
    nov: rNovela;
    ind: rNovela;
  begin
    writeln('Ingrese datos de la novela a modificar: ');
    cargarNovela(nov);
    reset(novelas);
    read(novelas, ind);
    while not (eof(novelas)) do begin
      while (ind.cod <> nov.cod) do begin
        read(novelas, ind);
      end;
      if (nov.cod = ind.cod) then begin
        seek(novelas, filepos(novelas)-1);
        write(novelas, nov);
      end
      else begin
        writeln('No se encontro novela');
      end;
    end;
    close(novelas);
  end;

  procedure eliminar(var novelas: ArchivoNovelas);
  var
    cod: integer;
    cab, ind: rNovela;
  begin
    writeln('Ingrese el cod de la novela que desea eliminar: ');
    readln(cod);
    reset(novelas);
    read(novelas, cab);
    if not (eof(novelas)) then
      read(novelas, ind);
    while not (eof(novelas)) do begin
      while not (eof(novelas)) and (ind.cod <> cod) do begin
        read(novelas, ind);
      end;
      if (ind.cod = cod) then begin
        seek(novelas, filepos(novelas)-1);
        ind.cod := filepos(novelas)*-1;
        write(novelas, cab);
        seek(novelas, 0);
        write(novelas, ind);
      end;
    end;
    close(novelas);
  end;

  procedure abrirArchivo(var novelas: ArchivoNovelas);
  var
    reg: rNovela;
    opcion: byte;
  begin
    writeln('Ingrese la opcion que desea realizar: ');
    readln(opcion);
    case opcion of
      1: alta(novelas);
      2: modificar(novelas);
      3: eliminar(novelas);
  end;

  procedure listarArchivo(var novelas: ArchivoNovelas);
  var
    texto: Text;
    nov: rNovela;
  begin
    Assign(texto, 'novelas.txt');
    rewrite(texto);
    reset(novelas);
    read(novelas, nov);
    if not (eof(novelas)) then
      read(novelas, nov);
    while not (eof(novelas)) do begin
      with nov do begin
        writeln(texto, cod, ' ', genero, ' ', nombre, ' ', duracion, ' ', director, ' ', precio);
      end;
      readln(novelas, nov);
    end;
    close(novelas);
    close(texto);
  end;
  
  procedure mostrarMenu(var novelas: ArchivoNovelas);
  var
    opcion: char;
  begin
    opcion := 'l';
    while (opcion <> 'x') do begin
      writeln('Menu de opciones: ');
      readln(char);
      writeln('a. Crear el archivo novelas');
      writeln('b. Abrir el archivo novelas');
      writeln('c. Listar en un archivo llamado "novelas.txt"');
      writeln('Ingrese x para cerrar el programa');
      case char of
        'a': crearArchivo(novelas);
        'b': abrirArchivo(novelas);
        'c': listarArchivo(novelas);
    end;
  end;

  var
    opcion: byte;
    novelas: ArchivoNovelas;
  begin
    Assign(novelas, 'novelas.dat');
    mostrarMenu(novelas);
  end;