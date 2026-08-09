@def title = "Clase 1 - AN"
@def hasmenu = true
@def menu_numerico = true

# Clase 1

## Discretización de derivadas

Una forma natural de aproximar la derivada de una función $u$ en un punto $x$ es a partir de su definición como límite, reemplazando el límite por un cociente incremental con un paso $h$ finito. Según qué puntos se usen, se obtienen distintas discretizaciones:

- **Diferencias hacia adelante (forward):** $u'(x) \approx \frac{u(x+h)-u(x)}{h}$
- **Diferencias hacia atrás (backward):** $u'(x) \approx \frac{u(x)-u(x-h)}{h}$
- **Diferencias centradas:** $u'(x) \approx \frac{u(x+h)-u(x-h)}{2h}$

Estas tres opciones se pueden implementar en una única función, seleccionando el método por un argumento:

```julia
function derivada(u,x;method="forward",h=0.01)
    if method == "forward"
        return (u(x+h)-u(x))/h
    elseif method == "backward"
        return (u(x)-u(x+h))/h
    elseif method == "centradas"
        return (u(x+h)-u(x-h))/(2h)
    end
end

function u(x)
    return sin(x)
end

function ∇u(x)
    return cos(x)
end
```

Tomando $u(x) = \sin(x)$, cuya derivada exacta es $\cos(x)$, podemos comparar la aproximación numérica de $u'(1)$ contra el valor exacto para distintos tamaños de paso $h$, y así estimar el **orden de convergencia** de cada método: el exponente $p$ tal que el error se comporta como $\mathcal{O}(h^p)$.

```julia
function orden(u,∇u,x;method="forward")
    h=[0.1,0.01,0.001,0.0001]
    error = zeros(length(h))
    for i=1:length(h)
        error[i]=∇u(x)-derivada(u,x,h=h[i],method=method)
    end
    println("orden: ",polyfit(log.(h),log.(error),1)[1])
    plot(log.(h),log.(error))
end
```

**Método forward:**

```julia
orden(u,∇u,1)
```

```plaintext
orden: 1.0027318905612974
```

~~~
<img src="/assets/numerico/clase_1/orden_forward.svg" alt="Orden de convergencia - diferencias forward" class="cover-img">
~~~

Como se ve, las diferencias forward (y backward) tienen **orden 1**: el error decrece linealmente con $h$.

**Método de diferencias centradas:**

```julia
orden(u,∇u,1,method="centradas")
```

```plaintext
orden: 1.9999453615526088
```

~~~
<img src="/assets/numerico/clase_1/orden_centradas.svg" alt="Orden de convergencia - diferencias centradas" class="cover-img">
~~~

Las diferencias centradas, en cambio, alcanzan **orden 2**: para el mismo $h$, el error es sensiblemente menor. Esto se debe a que el término de orden $h$ en el desarrollo de Taylor se cancela al combinar $u(x+h)$ y $u(x-h)$ simétricamente.

## Problemas de valores de contorno: capa límite

Consideremos la ecuación

$$ \varepsilon u_{xx} - u_x = f, \qquad u(0) = \alpha, \quad u(1) = \beta. $$

Para el caso $f(x) = 1$, la solución exacta está dada por

$$ u_\varepsilon(x) = \alpha + x + (\beta - \alpha - 1) \left( \frac{e^{x/\varepsilon}-1}{e^{1/\varepsilon}-1} \right). $$

> **Nota:** una ecuación de esta forma aparece, por ejemplo, al considerar el estado estacionario ($u_t = 0$) de un problema de convección-difusión $u_t = \kappa u_{xx} + a u_x + \phi$, con difusividad $\kappa > 0$ y convección $a \in \mathbb{R}$. A la proporción $Pe = a/\kappa$ se la conoce como **número de Péclet**, y se toma $\varepsilon = 1/Pe$.

```julia
function u_ε(x,ε;α=1,β=3)
    y=α+x+(β-α-1)*((ℯ^(x/ε)-1)/(ℯ^(1/ε)-1))
    return y
end
```

Graficando la solución exacta para $\alpha=1$, $\beta=3$ a medida que $\varepsilon \to 0$:

```julia
x=0:0.01:1

plot(x,u_ε.(x,0.3),label="epsilon=0.3")
plot!(x,u_ε.(x,0.1),label="epsilon=0.1")
plot!(x,u_ε.(x,0.05),label="epsilon=0.05")
plot!(x,u_ε.(x,0.01),label="epsilon=0.01")
```

~~~
<img src="/assets/numerico/clase_1/capa_limite_epsilon.svg" alt="Solución exacta para distintos epsilon" class="cover-img">
~~~

A medida que $\varepsilon$ disminuye, la solución desarrolla una transición cada vez más abrupta cerca del borde $x=1$: es la **capa límite**, una región angosta donde la solución cambia muy rápido mientras que en el resto del dominio se mantiene casi constante.

### Resolución numérica

Discretizando con diferencias centradas tanto la derivada primera como la segunda, sobre una malla de tamaño $h$, se obtiene un sistema lineal tridiagonal para los valores interiores de $u$:

```julia
function capa_limite(f,N;ε=0.3,α=1,β=3)

    h=1/N
    x=0:h:1
    n=length(x)
    U=zeros(n)
    U[1]=α
    U[n]=β
    A1=(ε/h^2)*Tridiagonal(ones(n-3),-2*ones(n-2),ones(n-3))
    A2=(1/2h)*Tridiagonal(-ones(n-3),zeros(n-2),ones(n-3))
    F=f.(x)[2:n-1]
    F[1]=F[1]-ε*α/h^2+α/2h
    F[end]=F[end]-ε*β/h^2-β/2h

    A=A1-A2
    sol=A\F
    U[2:n-1]=sol
    return U
end

function f(x)
    return -1.0
end
```

Comparando la solución numérica con la solución exacta para $\varepsilon = 0.1$ y $N=100$:

```julia
ε=0.1
N=100
x=0:1/N:1
U=capa_limite(f,N,ε=ε)
plot(x,U,label="solucion numerica")
plot!(x,u_ε.(x,ε),label="solucion exacta")
```

~~~
<img src="/assets/numerico/clase_1/capa_limite_solucion.svg" alt="Solución numérica vs exacta" class="cover-img">
~~~

La aproximación numérica reproduce bien tanto la zona suave como la capa límite cerca de $x=1$, siempre que la malla sea suficientemente fina en relación a $\varepsilon$ (si $h \gg 2\varepsilon$, el esquema deja de resolver correctamente la capa límite y aparecen oscilaciones espurias).


[← Volver](/numerico/)