program ej_2;
  type
    rAlumno = record
      cod: integer;
      apellido: string;
      nombre: string;
      cant_cursadas_aprobadas: integer;
      cant_final_aprobado: integer;
    end;

    rAlumnoDetalle = record
      cod:integer;
      aprobo_final: integer; // 0 indica que aprobo cursada sin final y 1 indica que aprobo final
    end;
    ArchivoMaestro = file of rAlumno;
    ArchivoDetalle = file of rAlumnoDetalle;

  procedure leerAlumno(var al: rAlumno);
  begin
    with al do begin
      writeln('Ingrese codigo de alumno: -> 0 para finalizar');
      readln(cod);
      if (cod <> 0) then begin
        writeln('Ingrese apellido de alumno: -> ');
        readln(apellido);
        writeln('Ingrese nombre de alumno: ->');
        readln(nombre);
        writeln('Ingrese cant de cursadas aprobadas: ->');
        readln(cant_cursadas_aprobadas);
        writeln('Ingrese cant de finales aprobados: ->');
        readln(cant_final_aprobado);
      end;
    end;
  end;

  procedure crearArchivoMaestro(var master: ArchivoMaestro; var masterTxt: Text);
    var
      al: rAlumno;
    begin
      rewrite(master);
      reset(masterTxt);
      while not (eof(masterTxt)) do begin
        with al do begin
          readln(masterTxt, cod);
          readln(masterTxt, apellido);
          readln(masterTxt, nombre);
          readln(masterTxt, cant_cursadas_aprobadas, cant_final_aprobado);
        end;
        write(master, al);
      end;
      close(masterTxt);
      close(master);
    end;
  
  procedure crearArchivoDetalle(var detail: ArchivoDetalle; var detailTxt: Text);
  var
    al: rAlumnoDetalle;
  begin
    rewrite(detail);
    reset(detailTxt);
    while not (eof(detailTxt)) do begin
      with al do begin
        readln(detailTxt, cod, aprobo_final);
      end;
      write(detail, al);
    end;
    close(detailTxt);
    close(detail);
  end;

  procedure mostrarMenu(var master: ArchivoMaestro; var detail: ArchivoDetalle; var masterTxt, detailTxt: Text);
    var
      opcion: integer;
    begin
      writeln('Ingrese la opcion deseada: ');
      writeln('1. Crear el archivo maestro a partir de alumnos.txt: ');
      writeln('2. Crear el archivo detalle a partir de detalle.txt: ');
      readln(opcion);
      case opcion of 
        1: crearArchivoMaestro(master, masterTxt);
        2: crearArchivoDetalle(detail, detailTxt);
      end;
    end;

  var
    master: ArchivoMaestro;
    detail: ArchivoDetalle;
    masterTxt: Text;
    detailTxt: Text;
    str: string;
  begin
    Assign(master, 'master.dat');
    Assign(detail, 'detail.dat');
    Assign(masterTxt, 'alumnos.txt');
    Assign(detailTxt, 'detalle.txt');
    str := 'c';
    while(str <> 'fin') do begin
      mostrarMenu(master, detail, masterTxt, detailTxt);
      writeln('Presione cualquier tecla para continuar. Escriba "fin" para finalizar la ejecucion: ');
      readln(str);
    end;
  end.
