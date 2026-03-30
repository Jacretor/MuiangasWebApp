package com.muiangas.controller;

import com.muiangas.dao.ClienteDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "AdminClienteServlet", urlPatterns = "/admin/cliente")
public class AdminClienteServlet extends HttpServlet {

    private final ClienteDAO dao = new ClienteDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!autenticado(req, resp)) return;
        String acao = req.getParameter("acao");

        try {
            if ("desactivar".equals(acao)) {
                int id = Integer.parseInt(req.getParameter("id"));
                dao.alterarAtivo(id, false);
                resp.sendRedirect(req.getContextPath() + "/admin/cliente?msg=desactivado");
                return;
            }
            if ("activar".equals(acao)) {
                int id = Integer.parseInt(req.getParameter("id"));
                dao.alterarAtivo(id, true);
                resp.sendRedirect(req.getContextPath() + "/admin/cliente?msg=activado");
                return;
            }
            req.setAttribute("clientes", dao.listarTodos());
            req.getRequestDispatcher("/views/admin/cliente.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("erro", "Erro: " + e.getMessage());
            req.getRequestDispatcher("/views/admin/cliente.jsp").forward(req, resp);
        }
    }

    private boolean autenticado(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession s = req.getSession(false);
        if (s == null || s.getAttribute("funcionario") == null) {
            resp.sendRedirect(req.getContextPath() + "/login"); return false;
        }
        return true;
    }
}
