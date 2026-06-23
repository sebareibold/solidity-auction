# Bitácora

## Paso 1: Crear el esqueleto del contrato

Primero comenzamos escribiendo el esqueleto básico del contrato inteligente en Solidity.

```solidity
// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract Auction {

}
```

### // SPDX-License-Identifier: GPL-3.0
Es un comentario especial que declara la licencia del código. SPDX es un estándar internacional para identificar licencias de software de forma legible por máquinas. GPL-3.0 indica que el código es open source bajo la licencia GNU General Public License versión 3.

Si no lo ponés, el compilador de Solidity no falla, pero lanza un warning: SPDX license identifier not provided in source file. Funciona igual, pero es mala práctica omitirlo porque en blockchain todo el código es público, entonces declarar la licencia explícitamente es importante.

### pragma solidity ^0.8.0;

Le dice al compilador qué versión de Solidity puede usar para compilar este archivo. El ^ significa "esta versión o superior dentro de la misma versión mayor", es decir, acepta 0.8.0, 0.8.1, 0.8.35, etc., pero no 0.9.x ni 1.x.x.
Si no lo ponés, el compilador sí falla, es obligatorio. Sin él no sabe con qué reglas compilar el código.

### contract Auction { }
Define el contrato. Es análogo a una class en orientación a objetos, agrupa datos y funciones bajo un mismo nombre. Todo lo que va adentro de las llaves pertenece al contrato.
Si no lo ponés, no existe el contrato. Es la declaración principal, sin ella no hay nada.