package com.muiangas.model;

public class EnderecoCliente {
    private int    id;
    private int    clienteId;
    private String nome;       // "Casa", "Trabalho", etc.
    private String morada;
    private int    zonaId;
    private String zonaNome;
    private boolean predefinido;

    public int     getId()                  { return id; }
    public void    setId(int id)            { this.id = id; }

    public int     getClienteId()               { return clienteId; }
    public void    setClienteId(int clienteId)  { this.clienteId = clienteId; }

    public String  getNome()              { return nome; }
    public void    setNome(String nome)   { this.nome = nome; }

    public String  getMorada()                { return morada; }
    public void    setMorada(String morada)   { this.morada = morada; }

    public int     getZonaId()              { return zonaId; }
    public void    setZonaId(int zonaId)    { this.zonaId = zonaId; }

    public String  getZonaNome()                  { return zonaNome; }
    public void    setZonaNome(String zonaNome)   { this.zonaNome = zonaNome; }

    public boolean isPredefinido()                  { return predefinido; }
    public void    setPredefinido(boolean pred)     { this.predefinido = pred; }
}
