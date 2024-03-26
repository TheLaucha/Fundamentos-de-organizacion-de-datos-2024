{
  4. Suponga que trabaja en una oficina donde está montada una LAN (red local). La misma
fue construida sobre una topología de red que conecta 5 máquinas entre sí y todas las
máquinas se conectan con un servidor central. Semanalmente cada máquina genera un
archivo de logs informando las sesiones abiertas por cada usuario en cada terminal y por
cuánto tiempo estuvo abierta. Cada archivo detalle contiene los siguientes campos:
cod_usuario, fecha, tiempo_sesion. Debe realizar un procedimiento que reciba los archivos
detalle y genere un archivo maestro con los siguientes datos: cod_usuario, fecha,
tiempo_total_de_sesiones_abiertas.
Notas:
- Cada archivo detalle está ordenado por cod_usuario y fecha.
- Un usuario puede iniciar más de una sesión el mismo dia en la misma o en diferentes
máquinas.
- El archivo maestro debe crearse en la siguiente ubicación física: /var/log.
}

program ej_5;
  const valorAlto = 9999;
  const dimF = 2;
  type
    dia= 1..31;
    rSesion = record
      cod_usuario: integer;
      fecha: dia;
      tiempo_sesion:integer;
    end;

    rSesionMaestro = record
      cod_usuario: integer;
      fecha: dia;
      tiempo_total_de_sesiones_abiertas:integer;
    end;

    ArchivoDetalle = file of rSesion;
    ArchivoMaestro = file of rSesionMaestro;
    vector_detalle = array[1..dimF] of ArchivoDetalle;
    vector_regd = array[1..dimF] of rSesion;

  procedure asignoDetalles(var arr_detalle: vector_detalle);
  var
    i:integer;
    a: string[2];
  begin
    for i:=1 to dimF do begin
      Str(i,a);
      Assign(arr_detalle[i], 'detalle'+a);
    end;
  end;

  procedure leerDetalle(var arch_detalle: ArchivoDetalle; var regd: rSesion);
  begin
    if not(eof(arch_detalle)) then begin
      read(arch_detalle,regd);
    end
    else begin
      regd.cod_usuario := valorAlto;
    end;
  end;

  procedure minimo(var arr_regd: vector_regd; var arr_detalle: vector_detalle; var min: rSesion);
  var
    i:integer;
    posMin: integer;
  begin
    min.cod_usuario := valorAlto;
    for i:=1 to dimF do begin
      if(arr_regd[i].cod_usuario <> valorAlto) then begin
        if (arr_regd[i].cod_usuario < min.cod_usuario) or ((arr_regd[i].cod_usuario = min.cod_usuario) and (arr_regd[i].fecha < min.fecha)) then begin
          min := arr_regd[i];
          posMin := i;
        end;
      end;
    end;
    if (min.cod_usuario <> valorAlto) then begin
      leerDetalle(arr_detalle[posMin], arr_regd[posMin])
    end;
  end;

  procedure generarMaestro(var maestro: ArchivoMaestro; var arr_detalle: vector_detalle);
  var
    arr_regd: vector_regd;
    i: integer;
    min: rSesion;
    actual: rSesionMaestro;
  begin
    rewrite(maestro);
    for i:=1 to dimF do begin
      reset(arr_detalle[i]);
      leerDetalle(arr_detalle[i],arr_regd[i]);
    end;
    minimo(arr_regd,arr_detalle, min);
    while(min.cod_usuario <> valorAlto) do begin
      actual.cod_usuario := min.cod_usuario;
      while(min.cod_usuario = actual.cod_usuario) do begin
        actual.fecha := min.fecha;
        actual.tiempo_total_de_sesiones_abiertas := 0;
        while(min.cod_usuario = actual.cod_usuario) and (actual.fecha = min.fecha) do begin
          actual.tiempo_total_de_sesiones_abiertas += min.tiempo_sesion;
          minimo(arr_regd,arr_detalle,min);
        end;
        write(maestro,actual);
      end;
    end;
    close(maestro);
    for i:= 1 to dimF do begin
      close(arr_detalle[i]);
    end;
  end;
  
  procedure imprimirMaestro(var maestro: ArchivoMaestro);
  var
		reg: rSesionMaestro;
  begin
		reset(maestro);
		while not (eof(maestro)) do begin
			read(maestro,reg);
			with reg do begin
				writeln('cod: ', cod_usuario, ' fecha: ', fecha, 'tiempo total: ', tiempo_total_de_sesiones_abiertas);
			end;
		end;
		close(maestro);
  end;

  var
    maestro: ArchivoMaestro;
    arr_detalle: vector_detalle;
  begin
    // Asigno detalles
    asignoDetalles(arr_detalle);
    writeln('Asigno detalles');
    // Asigno maestro
    Assign(maestro,'F:\UNLP\08-Septimo Semestre\FOD\Practica_2\Ejercicio_4\var\log\maestro.dat');
    writeln('Asigno masetro');
    // Analizo
    generarMaestro(maestro,arr_detalle);
    writeln('Maestro generado');
    // Imprimo maestro
    imprimirMaestro(maestro);
    writeln('Maestro generado');
  end.
