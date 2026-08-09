"""
    hfun_sidebar_optimizacion()

Renders the left sidebar navigation for the /optimizacion/ section.
Called from the layout templates as {{ sidebar_optimizacion }}.
Update this list as you add real pages (clase_2, labo_1, etc.).
"""
function hfun_sidebar_optimizacion()
    io = IOBuffer()
    write(io, """
    <nav class="sidebar-nav">
    <details class="sidebar-group" open>
        <summary class="sidebar-section">Clases prácticas</summary>
        <ul>
          <li><a href="/optimizacion/clase_1/">Clase 1</a></li>
        </ul>
      </details>
      <details class="sidebar-group" open>
        <summary class="sidebar-section">Laboratorio</summary>
        <ul>
          <li><a href="/optimizacion/intro_julia/">Introducción a Julia</a></li>
          <li><a href="/optimizacion/labo_1/">Cuadrados Mínimos: Ajuste de círculos</a></li>
          <li><a href="/optimizacion/labo_2/">Aproximación de gradiente y método de descenso</a></li>
          <li><a href="/optimizacion/labo_3/">Gauss - Newton: Ajuste geométrico</a></li>
          <li><a href="/optimizacion/labo_4/">Redes Neuronales: Aplicación de Descenso por Gradiente</a></li>
          <li><a href="/optimizacion/labo_5/">Perfil de Desempeño</a></li>
          <li><a href="/optimizacion/labo_6/">Modificación Levenberg-Marquardt para método de Newton</a></li>
          <li><a href="/optimizacion/labo_7/">Optimización con restricciones: Método de penalidad</a></li>
          <li><a href="/optimizacion/labo_8/">Heurísticas</a></li>
        </ul>
      </details>
      <ul>
        <li><a href="/optimizacion/references/">Bibliografía</a></li>
      </ul>
    </nav>
    """)
    return String(take!(io))
end

function hfun_sidebar_numerico()
    io = IOBuffer()
    write(io, """
    <nav class="sidebar-nav">
      <p class="sidebar-title">Análisis Numérico</p>
      <ul>
        <li><a href="/numerico/">Introducción</a></li>
      </ul>
      <details class="sidebar-group" open>
        <summary class="sidebar-section">Clases de Laboratorio</summary>
        <ul>
          <li><a href="/numerico/clase_1/">Clase 1</a></li>
        </ul>
      </details>
    </nav>
    """)
    return String(take!(io))
end