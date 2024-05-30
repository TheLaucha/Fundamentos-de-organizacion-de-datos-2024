{Se dispone de un archivo que contiene información de jugadores de futbol. Se sabe que el archivo utiliza la técnica de 
lista invertida para aprovechamiento de espacio. Es decir, las bajas se realizan apilando registros borrados y las altas 
reutilizando registros borrados. El registro en la posición 0 del archivo se usa como cabecera de la pila de registros 
borrados. El campo de enlace es el campo dni.
Nota: El valor 0 en el campo dni significa que no existen registros borrados, y el valor -N indica que el próximo 
registro a reutilizar es el  N, siendo éste un número relativo de registro válido.}
program parcial;

const
  valorAlto=9999;
Type
  tJugador= Record
    dni:longInt;
    nombre: String;
    apellido: String;
    pais_nacimiento: String;
  end;
  tArchivo = File of tJugador;

{ Se solicita implementar los siguientes módulos: }
{Abre el archivo y agrega un jugador, el mismo se recibe como parámetro  y debe utilizar la política descripta anteriormente para recuperación de espacio}

procedure leer(var jugadores: tArchivo; var aux: tJugador);
begin
  if not (eof(jugadores)) then
    read(jugadores, aux)
  else
    aux.dni := valorAlto;
end;

procedure agregarJugador(var jugadores: tArchivo; jugador: tJugador);
var
  ind: tJugador;
begin
  reset(jugadores);
  leer(jugadores, ind);
  if (ind.dni <> valorAlto) then begin
    if (ind.dni < 0) then begin
      seek(jugadores, Abs(ind.dni));
      read(jugadores, ind);
      seek(jugadores, filepos(jugadores)-1);
      write(jugadores, jugador);
      seek(jugadores, filepos(0));
      write(jugadores, ind);
    end
    else begin
      // si no hay lugar libre agrego al final
      seek(jugadores, filesize(jugadores));
      write(jugadores, jugador);
    end;
  end;
  close(jugadores);
end;

{Abre el archivo y elimina el jugador con el dni recibido como parámetro (si existe), manteniendo la política descripta anteriormente}

procedure eliminarJugador(var jugadores: tArchivo; jugador: tJugador);
var
cab, ind: tJugador;
begin
  reset(jugadores);
  leer(jugadores, cab);
  leer(jugadores, ind);
  while (ind.dni <> valorAlto) and (ind.dni <> jugador.dni) do
    leer(jugadores, ind);
  if (ind.dni <> valorAlto) then begin
    seek(jugadores, filepos(jugadores)-1);
    ind.dni := -(filepos(jugadores));
    write(jugadores, cab);
    seek(jugadores, 0);
    write(jugadores, ind);
  end
  else
    writeln('No se encontro jugador en el archivo')
  close(jugadores);
end;