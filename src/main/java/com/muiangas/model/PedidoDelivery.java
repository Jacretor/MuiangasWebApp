package com.muiangas.model;

import java.math.BigDecimal;
import java.util.Date;

public class PedidoDelivery {
    private int id;
    private int clienteId;  // 0 se não logado
    private String clienteNome;
    private String clienteTelefone;
    private int zonaId;
    private String zonaNome;
    private String morada;
    private Double latitude;
    private Double longitude;
    private String itens;
    private BigDecimal total;
    private BigDecimal taxaEntrega;
    private String status;
    private String metodoPagamento;   // mpesa, emola, dinheiro
    private String pagamentoStatus;   // pendente, comprovativo_enviado, aprovado, rejeitado
    private String comprovativoPath;  // caminho da imagem
    private String observacoes;
    private Date dataHora;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getClienteId() { return clienteId; }
    public void setClienteId(int clienteId) { this.clienteId = clienteId; }

    public String getClienteNome() { return clienteNome; }
    public void setClienteNome(String clienteNome) { this.clienteNome = clienteNome; }

    public String getClienteTelefone() { return clienteTelefone; }
    public void setClienteTelefone(String clienteTelefone) { this.clienteTelefone = clienteTelefone; }

    public int getZonaId() { return zonaId; }
    public void setZonaId(int zonaId) { this.zonaId = zonaId; }

    public String getZonaNome() { return zonaNome; }
    public void setZonaNome(String zonaNome) { this.zonaNome = zonaNome; }

    public String getMorada() { return morada; }
    public void setMorada(String morada) { this.morada = morada; }

    public Double getLatitude() { return latitude; }
    public void setLatitude(Double latitude) { this.latitude = latitude; }

    public Double getLongitude() { return longitude; }
    public void setLongitude(Double longitude) { this.longitude = longitude; }

    public String getItens() { return itens; }
    public void setItens(String itens) { this.itens = itens; }

    public BigDecimal getTotal() { return total; }
    public void setTotal(BigDecimal total) { this.total = total; }

    public BigDecimal getTaxaEntrega() { return taxaEntrega; }
    public void setTaxaEntrega(BigDecimal taxaEntrega) { this.taxaEntrega = taxaEntrega; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getMetodoPagamento() { return metodoPagamento; }
    public void setMetodoPagamento(String metodoPagamento) { this.metodoPagamento = metodoPagamento; }

    public String getPagamentoStatus() { return pagamentoStatus; }
    public void setPagamentoStatus(String pagamentoStatus) { this.pagamentoStatus = pagamentoStatus; }

    public String getComprovativoPath() { return comprovativoPath; }
    public void setComprovativoPath(String comprovativoPath) { this.comprovativoPath = comprovativoPath; }

    public String getObservacoes() { return observacoes; }
    public void setObservacoes(String observacoes) { this.observacoes = observacoes; }

    public Date getDataHora() { return dataHora; }
    public void setDataHora(Date dataHora) { this.dataHora = dataHora; }
}
