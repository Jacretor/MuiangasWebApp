package com.muiangas.model;

/** Entidade Funcionario - guarda credenciais e cargo. */
public class Funcionario {
    private int id;
    private String nome;
    private String email;
    private String senha; // armazenada como SHA-256
    private String cargo; // admin | funcionario

    public Funcionario() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getSenha() { return senha; }
    public void setSenha(String senha) { this.senha = senha; }
    public String getCargo() { return cargo; }
    public void setCargo(String cargo) { this.cargo = cargo; }

    /** @return true se o funcionário tiver cargo de administrador */
    public boolean isAdmin() { return "admin".equals(cargo); }
}
