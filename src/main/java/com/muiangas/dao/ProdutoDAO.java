package com.muiangas.dao;

import com.muiangas.model.Produto;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO para operações CRUD sobre a tabela produtos.
 */
public class ProdutoDAO {
	
	 /** Verifica se o produto tem itens de pedido associados */
    public boolean temPedidosAssociados(int produtoId) throws SQLException {
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(
                "SELECT COUNT(*) FROM itens_pedido WHERE produto_id=?")) {
            ps.setInt(1, produtoId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } finally { DBUtil.close(conn); }
        return false;
    }

    /** Desactiva o produto em vez de eliminar (quando tem pedidos associados) */
    public void desactivar(int id) throws SQLException {
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(
                "UPDATE produtos SET disponivel=0 WHERE id=?")) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } finally { DBUtil.close(conn); }
    }
    
    /** Activa o produto — volta a aparecer no menu */
    public void activar(int id) throws SQLException {
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(
                "UPDATE produtos SET disponivel=1 WHERE id=?")) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } finally { DBUtil.close(conn); }
    }



    public List<Produto> listarTodos() throws SQLException {
        List<Produto> lista = new ArrayList<>();
        String sql = "SELECT p.*, c.nome AS cat_nome FROM produtos p " +
                     "LEFT JOIN categorias c ON p.categoria_id = c.id ORDER BY c.nome, p.nome";
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(mapear(rs));
        } finally { DBUtil.close(conn); }
        return lista;
    }

    public List<Produto> listarDisponiveis(int categoriaId) throws SQLException {
        List<Produto> lista = new ArrayList<>();
        String sql = categoriaId > 0
            ? "SELECT p.*, c.nome AS cat_nome FROM produtos p LEFT JOIN categorias c ON p.categoria_id=c.id WHERE p.disponivel=1 AND p.categoria_id=? ORDER BY p.nome"
            : "SELECT p.*, c.nome AS cat_nome FROM produtos p LEFT JOIN categorias c ON p.categoria_id=c.id WHERE p.disponivel=1 ORDER BY c.nome, p.nome";
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            if (categoriaId > 0) ps.setInt(1, categoriaId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(mapear(rs));
            }
        } finally { DBUtil.close(conn); }
        return lista;
    }
    
    public List<Produto> listarPorIds(List<Integer> ids) throws SQLException {
        if (ids == null || ids.isEmpty()) return new java.util.ArrayList<>();
        StringBuilder sb = new StringBuilder(
            "SELECT p.*, c.nome AS cat_nome FROM produtos p " +
            "LEFT JOIN categorias c ON p.categoria_id=c.id WHERE p.id IN (");
        for (int i = 0; i < ids.size(); i++) {
            sb.append(i == 0 ? "?" : ",?");
        }
        sb.append(") ORDER BY p.nome");
        List<Produto> lista = new java.util.ArrayList<>();
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(sb.toString())) {
            for (int i = 0; i < ids.size(); i++) ps.setInt(i + 1, ids.get(i));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(mapear(rs));
            }
        } finally { DBUtil.close(conn); }
        return lista;
    }


    public Produto buscarPorId(int id) throws SQLException {
        String sql = "SELECT p.*, c.nome AS cat_nome FROM produtos p LEFT JOIN categorias c ON p.categoria_id=c.id WHERE p.id=?";
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapear(rs);
            }
        } finally { DBUtil.close(conn); }
        return null;
    }

    public void inserir(Produto p) throws SQLException {
        String sql = "INSERT INTO produtos (nome, descricao, preco, categoria_id, disponivel, imagem) VALUES (?,?,?,?,?,?)";
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getNome());
            ps.setString(2, p.getDescricao());
            ps.setBigDecimal(3, p.getPreco());
            ps.setInt(4, p.getCategoriaId());
            ps.setBoolean(5, p.isDisponivel());
            ps.setString(6, p.getImagem());
            ps.executeUpdate();
        } finally { DBUtil.close(conn); }
    }

    public void actualizar(Produto p) throws SQLException {
        // Se não enviou nova imagem, mantém a antiga
        String sql = p.getImagem() != null && !p.getImagem().isBlank()
            ? "UPDATE produtos SET nome=?, descricao=?, preco=?, categoria_id=?, disponivel=?, imagem=? WHERE id=?"
            : "UPDATE produtos SET nome=?, descricao=?, preco=?, categoria_id=?, disponivel=? WHERE id=?";

        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getNome());
            ps.setString(2, p.getDescricao());
            ps.setBigDecimal(3, p.getPreco());
            ps.setInt(4, p.getCategoriaId());
            ps.setBoolean(5, p.isDisponivel());
            if (p.getImagem() != null && !p.getImagem().isBlank()) {
                ps.setString(6, p.getImagem());
                ps.setInt(7, p.getId());
            } else {
                ps.setInt(6, p.getId());
            }
            ps.executeUpdate();
        } finally { DBUtil.close(conn); }
    }

    public void eliminar(int id) throws SQLException {
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement("DELETE FROM produtos WHERE id=?")) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } finally { DBUtil.close(conn); }
    }

    private Produto mapear(ResultSet rs) throws SQLException {
        Produto p = new Produto();
        p.setId(rs.getInt("id"));
        p.setNome(rs.getString("nome"));
        p.setDescricao(rs.getString("descricao"));
        p.setPreco(rs.getBigDecimal("preco"));
        p.setCategoriaId(rs.getInt("categoria_id"));
        p.setCategoriaNome(rs.getString("cat_nome"));
        p.setDisponivel(rs.getBoolean("disponivel"));
        p.setImagem(rs.getString("imagem"));
        return p;
    }
}
