package com.muiangas.dao;

import com.muiangas.model.PedidoDelivery;
import com.muiangas.model.ZonaDelivery;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DeliveryDAO {

    // ── ZONAS ─────────────────────────────────────────────────────────────────

    public List<ZonaDelivery> listarZonasAtivas() throws SQLException {
        List<ZonaDelivery> lista = new ArrayList<>();
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(
                "SELECT * FROM zonas_delivery WHERE ativo=1 ORDER BY nome");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(mapZona(rs));
        } finally { DBUtil.close(conn); }
        return lista;
    }

    public ZonaDelivery buscarZonaPorId(int id) throws SQLException {
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(
                "SELECT * FROM zonas_delivery WHERE id=?")) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapZona(rs);
            }
        } finally { DBUtil.close(conn); }
        return null;
    }

    // ── PEDIDOS ───────────────────────────────────────────────────────────────

    public int inserirPedido(PedidoDelivery p) throws SQLException {
        String sql = "INSERT INTO pedidos_delivery " +
            "(cliente_id, cliente_nome, cliente_telefone, zona_id, morada, latitude, longitude, " +
            " itens, total, taxa_entrega, status, metodo_pagamento, pagamento_status, observacoes) " +
            "VALUES (?,?,?,?,?,?,?,?,?,?,'pendente',?,?,?)";
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            if (p.getClienteId() > 0) ps.setInt(1, p.getClienteId()); else ps.setNull(1, Types.INTEGER);
            ps.setString(2,  p.getClienteNome());
            ps.setString(3,  p.getClienteTelefone());
            ps.setInt(4,     p.getZonaId());
            ps.setString(5,  p.getMorada());
            if (p.getLatitude()  != null) ps.setDouble(6, p.getLatitude());  else ps.setNull(6, Types.DECIMAL);
            if (p.getLongitude() != null) ps.setDouble(7, p.getLongitude()); else ps.setNull(7, Types.DECIMAL);
            ps.setString(8,  p.getItens());
            ps.setBigDecimal(9,  p.getTotal());
            ps.setBigDecimal(10, p.getTaxaEntrega());
            ps.setString(11, p.getMetodoPagamento() != null ? p.getMetodoPagamento() : "dinheiro");
            String pgStatus = "dinheiro".equals(p.getMetodoPagamento()) ? "aprovado" : "pendente";
            ps.setString(12, pgStatus);
            ps.setString(13, p.getObservacoes());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        } finally { DBUtil.close(conn); }
        return -1;
    }

    public void actualizarStatus(int id, String novoStatus) throws SQLException {
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(
                "UPDATE pedidos_delivery SET status=? WHERE id=?")) {
            ps.setString(1, novoStatus);
            ps.setInt(2, id);
            ps.executeUpdate();
        } finally { DBUtil.close(conn); }
    }

    public void aprovarPagamento(int id) throws SQLException {
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(
                "UPDATE pedidos_delivery SET pagamento_status='aprovado' WHERE id=?")) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } finally { DBUtil.close(conn); }
    }

    public void rejeitarPagamento(int id) throws SQLException {
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(
                "UPDATE pedidos_delivery SET pagamento_status='rejeitado' WHERE id=?")) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } finally { DBUtil.close(conn); }
    }

    public void guardarComprovativo(int id, String path) throws SQLException {
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(
                "UPDATE pedidos_delivery SET comprovativo_path=?, pagamento_status='comprovativo_enviado' WHERE id=?")) {
            ps.setString(1, path);
            ps.setInt(2, id);
            ps.executeUpdate();
        } finally { DBUtil.close(conn); }
    }

    public PedidoDelivery buscarPorId(int id) throws SQLException {
        String sql = "SELECT p.*, z.nome AS zona_nome FROM pedidos_delivery p " +
                     "LEFT JOIN zonas_delivery z ON p.zona_id = z.id WHERE p.id=?";
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapPedido(rs);
            }
        } finally { DBUtil.close(conn); }
        return null;
    }

    public List<PedidoDelivery> listarPorCliente(int clienteId) throws SQLException {
        String sql = "SELECT p.*, z.nome AS zona_nome FROM pedidos_delivery p " +
                     "LEFT JOIN zonas_delivery z ON p.zona_id = z.id " +
                     "WHERE p.cliente_id=? ORDER BY p.data_hora DESC";
        List<PedidoDelivery> lista = new ArrayList<>();
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clienteId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(mapPedido(rs));
            }
        } finally { DBUtil.close(conn); }
        return lista;
    }

    public List<PedidoDelivery> listarPorPeriodo(String inicio, String fim) throws SQLException {
        String sql = "SELECT p.*, z.nome AS zona_nome FROM pedidos_delivery p " +
                     "LEFT JOIN zonas_delivery z ON p.zona_id = z.id " +
                     "WHERE DATE(p.data_hora) BETWEEN ? AND ? " +
                     "ORDER BY p.data_hora DESC";
        List<PedidoDelivery> lista = new ArrayList<>();
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, inicio);
            ps.setString(2, fim);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(mapPedido(rs));
            }
        } finally { DBUtil.close(conn); }
        return lista;
    }

    public List<PedidoDelivery> listarPedidos(String filtroStatus) throws SQLException {
        String sql = "SELECT p.*, z.nome AS zona_nome FROM pedidos_delivery p " +
                     "LEFT JOIN zonas_delivery z ON p.zona_id = z.id ";
        if (filtroStatus != null && !filtroStatus.isEmpty() && !"todos".equals(filtroStatus)) {
            sql += "WHERE p.status=? ";
        }
        sql += "ORDER BY p.data_hora DESC";
        List<PedidoDelivery> lista = new ArrayList<>();
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            if (filtroStatus != null && !filtroStatus.isEmpty() && !"todos".equals(filtroStatus)) {
                ps.setString(1, filtroStatus);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(mapPedido(rs));
            }
        } finally { DBUtil.close(conn); }
        return lista;
    }

    public BigDecimal totalVendasHoje() throws SQLException {
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(
                "SELECT COALESCE(SUM(total),0) FROM pedidos_delivery " +
                "WHERE DATE(data_hora)=CURDATE() AND status='entregue'");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getBigDecimal(1);
        } finally { DBUtil.close(conn); }
        return BigDecimal.ZERO;
    }

    public int contarHoje() throws SQLException {
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(
                "SELECT COUNT(*) FROM pedidos_delivery WHERE DATE(data_hora)=CURDATE()");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } finally { DBUtil.close(conn); }
        return 0;
    }

    public int contarPendentes() throws SQLException {
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(
                "SELECT COUNT(*) FROM pedidos_delivery WHERE status='pendente'");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } finally { DBUtil.close(conn); }
        return 0;
    }

    public int contarComComprovativo() throws SQLException {
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(
                "SELECT COUNT(*) FROM pedidos_delivery WHERE pagamento_status='comprovativo_enviado'");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } finally { DBUtil.close(conn); }
        return 0;
    }

    // ── MAPPERS ───────────────────────────────────────────────────────────────

    private PedidoDelivery mapPedido(ResultSet rs) throws SQLException {
        PedidoDelivery p = new PedidoDelivery();
        p.setId(rs.getInt("id"));
        p.setClienteNome(rs.getString("cliente_nome"));
        p.setClienteTelefone(rs.getString("cliente_telefone"));
        p.setZonaId(rs.getInt("zona_id"));
        p.setZonaNome(rs.getString("zona_nome"));
        p.setMorada(rs.getString("morada"));
        p.setItens(rs.getString("itens"));
        p.setTotal(rs.getBigDecimal("total"));
        p.setTaxaEntrega(rs.getBigDecimal("taxa_entrega"));
        p.setStatus(rs.getString("status"));
        p.setMetodoPagamento(rs.getString("metodo_pagamento"));
        p.setPagamentoStatus(rs.getString("pagamento_status"));
        p.setComprovativoPath(rs.getString("comprovativo_path"));
        p.setObservacoes(rs.getString("observacoes"));
        p.setDataHora(rs.getTimestamp("data_hora"));
        double lat = rs.getDouble("latitude");
        if (!rs.wasNull()) p.setLatitude(lat);
        double lng = rs.getDouble("longitude");
        if (!rs.wasNull()) p.setLongitude(lng);
        return p;
    }

    private ZonaDelivery mapZona(ResultSet rs) throws SQLException {
        ZonaDelivery z = new ZonaDelivery();
        z.setId(rs.getInt("id"));
        z.setNome(rs.getString("nome"));
        z.setTaxaEntrega(rs.getBigDecimal("taxa_entrega"));
        z.setAtivo(rs.getBoolean("ativo"));
        return z;
    }
}
