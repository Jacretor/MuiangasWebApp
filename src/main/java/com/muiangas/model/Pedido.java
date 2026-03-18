package com.muiangas.model;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;

/**
 * Entidade Pedido - representa um pedido activo ou histórico.
 */
public class Pedido {
    private int id;
    private int mesaId;
    private int clienteId;
    private int funcionarioId;
    private Timestamp dataHora;
    private String status; // aberto | pago | cancelado
    private BigDecimal total;

    // Campos auxiliares para listagens
    private int mesaNumero;
    private String clienteNome;
    private String funcionarioNome;
    private List<ItemPedido> itens;

    public Pedido() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getMesaId() { return mesaId; }
    public void setMesaId(int mesaId) { this.mesaId = mesaId; }
    public int getClienteId() { return clienteId; }
    public void setClienteId(int clienteId) { this.clienteId = clienteId; }
    public int getFuncionarioId() { return funcionarioId; }
    public void setFuncionarioId(int funcionarioId) { this.funcionarioId = funcionarioId; }
    public Timestamp getDataHora() { return dataHora; }
    public void setDataHora(Timestamp dataHora) { this.dataHora = dataHora; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public BigDecimal getTotal() { return total; }
    public void setTotal(BigDecimal total) { this.total = total; }
    public int getMesaNumero() { return mesaNumero; }
    public void setMesaNumero(int mesaNumero) { this.mesaNumero = mesaNumero; }
    public String getClienteNome() { return clienteNome; }
    public void setClienteNome(String clienteNome) { this.clienteNome = clienteNome; }
    public String getFuncionarioNome() { return funcionarioNome; }
    public void setFuncionarioNome(String funcionarioNome) { this.funcionarioNome = funcionarioNome; }
    public List<ItemPedido> getItens() { return itens; }
    public void setItens(List<ItemPedido> itens) { this.itens = itens; }
}