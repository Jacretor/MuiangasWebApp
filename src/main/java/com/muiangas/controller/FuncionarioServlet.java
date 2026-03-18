package com.muiangas.controller;

import com.muiangas.dao.FuncionarioDAO;
import com.muiangas.model.Funcionario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * Servlet CRUD de funcionários (acesso restrito a admin).
 */
@WebServlet(name = "FuncionarioServlet", urlPatterns = "/admin/funcionarios")
public class FuncionarioServlet extends HttpServlet {

    private final FuncionarioDAO dao = new FuncionarioDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isAdmin(req, resp)) return;
        String acao = req.getParameter("acao");

        try {
            if ("novo".equals(acao)) {
                req.setAttribute("funcionario", new Funcionario());
                req.getRequestDispatcher("/views/admin/funcionario-form.jsp").forward(req, resp);

            } else if ("editar".equals(acao)) {
                req.setAttribute("funcionario", dao.buscarPorId(Integer.parseInt(req.getParameter("id"))));
                req.getRequestDispatcher("/views/admin/funcionario-form.jsp").forward(req, resp);

            } else {
                req.setAttribute("funcionarios", dao.listarTodos());
                req.getRequestDispatcher("/views/admin/funcionarios.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("erro", "Erro: " + e.getMessage());
            req.getRequestDispatcher("/views/admin/funcionarios.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isAdmin(req, resp)) return;
        req.setCharacterEncoding("UTF-8");

        try {
            Funcionario f = new Funcionario();
            String idStr = req.getParameter("id");
            if (idStr != null && !idStr.isBlank()) f.setId(Integer.parseInt(idStr));
            f.setNome(req.getParameter("nome"));
            f.setEmail(req.getParameter("email"));
            f.setCargo(req.getParameter("cargo"));
            String senha = req.getParameter("senha");

            if (f.getId() > 0) {
                dao.actualizar(f);
                if (senha != null && !senha.isBlank()) dao.redefinirSenha(f.getId(), senha);
            } else {
                f.setSenha(senha);
                dao.inserir(f);
            }
            resp.sendRedirect(req.getContextPath() + "/admin/funcionarios");
        } catch (Exception e) {
            req.setAttribute("erro", "Erro: " + e.getMessage());
            req.getRequestDispatcher("/views/admin/funcionario-form.jsp").forward(req, resp);
        }
    }

    private boolean isAdmin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession s = req.getSession(false);
        if (s == null || s.getAttribute("funcionario") == null) {
            resp.sendRedirect(req.getContextPath() + "/login"); return false;
        }
        Funcionario f = (Funcionario) s.getAttribute("funcionario");
        if (!f.isAdmin()) {
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard"); return false;
        }
        return true;
    }
}
