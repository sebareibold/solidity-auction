# solidity-auction

Smart contracts para un sistema de subastas descentralizado implementado en Solidity sobre Ethereum.

## Descripcion

Proyecto academico desarrollado para la materia **Topicos Formales en Criptografia** de la Facultad de Informatica, Universidad Nacional del Comahue (2026).

El sistema implementa una plataforma descentralizada para la **Casa de Subastas Digitales "Isla Null"**, permitiendo crear subastas, recibir ofertas en ETH, determinar ganadores y retornar fondos a participantes no ganadores, sin necesidad de una autoridad central.

## Tecnologias

- **Lenguaje:** Solidity `^0.8.x`
- **Plataforma:** Ethereum (EVM)
- **IDE:** [Remix](https://remix.ethereum.org)
- **Simulacion:** JavaScript VM (sin deploy real en blockchain)

## Estructura del Proyecto

```
solidity-auction/
├── contracts/
│   ├── CasaDeSubastas.sol       # Contrato base con logica general de subastas
│   ├── SubastaVehiculos.sol     # Subgrupo A: subastas de vehiculos (marca, modelo, patente)
│   ├── SubastaObrasDeArte.sol   # Subgrupo B: subastas de obras de arte (identificacion, autor, certificado)
│   └── SubastaInmuebles.sol     # Subgrupo C: subastas de inmuebles (partida catastral, direccion, superficie)
└── README.md
```

## Arquitectura

El sistema esta organizado en herencia de contratos:

- **`CasaDeSubastas`** — contrato base con toda la logica central:
  - Crear subastas (con deposito minimo de 500 wei)
  - Realizar ofertas en ETH (deben superar la oferta maxima actual)
  - Finalizar subastas y transferir fondos al creador
  - Retirar fondos para postores no ganadores (patron pull payment)
  - Eliminar subastas sin ofertas activas
  - Modificar fecha de cierre e item de subastas sin ofertas
  - Cambiar el propietario del contrato

- **`SubastaVehiculos`** — extiende `CasaDeSubastas` con:
  - Campos: marca, modelo, patente
  - `obtenerVehiculo(idSubasta)`: consulta informacion del vehiculo
  - `registrarTransferencia(idSubasta)`: registra al ganador como nuevo propietario
  - `obtenerPropietarioActual(idSubasta)`: consulta quien es el propietario actual

- **`SubastaObrasDeArte`** — extiende `CasaDeSubastas` con:
  - Campos: identificacion de la obra, autor, certificado de autenticidad
  - `obtenerObraDeArte(idSubasta)`: consulta informacion de la obra
  - `registrarTransferencia(idSubasta)`: registra la transferencia de propiedad al ganador
  - `obtenerPropietarioActual(idSubasta)`: consulta quien es el propietario actual

- **`SubastaInmuebles`** — extiende `CasaDeSubastas` con:
  - Campos: partida catastral, direccion, superficie (m2)
  - `obtenerInmueble(idSubasta)`: consulta informacion del inmueble
  - `registrarTransferencia(idSubasta)`: registra la adjudicacion al ganador
  - `obtenerPropietarioActual(idSubasta)`: consulta quien es el propietario actual

## Funcionalidades Principales

- Crear subastas indicando el bien, valor minimo y fecha de finalizacion
- Realizar ofertas en ETH que deben superar la oferta mas alta registrada
- Consultar la oferta maxima actual y el mejor postor
- Finalizar subastas y determinar automaticamente al ganador
- Retirar fondos para participantes cuyas ofertas fueron superadas
- Registrar la transferencia del bien al ganador una vez finalizada la subasta

## Como Ejecutarlo

1. Abrir [Remix IDE](https://remix.ethereum.org)
2. Importar todos los contratos de la carpeta `contracts/`
3. Compilar con Solidity `^0.8.x`
4. Desplegar el contrato del tipo de subasta deseado usando el entorno JavaScript VM
5. Interactuar con el contrato desde la interfaz de Remix

## Autores

Proyecto realizado por 3 integrantes del Grupo Davor-Bautista-Sebastian:

| Apellido y Nombre | Legajo | GitHub |
|-------------------|--------|--------|
| Reibold, Sebastian Alejandro | FAI-3854 | [@sebareibold](https://github.com/sebareibold) |
| Fernandez Gramajo, Bautista | FAI-3874 | [@bautistafg](https://github.com/bautistafg) |
| Kissner, Davor | FAI-3185 | [@Davidenko01](https://github.com/Davidenko01) |

## Licencia

Proyecto de uso academico — Universidad Nacional del Comahue, 2026.
