// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract CasaDeSubastas {

    // ------------------ Variables de Estado ------------------
    address public propietario;
    uint256 public contadorSubastas;

    mapping(uint256 => Subasta) public lst_subastas;
    mapping(uint256 => mapping(address => uint256)) public retirosPendientes;

    // ------------------ Estructura ------------------
    struct Subasta {
        uint256 id;
        uint256 idItem;
        address creador;
        uint256 ofertaMinima;
        uint256 fechaCierre;
        uint256 ofertaMaxima;
        address mejorPostor;
        bool finalizada;
        bool eliminada;
    }

    // ------------------ Modifiers ------------------
    modifier soloPropietario() {
        require(msg.sender == propietario, "No eres el propietario.");
        _;
    }

    modifier subastaExiste(uint256 idSubasta) {
        require(lst_subastas[idSubasta].creador != address(0), "La subasta no existe.");
        _;
    }

    // ------------------ Constructor ------------------
    constructor() {
        propietario = msg.sender;
        contadorSubastas = 0;
    }

    // ------------------ Funciones ------------------

    // Obtener una subasta por id
    function obtenerSubasta(uint256 id) public view subastaExiste(id) returns (Subasta memory) {
        return lst_subastas[id];
    }

    // Crear una subasta
    function crearSubasta(uint256 idItem, uint256 ofertaMinima, uint256 fechaCierre) payable public virtual {
        require(msg.value >= 500, "Debes enviar al menos 500 wei para crear una subasta.");
        require(ofertaMinima > 0, "El valor minimo de oferta debe ser mayor a cero.");
        require(fechaCierre > block.timestamp, "La fecha de cierre debe ser mayor a la fecha actual.");

        lst_subastas[contadorSubastas] = Subasta({
            id: contadorSubastas,
            idItem: idItem,
            creador: msg.sender,
            ofertaMinima: ofertaMinima,
            fechaCierre: fechaCierre,
            ofertaMaxima: 0,
            mejorPostor: address(0),
            finalizada: false,
            eliminada: false
        });

        (bool ok, ) = payable(propietario).call{value: msg.value}("");
        require(ok, "Transferencia fallida.");

        contadorSubastas++;
    }

    // Realizar una oferta
    function realizarOferta(uint256 idSubasta) payable public subastaExiste(idSubasta) {
        Subasta storage subasta = lst_subastas[idSubasta];

        require(msg.value >= subasta.ofertaMinima, "La oferta debe ser mayor o igual al valor minimo de oferta.");
        require(msg.value > subasta.ofertaMaxima, "La oferta debe superar la oferta mas alta actual.");
        require(block.timestamp < subasta.fechaCierre, "La fecha de cierre de la subasta ya paso.");
        require(!subasta.finalizada, "La subasta ya fue finalizada.");
        require(!subasta.eliminada, "La subasta fue eliminada.");

        if (subasta.mejorPostor != address(0)) {
            retirosPendientes[idSubasta][subasta.mejorPostor] += subasta.ofertaMaxima;
        }

        subasta.ofertaMaxima = msg.value;
        subasta.mejorPostor = msg.sender;
    }

    // Finalizar una subasta
    function finalizarSubasta(uint256 idSubasta) public subastaExiste(idSubasta) {
        Subasta storage subasta = lst_subastas[idSubasta];

        require(!subasta.finalizada, "La subasta ya fue finalizada.");
        require(!subasta.eliminada, "La subasta fue eliminada.");
        require(
            msg.sender == subasta.creador || msg.sender == propietario,
            "Solo el creador o el propietario pueden finalizar la subasta."
        );
        require(
            block.timestamp >= subasta.fechaCierre || msg.sender == subasta.creador,
            "La subasta no ha llegado a su fecha de cierre."
        );

        subasta.finalizada = true;

        if (subasta.mejorPostor != address(0)) {
            (bool ok, ) = payable(subasta.creador).call{value: subasta.ofertaMaxima}("");
            require(ok, "Transferencia fallida.");
        }
    }

    // Retirar fondos de ofertas superadas
    function retirarFondos(uint256 idSubasta) public subastaExiste(idSubasta) {
        uint256 monto = retirosPendientes[idSubasta][msg.sender];
        require(monto > 0, "No tienes fondos para retirar.");

        retirosPendientes[idSubasta][msg.sender] = 0;

        (bool ok, ) = payable(msg.sender).call{value: monto}("");
        require(ok, "Transferencia fallida.");
    }

    // Eliminar una subasta
    function eliminarSubasta(uint256 idSubasta) public subastaExiste(idSubasta) {
        Subasta storage subasta = lst_subastas[idSubasta];

        require(
            msg.sender == subasta.creador || msg.sender == propietario,
            "Solo el creador o el propietario pueden eliminar la subasta."
        );
        require(!subasta.finalizada, "No se puede eliminar una subasta finalizada.");
        require(!subasta.eliminada, "La subasta ya fue eliminada.");
        require(subasta.ofertaMaxima == 0, "No se puede eliminar una subasta con ofertas activas.");

        subasta.eliminada = true;
    }

    // Modificar una subasta existente
    function modificarSubasta(uint256 idSubasta, uint256 nuevaFechaCierre, uint256 nuevoIdItem)
        public subastaExiste(idSubasta) {
        Subasta storage subasta = lst_subastas[idSubasta];

        require(
            msg.sender == subasta.creador || msg.sender == propietario,
            "Solo el creador o el propietario pueden modificar la subasta."
        );
        require(!subasta.finalizada, "No se puede modificar una subasta finalizada.");
        require(!subasta.eliminada, "No se puede modificar una subasta eliminada.");
        require(subasta.ofertaMaxima == 0, "No se puede modificar una subasta con ofertas activas.");
        require(nuevaFechaCierre > block.timestamp, "La nueva fecha de cierre debe ser mayor a la fecha actual.");

        subasta.fechaCierre = nuevaFechaCierre;
        subasta.idItem = nuevoIdItem;
    }

    // Cambiar el propietario del contrato
    function cambiarPropietario(address nuevoPropietario) public soloPropietario {
        require(nuevoPropietario != address(0), "La nueva direccion no puede ser vacia.");
        propietario = nuevoPropietario;
    }
}