package com.muiangas.model;

import java.util.Date;

/** Entidade Cliente do restaurante. */
public class Cliente {
    private int     id;
    private String  nome;
    private String  telefone;
    private String  email;
    // ── campos novos para sistema de contas ──
    private String  senhaHash;
    private boolean ativo;
    private Date    dataRegisto;

    public Cliente() {}

    public int     getId()                  { return id; }
    public void    setId(int id)            { this.id = id; }

    public String  getNome()                { return nome; }
    public void    setNome(String nome)     { this.nome = nome; }

    public String  getTelefone()                    { return telefone; }
    public void    setTelefone(String telefone)     { this.telefone = telefone; }

    public String  getEmail()               { return email; }
    public void    setEmail(String email)   { this.email = email; }

    public String  getSenhaHash()                       { return senhaHash; }
    public void    setSenhaHash(String senhaHash)       { this.senhaHash = senhaHash; }

    public boolean isAtivo()                { return ativo; }
    public void    setAtivo(boolean ativo)  { this.ativo = ativo; }

    public Date    getDataRegisto()                     { return dataRegisto; }
    public void    setDataRegisto(Date dataRegisto)     { this.dataRegisto = dataRegisto; }
}
