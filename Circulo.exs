defmodule Circulo do
  @moduledoc """
  Genera un archivo SVG con círculos concéntricos, aplicando
  recursividad para la creación de los dibujos

  ## Funciones
  - generar: calcula el tamaño, arma el SVG y lo guarda en un archivo
  - dibujar: función recursiva que crea un círculo por llamada
  - circulo: genera la etiqueta <circle> de un círculo (como dibujar_celda)
  - color: define el color según el radio (como color_celda)
  """
  @margen 10

  @doc """
  generar calcula el tamaño, carga los circulos, crea el archivo y lo guarda

  ## Parametros:
  - cantidad: cuantos circulos se van a crear ( depende del radio)
  - reducción: cuantas reducción hay entre cada circulo
  - radio: que radio contiene cada circulo
  - archivo: nombre del archivo que se va a crear cuando termine el proceso

  ## Ejemplo:
  - generar(10 círculos, 15 reducción, radio 200, circulos.svg)
  - generar(20 círculos, 8 reducción)
  - generar(5 círculos, 30 reducción, radio 150)

  """

  def generar(cantidad \\ 10, reduccion \\ 15, radio \\ 200, archivo \\ "circulos.svg") do
    lado = 2 * radio + 2 * @margen
    centro = radio + @margen

    circulos = dibujar(centro, centro, radio, cantidad, reduccion)

    svg = """
    <svg xmlns="http://www.w3.org/2000/svg"
         width="#{lado}" height="#{lado}"
         viewBox="0 0 #{lado} #{lado}">
      <rect width="100%" height="100%" fill="currentColor"/>
    #{circulos}</svg>
    """

    File.write!(archivo, svg)
    IO.puts("Imagen creada: #{archivo}")
  end

  @doc """
    dibujar función que crea los circulos según las llamadas establecidas por el usuario

    ## Parametros:
    - centro (cx, cy): posición horizontal y posición vertical
    - radio: Distancia del centro a un punto del circulo
    - faltan: cuantos circulos faltan
    - reduccion: la resta del radio en cada llamado
  """
  def dibujar(_cx, _cy, _radio, 0, _reduccion), do: ""
  def dibujar(_cx, _cy, radio, _faltan, _reduccion) when radio <= 0, do: ""
  def dibujar(cx, cy, radio, faltan, reduccion) when faltan > 0 do
    siguiente_radio = radio - reduccion

    circulo(cx, cy, radio) <>
      dibujar(cx, cy, siguiente_radio, faltan - 1, reduccion)
  end

  # Dibujo del círculo uno por uno ( se cuenta como una celda cada creación)
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
end


Circulo.generar(10, 20, 200)
