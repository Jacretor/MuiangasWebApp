package com.muiangas.model;

import java.util.Date;

public class Avaliacao {
    private int    id;
    private int    clienteId;
    private String clienteNome;
    private int    pedidoId;
    private int    estrelas;
    private String comentario;
    private Date   dataAvalia;

    public int     getId()                  { return id; }
    public void    setId(int id)            { this.id = id; }

    public int     getClienteId()               { return clienteId; }
    public void    setClienteId(int clienteId)  { this.clienteId = clienteId; }

    public String  getClienteNome()                   { return clienteNome; }
    public void    setClienteNome(String clienteNome) { this.clienteNome = clienteNome; }

    public int     getPedidoId()                { return pedidoId; }
    public void    setPedidoId(int pedidoId)    { this.pedidoId = pedidoId; }

    public int     getEstrelas()                { return estrelas; }
    public void    setEstrelas(int estrelas)    { this.estrelas = estrelas; }

    public String  getComentario()                    { return comentario; }
    public void    setComentario(String comentario)   { this.comentario = comentario; }

    public Date    getDataAvalia()                    { return dataAvalia; }
    public void    setDataAvalia(Date dataAvalia)     { this.dataAvalia = dataAvalia; }
}
