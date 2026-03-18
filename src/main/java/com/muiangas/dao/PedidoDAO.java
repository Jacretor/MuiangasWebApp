package com.muiangas.dao;

import com.muiangas.model.ItemPedido;
import com.muiangas.model.Pedido;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO para gestão completa de pedidos e itens_pedido.
 */
public class PedidoDAO {

    /**
     * Cria um novo pedido e devolve o ID gerado.
     * @param p pedido a criar
     * @return ID do pedido criado
     */
    public int criarPedido(Pedido p) throws SQLException {
        String sql = "INSERT INTO pedidos (mesa_id, cliente_id, funcionario_id, status, total) VALUES (?,?,?,'aberto',0)";
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, p.getMesaId());
            ps.setInt(2, p.getClienteId());
            ps.setInt(3, p.getFuncionarioId());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        } finally { DBUtil.close(conn); }
        return -1;
    }

    /**
     * Adiciona um item a um pedido existente.
     * @param item item a adicionar
     */
    public void adicionarItem(ItemPedido item) throws SQLException {
        String sql = "INSERT INTO itens_pedido (pedido_id, produto_id, quantidade, preco_unitario) VALUES (?,?,?,?)";
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, item.getPedidoId());
            ps.setInt(2, item.getProdutoId());
            ps.setInt(3, item.getQuantidade());
            ps.setBigDecimal(4, item.getPrecoUnitario());
            ps.executeUpdate();
        } finally { DBUtil.close(conn); }
        recalcularTotal(item.getPedidoId());
    }

    /**
     * Fecha um pedido: actualiza status para 'pago' e liberta a mesa.
     * @param pedidoId ID do pedido a fechar
     */
    public void fecharPedido(int pedidoId) throws SQLException {
        Connection conn = DBUtil.getConnection();
        try {
            conn.setAutoCommit(false);
            // 1. Obter mesa do pedido
            int mesaId = -1;
            try (PreparedStatement ps = conn.prepareStatement("SELECT mesa_id FROM pedidos WHERE id=?")) {
                ps.setInt(1, pedidoId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) mesaId = rs.getInt("mesa_id");
                }
            }
            // 2. Marcar pedido como pago
            try (PreparedStatement ps = conn.prepareStatement("UPDATE pedidos SET status='pago' WHERE id=?")) {
                ps.setInt(1, pedidoId);
                ps.executeUpdate();
            }
            // 3. Libertar mesa
            if (mesaId > 0) {
                try (PreparedStatement ps = conn.prepareStatement("UPDATE mesas SET status='livre' WHERE id=?")) {
                    ps.setInt(1, mesaId);
                    ps.executeUpdate();
                }
            }
            conn.commit();
        } catch (SQLException e) {
            conn.rollback();
            throw e;
        } finally {
            conn.setAutoCommit(true);
            DBUtil.close(conn);
        }
    }

    /**
     * Recalcula e actualiza o total de um pedido.
     * @param pedidoId ID do pedido
     */
    public void recalcularTotal(int pedidoId) throws SQLException {
        String sql = "UPDATE pedidos SET total = (SELECT COALESCE(SUM(quantidade * preco_unitario),0) FROM itens_pedido WHERE pedido_id=?) WHERE id=?";
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, pedidoId);
            ps.setInt(2, pedidoId);
            ps.executeUpdate();
        } finally { DBUtil.close(conn); }
    }

    /** @return pedido pelo ID com itens incluídos */
    public Pedido buscarPorId(int id) throws SQLException {
        String sql = "SELECT p.*, m.numero AS mesa_numero, c.nome AS cliente_nome, f.nome AS func_nome " +
                     "FROM pedidos p LEFT JOIN mesas m ON p.mesa_id=m.id " +
                     "LEFT JOIN clientes c ON p.cliente_id=c.id " +
                     "LEFT JOIN funcionarios f ON p.funcionario_id=f.id WHERE p.id=?";
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Pedido p = mapear(rs);
                    p.setItens(listarItensPorPedido(id));
                    return p;
                }
            }
        } finally { DBUtil.close(conn); }
        return null;
    }

    /** @return lista de pedidos abertos do dia */
    public List<Pedido> listarAbertos() throws SQLException {
        List<Pedido> lista = new ArrayList<>();
        String sql = "SELECT p.*, m.numero AS mesa_numero, c.nome AS cliente_nome, f.nome AS func_nome " +
                     "FROM pedidos p LEFT JOIN mesas m ON p.mesa_id=m.id " +
                     "LEFT JOIN clientes c ON p.cliente_id=c.id " +
                     "LEFT JOIN funcionarios f ON p.funcionario_id=f.id " +
                     "WHERE p.status='aberto' ORDER BY p.data_hora DESC";
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(mapear(rs));
        } finally { DBUtil.close(conn); }
        return lista;
    }

    /**
     * Lista pedidos filtrados por datas para relatórios.
     * @param dataInicio data início (YYYY-MM-DD)
     * @param dataFim data fim (YYYY-MM-DD)
     */
    public List<Pedido> listarPorPeriodo(String dataInicio, String dataFim) throws SQLException {
        List<Pedido> lista = new ArrayList<>();
        String sql = "SELECT p.*, m.numero AS mesa_numero, c.nome AS cliente_nome, f.nome AS func_nome " +
                     "FROM pedidos p LEFT JOIN mesas m ON p.mesa_id=m.id " +
                     "LEFT JOIN clientes c ON p.cliente_id=c.id " +
                     "LEFT JOIN funcionarios f ON p.funcionario_id=f.id " +
                     "WHERE DATE(p.data_hora) BETWEEN ? AND ? ORDER BY p.data_hora DESC";
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, dataInicio);
            ps.setString(2, dataFim);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(mapear(rs));
            }
        } finally { DBUtil.close(conn); }
        return lista;
    }

    /** @return total de vendas do dia actual */
    public BigDecimal totalVendasHoje() throws SQLException {
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(
                "SELECT COALESCE(SUM(total),0) FROM pedidos WHERE status='pago' AND DATE(data_hora)=CURDATE()");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getBigDecimal(1);
        } finally { DBUtil.close(conn); }
        return BigDecimal.ZERO;
    }

    /** @return número de pedidos abertos */
    public int contarAbertos() throws SQLException {
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM pedidos WHERE status='aberto'");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } finally { DBUtil.close(conn); }
        return 0;
    }

    /** @return itens de um pedido com nome do produto */
    public List<ItemPedido> listarItensPorPedido(int pedidoId) throws SQLException {
        List<ItemPedido> lista = new ArrayList<>();
        String sql = "SELECT ip.*, p.nome AS prod_nome FROM itens_pedido ip " +
                     "LEFT JOIN produtos p ON ip.produto_id=p.id WHERE ip.pedido_id=?";
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, pedidoId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ItemPedido item = new ItemPedido();
                    item.setId(rs.getInt("id"));
                    item.setPedidoId(rs.getInt("pedido_id"));
                    item.setProdutoId(rs.getInt("produto_id"));
                    item.setProdutoNome(rs.getString("prod_nome"));
                    item.setQuantidade(rs.getInt("quantidade"));
                    item.setPrecoUnitario(rs.getBigDecimal("preco_unitario"));
                    lista.add(item);
                }
            }
        } finally { DBUtil.close(conn); }
        return lista;
    }

    private Pedido mapear(ResultSet rs) throws SQLException {
        Pedido p = new Pedido();
        p.setId(rs.getInt("id"));
        p.setMesaId(rs.getInt("mesa_id"));
        p.setClienteId(rs.getInt("cliente_id"));
        p.setFuncionarioId(rs.getInt("funcionario_id"));
        p.setDataHora(rs.getTimestamp("data_hora"));
        p.setStatus(rs.getString("status"));
        p.setTotal(rs.getBigDecimal("total"));
        try { p.setMesaNumero(rs.getInt("mesa_numero")); } catch (SQLException ignored) {}
        try { p.setClienteNome(rs.getString("cliente_nome")); } catch (SQLException ignored) {}
        try { p.setFuncionarioNome(rs.getString("func_nome")); } catch (SQLException ignored) {}
        return p;
    }
}
