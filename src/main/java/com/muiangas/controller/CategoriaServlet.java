package com.muiangas.controller;

import com.muiangas.dao.CategoriaDAO;
import com.muiangas.model.Categoria;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * Servlet CRUD de categorias.
 */
@WebServlet(name = "CategoriaServlet", urlPatterns = "/admin/categorias")
public class CategoriaServlet extends HttpServlet {

    private final CategoriaDAO dao = new CategoriaDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!autenticado(req, resp)) return;
        String acao = req.getParameter("acao");

        try {
            if ("nova".equals(acao)) {
                req.setAttribute("categoria", new Categoria());
                req.getRequestDispatcher("/views/admin/categoria-form.jsp").forward(req, resp);

            } else if ("editar".equals(acao)) {
                req.setAttribute("categoria", dao.buscarPorId(Integer.parseInt(req.getParameter("id"))));
                req.getRequestDispatcher("/views/admin/categoria-form.jsp").forward(req, resp);

            } else if ("eliminar".equals(acao)) {
                dao.eliminar(Integer.parseInt(req.getParameter("id")));
                resp.sendRedirect(req.getContextPath() + "/admin/categorias");

            } else {
                req.setAttribute("categorias", dao.listarTodas());
                req.getRequestDispatcher("/views/admin/categorias.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("erro", "Erro: " + e.getMessage());
            req.getRequestDispatcher("/views/admin/categorias.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!autenticado(req, resp)) return;
        req.setCharacterEncoding("UTF-8");

        try {
            Categoria c = new Categoria();
            String idStr = req.getParameter("id");
            if (idStr != null && !idStr.isBlank()) c.setId(Integer.parseInt(idStr));
            c.setNome(req.getParameter("nome"));
            c.setDescricao(req.getParameter("descricao"));

            if (c.getId() > 0) dao.actualizar(c);
            else dao.inserir(c);
            resp.sendRedirect(req.getContextPath() + "/admin/categorias");
        } catch (Exception e) {
            req.setAttribute("erro", "Erro: " + e.getMessage());
            req.getRequestDispatcher("/views/admin/categoria-form.jsp").forward(req, resp);
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
