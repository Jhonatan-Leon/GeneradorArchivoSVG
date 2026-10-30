Code.require_file("Util2.ex", __DIR__)
defmodule Circulo do
  @moduledoc """
  Genera un archivo SVG con círculos concéntricos, aplicando
  recursividad para la creación de los dibujos.

  ## Funciones
  - solicitar_datos: pide los datos al usuario
  - generar: calcula el tamaño y arma el SVG
  - dibujar: función recursiva que crea un círculo por llamada
  - circulo: genera la etiqueta <circle> de un círculo (como dibujar_celda)
  - color: define el color según el radio (como color_celda)
  - mostrar: guarda el archivo e informa el resultado
  """

  @margen 10
  @archivo "circulos.svg"

  def main do
    {cantidad, reduccion, radio} = solicitar_datos()
    svg = generar(cantidad, reduccion, radio)
    mostrar(svg)
  end

  def solicitar_datos do
    IO.puts("Ingrese los datos solicitados para crear los círculos: ")
    cantidad = Util2.ingresar("Cantidad de círculos: ", :entero)
    reduccion = Util2.ingresar("Reducción del radio en cada círculo: ", :entero)
    radio = Util2.ingresar("Radio del círculo inicial: ", :entero)

    {cantidad, reduccion, radio}
  end

  @doc """
  generar calcula el tamaño, carga los círculos y devuelve el texto del SVG.

  ## Parámetros
  - cantidad: cuántos círculos se van a crear (depende del radio)
  - reduccion: cuánto se resta al radio entre cada círculo
  - radio: radio del círculo inicial

  ## Ejemplos
  - generar(10, 15, 200)
  - generar(20, 8)
  - generar(5, 30, 150)
  """
  def generar(cantidad \\ 10, reduccion \\ 15, radio \\ 200) do
    lado = 2 * radio + 2 * @margen
    centro = radio + @margen

    circulos = dibujar(centro, centro, radio, cantidad, reduccion)

    """
    <svg xmlns="http://www.w3.org/2000/svg"
         width="#{lado}" height="#{lado}"
         viewBox="0 0 #{lado} #{lado}">
      <rect width="100%" height="100%" fill="black"/>
    #{circulos}</svg>
    """
  end

  @doc """
  dibujar crea los círculos de forma recursiva.

  ## Parámetros
  - cx, cy: posición horizontal y vertical del centro
  - radio: distancia del centro a un punto del círculo
  - faltan: cuántos círculos faltan por dibujar
  - reduccion: lo que se resta al radio en cada llamada
  """
  def dibujar(_cx, _cy, _radio, 0, _reduccion), do: ""
  def dibujar(_cx, _cy, radio, _faltan, _reduccion) when radio <= 0, do: ""

  def dibujar(cx, cy, radio, faltan, reduccion) when faltan > 0 do
    siguiente_radio = radio - reduccion

    circulo(cx, cy, radio) <>
      dibujar(cx, cy, siguiente_radio, faltan - 1, reduccion)
  end

  # Dibujo de un círculo (se cuenta como una celda en cada creación)
  defp circulo(cx, cy, radio) do
    color = color(radio)

    """
      <circle cx="#{cx}" cy="#{cy}" r="#{radio}"
              fill="none" stroke="#{color}"
              stroke-width="2"/>
    """
  end

  # Se escoge el color de manera individual por cada círculo creado
  defp color(radio) do
    tono = rem(round(radio * 1.8), 360)
    "hsl(#{tono}, 75%, 60%)"
  end

  def mostrar(svg) do
    File.write!(@archivo, svg)

    IO.puts("\nImagen creada: #{@archivo}")
  end


end

Circulo.main()
