package com.muiangas.dao;

import com.muiangas.model.Categoria;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoriaDAO {

    /** Verifica se a categoria tem produtos associados */
    public boolean temProdutosAssociados(int categoriaId) throws SQLException {
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(
                "SELECT COUNT(*) FROM produtos WHERE categoria_id=?")) {
            ps.setInt(1, categoriaId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } finally { DBUtil.close(conn); }
        return false;
    }

    /**
     * Elimina categoria de forma segura:
     * 1. Garante que existe categoria "Outros" para receber produtos órfãos
     * 2. Move todos os produtos da categoria a eliminar para "Outros"
     * 3. Elimina a categoria
     */
    public void eliminarComSeguranca(int id) throws SQLException {
        Connection conn = DBUtil.getConnection();
        try {
            conn.setAutoCommit(false);

            // 1. Obter ou criar categoria "Outros"
            int outrosId = obterOuCriarOutros(conn);

            // 2. Mover produtos para "Outros" (se não for já a própria categoria Outros)
            if (id != outrosId) {
                try (PreparedStatement ps = conn.prepareStatement(
                        "UPDATE produtos SET categoria_id=? WHERE categoria_id=?")) {
                    ps.setInt(1, outrosId);
                    ps.setInt(2, id);
                    ps.executeUpdate();
                }
            }

            // 3. Eliminar a categoria
            try (PreparedStatement ps = conn.prepareStatement(
                    "DELETE FROM categorias WHERE id=?")) {
                ps.setInt(1, id);
                ps.executeUpdate();
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

    /** Obtém o ID da categoria "Outros", criando-a se não existir */
    private int obterOuCriarOutros(Connection conn) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(
                "SELECT id FROM categorias WHERE nome='Outros' LIMIT 1");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt("id");
        }
        // Criar categoria Outros
        try (PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO categorias (nome, descricao) VALUES ('Outros', 'Produtos sem categoria')",
                Statement.RETURN_GENERATED_KEYS)) {
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return -1;
    }

    public List<Categoria> listarTodas() throws SQLException {
        List<Categoria> lista = new ArrayList<>();
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement("SELECT * FROM categorias ORDER BY nome");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(mapear(rs));
        } finally { DBUtil.close(conn); }
        return lista;
    }

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

    public void inserir(Categoria c) throws SQLException {
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO categorias (nome, descricao) VALUES (?,?)")) {
            ps.setString(1, c.getNome());
            ps.setString(2, c.getDescricao());
            ps.executeUpdate();
        } finally { DBUtil.close(conn); }
    }

    public void actualizar(Categoria c) throws SQLException {
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(
                "UPDATE categorias SET nome=?, descricao=? WHERE id=?")) {
            ps.setString(1, c.getNome());
            ps.setString(2, c.getDescricao());
            ps.setInt(3, c.getId());
            ps.executeUpdate();
        } finally { DBUtil.close(conn); }
    }

    public void eliminar(int id) throws SQLException {
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(
                "DELETE FROM categorias WHERE id=?")) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } finally { DBUtil.close(conn); }
    }

    private Categoria mapear(ResultSet rs) throws SQLException {
        return new Categoria(rs.getInt("id"), rs.getString("nome"), rs.getString("descricao"));
    }
}
