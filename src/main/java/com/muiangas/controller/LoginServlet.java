package com.muiangas.controller;

import com.muiangas.dao.FuncionarioDAO;
import com.muiangas.model.Funcionario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login", "/logout"})
public class LoginServlet extends HttpServlet {

    private final FuncionarioDAO dao = new FuncionarioDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getServletPath();

        if ("/logout".equals(path)) {
            HttpSession session = req.getSession(false);
            if (session != null) session.invalidate();
            // ── Logout vai para a página inicial ──
            resp.sendRedirect(req.getContextPath() + "/views/public/index.jsp");
            return;
        }

        // Redirecionar se já autenticado
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("funcionario") != null) {
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            return;
        }

        req.getRequestDispatcher("/views/public/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String email = req.getParameter("email");
        String senha = req.getParameter("senha");

        if (email == null || senha == null || email.isBlank() || senha.isBlank()) {
            req.setAttribute("erro", "Preencha o e-mail e a senha.");
            req.getRequestDispatcher("/views/public/login.jsp").forward(req, resp);
            return;
        }

        try {
            Funcionario f = dao.verificarCredenciais(email.trim(), senha);
            if (f != null) {
                HttpSession session = req.getSession(true);
                session.setAttribute("funcionario", f);
                session.setMaxInactiveInterval(60 * 60);
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            } else {
                req.setAttribute("erro", "E-mail ou senha inválidos.");
                req.getRequestDispatcher("/views/public/login.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("erro", "Erro interno. Tente novamente.");
            req.getRequestDispatcher("/views/public/login.jsp").forward(req, resp);
        }
    }
}
