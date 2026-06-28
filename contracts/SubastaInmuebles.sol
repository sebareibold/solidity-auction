// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./CasaDeSubastas.sol";

contract SubastaInmuebles is CasaDeSubastas {

    // ------------------ Estructura ------------------
    struct Inmueble {
        string partidaCatastral;
        string direccion;
        uint256 superficieM2;
    }

    // ------------------ Variables de Estado ------------------
    mapping(uint256 => Inmueble) public lst_inmuebles;
    mapping(uint256 => address) public propietarioActual;

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
        string memory partidaCatastral,
        string memory direccion,
        uint256 superficieM2
    ) payable public {
        require(bytes(partidaCatastral).length > 0, "La partida catastral no puede estar vacia.");
        require(bytes(direccion).length > 0, "La direccion no puede estar vacia.");
        require(superficieM2 > 0, "La superficie debe ser mayor a cero.");

        super.crearSubasta(idItem, ofertaMinima, fechaCierre);

        lst_inmuebles[contadorSubastas - 1] = Inmueble({
            partidaCatastral: partidaCatastral,
            direccion: direccion,
            superficieM2: superficieM2
        });
    }

    // Consultar la informacion del inmueble
    function obtenerInmueble(uint256 idSubasta) public view subastaExiste(idSubasta) returns (Inmueble memory) {
        return lst_inmuebles[idSubasta];
    }

    // Consultar el propietario actual (ganador) del inmueble
    function obtenerPropietarioActual(uint256 idSubasta) public view subastaExiste(idSubasta) returns (address) {
        return propietarioActual[idSubasta];
    }

    // Registrar la adjudicacion del inmueble al ganador
    function registrarTransferencia(uint256 idSubasta) public subastaExiste(idSubasta) {
        Subasta storage subasta = lst_subastas[idSubasta];

        require(subasta.finalizada, "La subasta aun no fue finalizada.");
        require(subasta.mejorPostor != address(0), "La subasta no tuvo ofertas, no hay ganador.");
        require(propietarioActual[idSubasta] == address(0), "La adjudicacion ya fue registrada.");
        require(
            msg.sender == subasta.mejorPostor ||
            msg.sender == subasta.creador     ||
            msg.sender == propietario,
            "Solo el ganador, el creador o el propietario pueden registrar la adjudicacion."
        );

        propietarioActual[idSubasta] = subasta.mejorPostor;
    }
}
