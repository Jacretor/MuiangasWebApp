package com.muiangas.model;

import java.math.BigDecimal;

public class ZonaDelivery {
    private int id;
    private String nome;
    private BigDecimal taxaEntrega;
    private boolean ativo;

    public ZonaDelivery() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }
    public BigDecimal getTaxaEntrega() { return taxaEntrega; }
    public void setTaxaEntrega(BigDecimal taxaEntrega) { this.taxaEntrega = taxaEntrega; }
    public boolean isAtivo() { return ativo; }
    public void setAtivo(boolean ativo) { this.ativo = ativo; }
}
