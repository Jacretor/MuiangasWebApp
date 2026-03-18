package com.muiangas.controller;

import com.muiangas.dao.ClienteDAO;
import com.muiangas.model.Cliente;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;


public class ClienteAuthServlet extends HttpServlet {

    private final ClienteDAO dao = new ClienteDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getServletPath();

        if ("/cliente/logout".equals(path)) {
            HttpSession session = req.getSession(false);
            if (session != null) session.removeAttribute("cliente");
            resp.sendRedirect(req.getContextPath() + "/views/public/index.jsp");
            return;
        }

        // Se já logado redireciona para área do cliente
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("cliente") != null) {
            resp.sendRedirect(req.getContextPath() + "/cliente/area");
            return;
        }

        if ("/cliente/registo".equals(path)) {
            req.getRequestDispatcher("/views/public/cliente-registro.jsp").forward(req, resp);
        } else {
            req.getRequestDispatcher("/views/public/cliente-login.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String path = req.getServletPath();

        if ("/cliente/registo".equals(path)) {
            processarRegisto(req, resp);
        } else {
            processarLogin(req, resp);
        }
    }

    private void processarLogin(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String email = req.getParameter("email");
        String senha = req.getParameter("senha");

        if (email == null || senha == null || email.isBlank() || senha.isBlank()) {
            req.setAttribute("erro", "Preencha o e-mail e a senha.");
            req.getRequestDispatcher("/views/public/cliente-login.jsp").forward(req, resp);
            return;
        }
        try {
            Cliente c = dao.verificarCredenciais(email.trim(), senha);
            if (c != null) {
                HttpSession session = req.getSession(true);
                session.setAttribute("cliente", c);
                session.setMaxInactiveInterval(60 * 60 * 24); // 24h
                // Redirecionar para página anterior ou área do cliente
                String redirect = req.getParameter("redirect");
                if (redirect != null && !redirect.isBlank()) {
                    resp.sendRedirect(req.getContextPath() + redirect);
                } else {
                    resp.sendRedirect(req.getContextPath() + "/cliente/area");
                }
            } else {
                req.setAttribute("erro", "E-mail ou senha inválidos.");
                req.getRequestDispatcher("/views/public/cliente-login.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("erro", "Erro interno. Tente novamente.");
            req.getRequestDispatcher("/views/public/cliente-login.jsp").forward(req, resp);
        }
    }

    private void processarRegisto(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String nome     = req.getParameter("nome");
        String email    = req.getParameter("email");
        String senha    = req.getParameter("senha");
        String confirma = req.getParameter("confirma");
        String telefone = req.getParameter("telefone");

        // Validações
        if (nome == null || nome.isBlank()) {
            req.setAttribute("erro", "O nome é obrigatório.");
            req.getRequestDispatcher("/views/public/cliente-registo.jsp").forward(req, resp); return;
        }
        if (email == null || !email.contains("@")) {
            req.setAttribute("erro", "E-mail inválido.");
            req.getRequestDispatcher("/views/public/cliente-registo.jsp").forward(req, resp); return;
        }
        if (senha == null || senha.length() < 6) {
            req.setAttribute("erro", "A senha deve ter pelo menos 6 caracteres.");
            req.getRequestDispatcher("/views/public/cliente-registo.jsp").forward(req, resp); return;
        }
        if (!senha.equals(confirma)) {
            req.setAttribute("erro", "As senhas não coincidem.");
            req.getRequestDispatcher("/views/public/cliente-registo.jsp").forward(req, resp); return;
        }

        try {
            if (dao.emailExiste(email.trim())) {
                req.setAttribute("erro", "Este e-mail já está registado.");
                req.getRequestDispatcher("/views/public/cliente-registo.jsp").forward(req, resp); return;
            }
            Cliente c = new Cliente();
            c.setNome(nome.trim());
            c.setEmail(email.trim());
            c.setSenhaHash(ClienteDAO.hashSenha(senha));
            c.setTelefone(telefone != null ? telefone.trim() : null);
            dao.registar(c);

            // Login automático após registo
            Cliente novo = dao.verificarCredenciais(email.trim(), senha);
            HttpSession session = req.getSession(true);
            session.setAttribute("cliente", novo);
            session.setMaxInactiveInterval(60 * 60 * 24);
            resp.sendRedirect(req.getContextPath() + "/cliente/area?bemvindo=1");

        } catch (Exception e) {
            req.setAttribute("erro", "Erro ao registar: " + e.getMessage());
            req.getRequestDispatcher("/views/public/cliente-registo.jsp").forward(req, resp);
        }
    }
}
