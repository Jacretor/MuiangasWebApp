package com.muiangas.dao;

import com.muiangas.model.Categoria;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO para operações CRUD sobre a tabela categorias.
 */
public class CategoriaDAO {

    /** @return lista de todas as categorias ordenadas por nome */
    public List<Categoria> listarTodas() throws SQLException {
        List<Categoria> lista = new ArrayList<>();
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement("SELECT * FROM categorias ORDER BY nome");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(mapear(rs));
        } finally { DBUtil.close(conn); }
        return lista;
    }

    /** @return categoria pelo ID ou null */
    public Categoria buscarPorId(int id) throws SQLException {
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement("SELECT * FROM categorias WHERE id=?")) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapear(rs);
            }
        } finally { DBUtil.close(conn); }
        return null;
    }

    /** Insere uma nova categoria. */
    public void inserir(Categoria c) throws SQLException {
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement("INSERT INTO categorias (nome, descricao) VALUES (?,?)")) {
            ps.setString(1, c.getNome());
            ps.setString(2, c.getDescricao());
            ps.executeUpdate();
        } finally { DBUtil.close(conn); }
    }

    /** Actualiza uma categoria existente. */
    public void actualizar(Categoria c) throws SQLException {
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement("UPDATE categorias SET nome=?, descricao=? WHERE id=?")) {
            ps.setString(1, c.getNome());
            ps.setString(2, c.getDescricao());
            ps.setInt(3, c.getId());
            ps.executeUpdate();
        } finally { DBUtil.close(conn); }
    }

    /** Remove uma categoria pelo ID. */
    public void eliminar(int id) throws SQLException {
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement("DELETE FROM categorias WHERE id=?")) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } finally { DBUtil.close(conn); }
    }

    private Categoria mapear(ResultSet rs) throws SQLException {
        return new Categoria(rs.getInt("id"), rs.getString("nome"), rs.getString("descricao"));
    }
}
