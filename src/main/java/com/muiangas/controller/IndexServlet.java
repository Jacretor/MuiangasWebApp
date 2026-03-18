package com.muiangas.controller;

import com.muiangas.dao.ClienteDAO;
import com.muiangas.model.Avaliacao;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class IndexServlet extends HttpServlet {

    private final ClienteDAO clienteDAO = new ClienteDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            List<Avaliacao> avaliacoes = clienteDAO.listarTodasAvaliacoes();
            List<Avaliacao> destaque = new ArrayList<>();
            for (Avaliacao a : avaliacoes) {
                if (a.getEstrelas() >= 4 && a.getComentario() != null && !a.getComentario().isBlank()) {
                    destaque.add(a);
                    if (destaque.size() >= 6) break;
                }
            }
            req.setAttribute("avaliacoes", destaque);
        } catch (Exception e) {
            req.setAttribute("avaliacoes", new ArrayList<>());
        }
        req.getRequestDispatcher("/views/public/index.jsp").forward(req, resp);
    }
}
