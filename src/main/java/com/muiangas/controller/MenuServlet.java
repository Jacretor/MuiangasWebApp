package com.muiangas.controller;

import com.muiangas.dao.CategoriaDAO;
import com.muiangas.dao.ProdutoDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * Servlet do menu público - lista produtos disponíveis com filtro por categoria.
 */
@WebServlet(name = "MenuServlet", urlPatterns = "/menu")
public class MenuServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int catId = 0;
            String catParam = req.getParameter("categoria");
            if (catParam != null && !catParam.isBlank()) catId = Integer.parseInt(catParam);

            req.setAttribute("categorias", new CategoriaDAO().listarTodas());
            req.setAttribute("produtos",   new ProdutoDAO().listarDisponiveis(catId));
            req.setAttribute("catSelecionada", catId);
        } catch (Exception e) {
            req.setAttribute("erro", "Erro ao carregar menu.");
        }
        req.getRequestDispatcher("/views/public/menu.jsp").forward(req, resp);
    }
}
