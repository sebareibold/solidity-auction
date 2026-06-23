# solidity-auction

Smart contract para un sistema de subastas descentralizado implementado en Solidity sobre Ethereum.

## Descripción

Proyecto académico desarrollado para la materia **Tópicos Formales en Criptografía** de la Facultad de Informática, Universidad Nacional del Comahue (2026).

El contrato implementa un sistema de subastas descentralizado para la **Casa de Subastas Digitales "Isla Null"**, permitiendo a los usuarios crear subastas, realizar ofertas en ETH y recuperar fondos, sin necesidad de una autoridad central.

## Tecnologías

- **Lenguaje:** Solidity `^0.8.x`
- **Plataforma:** Ethereum (EVM)
- **IDE:** [Remix](https://remix.ethereum.org)

## Funcionalidades

- Crear subastas con un valor mínimo y fecha de finalización
- Realizar ofertas en ETH (deben superar la oferta más alta registrada)
- Consultar la oferta más alta actual
- Finalizar subastas y determinar al ganador
- Retirar fondos para los participantes no ganadores

## Estructura del Proyecto

```
solidity-auction/
├── contracts/
│   └── Auction.sol        # Contrato base
├── docs/
│   └── informe.pdf        # Informe académico
└── README.md
```

## Cómo Ejecutarlo

1. Abrir [Remix IDE](https://remix.ethereum.org)
2. Importar `contracts/Auction.sol`
3. Compilar con Solidity `^0.8.x`
4. Desplegar usando el entorno JavaScript VM
5. Interactuar con el contrato desde la interfaz de Remix

## Autores

| Apellido y Nombre | Legajo |
|-------------------|--------|
| Reibold, Sebastian Alejandro | FAI-3854 |
| Fernandez Gramajo, Bautista | FAI-3874 |
| Kissner, Davor | FAI-3185 |

## Licencia

Proyecto de uso académico.