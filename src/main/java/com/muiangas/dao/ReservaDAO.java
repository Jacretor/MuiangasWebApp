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

    /** @return todas as reservas */
    public List<Reserva> listarTodas() throws SQLException {
        List<Reserva> lista = new ArrayList<>();
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(
                "SELECT * FROM reservas ORDER BY data_reserva DESC, hora_reserva DESC");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(mapear(rs));
        } finally { DBUtil.close(conn); }
        return lista;
    }

    /** Confirma uma reserva. */
    public void confirmar(int id) throws SQLException {
        alterarStatus(id, "confirmada");
    }

    /** Cancela uma reserva. */
    public void cancelar(int id) throws SQLException {
        alterarStatus(id, "cancelada");
    }

    private void alterarStatus(int id, String status) throws SQLException {
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement("UPDATE reservas SET status=? WHERE id=?")) {
            ps.setString(1, status);
            ps.setInt(2, id);
            ps.executeUpdate();
        } finally { DBUtil.close(conn); }
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
