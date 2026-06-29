// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./CasaDeSubastas.sol";

contract SubastaVehiculos is CasaDeSubastas {

    // ------------------ Estructura ------------------
    struct Vehiculo {
        string marca;
        string modelo;
        string patente;
    }

    // ------------------ Variables de Estado ------------------
    mapping(uint256 => Vehiculo) public lst_vehiculos;
    // Registra la direccion del ganador una vez confirmada la transferencia.
    // address(0) significa que el vehiculo aun no fue transferido.
    mapping(uint256 => address) public propietarioActual;


    // ------------------ Funciones ------------------

    // Anulamos la funcion base para que no se pueda crear una subasta sin datos del vehiculo
    function crearSubasta(uint256, uint256, uint256) payable public override {
        revert("Debe usar crearSubasta con los datos del vehiculo.");
    }

    // Crear una subasta de vehiculo
    function crearSubasta(
        uint256 idItem,
        uint256 ofertaMinima,
        uint256 fechaCierre,
        string memory marca,
        string memory modelo,
        string memory patente
    ) payable public {
        require(bytes(marca).length > 0, "La marca no puede estar vacia.");
        require(bytes(modelo).length > 0, "El modelo no puede estar vacio.");
        require(bytes(patente).length > 0, "La patente no puede estar vacia.");

        // Ejecuta toda la logica del contrato base
        super.crearSubasta(idItem, ofertaMinima, fechaCierre);

        // Guarda los datos del vehiculo asociados a la subasta recien creada
        lst_vehiculos[contadorSubastas - 1] = Vehiculo({
            marca: marca,
            modelo: modelo,
            patente: patente
        });
    }

    // Consultar la informacion completa del vehiculo subastado
    function obtenerVehiculo(uint256 idSubasta) public view subastaExiste(idSubasta) returns (Vehiculo memory) {
        return lst_vehiculos[idSubasta];
    }

    // Registrar la transferencia del vehiculo al ganador
    function registrarTransferencia(uint256 idSubasta) public subastaExiste(idSubasta) {
        Subasta storage subasta = lst_subastas[idSubasta];

        require(subasta.finalizada, "La subasta debe estar finalizada para transferir.");
        require(
            msg.sender == subasta.creador || msg.sender == propietario || msg.sender == subasta.mejorPostor,
            "Solo el creador o el propietario pueden registrar la transferencia."
        );
        require(subasta.mejorPostor != address(0), "No hubo ganador en la subasta.");
        require(propietarioActual[idSubasta] == address(0), "El vehiculo ya fue transferido.");

        propietarioActual[idSubasta] = subasta.mejorPostor;
    }

    // Consultar el propietario actual (ganador) del vehiculo
    function obtenerPropietarioActual(uint256 idSubasta) public view subastaExiste(idSubasta) returns (address) {
        return propietarioActual[idSubasta];
    }

}
