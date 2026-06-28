// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./CasaDeSubastas.sol";

contract SubastaObrasDeArte is CasaDeSubastas {

    // ------------------ Estructura ------------------
    struct ObraDeArte {
        string identificacion;
        string autor;
        string certificadoAutenticidad;
    }

    // ------------------ Variables de Estado ------------------
    mapping(uint256 => ObraDeArte) public lst_obras;
    mapping(uint256 => address) public propietarioActual;

    // ------------------ Funciones ------------------

    // Anulamos la función base para que no se pueda crear una subasta sin los datos de la obra
    function crearSubasta(uint256, uint256, uint256) payable public override {
        revert("Debe usar crearSubasta con los datos de la obra de arte.");
    }

    // Crear una subasta de obra de arte
    function crearSubasta(
        uint256 idItem,
        uint256 ofertaMinima,
        uint256 fechaCierre,
        string memory identificacion,
        string memory autor,
        string memory certificadoAutenticidad
    ) payable public {
        require(bytes(identificacion).length > 0, "La identificacion de la obra no puede estar vacia.");
        require(bytes(autor).length > 0, "El autor no puede estar vacio.");
        require(bytes(certificadoAutenticidad).length > 0, "El certificado de autenticidad no puede estar vacio.");

        super.crearSubasta(idItem, ofertaMinima, fechaCierre);

        lst_obras[contadorSubastas - 1] = ObraDeArte({
            identificacion: identificacion,
            autor: autor,
            certificadoAutenticidad: certificadoAutenticidad
        });
    }

    // Consultar la información de la obra
    function obtenerObraDeArte(uint256 idSubasta) public view subastaExiste(idSubasta) returns (ObraDeArte memory) {
        return lst_obras[idSubasta];
    }

    // Consultar el propietario actual (ganador) de la obra
    function obtenerPropietarioActual(uint256 idSubasta) public view subastaExiste(idSubasta) returns (address) {
        return propietarioActual[idSubasta];
    }

    // Registrar la transferencia de propiedad al ganador
    function registrarTransferencia(uint256 idSubasta) public subastaExiste(idSubasta) {
        Subasta storage subasta = lst_subastas[idSubasta];

        require(subasta.finalizada, "La subasta aun no fue finalizada.");
        require(subasta.mejorPostor != address(0), "La subasta no tuvo ofertas, no hay ganador.");
        require(propietarioActual[idSubasta] == address(0), "La transferencia ya fue registrada.");
        require(
            msg.sender == subasta.mejorPostor ||
            msg.sender == subasta.creador     ||
            msg.sender == propietario,
            "Solo el ganador, el creador o el propietario pueden registrar la transferencia."
        );

        propietarioActual[idSubasta] = subasta.mejorPostor;
    }
}