program ej_3;
  const
    valorAlto = 9999;
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

  procedure leerNovela(var nov: rNovela);
  begin
    with nov do begin
      writeln('Ingrese el codigo de novela: ');
      readln(cod);
      if (cod <> 0) then begin
        writeln('Ingrese el genero de novela: ');
        readln(genero);
        writeln('Ingrese el nombre de novela: ');
        readln(nombre);
        writeln('Ingrese el duracion de novela: ');
        readln(duracion);
        writeln('Ingrese el director de novela: ');
        readln(precio);
        writeln('Ingrese el precio de novela: ');
      end;
    end;
  end;

  procedure cargarArchivo(var novelas: ArchivoNovelas);
  var
    nov: rNovela;
  begin
    rewrite(novelas);
    // Cargo el primer registro con cod 0
    nov.cod := 0;
    write(novelas, nov);
    // Leo y escribo
    leerNovela(nov);
    while (nov.cod <> 0) do begin
      write(novelas, nov);
      leerNovela(nov);
    end;
    close(novelas);
  end;

  procedure leer(var novelas: ArchivoNovelas; var aux: rNovela);
  begin
    if not (eof(novelas)) then
      read(novelas, aux)
    else
      aux.cod := valorAlto;
  end;

  procedure alta(var novelas: ArchivoNovelas);
  var
    newNov: rNovela;
    ind: rNovela;
  begin
    reset(novelas);
    leerNovela(newNov);
    leer(novelas, ind);
    if (newNov.cod <> 0) and (ind.cod <> valorAlto) then begin
      if(ind.cod < 0) then begin
        seek(novelas, Abs(ind.cod)); // Voy a la pos libre
        read(novelas, ind); // Guardo el registro que indica el sig libre
        seek(novelas, filepos(novelas)-1); // Me vuelvo a posicionar en el lugar libre 
        write(novelas, newNov); // Escribo la nueva novela en el lugar libre
        seek(novelas, 0); // Vuelvo a la pos 0
        write(novelas, ind); // Escribo el indice que indica el prox lugar libre
      end
      else begin
        seek(novelas, filsize(novelas)); // Me posiciono al final
        write(novelas, newNov); // Agrego la novela
      end;
    end;
    close(novelas);
  end;

  procedure modificarNovela(var nov: rNovela);
  begin
    with nov do begin
      writeln('Usted va a modicar la novela con cod: ', cod);
      writeln(genero, ' -> '); read(genero);
      writeln(nombre, ' -> '); read(nombre);
      writeln(duracion, ' -> '); read(duracion);
      writeln(director, ' -> '); read(director);
      writeln(precio, ' -> '); read(precio);
    end;
  end;

  procedure modificar(var novelas: ArchivoNovelas);
  var
    nov: rNovela;
    cod: integer;
  begin
    reset(novelas);
    writeln('Escriba el codigo de la novela a modificar: ');
    readln(cod);
    leer(novelas, nov);
    while (nov.cod <> valorAlto) do begin
      // Avanzo hasta encontrar el correspondiente
      while (nov.cod <> valorAlto) and (nov.cod <> cod) do begin
        leer(novelas, nov);
      end;
      // Si encontre modifico.
      if (nov.cod = cod) then begin
        modificarNovela(nov);
        seek(novelas, filepos(novelas)-1);
        write(novelas, nov);
        writeln('Novela modificada exitosamente!');
      end
      else begin
        writeln('No se encontro la novela...');
      end;
    end;
    close(novelas);
  end;

  procedure eliminar(var novelas: ArchivoNovelas);
  var
    nov: rNovela;
    cab: rNovela;
    cod, pos: integer;
  begin
    reset(novelas);
    writeln('Ingrese el cod de novela que desea eliminar: ');
    readln(cod);
    // Guardo la cabecera
    leer(novelas, cab);
    // Leo la primer nov
    leer(novelas, nov);
    while (nov.cod <> valorAlto) do begin
      // Busco el registro a borrar
      while (nov.cod <> valorAlto) and (nov.cod <> cod) do begin
        leer(novelas, nov);
      end;
      if(nov.cod = cod) then begin
        // Guardo la pos
        pos := filepos(novelas)-1;
        // sobreescribo la baja con la cabecera actual
        nov.cod := cab.cod;
        seek(novelas, pos);
        write(novelas, nov);
        // Actualizo el indice con la pos donde se encuentra el archivo a borrar y lo guardo en negativo
        cab.cod := -pos;
        seek(novelas, 0);
        write(novelas, cab);
      end;
    end;
    close(novelas);
  end;

  procedure abrirArchivo(var novelas: ArchivoNovelas);
  var
    opcion: char;
  begin
    writeln('Seleccione la operacion a realizar: ');
    writeln('a. Dar de alta una novela: ');
    writeln('b. Modificar datos de una novela: ');
    writeln('c. Eliminar una novela: ');

    case opcion of 
      'a': alta(novelas);
      'b': modificar(novelas);
      'c': eliminar(novelas);
    end;
  end;

  procedure listarEnUnArchivoDeTexto(var novelas: ArchivoNovelas);
  var
    txt: Text;
    nov: rNovela;
  begin
    Assign(txt, 'novelas.txt');
    rewrite(txt);
    reset(novelas);
    leer(novelas, nov);
    while(nov.cod <> valorAlto) do begin
      with nov do begin
        // ?? Consultar por modo de escritura en arch de txt;
        writeln(txt, cod, ' ', nombre, ' ', genero, ' ', director, ' ', duracion, ' ', precio);
      end;
      leer(novelas, nov);
    end;
    close(novelas);
    close(txt);
  end;

  var
    novelas: ArchivoNovelas;
    opcion: char;
  begin
    Assign(novelas, 'novelas.dat');
    writeln('a. Crear el archivo novelas');
    writeln('b. Abrir el archivo novelas');
    writeln('c. Listar en un archivo llamado "novelas.txt"');

    case opcion of
      'a' : cargarArchivo(novelas);
      'b' : abrirArchivo(novelas);
      'c' : listarEnUnArchivoDeTexto(novelas);
    end;
  end.