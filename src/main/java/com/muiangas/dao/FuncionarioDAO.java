package com.muiangas.dao;

import com.muiangas.model.Funcionario;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO para operações sobre a tabela funcionarios.
 * Inclui utilitário de hash SHA-256 para senhas.
 */
public class FuncionarioDAO {

    /**
     * Verifica as credenciais de login.
     * @param email email do funcionário
     * @param senha senha em texto claro (será hasheada antes da consulta)
     * @return Funcionario autenticado ou null
     */
    public Funcionario verificarCredenciais(String email, String senha) throws SQLException {
        String hash = hashSHA256(senha);
        String sql = "SELECT * FROM funcionarios WHERE email=? AND senha=?";
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, hash);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapear(rs);
            }
        } finally { DBUtil.close(conn); }
        return null;
    }

    /** @return todos os funcionários */
    public List<Funcionario> listarTodos() throws SQLException {
        List<Funcionario> lista = new ArrayList<>();
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement("SELECT * FROM funcionarios ORDER BY nome");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(mapear(rs));
        } finally { DBUtil.close(conn); }
        return lista;
    }

    /** @return funcionário pelo ID ou null */
    public Funcionario buscarPorId(int id) throws SQLException {
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement("SELECT * FROM funcionarios WHERE id=?")) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapear(rs);
            }
        } finally { DBUtil.close(conn); }
        return null;
    }

    /** Insere um novo funcionário (senha é hasheada automaticamente). */
    public void inserir(Funcionario f) throws SQLException {
        String sql = "INSERT INTO funcionarios (nome, email, senha, cargo) VALUES (?,?,?,?)";
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, f.getNome());
            ps.setString(2, f.getEmail());
            ps.setString(3, hashSHA256(f.getSenha()));
            ps.setString(4, f.getCargo());
            ps.executeUpdate();
        } finally { DBUtil.close(conn); }
    }

    /** Actualiza dados de um funcionário (sem alterar senha). */
    public void actualizar(Funcionario f) throws SQLException {
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement("UPDATE funcionarios SET nome=?, email=?, cargo=? WHERE id=?")) {
            ps.setString(1, f.getNome());
            ps.setString(2, f.getEmail());
            ps.setString(3, f.getCargo());
            ps.setInt(4, f.getId());
            ps.executeUpdate();
        } finally { DBUtil.close(conn); }
    }

    /** Redefine a senha de um funcionário. */
    public void redefinirSenha(int id, String novaSenha) throws SQLException {
        Connection conn = DBUtil.getConnection();
        try (PreparedStatement ps = conn.prepareStatement("UPDATE funcionarios SET senha=? WHERE id=?")) {
            ps.setString(1, hashSHA256(novaSenha));
            ps.setInt(2, id);
            ps.executeUpdate();
        } finally { DBUtil.close(conn); }
    }

    /**
     * Gera hash SHA-256 de uma string.
     * @param texto texto a ser hasheado
     * @return hash hexadecimal em minúsculas
     */
    public static String hashSHA256(String texto) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] bytes = md.digest(texto.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : bytes) sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 não disponível", e);
        }
    }

    private Funcionario mapear(ResultSet rs) throws SQLException {
        Funcionario f = new Funcionario();
        f.setId(rs.getInt("id"));
        f.setNome(rs.getString("nome"));
        f.setEmail(rs.getString("email"));
        f.setSenha(rs.getString("senha"));
        f.setCargo(rs.getString("cargo"));
        return f;
    }
}
