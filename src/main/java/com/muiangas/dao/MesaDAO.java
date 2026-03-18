package com.muiangas.dao;

import com.muiangas.model.Mesa;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO para operações sobre a tabela mesas.
 */
public class MesaDAO {

    /** @return todas as mesas ordenadas por número */
    public List<Mesa> listarTodas() throws SQLException {
        List<Mesa> lista = new ArrayList<>();
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement("SELECT * FROM mesas ORDER BY numero");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(mapear(rs));
        } finally { DBUtil.close(conn); }
        return lista;
    }

    /** @return apenas as mesas com status 'livre' */
    public List<Mesa> listarLivres() throws SQLException {
        List<Mesa> lista = new ArrayList<>();
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement("SELECT * FROM mesas WHERE status='livre' ORDER BY numero");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(mapear(rs));
        } finally { DBUtil.close(conn); }
        return lista;
    }

    /** @return mesa pelo ID ou null */
    public Mesa buscarPorId(int id) throws SQLException {
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement("SELECT * FROM mesas WHERE id=?")) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapear(rs);
            }
        } finally { DBUtil.close(conn); }
        return null;
    }

    /** Insere uma nova mesa. */
    public void inserir(Mesa m) throws SQLException {
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement("INSERT INTO mesas (numero, capacidade, status) VALUES (?,?,?)")) {
            ps.setInt(1, m.getNumero());
            ps.setInt(2, m.getCapacidade());
            ps.setString(3, m.getStatus() != null ? m.getStatus() : "livre");
            ps.executeUpdate();
        } finally { DBUtil.close(conn); }
    }

    /** Actualiza os dados de uma mesa. */
    public void actualizar(Mesa m) throws SQLException {
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement("UPDATE mesas SET numero=?, capacidade=?, status=? WHERE id=?")) {
            ps.setInt(1, m.getNumero());
            ps.setInt(2, m.getCapacidade());
            ps.setString(3, m.getStatus());
            ps.setInt(4, m.getId());
            ps.executeUpdate();
        } finally { DBUtil.close(conn); }
    }
    
    /** Elimina uma mesa pelo ID. Lança excepção se tiver pedidos associados. */
    public void eliminar(int id) throws SQLException {
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(
                "DELETE FROM mesas WHERE id=?")) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } finally { DBUtil.close(conn); }
    }


    /**
     * Altera apenas o status de uma mesa.
     * @param id ID da mesa
     * @param status novo status (livre | ocupada | reservada)
     */
    public void alterarStatus(int id, String status) throws SQLException {
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement("UPDATE mesas SET status=? WHERE id=?")) {
            ps.setString(1, status);
            ps.setInt(2, id);
            ps.executeUpdate();
        } finally { DBUtil.close(conn); }
    }

    /** Conta mesas por status. */
    public int contarPorStatus(String status) throws SQLException {
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM mesas WHERE status=?")) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } finally { DBUtil.close(conn); }
        return 0;
    }

    private Mesa mapear(ResultSet rs) throws SQLException {
        Mesa m = new Mesa();
        m.setId(rs.getInt("id"));
        m.setNumero(rs.getInt("numero"));
        m.setCapacidade(rs.getInt("capacidade"));
        m.setStatus(rs.getString("status"));
        return m;
    }
}
