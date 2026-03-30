package com.muiangas.dao;

import com.muiangas.model.Avaliacao;
import com.muiangas.model.Cliente;
import com.muiangas.model.EnderecoCliente;

import java.security.MessageDigest;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ClienteDAO {

    // ════════════════════════════════════════════════
    // MÉTODOS ORIGINAIS (não alterados)
    // ════════════════════════════════════════════════
	
    /** Activa ou desactiva um cliente */
    public void alterarAtivo(int id, boolean ativo) throws SQLException {
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(
                "UPDATE clientes SET ativo=? WHERE id=?")) {
            ps.setBoolean(1, ativo);
            ps.setInt(2, id);
            ps.executeUpdate();
        } finally { DBUtil.close(conn); }
    }


    public List<Cliente> listarTodos() throws SQLException {
        List<Cliente> lista = new ArrayList<>();
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement("SELECT * FROM clientes ORDER BY nome");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(mapear(rs));
        } finally { DBUtil.close(conn); }
        return lista;
    }

    public Cliente buscarPorId(int id) throws SQLException {
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement("SELECT * FROM clientes WHERE id=?")) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapear(rs);
            }
        } finally { DBUtil.close(conn); }
        return null;
    }

    public int inserir(Cliente c) throws SQLException {
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO clientes (nome, telefone, email) VALUES (?,?,?)",
                Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, c.getNome());
            ps.setString(2, c.getTelefone());
            ps.setString(3, c.getEmail());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        } finally { DBUtil.close(conn); }
        return -1;
    }

    // ════════════════════════════════════════════════
    // NOVOS MÉTODOS — sistema de contas
    // ════════════════════════════════════════════════

    // ── Hash SHA-256 ─────────────────────────────────
    public static String hashSenha(String senha) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(senha.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (byte b : hash) sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (Exception e) {
            throw new RuntimeException("Erro ao gerar hash", e);
        }
    }

    // ── Registo com senha ─────────────────────────────
    public void registar(Cliente c) throws SQLException {
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO clientes (nome, telefone, email, senha_hash, ativo) VALUES (?,?,?,?,1)")) {
            ps.setString(1, c.getNome());
            ps.setString(2, c.getTelefone());
            ps.setString(3, c.getEmail());
            ps.setString(4, c.getSenhaHash());
            ps.executeUpdate();
        } finally { DBUtil.close(conn); }
    }

    // ── Login ─────────────────────────────────────────
    public Cliente verificarCredenciais(String email, String senha) throws SQLException {
        String hash = hashSenha(senha);
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(
                "SELECT * FROM clientes WHERE email=? AND senha_hash=? AND ativo=1")) {
            ps.setString(1, email);
            ps.setString(2, hash);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapear(rs);
            }
        } finally { DBUtil.close(conn); }
        return null;
    }

    public boolean emailExiste(String email) throws SQLException {
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(
                "SELECT COUNT(*) FROM clientes WHERE email=?")) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } finally { DBUtil.close(conn); }
        return false;
    }

    // ── Endereços ─────────────────────────────────────
    public List<EnderecoCliente> listarEnderecos(int clienteId) throws SQLException {
        List<EnderecoCliente> lista = new ArrayList<>();
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(
                "SELECT e.*, z.nome AS zona_nome FROM enderecos_cliente e " +
                "LEFT JOIN zonas_delivery z ON e.zona_id=z.id " +
                "WHERE e.cliente_id=? ORDER BY e.predefinido DESC, e.id")) {
            ps.setInt(1, clienteId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(mapEndereco(rs));
            }
        } finally { DBUtil.close(conn); }
        return lista;
    }

    public void inserirEndereco(EnderecoCliente e) throws SQLException {
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO enderecos_cliente (cliente_id,nome,morada,zona_id,predefinido) VALUES (?,?,?,?,?)")) {
            ps.setInt(1, e.getClienteId());
            ps.setString(2, e.getNome());
            ps.setString(3, e.getMorada());
            if (e.getZonaId() > 0) ps.setInt(4, e.getZonaId()); else ps.setNull(4, Types.INTEGER);
            ps.setBoolean(5, e.isPredefinido());
            ps.executeUpdate();
        } finally { DBUtil.close(conn); }
    }

    public void eliminarEndereco(int id, int clienteId) throws SQLException {
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(
                "DELETE FROM enderecos_cliente WHERE id=? AND cliente_id=?")) {
            ps.setInt(1, id);
            ps.setInt(2, clienteId);
            ps.executeUpdate();
        } finally { DBUtil.close(conn); }
    }

    // ── Favoritos ─────────────────────────────────────
    public List<Integer> listarFavoritosIds(int clienteId) throws SQLException {
        List<Integer> ids = new ArrayList<>();
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(
                "SELECT produto_id FROM favoritos WHERE cliente_id=?")) {
            ps.setInt(1, clienteId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) ids.add(rs.getInt("produto_id"));
            }
        } finally { DBUtil.close(conn); }
        return ids;
    }

    public void toggleFavorito(int clienteId, int produtoId) throws SQLException {
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(
                "SELECT id FROM favoritos WHERE cliente_id=? AND produto_id=?")) {
            ps.setInt(1, clienteId);
            ps.setInt(2, produtoId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    try (PreparedStatement del = conn.prepareStatement(
                            "DELETE FROM favoritos WHERE cliente_id=? AND produto_id=?")) {
                        del.setInt(1, clienteId); del.setInt(2, produtoId);
                        del.executeUpdate();
                    }
                } else {
                    try (PreparedStatement ins = conn.prepareStatement(
                            "INSERT INTO favoritos (cliente_id,produto_id) VALUES (?,?)")) {
                        ins.setInt(1, clienteId); ins.setInt(2, produtoId);
                        ins.executeUpdate();
                    }
                }
            }
        } finally { DBUtil.close(conn); }
    }

    // ── Avaliações ────────────────────────────────────
    public void inserirAvaliacao(Avaliacao a) throws SQLException {
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO avaliacoes (cliente_id,pedido_id,estrelas,comentario) VALUES (?,?,?,?)")) {
            ps.setInt(1, a.getClienteId());
            if (a.getPedidoId() > 0) ps.setInt(2, a.getPedidoId()); else ps.setNull(2, Types.INTEGER);
            ps.setInt(3, a.getEstrelas());
            ps.setString(4, a.getComentario());
            ps.executeUpdate();
        } finally { DBUtil.close(conn); }
    }

    public List<Avaliacao> listarAvaliacoes(int clienteId) throws SQLException {
        List<Avaliacao> lista = new ArrayList<>();
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(
                "SELECT a.*, c.nome AS cliente_nome FROM avaliacoes a " +
                "JOIN clientes c ON a.cliente_id=c.id " +
                "WHERE a.cliente_id=? ORDER BY a.data_avalia DESC")) {
            ps.setInt(1, clienteId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(mapAvaliacao(rs));
            }
        } finally { DBUtil.close(conn); }
        return lista;
    }

    public boolean jaAvaliou(int clienteId, int pedidoId) throws SQLException {
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(
                "SELECT COUNT(*) FROM avaliacoes WHERE cliente_id=? AND pedido_id=?")) {
            ps.setInt(1, clienteId);
            ps.setInt(2, pedidoId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } finally { DBUtil.close(conn); }
        return false;
    }

    public List<Avaliacao> listarTodasAvaliacoes() throws SQLException {
        List<Avaliacao> lista = new ArrayList<>();
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(
                "SELECT a.*, c.nome AS cliente_nome FROM avaliacoes a " +
                "JOIN clientes c ON a.cliente_id=c.id ORDER BY a.data_avalia DESC");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(mapAvaliacao(rs));
        } finally { DBUtil.close(conn); }
        return lista;
    }

    // ════════════════════════════════════════════════
    // MAPPERS
    // ════════════════════════════════════════════════

    private Cliente mapear(ResultSet rs) throws SQLException {
        Cliente c = new Cliente();
        c.setId(rs.getInt("id"));
        c.setNome(rs.getString("nome"));
        c.setTelefone(rs.getString("telefone"));
        c.setEmail(rs.getString("email"));
        // campos novos — podem ser null em registos antigos
        try { c.setSenhaHash(rs.getString("senha_hash")); } catch (Exception ignored) {}
        try { c.setAtivo(rs.getBoolean("ativo")); }        catch (Exception ignored) {}
        try { c.setDataRegisto(rs.getTimestamp("data_registo")); } catch (Exception ignored) {}
        return c;
    }

    private EnderecoCliente mapEndereco(ResultSet rs) throws SQLException {
        EnderecoCliente e = new EnderecoCliente();
        e.setId(rs.getInt("id"));
        e.setClienteId(rs.getInt("cliente_id"));
        e.setNome(rs.getString("nome"));
        e.setMorada(rs.getString("morada"));
        e.setZonaId(rs.getInt("zona_id"));
        e.setZonaNome(rs.getString("zona_nome"));
        e.setPredefinido(rs.getBoolean("predefinido"));
        return e;
    }

    private Avaliacao mapAvaliacao(ResultSet rs) throws SQLException {
        Avaliacao a = new Avaliacao();
        a.setId(rs.getInt("id"));
        a.setClienteId(rs.getInt("cliente_id"));
        a.setClienteNome(rs.getString("cliente_nome"));
        a.setPedidoId(rs.getInt("pedido_id"));
        a.setEstrelas(rs.getInt("estrelas"));
        a.setComentario(rs.getString("comentario"));
        a.setDataAvalia(rs.getTimestamp("data_avalia"));
        return a;
    }
}
