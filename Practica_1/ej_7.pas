program ej_7;
  type
    rNovela = record
      cod: integer;
      nombre: string;
      genero: string;
      precio: integer;
    end;
    ArchivoNovelas = file of rNovela;

  procedure crearArchivoAPartirDeTxt(var novelas: ArchivoNovelas; var archivoTxt: Text);
  var
    novela: rNovela;
  begin
    reset(archivoTxt);
    rewrite(novelas);
    while not (eof(archivoTxt)) do begin
      with novela do begin
        readln(archivoTxt, cod, precio, genero);
        readln(archivoTxt, nombre);
      end;
      write(novelas, novela);
    end;
    close(archivoTxt);
    close(novelas);
  end;

  procedure leerNovela(var novela: rNovela);
  begin
    with novela do begin
      writeln('Ingrese el codigo de novela: ');
      readln(cod);
      if (cod <> 0) then begin
        writeln('Ingrese el nombre de novela: ');
        readln(nombre);
        writeln('Ingrese el genero de novela: ');
        readln(genero);
        writeln('Ingrese el precio de novela: ');
        readln(precio);
      end;
    end;
  end;

  procedure agregarUnaNovela(var novelas: ArchivoNovelas);
  var
    novela: rNovela;
  begin
    reset(novelas);
    seek(novelas, filesize(novelas));
    leerNovela(novela);
    while (novela.cod <> 0) do begin
      write(novelas,novela);
      leerNovela(novela);
    end;
    close(novelas);
  end;

  procedure modificarUnaNovela(var novelas: ArchivoNovelas);
  var
    cod: integer;
    novela: rNovela;
    encontre: boolean;
  begin
    encontre:= false;
    reset(novelas);
    writeln('Ingrese codigo de novela que desea modificar: ');
    readln(cod);
    while not (eof(novelas)) and not (encontre) do begin
      read(novelas, novela);
      if (novela.cod = cod) then begin
        writeln('Datos actuales: ');
        writeln('Nombre: ', novela.nombre);
        writeln('Genero: ', novela.genero);
        writeln('Precio: ', novela.precio);
        writeln('Ingrese nuevo nombre: ');
        readln(novela.nombre);
        writeln('Ingrese nuevo genero: ');
        readln(novela.genero);
        writeln('Ingrese nuevo precio: ');
        readln(novela.precio);
        seek(novelas, filepos(novelas)-1);
        write(novelas,novela);
        encontre := true;
      end;
    end;
    close(novelas);
  end;

  procedure abrirBinario(var novelas: ArchivoNovelas);
  var
    opcion: integer;
  begin
    writeln('Que desea hacer con el archivo de novelas ?');
    writeln('1. Agregar una novela');
    writeln('2. Actualizar una novela');
    readln(opcion);
    if (opcion = 1) then begin
      agregarUnaNovela(novelas);
    end
    else if (opcion = 2) then begin
      modificarUnaNovela(novelas)
    end
    else begin
      writeln('Ha seleccionado una opcion incorrecta...');
    end;
  end;

  procedure imprimirInformacion(var novelas: ArchivoNovelas);
  var
    n:rNovela;
  begin
    reset(novelas);
    while not (eof(novelas)) do begin
      read(novelas,n);
      with n do begin
        writeln('- Cod:', cod);
        writeln('- Nombre:', nombre);
        writeln('- Genero:', genero);
        writeln('- Precio:', precio);
        writeln('=====');
      end;
    end;
  end;
  
  procedure mostrarMenu(var novelas: ArchivoNovelas; var archivoTxt: Text; nombre: string);
  var
    opcion: integer;
  begin
    writeln('Que desea hacer con el archivo: ', nombre);
    writeln('1. Crear un archivo a partir de la informacion almacenada en novelas.txt');
    writeln('2. Abrir el archivo');
    writeln('3. Imprimir informacion');
    readln(opcion);
    if(opcion = 1) then begin
      crearArchivoAPartirDeTxt(novelas, archivoTxt);
    end
    else if (opcion = 2) then begin
      abrirBinario(novelas);
    end
    else if (opcion = 3) then begin
      imprimirInformacion(novelas);
    end
    else begin
      writeln('Ha seleccionado una opcion incorrecta...');
    end;
  end;

  var
    novelas: ArchivoNovelas;
    archivoTxt: Text;
    nombre: string;
    fin: char;
  begin
		fin := 'a';
    writeln('Ingrese el nombre deseado del archivo: ');
    readln(nombre);
    Assign(novelas,nombre);
    Assign(archivoTxt, 'novelas.txt');
    mostrarMenu(novelas, archivoTxt, nombre);
    while (fin <> 'f') do begin
      writeln('Presione cualquier tecla para volver a mostrar el menu, o f si desea finalizar');
      readln(fin);
      if(fin <> 'f') then begin
        mostrarMenu(novelas, archivoTxt, nombre);
      end
    end;
  end.
