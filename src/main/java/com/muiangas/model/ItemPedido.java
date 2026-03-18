package com.muiangas.model;

import java.math.BigDecimal;

/** Representa um item (linha) de um pedido. */
public class ItemPedido {
    private int id;
    private int pedidoId;
    private int produtoId;
    private String produtoNome; // auxiliar
    private int quantidade;
    private BigDecimal precoUnitario;

    public ItemPedido() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getPedidoId() { return pedidoId; }
    public void setPedidoId(int pedidoId) { this.pedidoId = pedidoId; }
    public int getProdutoId() { return produtoId; }
    public void setProdutoId(int produtoId) { this.produtoId = produtoId; }
    public String getProdutoNome() { return produtoNome; }
    public void setProdutoNome(String produtoNome) { this.produtoNome = produtoNome; }
    public int getQuantidade() { return quantidade; }
    public void setQuantidade(int quantidade) { this.quantidade = quantidade; }
    public BigDecimal getPrecoUnitario() { return precoUnitario; }
    public void setPrecoUnitario(BigDecimal precoUnitario) { this.precoUnitario = precoUnitario; }

    /** @return subtotal do item (preço × quantidade) */
    public BigDecimal getSubtotal() {
        if (precoUnitario == null) return BigDecimal.ZERO;
        return precoUnitario.multiply(BigDecimal.valueOf(quantidade));
    }
}
