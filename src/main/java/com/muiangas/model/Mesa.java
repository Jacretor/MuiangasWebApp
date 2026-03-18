package com.muiangas.model;

/** Entidade Mesa do restaurante. */
public class Mesa {
    private int id;
    private int numero;
    private int capacidade;
    private String status; // livre | ocupada | reservada

    public Mesa() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getNumero() { return numero; }
    public void setNumero(int numero) { this.numero = numero; }
    public int getCapacidade() { return capacidade; }
    public void setCapacidade(int capacidade) { this.capacidade = capacidade; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
