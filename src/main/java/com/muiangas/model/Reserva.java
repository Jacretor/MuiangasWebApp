package com.muiangas.model;

import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;

/** Entidade que representa uma reserva de mesa feita pelo cliente. */
public class Reserva {
    private int id;
    private String nomeCliente;
    private String telefone;
    private Date dataReserva;
    private Time horaReserva;
    private int numPessoas;
    private String status; // pendente | confirmada | cancelada
    private Timestamp dataCriacao;

    public Reserva() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getNomeCliente() { return nomeCliente; }
    public void setNomeCliente(String nomeCliente) { this.nomeCliente = nomeCliente; }
    public String getTelefone() { return telefone; }
    public void setTelefone(String telefone) { this.telefone = telefone; }
    public Date getDataReserva() { return dataReserva; }
    public void setDataReserva(Date dataReserva) { this.dataReserva = dataReserva; }
    public Time getHoraReserva() { return horaReserva; }
    public void setHoraReserva(Time horaReserva) { this.horaReserva = horaReserva; }
    public int getNumPessoas() { return numPessoas; }
    public void setNumPessoas(int numPessoas) { this.numPessoas = numPessoas; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Timestamp getDataCriacao() { return dataCriacao; }
    public void setDataCriacao(Timestamp dataCriacao) { this.dataCriacao = dataCriacao; }
}