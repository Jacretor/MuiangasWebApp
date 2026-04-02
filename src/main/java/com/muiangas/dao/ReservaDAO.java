package com.muiangas.dao;

import com.muiangas.model.Reserva;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO para operações sobre a tabela reservas.
 */
public class ReservaDAO {

    /** Insere uma nova reserva de mesa. */
    public void inserir(Reserva r) throws SQLException {
        String sql = "INSERT INTO reservas (nome_cliente, telefone, data_reserva, hora_reserva, num_pessoas) VALUES (?,?,?,?,?)";
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, r.getNomeCliente());
            ps.setString(2, r.getTelefone());
            ps.setDate(3, r.getDataReserva());
            ps.setTime(4, r.getHoraReserva());
            ps.setInt(5, r.getNumPessoas());
            ps.executeUpdate();
        } finally { DBUtil.close(conn); }
    }

    /** @return todas as reservas pendentes ordenadas por data */
    public List<Reserva> listarPendentes() throws SQLException {
        List<Reserva> lista = new ArrayList<>();
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(
                "SELECT * FROM reservas WHERE status='pendente' ORDER BY data_reserva, hora_reserva");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(mapear(rs));
        } finally { DBUtil.close(conn); }
        return lista;
    }


    private void alterarStatus(int id, String status) throws SQLException {
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement("UPDATE reservas SET status=? WHERE id=?")) {
            ps.setString(1, status);
            ps.setInt(2, id);
            ps.executeUpdate();
        } finally { DBUtil.close(conn); }
    }
    
    /**
     * Marca como 'nao_compareceu' reservas confirmadas/pendentes
     * cuja hora já passou há mais de 15 minutos.
     * @return número de reservas marcadas
     */
    public int marcarExpiradas() throws SQLException {
        String sql = "UPDATE reservas SET status='nao_compareceu' " +
                     "WHERE status IN ('pendente','confirmada') " +
                     "AND TIMESTAMP(data_reserva, hora_reserva) < DATE_SUB(NOW(), INTERVAL 15 MINUTE)";
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            return ps.executeUpdate();
        } finally { DBUtil.close(conn); }
    }

    /**
     * Verifica se cliente tem 3+ não comparências — bloquear reservas
     */
    public boolean clienteBloqueadoParaReservas(int clienteId) throws SQLException {
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(
                "SELECT COUNT(*) FROM reservas WHERE cliente_id=? AND status='nao_compareceu'")) {
            ps.setInt(1, clienteId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) >= 3;
            }
        } finally { DBUtil.close(conn); }
        return false;
    }
    
    /** Marca reserva como não compareceu */
    public void marcarNaoCompareceu(int id) throws SQLException {
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(
                "UPDATE reservas SET status='nao_compareceu' WHERE id=?")) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } finally { DBUtil.close(conn); }
    }

    /** Confirmar reserva */
    public void confirmar(int id) throws SQLException {
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(
                "UPDATE reservas SET status='confirmada' WHERE id=?")) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } finally { DBUtil.close(conn); }
    }

    /** Cancelar reserva */
    public void cancelar(int id) throws SQLException {
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(
                "UPDATE reservas SET status='cancelada' WHERE id=?")) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } finally { DBUtil.close(conn); }
    }

    /** Listar todas as reservas ordenadas por data */
    public List<Reserva> listarTodas() throws SQLException {
        List<Reserva> lista = new ArrayList<>();
        String sql = "SELECT r.*, c.nome AS cliente_nome_conta FROM reservas r " +
                     "LEFT JOIN clientes c ON r.cliente_id = c.id " +
                     "ORDER BY r.data_reserva DESC, r.hora_reserva DESC";
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(mapear(rs));
        } finally { DBUtil.close(conn); }
        return lista;
    }

    /** Listar reservas de um cliente específico */
    public List<Reserva> listarPorCliente(int clienteId) throws SQLException {
        List<Reserva> lista = new ArrayList<>();
        String sql = "SELECT * FROM reservas WHERE cliente_id=? ORDER BY data_reserva DESC, hora_reserva DESC";
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clienteId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(mapear(rs));
            }
        } finally { DBUtil.close(conn); }
        return lista;
    }



    private Reserva mapear(ResultSet rs) throws SQLException {
        Reserva r = new Reserva();
        r.setId(rs.getInt("id"));
        r.setNomeCliente(rs.getString("nome_cliente"));
        r.setTelefone(rs.getString("telefone"));
        r.setDataReserva(rs.getDate("data_reserva"));
        r.setHoraReserva(rs.getTime("hora_reserva"));
        r.setNumPessoas(rs.getInt("num_pessoas"));
        r.setStatus(rs.getString("status"));
        r.setDataCriacao(rs.getTimestamp("data_criacao"));
        return r;
    }
}
