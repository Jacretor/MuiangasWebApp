package com.muiangas.model;

import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;

/** Entidade que representa uma reserva de mesa feita pelo cliente. */
public class Reserva {
    private int       id;
    private int       clienteId;      // 0 se não logado
    private String    nomeCliente;
    private String    telefone;
    private Date      dataReserva;
    private Time      horaReserva;
    private int       numPessoas;
    private String    observacoes;
    private String    status;         // pendente | confirmada | cancelada | nao_compareceu
    private Timestamp dataCriacao;

    public Reserva() {}

    public int       getId()                        { return id; }
    public void      setId(int id)                  { this.id = id; }

    public int       getClienteId()                 { return clienteId; }
    public void      setClienteId(int clienteId)    { this.clienteId = clienteId; }

    public String    getNomeCliente()               { return nomeCliente; }
    public void      setNomeCliente(String n)       { this.nomeCliente = n; }

    public String    getTelefone()                  { return telefone; }
    public void      setTelefone(String t)          { this.telefone = t; }

    public Date      getDataReserva()               { return dataReserva; }
    public void      setDataReserva(Date d)         { this.dataReserva = d; }

    public Time      getHoraReserva()               { return horaReserva; }
    public void      setHoraReserva(Time h)         { this.horaReserva = h; }

    public int       getNumPessoas()                { return numPessoas; }
    public void      setNumPessoas(int n)           { this.numPessoas = n; }

    public String    getObservacoes()               { return observacoes; }
    public void      setObservacoes(String o)       { this.observacoes = o; }

    public String    getStatus()                    { return status; }
    public void      setStatus(String s)            { this.status = s; }

    public Timestamp getDataCriacao()               { return dataCriacao; }
    public void      setDataCriacao(Timestamp ts)   { this.dataCriacao = ts; }
}
