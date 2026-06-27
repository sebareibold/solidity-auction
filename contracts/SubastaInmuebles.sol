// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./CasaDeSubastas.sol";

contract SubastaInmuebles is CasaDeSubastas {

    // ------------------ Enum ------------------
    enum TipoPropiedad { Casa, Departamento, Terreno, Local, Oficina }

    // ------------------ Estructura ------------------
    struct Inmueble {
        uint256 superficieM2;
        uint256 cantHabitaciones;
        uint256 cantBanios;
        uint256 anioConstruccion;
        bool tieneGarage;
        TipoPropiedad tipoPropiedad;
    }

    // ------------------ Variables de Estado ------------------
    mapping(uint256 => Inmueble) public lst_inmuebles;

    // ------------------ Funciones ------------------

    // Anulamos la funcion base para que no se pueda crear una subasta sin datos del inmueble
    function crearSubasta(uint256, uint256, uint256) payable public override {
        revert("Debe usar crearSubasta con los datos del inmueble.");
    }

    // Crear una subasta de inmueble
    function crearSubasta(
        uint256 idItem,
        uint256 ofertaMinima,
        uint256 fechaCierre,
        uint256 superficieM2,
        uint256 cantHabitaciones,
        uint256 cantBanios,
        uint256 anioConstruccion,
        bool tieneGarage,
        TipoPropiedad tipoPropiedad
    ) payable public {
        require(superficieM2 > 0, "La superficie debe ser mayor a cero.");
        require(anioConstruccion >= 1900 && anioConstruccion <= 2026, "Anio de construccion invalido.");

        // Ejecuta toda la logica del contrato base
        super.crearSubasta(idItem, ofertaMinima, fechaCierre);

        // Guarda los datos del inmueble asociados a la subasta recien creada
        lst_inmuebles[contadorSubastas - 1] = Inmueble({
            superficieM2: superficieM2,
            cantHabitaciones: cantHabitaciones,
            cantBanios: cantBanios,
            anioConstruccion: anioConstruccion,
            tieneGarage: tieneGarage,
            tipoPropiedad: tipoPropiedad
        });
    }

    // Obtener los datos del inmueble de una subasta
    function obtenerInmueble(uint256 idSubasta) public view subastaExiste(idSubasta) returns (Inmueble memory) {
        return lst_inmuebles[idSubasta];
    }

    // Modificar los datos del inmueble
    function modificarInmueble(
        uint256 idSubasta,
        uint256 nuevaSuperficieM2,
        uint256 nuevaCantHabitaciones,
        uint256 nuevaCantBanios,
        uint256 nuevoAnioConstruccion,
        bool nuevoGarage,
        TipoPropiedad nuevoTipo
    ) public subastaExiste(idSubasta) {
        Subasta storage subasta = lst_subastas[idSubasta];

        require(
            msg.sender == subasta.creador || msg.sender == propietario,
            "Solo el creador o el propietario pueden modificar el inmueble."
        );
        require(!subasta.finalizada, "No se puede modificar un inmueble de subasta finalizada.");
        require(!subasta.eliminada, "No se puede modificar un inmueble de subasta eliminada.");
        require(subasta.ofertaMaxima == 0, "No se puede modificar con ofertas activas.");
        require(nuevaSuperficieM2 > 0, "La superficie debe ser mayor a cero.");
        require(nuevoAnioConstruccion >= 1900 && nuevoAnioConstruccion <= 2026, "Anio de construccion invalido.");

        Inmueble storage inmueble = lst_inmuebles[idSubasta];
        inmueble.superficieM2 = nuevaSuperficieM2;
        inmueble.cantHabitaciones = nuevaCantHabitaciones;
        inmueble.cantBanios = nuevaCantBanios;
        inmueble.anioConstruccion = nuevoAnioConstruccion;
        inmueble.tieneGarage = nuevoGarage;
        inmueble.tipoPropiedad = nuevoTipo;
    }
}